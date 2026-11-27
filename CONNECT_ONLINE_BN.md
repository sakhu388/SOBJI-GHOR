# সবজি ঘর অনলাইনে যুক্ত করার সহজ নির্দেশনা

এই V5 ফাইলে অনলাইন সংযোগের কোড যোগ করা হয়েছে। কিন্তু আপনার নিজের Supabase project URL, anon key এবং মালিকের লগইন তৈরি না হওয়া পর্যন্ত এটি আপনার বাস্তব অর্ডার গ্রহণ করবে না। এগুলো আপনার ব্যক্তিগত অ্যাকাউন্টের তথ্য, তাই আমি নিজে থেকে বানিয়ে দিতে পারি না।

## ১) অনলাইন ডাটাবেস তৈরি
1. https://supabase.com এ গিয়ে নিজের ইমেইল দিয়ে অ্যাকাউন্ট খুলুন এবং New project চাপুন।
2. Project name দিন `shobji-ghor`। একটি শক্ত database password দিন এবং নিরাপদে লিখে রাখুন। Region হিসেবে কাছাকাছি উপলভ্য Singapore বেছে নিতে পারেন।
3. Project তৈরি হলে বাম পাশের SQL Editor খুলুন।
4. এই ZIP-এর `supabase_setup.sql` ফাইলের সম্পূর্ণ লেখা SQL Editor-এ paste করে Run চাপুন।

## ২) মালিকের লগইন তৈরি
1. Supabase Dashboard > Authentication > Users > Add user থেকে আপনার নিজের ইমেইল ও শক্ত পাসওয়ার্ড দিয়ে user তৈরি করুন।
2. SQL Editor-এ নিচের query চালান। `আপনার-ইমেইল` জায়গায় ঠিক ওই ইমেইল লিখবেন:

```sql
update auth.users
set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"owner"}'::jsonb
where email = 'আপনার-ইমেইল';
```

3. এরপর Authentication > Users-এ গিয়ে তৈরি করা user-টি আছে কি না দেখুন।

## ৩) কাস্টমার অ্যাপের সঙ্গে সংযোগ
1. Supabase Dashboard > Project Settings > API খুলুন।
2. Project URL এবং `anon` / `publishable` client key নিন। `service_role` বা `secret` key কখনো অ্যাপে দেবেন না।
3. কম্পিউটারে Flutter SDK থাকা অবস্থায় এই ফোল্ডারে টার্মিনাল খুলে চালান:

```bash
flutter pub get
flutter run --dart-define=SUPABASE_URL=আপনার_Project_URL --dart-define=SUPABASE_ANON_KEY=আপনার_anon_key
```

অ্যাপে অর্ডার দিলে `orders` টেবিলে জমা হবে। ডাটাবেস নিজে থেকে দৈনিক অর্ডারে ৳২০ এবং সাপ্তাহিক প্যাকেজে নির্বাচিত প্রতিটি ডেলিভারি দিনের জন্য ৳২০ যোগ করবে।

## ৪) মালিকের অ্যাডমিন প্যানেল যুক্ত করা
1. `admin/index.html` ফাইলটি text editor-এ খুলুন।
2. `SUPABASE_URL` এবং `SUPABASE_ANON_KEY`-এর placeholder-এ একই Project URL ও anon key বসান।
3. `admin/index.html` ফাইলটি Netlify, Cloudflare Pages বা অন্য static hosting-এ publish করুন। প্রথমে নিজের কম্পিউটারে খুলে লগইন পরীক্ষা করতে পারেন, তবে অনলাইন ব্যবহারের জন্য hosting দরকার।
4. নিজের তৈরি করা owner email/password দিয়ে লগইন করুন। কাস্টমার অ্যাপের অর্ডার এখানে দেখা যাবে।

## নিরাপত্তা ও সীমাবদ্ধতা
- Admin panel-এ শুধু `owner` role দেওয়া account অর্ডার দেখতে/পরিবর্তন করতে পারবে।
- Customer app-এ শুধু order insert permission আছে; অন্য কাস্টমারের অর্ডার পড়তে পারবে না।
- এই পর্যায়ে customer phone login/registration এখনো demo/local; OTP verification নয়। অর্ডার জমা দিতে অ্যাপের বর্তমান নাম-ফোন ধাপ ব্যবহার করা হয়।
- সবজির subtotal এখনো অ্যাপ থেকে আসে। ডেলিভারি fee ও total ডাটাবেসে পুনর্গণনা হয়। লাইভ ব্যবসার আগে পণ্যের দামও ডাটাবেস থেকে নিয়ে সার্ভারে subtotal গণনা করা উচিত।
- bKash/Nagad/Rocket এখানে payment preference হিসেবে রাখা হয়, স্বয়ংক্রিয় পেমেন্ট নেওয়া হয় না।
- আগের দিন রাত ১২টার cutoff এখনো UI-তে নির্দেশনা; server-side delivery-date validation পরের ধাপে যোগ করতে হবে।

## আপনার কাছ থেকে যা লাগবে
Supabase project URL ও anon key এবং admin email setup হয়ে গেলে এগুলো অ্যাপে/প্যানেলে বসিয়ে পরীক্ষা করতে হবে। Secret/service-role key কখনো কাউকে পাঠাবেন না।
