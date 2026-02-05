# Ynov Campus League (YCL) - Flutter App

This project is based on the referenced campus app design and adapted for **Ynov Campus Maroc**.

## Included changes
- App display name set to **Ynov Campus League**.
- Splash/loading logo uses `assets/images/launcher_icon.png`.
- Auth updated with:
  - register support,
  - `@ynov.com` email restriction,
  - Google sign-in,
  - Microsoft sign-in.
- New **Clubs** page with join/quit and club events.
- Events page supports **List/Grid toggle** and **Google Maps launch** using event coordinates.
- Firestore security rules restricted to authenticated `@ynov.com` users.
- Firestore seeding script added for Morocco-focused clubs and events.
- Runtime permission requests improved for notifications, camera, microphone, and gallery.

## What you still need to set in your Firebase console
1. Add `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS).
2. Update `lib/firebase_options.dart` with your real API keys/app IDs.
3. Enable providers in Firebase Auth:
   - Email/Password
   - Google
   - Microsoft
4. Deploy Firestore rules:
   ```bash
   firebase deploy --only firestore:rules
   ```
5. Seed starter data:
   ```bash
   python scripts/seed_firestore.py
   ```
   using env var `FIREBASE_SERVICE_ACCOUNT_JSON`.

## Logo / launcher icon
To use your exact PNG everywhere, replace:
- `assets/images/launcher_icon.png`

Then regenerate launcher icons:
```bash
flutter pub run flutter_launcher_icons
```


## Pull request note (binary files)
This project contains many images/fonts/GIF assets. To avoid PR tooling errors like **"binary files are not supported"**, assets are tracked with **Git LFS** via `.gitattributes`.

Before committing/pushing:
```bash
git lfs install
git lfs pull
```

