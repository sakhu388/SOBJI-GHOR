# সবজি ঘর V6: অনলাইন সংযোগ প্রস্তুত

V6-এ কাস্টমার Flutter অ্যাপ থেকে Supabase database-এ অর্ডার পাঠানোর সংযোগ কোড এবং owner-only অনলাইন admin panel যুক্ত করা হয়েছে।

## ফাইল
- `lib/main.dart`: কাস্টমার অ্যাপ; Supabase URL/key build-time define দিয়ে নেয়।
- `admin/index.html`: মালিকের ইমেইল-পাসওয়ার্ড লগইন, live order list, search/filter এবং status update।
- `supabase_setup.sql`: orders table, Row Level Security, owner policies এবং delivery-fee trigger।
- `CONNECT_ONLINE_BN.md`: বাংলায় ধাপে ধাপে সংযোগ নির্দেশনা।

## গুরুত্বপূর্ণ
এটি এখনো আপনার ব্যবসার live deployment নয়। আপনার Supabase project, owner user এবং hosting configuration তৈরি করে নির্দেশনা অনুযায়ী বসাতে হবে। Project credentials ছাড়া এই পরিবেশ থেকে আপনার বাস্তব ডাটাবেসে সংযোগ করা সম্ভব নয়। `service_role` key কখনো customer app বা admin HTML-এ বসাবেন না।


V7-এ আপনার Supabase Project URL ও Publishable key কনফিগার করা হয়েছে। বিস্তারিত `README_V7_BN.md` দেখুন।
