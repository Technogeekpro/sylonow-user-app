# Android Release Build & Google Play Submission Guide

## 🤖 Complete Guide for Google Play Store Submission

---

## Part 1: Create Release Keystore (One-Time Setup)

### Step 1: Generate Keystore

Open terminal and navigate to your project's android directory:

```bash
cd "/Users/arbazkudekar/Downloads/flutter projects/sylonow-user-app-1/android"
```

Generate the keystore:

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

**You'll be prompted for:**
1. **Keystore password**: Create a strong password (save it!)
2. **Re-enter password**: Confirm password
3. **Key password**: Can be same as keystore password (save it!)
4. **What is your first and last name?**: Arbaz Kudekar (or your name)
5. **What is the name of your organizational unit?**: Sylonow
6. **What is the name of your organization?**: Sylonow Vision Private Limited
7. **What is the name of your City or Locality?**: Bengaluru
8. **What is the name of your State or Province?**: Karnataka
9. **What is the two-letter country code?**: IN
10. **Is this correct?**: yes

### Step 2: Create key.properties File

Create `android/key.properties` (this file is already in .gitignore):

```properties
storePassword=YOUR_KEYSTORE_PASSWORD_HERE
keyPassword=YOUR_KEY_PASSWORD_HERE
keyAlias=upload
storeFile=../upload-keystore.jks
```

**Replace:**
- `YOUR_KEYSTORE_PASSWORD_HERE` with your actual keystore password
- `YOUR_KEY_PASSWORD_HERE` with your actual key password

### Step 3: Backup Your Keystore

**CRITICAL: Backup these files securely!**

```bash
# Copy to safe location (USB drive, encrypted cloud storage, etc.)
cp upload-keystore.jks ~/Desktop/BACKUP_upload-keystore.jks
cp key.properties ~/Desktop/BACKUP_key.properties

# Create a text file with passwords
echo "Keystore Password: YOUR_PASSWORD" > ~/Desktop/BACKUP_passwords.txt
echo "Key Password: YOUR_PASSWORD" >> ~/Desktop/BACKUP_passwords.txt
```

⚠️ **WARNING:** If you lose your keystore, you CANNOT update your app on Play Store. You'll have to publish a new app with a different package name!

---

## Part 2: Build Release APK/Bundle

### Option 1: Build App Bundle (Recommended for Play Store)

```bash
cd "/Users/arbazkudekar/Downloads/flutter projects/sylonow-user-app-1"

# Clean build
flutter clean
flutter pub get

# Build app bundle
flutter build appbundle --release
```

**Output location:**
```
build/app/outputs/bundle/release/app-release.aab
```

### Option 2: Build APK (For testing or alternative stores)

```bash
# Build release APK
flutter build apk --release

# Or build split APKs (smaller size)
flutter build apk --split-per-abi --release
```

**Output location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

### Build Verification

Check the build was signed correctly:

```bash
# For App Bundle
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab

# For APK
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk

# Should say "jar verified" if successful
```

---

## Part 3: Test Release Build

### Step 1: Install on Physical Device

```bash
# Install release APK
flutter install --release

# Or manually install
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Step 2: Test Critical Features

**Must test:**
- ✅ Login with phone OTP (SMS autofill should still work without manifest permissions)
- ✅ Google Sign-In
- ✅ Location services
- ✅ Camera access
- ✅ Photo picker
- ✅ QR code scanning
- ✅ Payment flow with Razorpay
- ✅ Firebase notifications
- ✅ Network requests to Supabase
- ✅ App doesn't crash on startup
- ✅ ProGuard didn't break anything

### Step 3: Check APK Size

```bash
# Check app bundle size
ls -lh build/app/outputs/bundle/release/app-release.aab

# Should be around 20-40 MB
```

---

## Part 4: Google Play Console Setup

### Step 1: Create App (If First Time)

1. Go to [Google Play Console](https://play.google.com/console)
2. Click **"Create app"**
3. Fill in details:
   - **App name**: Sylonow
   - **Default language**: English (United States)
   - **App or game**: App
   - **Free or paid**: Free
4. Accept declarations
5. Click **"Create app"**

### Step 2: Set Up Store Listing

Navigate to **"Store presence"** → **"Main store listing"**:

**App details:**
```
App name: Sylonow

Short description (80 chars):
Book trusted service providers for events, decorations, and celebrations

Full description:
Sylonow connects you with verified service providers for all your celebration needs. Whether it's birthday decorations, anniversary surprises, or event planning, find and book trusted vendors near you.

Features:
• Book verified service providers
• Real-time tracking & QR verification
• Secure payments with multiple options
• Wallet for easy refunds
• Browse services by category
• Location-based provider search
• Booking history & management

Perfect for:
✓ Birthday parties
✓ Anniversaries
✓ Corporate events
✓ Surprise arrangements
✓ Home decorations
✓ Event planning

Download now and make your celebrations memorable!
```

**App icon:**
- Upload: `assets/images/app_icon.png` (512x512 PNG)

**Screenshots:**
- Minimum 2 screenshots
- Recommended: 4-8 screenshots
- Size: 1080x1920 or 1440x2560

**Feature graphic:**
- Size: 1024x500
- Create using Canva or Photoshop

**App category:**
- Primary: Lifestyle or Events

**Contact details:**
```
Email: info@sylonow.com
Phone: +91 9741338102
Website: (if you have one)
```

**Privacy policy:**
- URL: (if hosted online)
- Or: Include in-app and note it in description

### Step 3: Fill Out Data Safety Form

Navigate to **"App content"** → **"Data safety"**:

**Data collection:**
- ✅ Yes, we collect data

**Location data:**
- ✅ Approximate location
- ✅ Precise location
- Purpose: App functionality
- Collected: Yes
- Shared: Yes (with service providers)
- Optional: No

**Personal info:**
- ✅ Name
- Purpose: App functionality, Account management
- Collected: Yes
- Shared: Yes (with service providers)

- ✅ Email address
- Purpose: App functionality (optional)
- Collected: Yes
- Shared: No
- Optional: Yes

- ✅ Phone number
- Purpose: App functionality, Account management
- Collected: Yes
- Shared: Yes (with service providers)
- Optional: No

**Photos and videos:**
- ✅ Photos
- Purpose: App functionality (profile pictures)
- Collected: Yes
- Shared: No
- Optional: Yes

**Financial info:**
- ✅ Payment info
- Purpose: Payment processing
- Collected: No (handled by Razorpay)
- Shared: Yes (with payment processor)

**Data security:**
- ✅ Data is encrypted in transit
- ✅ Users can request data deletion
- ✅ Committed to Google Play Families Policy: No (not targeting children)

### Step 4: App Access

Navigate to **"App content"** → **"App access"**:

- Select: **"All functionality is available without special access"**
- Or if needed, provide test credentials:
```
Username: +91 XXXXXXXXXX
Password: (if applicable)
Instructions: Use this phone number to receive OTP for login
```

### Step 5: Ads

Navigate to **"App content"** → **"Ads"**:
- Select: **"No, my app does not contain ads"** (or Yes if you have ads)

### Step 6: Content Rating

Navigate to **"App content"** → **"Content rating"**:

1. Click **"Start questionnaire"**
2. **Email address**: info@sylonow.com
3. **App category**: Utility, Productivity, Communication or Other
4. Answer questions honestly:
   - Violence: No
   - Sexual content: No
   - Bad language: No
   - Drugs/alcohol: No
5. Submit for rating

### Step 7: Target Audience

Navigate to **"App content"** → **"Target audience"**:
- **Age groups**: 18+ (based on your Terms of Service)

### Step 8: News Apps (Skip if not applicable)

### Step 9: COVID-19 Contact Tracing/Status Apps (Skip)

### Step 10: Data Safety Questionnaire

Navigate to **"App content"** → **"App content"**:
Complete all required declarations

---

## Part 5: Release Management

### Step 1: Create Internal Testing Track (Optional)

1. Go to **"Release"** → **"Testing"** → **"Internal testing"**
2. Click **"Create new release"**
3. Upload your AAB file: `app-release.aab`
4. Add release notes:
```
Initial release v1.0.0
- Phone, Google, and Apple sign-in
- Service browsing and booking
- Real-time tracking
- Secure payments
- QR vendor verification
```
5. Review and roll out
6. Share with internal testers

### Step 2: Create Production Release

1. Go to **"Release"** → **"Production"**
2. Click **"Create new release"**
3. Upload your AAB file: `app-release.aab`
4. **Release name**: 1.0.0 (1)
5. **Release notes** (in all languages):
```
🎉 Welcome to Sylonow!

Book trusted service providers for all your celebrations:
• Verified vendors for events, decorations & more
• Real-time tracking with QR verification
• Secure payments & instant wallet refunds
• Browse services by category
• Location-based provider search

Download now and make your celebrations memorable!
```
6. Click **"Next"**
7. Review release:
   - Check app bundle is correct
   - Verify release notes
   - Confirm all content declarations complete
8. Click **"Start rollout to production"**

### Step 3: Review and Publish

1. Complete all required tasks in dashboard
2. All green checkmarks should appear
3. Click **"Send for review"**
4. Google will review (usually 1-3 days)

---

## Part 6: Post-Submission

### Monitor Review Status

Check status in Play Console:
- **"Changes pending"**: Under review
- **"Publishing"**: Approved, rolling out
- **"Published"**: Live on Play Store!

### If Rejected

1. Read rejection email carefully
2. Fix issues mentioned
3. Build new AAB with incremented version:
   - Update `pubspec.yaml`: `version: 1.0.1+2`
   - Rebuild: `flutter build appbundle --release`
4. Upload new release
5. Add notes explaining fixes

---

## 🔧 Troubleshooting

### Build Fails with "key.properties not found"

**Solution:**
```bash
# Make sure file exists
ls -la android/key.properties

# If missing, create it (see Part 1, Step 2)
```

### "Failed to load keystore"

**Solution:**
- Check `storeFile` path in `key.properties`
- Ensure `upload-keystore.jks` exists in `android/` folder
- Verify password is correct

### "INSTALL_FAILED_UPDATE_INCOMPATIBLE"

**Solution:**
```bash
# Uninstall old debug version first
adb uninstall com.sylonow.sylonowUser

# Then install release
flutter install --release
```

### ProGuard Issues (App Crashes)

**Solution:**
Check `android/app/proguard-rules.pro` and add keep rules:
```proguard
-keep class your.crashing.class.** { *; }
```

### APK Too Large

**Solution:**
```bash
# Build with split APKs
flutter build apk --split-per-abi --release

# Results in smaller APKs for each architecture
```

---

## 📋 Pre-Submission Checklist

### Build Configuration
- [x] Release keystore created and backed up
- [x] key.properties configured
- [x] ProGuard rules added
- [x] Signing configuration in build.gradle.kts

### App Content
- [ ] App bundle built successfully
- [ ] Release build tested on physical device
- [ ] All features work in release mode
- [ ] No crashes or errors
- [ ] SMS autofill works without manifest permissions
- [ ] ProGuard didn't break functionality

### Google Play Console
- [ ] App created
- [ ] Store listing completed
- [ ] App icon uploaded (512x512)
- [ ] Screenshots uploaded (minimum 2)
- [ ] Feature graphic uploaded (1024x500)
- [ ] Data safety form completed
- [ ] Content rating received
- [ ] Target audience set (18+)
- [ ] All content declarations complete
- [ ] Privacy policy provided

### Release
- [ ] App bundle uploaded
- [ ] Release notes added
- [ ] Version number correct (1.0.0+1)
- [ ] Review initiated

---

## 📞 Support

Need help?
- Email: info@sylonow.com
- Phone: 9741338102 / 8867266638
- Company: Sylonow Vision Private Limited

---

## 🚀 Quick Commands Reference

```bash
# Navigate to project
cd "/Users/arbazkudekar/Downloads/flutter projects/sylonow-user-app-1"

# Clean and get dependencies
flutter clean && flutter pub get

# Build app bundle
flutter build appbundle --release

# Build APK
flutter build apk --release

# Install release
flutter install --release

# Verify signature
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

---

**Good luck with your Google Play submission! 🚀**
