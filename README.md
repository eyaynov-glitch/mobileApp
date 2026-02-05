# Ynov Campus League (YCL)

This repository now contains a **Flutter starter implementation** of your school app adapted for **Ynov Campus Maroc (Casablanca)** with:

- App name changed to **Ynov Campus League (YCL)**.
- Splash/login flow prepared for replacing old DYC branding with your own logo.
- Firebase email/password login + register.
- Restricted authentication to `@ynov.com` email addresses.
- Google sign-in + Microsoft sign-in integration points.
- Role model structure for student/professor/admin/clubLead.
- Clubs page with join/quit actions.
- Events page with grid/list toggle and image support.
- Real-time chat with Firestore streams.
- Profile editing flow, camera/gallery/microphone permissions.
- Local notifications service.
- Google Maps page centered on Casablanca.
- Firestore seeding script with Moroccan sample clubs/events.

## Important security note
You shared a Firebase service account private key in chat. **Revoke/rotate it immediately** in Google Cloud IAM, then generate a new one.

## Setup checklist

1. Create the Flutter project shell (if not already):
   ```bash
   flutter create .
   ```
2. Add your custom app icon/logo files under:
   - `assets/images/app_logo.png`
   - launcher icon assets generated with `flutter_launcher_icons`.
3. Install Firebase CLI and configure platforms:
   ```bash
   flutterfire configure --project=ynov-campus-league-d510f
   ```
4. Add platform Firebase files:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
5. Install packages:
   ```bash
   flutter pub get
   ```
6. Install seed dependency:
   ```bash
   npm install
   ```
7. Seed your Firestore DB with Moroccan data:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/new-service-account.json"
   npm run seed
   ```
8. Deploy rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

## Where to replace logos
- Splash logo area: `lib/pages/splash_page.dart`
- App launcher icon reference: `android/app/src/main/AndroidManifest.xml`

## What you still need from Firebase console
- Enable providers in Firebase Auth: Email/Password, Google, Microsoft.
- For Microsoft provider, configure Azure AD app and copy client ID/secret in Firebase Auth provider config.
- Add Firestore indexes if prompted for chat/events queries.

