# Apple Sign-In Quick Checklist

Use this checklist to verify all Apple Sign-In configuration steps are complete.

## ✅ Code Changes (COMPLETED)

- [x] Updated [auth_service.dart](lib/features/auth/services/auth_service.dart#L292) with correct clientId
- [x] Implemented secure nonce generation with `Random.secure()`
- [x] Added SHA-256 nonce hashing
- [x] Added platform-specific clientId logic (iOS: `com.sylonow.usr.app`, Web: `com.sylonowusr`)
- [x] Enhanced error handling for audience mismatch
- [x] Updated [Info.plist](ios/Runner/Info.plist#L35) with Apple URL scheme
- [x] Changed Bundle Identifier to `com.sylonow.usr.app` in Xcode project
- [x] Code passes `flutter analyze` with no issues

## ⚠️ External Configuration (ACTION REQUIRED)

### Apple Developer Console

Log in to [Apple Developer Portal](https://developer.apple.com/account/resources/)

#### App ID Configuration
- [ ] Navigate to **Identifiers** → **App IDs**
- [ ] Find or create App ID: `com.sylonow.usr.app`
- [ ] Verify **Sign In with Apple** capability is enabled
- [ ] Click **Edit** → Enable as Primary App ID → **Save**

#### Services ID Configuration (for Web support)
- [ ] Navigate to **Identifiers** → **Services IDs**
- [ ] Find or create Services ID: `com.sylonowusr`
- [ ] Enable **Sign In with Apple**
- [ ] Click **Configure**:
  - [ ] Primary App ID: `com.sylonow.usr.app`
  - [ ] Domains: `txgszrxjyanazlrupaty.supabase.co`
  - [ ] Return URLs: `https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback`
- [ ] Click **Save** → **Continue** → **Register**

#### Private Key Generation
- [ ] Navigate to **Keys** section
- [ ] Click **+** to create new key
- [ ] Name: "Sylonow Apple Sign In Key"
- [ ] Check **Sign In with Apple**
- [ ] Click **Configure** → Select `com.sylonow.usr.app`
- [ ] Click **Save** → **Continue** → **Register**
- [ ] **Download the .p8 file** (only available once!)
- [ ] **Save the Key ID** (shown at top of page)

#### Team ID
- [ ] Go to **Membership** section
- [ ] Note your **Team ID** (format: XXXXXXXXXX)

### Supabase Configuration

Log in to [Supabase Dashboard](https://supabase.com/dashboard)

#### Apple Provider Setup
- [ ] Navigate to your project → **Authentication** → **Providers**
- [ ] Find **Apple** provider and enable it
- [ ] Configure settings:
  - [ ] **Client ID (iOS)**: `com.sylonow.usr.app`
  - [ ] **Client ID (Web)**: `com.sylonowusr` (if supporting web)
  - [ ] **Team ID**: [Your Team ID from Apple]
  - [ ] **Key ID**: [Your Key ID from Apple]
  - [ ] **Private Key**: [Paste contents of .p8 file]
- [ ] Click **Save**

#### URL Configuration
- [ ] Navigate to **Authentication** → **URL Configuration**
- [ ] Verify **Redirect URLs** includes:
  - [ ] `https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback`
  - [ ] Your app's deep link URL (if applicable)

### Xcode Configuration

#### Open Project
```bash
cd "/Users/arbazkudekar/Downloads/flutter projects/sylonow-user-app-1/ios"
open Runner.xcodeproj
```

#### Verify Settings
- [ ] Select **Runner** target
- [ ] Go to **Signing & Capabilities** tab
- [ ] Verify **Bundle Identifier**: `com.sylonow.usr.app`
- [ ] Select your **Team**
- [ ] Verify **Sign In with Apple** capability is present
- [ ] If missing, click **+ Capability** → Add **Sign In with Apple**

## 🧪 Testing

### Prerequisites
- [ ] Have a real iOS device (not simulator)
- [ ] Device is running iOS 13.0 or later
- [ ] Device is signed in to iCloud
- [ ] Device is connected to internet

### Test Steps
1. [ ] Connect iOS device to Mac
2. [ ] Run: `flutter run -d <device-id>`
3. [ ] Navigate to login screen
4. [ ] Tap "Sign in with Apple" button
5. [ ] Authenticate with Face ID/Touch ID
6. [ ] Verify user is logged in successfully
7. [ ] Check Supabase Dashboard → Authentication → Users for new user

### Expected Results
- [ ] First login: Apple prompts for consent and optionally name/email
- [ ] Subsequent logins: Quick authentication with biometrics
- [ ] User profile created in Supabase
- [ ] User redirected to home screen
- [ ] No error messages in console

## 🐛 Troubleshooting

If you encounter issues, check:

- [ ] **"Invalid client_id"**: Verify Bundle Identifier matches `com.sylonow.usr.app` in Xcode
- [ ] **"Audience mismatch"**: Verify Supabase Apple provider uses correct Client IDs
- [ ] **"Sign in not available"**: Ensure using real device, not simulator
- [ ] **"Error 1000"**: Check all Apple Developer Console settings are correct

For detailed troubleshooting, see [APPLE_SIGNIN_CONFIGURATION_GUIDE.md](APPLE_SIGNIN_CONFIGURATION_GUIDE.md#troubleshooting)

## 📚 Documentation

- [APPLE_SIGNIN_FIX_SUMMARY.md](APPLE_SIGNIN_FIX_SUMMARY.md) - Summary of changes made
- [APPLE_SIGNIN_CONFIGURATION_GUIDE.md](APPLE_SIGNIN_CONFIGURATION_GUIDE.md) - Complete configuration guide
- [APPLE_SIGNIN_ERROR_CODES.md](APPLE_SIGNIN_ERROR_CODES.md) - Error code reference

## ✅ Final Verification

Before deploying to production:

- [ ] All items in "External Configuration" section are complete
- [ ] Apple Sign-In tested successfully on real device
- [ ] User profile created correctly in Supabase
- [ ] No console errors during authentication
- [ ] App Store Connect bundle ID updated to `com.sylonow.usr.app`
- [ ] Provisioning profiles regenerated with new Bundle ID
- [ ] Push notification certificates updated (if applicable)

## 🚀 Ready to Deploy

Once all checkboxes are complete:
- Code changes are ready for commit
- External configurations are complete
- Testing is successful
- You're ready to submit to App Store

## Need Help?

See detailed guides:
1. [APPLE_SIGNIN_CONFIGURATION_GUIDE.md](APPLE_SIGNIN_CONFIGURATION_GUIDE.md) - Step-by-step setup
2. [APPLE_SIGNIN_FIX_SUMMARY.md](APPLE_SIGNIN_FIX_SUMMARY.md) - Technical details
3. [Apple Developer Documentation](https://developer.apple.com/sign-in-with-apple/)
