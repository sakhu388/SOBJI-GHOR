# সবজি ঘর V7: আপনার Supabase Project দিয়ে কনফিগার করা

আপনার দেওয়া Project URL এবং Publishable key অ্যাডমিন প্যানেলে বসানো হয়েছে। Flutter অ্যাপেও একই তথ্য দিয়ে রান/বিল্ড করার নির্দেশনা দেওয়া হলো।

## আপনার Supabase সংযোগ
- Project URL: `https://kvgzvnzsztufiodkmhaf.supabase.co`
- Key type: Publishable (`sb_publishable_...`)

## কাস্টমার অ্যাপ চালানো (কম্পিউটারে Flutter লাগবে)
এই ফোল্ডারে টার্মিনাল খুলে চালান:

```bash
flutter pub get
flutter run --dart-define=SUPABASE_URL=https://kvgzvnzsztufiodkmhaf.supabase.co --dart-define=SUPABASE_ANON_KEY=sb_publishable_NY8K0Fh_LczN73d9KDZjpw_tFz6JEqM
```

Android APK বানাতে:

```bash
flutter build apk --release --dart-define=SUPABASE_URL=https://kvgzvnzsztufiodkmhaf.supabase.co --dart-define=SUPABASE_ANON_KEY=sb_publishable_NY8K0Fh_LczN73d9KDZjpw_tFz6JEqM
```

APK পাওয়া যাবে `build/app/outputs/flutter-apk/app-release.apk` ফাইলে।

## অ্যাডমিন প্যানেল
`admin/index.html`-এ আপনার Project URL ও Publishable key ইতিমধ্যে বসানো আছে। এই ফাইলটি static hosting-এ publish করতে হবে।

## গুরুত্বপূর্ণ পরের কাজ: মালিকের লগইন
Supabase Dashboard > Authentication > Users > Add user থেকে নিজের ইমেইল ও শক্ত পাসওয়ার্ড দিয়ে একটি user তৈরি করুন। তারপর SQL Editor-এ নিচের কোড চালান (ইমেইলটি নিজের আসল ইমেইল দিয়ে বদলাবেন):

```sql
update auth.users
set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"owner"}'::jsonb
where email = 'আপনার-ইমেইল';
```

এরপর Admin panel-এ ওই ইমেইল ও পাসওয়ার্ড দিয়ে লগইন করবেন।

## নিরাপত্তা
- আপনি শুধু Publishable key দিয়েছেন, এটি client-side ব্যবহারের জন্য।
- Secret key / service_role key কাউকে দেবেন না এবং কোনো app/browser code-এ বসাবেন না।
- এই ZIP নিজে থেকে আপনার ফোনে অ্যাপ ইনস্টল করে না, Supabase-এও নতুন কিছু আপলোড করে না। Flutter build ও admin hosting এখনও করতে হবে।
- ফোন নম্বর-ভিত্তিক customer login এখনো demo তথ্য সংগ্রহ, OTP authentication নয়।
