# Sign in with Apple - Configuration Guide

## 🍎 Step-by-Step Setup for Apple Developer Console

### Prerequisites
- Apple Developer Account ($99/year)
- Admin access to Supabase project
- Xcode installed on Mac

---

## Part 1: Apple Developer Console Setup

### Step 1: Create an App ID

1. Go to [Apple Developer](https://developer.apple.com/account/resources/identifiers/list)
2. Click the **"+"** button to create a new identifier
3. Select **"App IDs"** → Continue
4. Select **"App"** → Continue
5. Fill in the details:
   - **Description**: Sylonow User App
   - **Bundle ID**: `com.sylonowusr.app` (must match your app)
   - **Capabilities**: Check ✓ **"Sign in with Apple"**
6. Click **"Continue"** → **"Register"**

### Step 2: Create a Services ID

1. Go to [Identifiers](https://developer.apple.com/account/resources/identifiers/list)
2. Click **"+"** → Select **"Services IDs"** → Continue
3. Fill in details:
   - **Description**: Sylonow Auth Service
   - **Identifier**: `com.sylonowusr.app.auth` (can be anything unique)
4. Check ✓ **"Sign in with Apple"**
5. Click **"Configure"** next to Sign in with Apple:
   - **Primary App ID**: Select `com.sylonowusr.app`
   - **Domains and Subdomains**:
     - Add: `txgszrxjyanazlrupaty.supabase.co`
   - **Return URLs**:
     - Add: `https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback`
6. Click **"Save"** → **"Continue"** → **"Register"**

### Step 3: Create a Private Key

1. Go to [Keys](https://developer.apple.com/account/resources/authkeys/list)
2. Click **"+"** → Fill in details:
   - **Key Name**: Sylonow Apple Sign In Key
   - Check ✓ **"Sign in with Apple"**
3. Click **"Configure"** next to Sign in with Apple:
   - **Primary App ID**: Select `com.sylonowusr.app`
4. Click **"Save"** → **"Continue"** → **"Register"**
5. Click **"Download"** → Save the `.p8` file securely
   - ⚠️ **You can only download this ONCE!** Keep it safe!
6. Note down:
   - **Key ID** (e.g., `ABC123DEF4`)
   - **Team ID** (found in top right corner)

---

## Part 2: Xcode Configuration

### Step 1: Open Project in Xcode

```bash
cd ios
open Runner.xcworkspace
```

### Step 2: Add Sign in with Apple Capability

1. In Xcode, select **Runner** in the left panel
2. Select **Runner** target (under TARGETS)
3. Go to **"Signing & Capabilities"** tab
4. Click **"+ Capability"** button
5. Search for **"Sign in with Apple"**
6. Double-click to add it
7. You should see "Sign in with Apple" capability added

### Step 3: Build and Test

```bash
# Build iOS app
flutter build ios --release

# Or run on simulator
flutter run
```

---

## Part 3: Supabase Configuration

### Step 1: Enable Apple Provider

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Select your project: `txgszrxjyanazlrupaty`
3. Go to **Authentication** → **Providers**
4. Find **Apple** and click **"Enable"**

### Step 2: Configure Apple Provider

Fill in the following details:

**Services ID:**
```
com.sylonowusr.app.auth
```

**Authorized Client IDs** (optional):
```
com.sylonowusr.app
```

**Apple Secret (JWT):**
- Click **"Generate JWT from .p8 file"**
- Upload your `.p8` file
- Enter your **Team ID** (from Apple Developer)
- Enter your **Key ID** (from Apple Developer)
- Enter your **Services ID**: `com.sylonowusr.app.auth`
- Click **"Generate Secret"**
- Copy the generated secret

**Redirect URL:**
```
https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback
```

### Step 3: Save Configuration

1. Click **"Save"**
2. Test the configuration using Supabase's test button

---

## Part 4: Testing Sign in with Apple

### Test on iOS Simulator

1. Open Settings app on simulator
2. Go to **"Sign in to iPhone"**
3. Sign in with your Apple ID
4. Run your app
5. Tap **"Continue with Apple"**
6. Authenticate with Face ID/Touch ID (simulator uses keyboard)
7. Choose **"Share My Email"** or **"Hide My Email"**
8. Verify user is created in Supabase Auth dashboard

### Test on Physical Device

1. Build and install release version:
```bash
flutter build ios --release
flutter install --release
```

2. Make sure device is signed in to iCloud
3. Test Sign in with Apple button
4. Verify authentication works

---

## 🔧 Troubleshooting

### Error: "Invalid Client"
**Cause**: Services ID doesn't match or not configured correctly
**Fix**: Double-check Services ID in Apple Developer and Supabase

### Error: "Invalid Redirect URI"
**Cause**: Return URL not configured in Services ID
**Fix**: Add `https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback` to Services ID

### Error: "Invalid Grant"
**Cause**: Private key or Team ID mismatch
**Fix**: Regenerate JWT secret in Supabase with correct key

### Button Not Showing
**Cause**: Device doesn't support Sign in with Apple
**Fix**: Test on iOS 13+ or macOS 10.15+

---

## 📝 Configuration Summary

Copy these values for reference:

| Item | Value |
|------|-------|
| **Bundle ID** | `com.sylonowusr.app` |
| **Services ID** | `com.sylonowusr.app.auth` |
| **Supabase URL** | `https://txgszrxjyanazlrupaty.supabase.co` |
| **Redirect URL** | `https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback` |
| **Team ID** | _(Get from Apple Developer)_ |
| **Key ID** | _(Get from Apple Developer)_ |
| **Private Key** | _(Downloaded .p8 file)_ |

---

## ✅ Verification Checklist

- [ ] App ID created with Sign in with Apple capability
- [ ] Services ID created and configured
- [ ] Private key (.p8) created and downloaded
- [ ] Team ID and Key ID noted
- [ ] Xcode capability added
- [ ] Supabase Apple provider enabled and configured
- [ ] JWT secret generated in Supabase
- [ ] Tested on iOS simulator
- [ ] Tested on physical device
- [ ] User created in Supabase Auth dashboard after sign in

---

## 🔐 Security Notes

1. **NEVER share your .p8 private key** - Keep it encrypted and backed up
2. **Keep Team ID and Key ID private** - Don't commit to Git
3. **Rotate keys annually** - Best security practice
4. **Monitor auth logs** - Check Supabase dashboard for suspicious activity

---

## 📚 Additional Resources

- [Apple Sign in Documentation](https://developer.apple.com/sign-in-with-apple/)
- [Supabase Apple Auth Guide](https://supabase.com/docs/guides/auth/social-login/auth-apple)
- [Flutter Sign in with Apple Package](https://pub.dev/packages/sign_in_with_apple)

---

**Need Help?**
- Email: info@sylonow.com
- Phone: 9741338102 / 8867266638
