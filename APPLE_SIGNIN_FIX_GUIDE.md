# Apple Sign In Error 1000 - Fix Guide

## Problem
You're getting `AuthorizationErrorCode.unknown (Error 1000)` when attempting Apple Sign In.

## Root Cause
This error occurs due to missing or incorrect configuration in:
1. **Supabase Dashboard** - Missing Apple provider configuration
2. **Apple Developer Console** - Missing or incorrect Service ID/Key configuration
3. **iOS Project** - Bundle ID or entitlements mismatch

## Solution Steps

### 1. Configure Apple Developer Console

#### Step 1.1: Create an App ID (if not already created)
1. Go to [Apple Developer Console](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles** → **Identifiers**
3. Find or create: `com.sylonow.sylonowUser`
4. **Enable**: ✅ Sign in with Apple
5. Click **Edit** → **Configure** and save

#### Step 1.2: Create a Services ID
1. In **Identifiers**, click **+** → Select **Services IDs** → Continue
2. **Description**: `Sylonow User Sign In`
3. **Identifier**: `com.sylonow.sylonowUser.signin` (or use `com.sylonow.sylonowUser`)
4. Click **Continue** → **Register**
5. Find the Services ID you just created and click **Configure**
6. ✅ Enable **Sign in with Apple**
7. Click **Configure** next to "Sign in with Apple"
8. **Primary App ID**: Select `com.sylonow.sylonowUser`
9. **Website URLs**:
   - **Domains**: `txgszrxjyanazlrupaty.supabase.co`
   - **Return URLs**: `https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback`
10. Click **Next** → **Done** → **Continue** → **Save**

#### Step 1.3: Create a Sign in with Apple Key
1. Navigate to **Certificates, Identifiers & Profiles** → **Keys**
2. Click **+** to create a new key
3. **Key Name**: `Sylonow Apple Sign In Key`
4. ✅ Enable **Sign in with Apple**
5. Click **Configure** → Select **Primary App ID**: `com.sylonow.sylonowUser`
6. Click **Save** → **Continue** → **Register**
7. **⚠️ IMPORTANT**: Download the `.p8` key file immediately (you can only download it once!)
8. **Note down**:
   - **Key ID** (10-character string, e.g., `ABC123DEFG`)
   - **Team ID** (in the top right, e.g., `XYZ987WXYZ`)

---

### 2. Configure Supabase Dashboard

1. Go to [Supabase Dashboard](https://supabase.com/dashboard/project/txgszrxjyanazlrupaty/auth/providers)
2. Navigate to: **Authentication** → **Providers**
3. Find **Apple** and click to configure
4. Toggle **Enable Sign in with Apple** to ON
5. Fill in the following fields:

   **Required Fields:**
   - **Services ID** (Client ID): `com.sylonow.sylonowUser.signin` (the Services ID you created)
   - **Secret Key** (Private Key):
     - Open the `.p8` file you downloaded in a text editor
     - Copy the entire contents (including `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----`)
     - Paste it into this field
   - **Key ID**: The 10-character Key ID from Step 1.3
   - **Team ID**: Your Apple Developer Team ID from Step 1.3

   **Optional Fields:**
   - **Authorized Client IDs**: Add your app's bundle ID: `com.sylonow.sylonowUser`

6. Click **Save**

**Expected Redirect URLs (auto-configured by Supabase):**
- `https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback`

---

### 3. Verify iOS Project Configuration

#### Step 3.1: Check Bundle Identifier in Xcode
1. Open Xcode: `/Users/arbazkudekar/Downloads/flutter projects/sylonow-user-app-1/ios/Runner.xcworkspace`
2. Select **Runner** (project) → **Runner** (target)
3. Under **General** tab:
   - **Bundle Identifier**: Must be `com.sylonow.sylonowUser`
   - **Team**: Must be set to your Apple Developer Team

#### Step 3.2: Verify Signing & Capabilities
1. In Xcode, go to **Signing & Capabilities** tab
2. Verify that **Sign in with Apple** capability is added
3. If not present:
   - Click **+ Capability**
   - Search for "Sign in with Apple"
   - Add it

#### Step 3.3: Verify Entitlements File
The file `ios/Runner/Runner.entitlements` should contain:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.applesignin</key>
    <array>
        <string>Default</string>
    </array>
</dict>
</plist>
```
✅ **This is already correct in your project**

---

### 4. Clean Build and Test

After completing all configuration steps:

```bash
# Navigate to project directory
cd "/Users/arbazkudekar/Downloads/flutter projects/sylonow-user-app-1"

# Clean Flutter build cache
flutter clean

# Get dependencies
flutter pub get

# Clean iOS build
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# Run on iOS device (Apple Sign In only works on real devices, not simulator)
flutter run -d <your-device-id>
```

---

## Testing Checklist

- [ ] Supabase Apple provider is enabled with correct Services ID
- [ ] Apple Developer Console Services ID is configured with Supabase redirect URL
- [ ] Sign in with Apple Key is created and added to Supabase
- [ ] Xcode project has "Sign in with Apple" capability
- [ ] Bundle ID matches across all configurations: `com.sylonow.sylonowUser`
- [ ] Testing on a **real iOS device** (not simulator)
- [ ] User is signed in to iCloud on the test device

---

## Common Issues and Solutions

### Issue 1: Still getting Error 1000
**Solution**:
- Wait 5-10 minutes after saving Supabase configuration (Apple's servers need time to propagate)
- Verify the Services ID redirect URL exactly matches: `https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback`
- Check that you're testing on a real device, not simulator

### Issue 2: "This app requires Sign in with Apple" error
**Solution**: Make sure the device is signed into iCloud (Settings → [Your Name])

### Issue 3: Credentials not being received
**Solution**:
- Revoke Apple Sign In access: Settings → Apple ID → Password & Security → Apps Using Your Apple ID → Sylonow User → Stop Using Apple ID
- Try signing in again

### Issue 4: Bundle ID mismatch error
**Solution**: Verify that the Bundle ID is exactly `com.sylonow.sylonowUser` in:
- Xcode → Runner target → General → Identity → Bundle Identifier
- Apple Developer Console → App ID
- Supabase Dashboard → Authorized Client IDs

---

## Debug Output

The updated code now includes detailed debug logging. When testing, watch for these console messages:

```
🍎 Starting Apple Sign In process...
🍎 Received credential from Apple
🍎 User ID: <user_id>
🍎 Email: <email>
🍎 Identity Token available: true
🍎 Successfully signed in to Supabase
🍎 User ID: <supabase_user_id>
```

If you see an error, it will now provide specific guidance:
```
🍎 Apple Sign In Authorization Error: AuthorizationErrorCode.unknown
🍎 Error message: <detailed_message>
```

---

## Additional Resources

- [Apple Sign In with Supabase Official Docs](https://supabase.com/docs/guides/auth/social-login/auth-apple)
- [Apple Developer - Sign in with Apple](https://developer.apple.com/sign-in-with-apple/)
- [Flutter sign_in_with_apple Package](https://pub.dev/packages/sign_in_with_apple)

---

## Summary of Changes Made to Code

1. ✅ Added nonce generation for enhanced security
2. ✅ Added comprehensive error handling with specific error codes
3. ✅ Added detailed debug logging at each step
4. ✅ Improved error messages to guide troubleshooting
5. ✅ Verified iOS entitlements configuration

The code changes are complete. Now you must complete the Supabase and Apple Developer Console configuration steps above.
