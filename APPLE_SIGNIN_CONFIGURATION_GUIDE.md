# Apple Sign-In Configuration Guide

This guide provides step-by-step instructions to configure Apple Sign-In for the Sylonow User app, resolving the AuthApiException audience error.

## Overview

The app has been updated to use the correct client IDs:
- **iOS/macOS**: `com.sylonow.usr.app` (App ID)
- **Web**: `com.sylonowusr` (Services ID)

## Code Changes Completed

### 1. Updated [auth_service.dart](lib/features/auth/services/auth_service.dart)

- ✅ Added secure nonce generation using `Random.secure()`
- ✅ Implemented SHA-256 hashing for nonce
- ✅ Added platform-specific clientId logic
- ✅ Enhanced error handling for audience mismatch
- ✅ Added nonce storage for backend validation

### 2. Updated [Info.plist](ios/Runner/Info.plist)

- ✅ Added Apple Sign-In URL scheme: `com.sylonow.usr.app`

### 3. Updated Xcode Project Configuration

- ✅ Changed Bundle Identifier from `com.sylonow.sylonowUser` to `com.sylonow.usr.app`

## Apple Developer Console Configuration

### Step 1: Verify/Create App ID

1. Log in to [Apple Developer Portal](https://developer.apple.com/account/resources/)
2. Navigate to **Certificates, Identifiers & Profiles** → **Identifiers**
3. Find or create **App ID**: `com.sylonow.usr.app`
4. Ensure **Sign In with Apple** capability is enabled:
   - Click on the App ID
   - Scroll to **Capabilities**
   - Check "Sign In with Apple"
   - Click **Save**

### Step 2: Configure Services ID (for Web - Optional)

If you plan to support web:

1. Navigate to **Identifiers** → **Services IDs**
2. Create or find Services ID: `com.sylonowusr`
3. Enable **Sign In with Apple**
4. Click **Configure** next to Sign In with Apple
5. Set the following:
   - **Primary App ID**: Select `com.sylonow.usr.app`
   - **Website URLs**:
     - **Domains**: Add your Supabase project domain (e.g., `yourproject.supabase.co`)
     - **Return URLs**: Add `https://yourproject.supabase.co/auth/v1/callback`
6. Click **Save** → **Continue** → **Register**

### Step 3: Verify Sign In with Apple Configuration

1. Go to **Identifiers** → Select `com.sylonow.usr.app`
2. Scroll to **Sign In with Apple** capability
3. Click **Edit**
4. Ensure configuration shows:
   - ✅ Enable as a primary App ID
5. Click **Save**

### Step 4: Generate Private Key (if not already done)

1. Navigate to **Keys** section
2. Click **+** to create a new key
3. Enter a name (e.g., "Sylonow Apple Sign In Key")
4. Check **Sign In with Apple**
5. Click **Configure** → Select `com.sylonow.usr.app`
6. Click **Save** → **Continue** → **Register**
7. Download the `.p8` key file (you can only download it once!)
8. Save the **Key ID** - you'll need this for Supabase

### Step 5: Note Required Information

For Supabase configuration, you'll need:
- **Team ID**: Found in Apple Developer Account → Membership
- **Key ID**: From Step 4
- **Private Key**: Contents of the `.p8` file
- **Services ID**: `com.sylonowusr` (for web) or `com.sylonow.usr.app` (for mobile)

## Xcode Configuration

### Step 1: Open Project in Xcode

```bash
cd ios
open Runner.xcodeproj
```

### Step 2: Verify Signing & Capabilities

1. Select **Runner** target
2. Go to **Signing & Capabilities** tab
3. Verify:
   - ✅ Bundle Identifier: `com.sylonow.usr.app`
   - ✅ Team: Select your team
   - ✅ **Sign In with Apple** capability is added

### Step 3: Add Sign In with Apple Capability (if missing)

1. Click **+ Capability**
2. Search for "Sign In with Apple"
3. Double-click to add

## Supabase Configuration

### Step 1: Configure Apple Provider

1. Go to your Supabase Dashboard
2. Navigate to **Authentication** → **Providers**
3. Find **Apple** provider
4. Enable it and configure:
   - **Client ID (iOS)**: `com.sylonow.usr.app`
   - **Client ID (Web)**: `com.sylonowusr` (if supporting web)
   - **Team ID**: Your Apple Team ID
   - **Key ID**: From Apple Developer Console
   - **Private Key**: Contents of `.p8` file
5. Click **Save**

### Step 2: Update Redirect URLs

1. In Supabase Dashboard → **Authentication** → **URL Configuration**
2. Ensure **Redirect URLs** includes:
   - `yourapp://auth/callback` (for deep linking)
   - `https://yourproject.supabase.co/auth/v1/callback`

## Testing

### Prerequisites

- ✅ Real iOS device (Apple Sign-In does NOT work on simulators)
- ✅ Device signed in to iCloud with an Apple ID
- ✅ Internet connection

### Testing Steps

1. Build and run the app on a real iOS device:
   ```bash
   flutter run -d <device-id>
   ```

2. Tap "Sign in with Apple" button
3. Authenticate with Face ID/Touch ID or Apple ID password
4. Verify successful authentication

### Expected Behavior

- First time: Apple will ask for consent and optionally name/email
- Subsequent times: Quick authentication with Face ID/Touch ID
- Profile should be created in Supabase
- User should be redirected to home screen

## Troubleshooting

### Error: "Invalid client_id"

**Cause**: Bundle Identifier mismatch

**Solution**:
1. Verify Xcode Bundle Identifier is `com.sylonow.usr.app`
2. Verify Apple Developer Console has App ID `com.sylonow.usr.app`
3. Clean build: `flutter clean && flutter pub get`

### Error: "Audience mismatch" or "aud claim mismatch"

**Cause**: Token validation expects different client ID

**Solution**:
1. Verify code uses `com.sylonow.usr.app` for iOS (check [auth_service.dart:317](lib/features/auth/services/auth_service.dart#L317))
2. Verify Supabase Apple provider uses correct Client ID
3. Check Apple Developer Console configuration

### Error: "Sign in with Apple is not available"

**Cause**: Running on simulator or device not configured

**Solution**:
1. Use a real iOS device (not simulator)
2. Ensure device is signed in to iCloud
3. Check device has iOS 13+ (required for Apple Sign-In)

### Error: "Invalid nonce"

**Cause**: Nonce generation or validation issue

**Solution**:
1. Verify nonce is generated correctly (check [auth_service.dart:307](lib/features/auth/services/auth_service.dart#L307))
2. Ensure hashed nonce is sent to Apple
3. Ensure raw nonce is sent to Supabase

### Error 1000: "Unknown error"

**Cause**: Multiple possible issues

**Solution**:
1. Verify all Apple Developer Console settings
2. Check Supabase redirect URLs
3. Ensure Sign In with Apple capability is enabled in Xcode
4. Try revoking Apple Sign-In permissions on device (Settings → Apple ID → Password & Security → Apps Using Apple ID)

## Verification Checklist

Before testing, verify:

### Code
- ✅ [auth_service.dart](lib/features/auth/services/auth_service.dart) uses correct clientId
- ✅ Nonce is generated securely with `Random.secure()`
- ✅ Nonce is hashed with SHA-256 for Apple request
- ✅ Raw nonce is used for Supabase validation

### iOS Configuration
- ✅ Bundle Identifier: `com.sylonow.usr.app`
- ✅ [Info.plist](ios/Runner/Info.plist) includes Apple URL scheme
- ✅ Sign In with Apple capability enabled in Xcode

### Apple Developer Console
- ✅ App ID `com.sylonow.usr.app` exists
- ✅ Sign In with Apple enabled for App ID
- ✅ Private key generated and downloaded
- ✅ Services ID `com.sylonowusr` configured (if using web)

### Supabase
- ✅ Apple provider enabled
- ✅ Correct Client IDs configured
- ✅ Team ID, Key ID, and Private Key configured
- ✅ Redirect URLs configured

## Security Best Practices

1. **Nonce Generation**: Uses cryptographically secure random number generator
2. **Nonce Hashing**: SHA-256 hash prevents nonce replay attacks
3. **Token Validation**: Supabase validates ID token and nonce
4. **Secure Storage**: Nonce stored securely in SharedPreferences
5. **Error Handling**: Specific error messages for different failure scenarios

## References

- [Apple Sign-In Documentation](https://developer.apple.com/sign-in-with-apple/)
- [Supabase Apple Sign-In Guide](https://supabase.com/docs/guides/auth/social-login/auth-apple)
- [sign_in_with_apple Package](https://pub.dev/packages/sign_in_with_apple)

## Support

If issues persist:
1. Check [APPLE_SIGNIN_ERROR_CODES.md](APPLE_SIGNIN_ERROR_CODES.md) for detailed error information
2. Review Supabase logs in Dashboard → Logs
3. Check Xcode console for detailed error messages
4. Verify device meets all prerequisites (real device, iOS 13+, signed in to iCloud)
