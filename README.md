# SHOBJI GHOR V2 — Flutter prototype

## Business rules included in the UI
- Service area: Rajshahi city
- Delivery window: 08:00–12:00 (Asia/Dhaka)
- Order cutoff: midnight (00:00) on the previous day
- Delivery fee: BDT 20 per delivery order
- Payment choices: cash, bKash, Nagad, Rocket
- Order modes: daily and weekly (weekly schedule editor is not yet implemented)

## Run
Install Flutter SDK and run:
```bash
flutter pub get
flutter run
```

## Important: prototype only
Orders are currently held in local app memory, not stored online. OTP authentication,
real customer accounts, cloud database writes, the admin dashboard, rider app,
automated cutoff enforcement, real payment collection and push notifications still
need backend implementation and testing. Payment method selection does not collect money.

The vegetable prices are illustrative and must be updated by the business owner.
The delivery fee is added once per checkout/delivery order, not once per vegetable item.

## Production checklist
1. Create Supabase project and configure phone OTP.
2. Apply the original schema plus `supabase/v2_business_rules.sql`.
3. Configure Row Level Security and server-controlled admin/rider roles.
4. Implement trusted backend logic using Asia/Dhaka timezone for midnight cutoff.
5. Create admin dashboard and rider assignment/delivery app.
6. Integrate an approved Bangladesh payment gateway after merchant onboarding.
7. Test weekly billing, delivery fees per delivery day, order changes, stock and refunds.
8. Configure signing, app store accounts, privacy policy and publish.
