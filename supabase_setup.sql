-- SHOBJI GHOR: Supabase database setup
-- Run the full script in Supabase Dashboard > SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  order_code text not null unique,
  order_type text not null,
  customer_name text not null,
  phone text not null,
  address text not null,
  payment_method text not null,
  subtotal integer not null check (subtotal >= 0),
  delivery_fee integer not null default 20 check (delivery_fee >= 0),
  total integer not null check (total >= 0),
  status text not null default 'নতুন অর্ডার',
  items jsonb not null default '[]'::jsonb,
  delivery_days jsonb not null default '[]'::jsonb,
  weekly_plan jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- Calculate delivery fee on the database, not in the customer's app.
create or replace function public.set_shobji_order_totals()
returns trigger language plpgsql as $$
declare day_count integer;
begin
  if new.order_type = 'কাস্টম সাপ্তাহিক প্যাকেজ' then
    day_count := jsonb_array_length(coalesce(new.delivery_days, '[]'::jsonb));
    if day_count < 1 then raise exception 'সাপ্তাহিক প্যাকেজে অন্তত একটি ডেলিভারির দিন নির্বাচন করুন'; end if;
    new.delivery_fee := day_count * 20;
  else
    new.delivery_fee := 20;
  end if;
  new.total := new.subtotal + new.delivery_fee;
  return new;
end;
$$;
drop trigger if exists shobji_order_totals on public.orders;
create trigger shobji_order_totals before insert or update of subtotal, order_type, delivery_days
on public.orders for each row execute function public.set_shobji_order_totals();

alter table public.orders enable row level security;

-- Customer app can submit an order without being able to read other customers' orders.
drop policy if exists "public can submit orders" on public.orders;
create policy "public can submit orders" on public.orders
for insert to anon, authenticated with check (
  length(trim(customer_name)) > 0 and length(trim(phone)) >= 8 and length(trim(address)) > 0
);

-- Only a signed-in account marked as owner can see and manage orders.
drop policy if exists "owner can view orders" on public.orders;
create policy "owner can view orders" on public.orders
for select to authenticated using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'owner');

drop policy if exists "owner can update orders" on public.orders;
create policy "owner can update orders" on public.orders
for update to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'owner')
with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'owner');

grant insert on public.orders to anon, authenticated;
grant select, update on public.orders to authenticated;

-- Optional: enable Realtime for instant admin refresh later.
do $$ begin
  alter publication supabase_realtime add table public.orders;
exception when duplicate_object then null;
end $$;
