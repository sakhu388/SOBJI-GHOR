-- Add a server-side default delivery fee to orders.
alter table orders
  add column if not exists delivery_window text not null default '08:00-12:00',
  add column if not exists order_cutoff_local time not null default '00:00';

-- Set delivery fee to 20 BDT for each delivery order.
-- The trusted backend must calculate totals; never trust a client-submitted total.
alter table orders
  alter column delivery_fee set default 20;

-- Suggested operational configuration table.
create table if not exists business_settings (
  setting_key text primary key,
  setting_value jsonb not null,
  updated_at timestamptz not null default now()
);

insert into business_settings(setting_key, setting_value)
values
 ('delivery_area', '{"city":"Rajshahi","country":"Bangladesh"}'::jsonb),
 ('delivery_window', '{"start":"08:00","end":"12:00","timezone":"Asia/Dhaka"}'::jsonb),
 ('order_cutoff', '{"time":"00:00","rule":"previous_day","timezone":"Asia/Dhaka"}'::jsonb),
 ('delivery_fee', '{"amount":20,"currency":"BDT","basis":"per_delivery_order"}'::jsonb)
on conflict (setting_key) do update set setting_value = excluded.setting_value, updated_at = now();

-- Production backend must enforce:
-- 1. Orders for a delivery date close at 00:00 Asia/Dhaka on the previous date.
-- 2. Each separate delivery day/order gets one 20 BDT delivery fee.
-- 3. A weekly subscription with 7 delivery days gets 7 x 20 BDT delivery charges.
-- 4. If multiple vegetable lines are bundled into one delivery, charge only once for that delivery.
