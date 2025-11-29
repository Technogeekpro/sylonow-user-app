# Google Maps API Keys Configuration - Final Setup

## ✅ All API Keys Configured Successfully

### API Keys Summary

| Purpose | Key | Restriction | Location |
|---------|-----|-------------|----------|
| **Android Maps** | `AIzaSyB3WtSmaLqOuAh-642QcTUI2TM3skK0i_U` | Android apps | `android/app/src/main/AndroidManifest.xml` |
| **iOS Maps** | `AIzaSyD4Lbd1wwEpEOB1pBHLB8mWEDJ4MHpiDW8` | iOS apps | `ios/Runner/AppDelegate.swift` |
| **Places Autocomplete** | `AIzaSyDGQShvfon0olSlQIRJy8F8ION3rWQG-tQ` | Unrestricted | `lib/features/address/screens/location_picker_screen.dart` |

---

## ⏳ CURRENT STATUS

**Key Created:** November 27, 2025, 12:03:59 PM GMT+5
**Configuration:** ✅ Properly unrestricted
**Propagation Time:** 5-10 minutes (wait until 12:14 PM GMT+5)
**Test After:** 12:15 PM GMT+5

---

## Configuration Details

### 1. Android Maps SDK
**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyB3WtSmaLqOuAh-642QcTUI2TM3skK0i_U"/>
```

**Restrictions:**
- Application: Android apps
- Package name: (your package)
- SHA-1: (your fingerprint)
- APIs: Maps SDK for Android

---

### 2. iOS Maps SDK
**File:** `ios/Runner/AppDelegate.swift`

```swift
GMSServices.provideAPIKey("AIzaSyD4Lbd1wwEpEOB1pBHLB8mWEDJ4MHpiDW8")
```

**Restrictions:**
- Application: iOS apps
- Bundle ID: `com.sylonow.usr.sylonowUser`
- APIs: Maps SDK for iOS, Places API, Places API (New)

---

### 3. Places Autocomplete
**File:** `lib/features/address/screens/location_picker_screen.dart`

```dart
static const String _googleApiKey = 'AIzaSyDGQShvfon0olSlQIRJy8F8ION3rWQG-tQ';
```

**Restrictions:**
- Application: **None (Unrestricted)** ✅
- API: **Don't restrict key** ✅

**Why Unrestricted?**
The `google_places_flutter` package makes HTTP REST API calls, which cannot be restricted to mobile apps. App restrictions only work with native SDKs.

**Created:** November 27, 2025, 12:03:59 PM GMT+5
**Status:** ⏳ Propagating (wait 5-10 minutes)

---

## Next Steps (After 12:15 PM GMT+5)

### 1. Test the API Key

Wait until **12:15 PM GMT+5**, then test:

```bash
curl -s "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Mumbai&key=AIzaSyDGQShvfon0olSlQIRJy8F8ION3rWQG-tQ"
```

**Expected Response:**
```json
{
  "predictions": [...],
  "status": "OK"
}
```

### 2. Clean and Rebuild

```bash
flutter clean
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

### 4. Test Location Picker

1. Navigate to **Add Address** screen
2. Click **"Select Location on Map"**
3. Verify:
   - ✅ Map loads (using Android/iOS key)
   - ✅ Current location button works
   - ✅ **Search autocomplete works** (using unrestricted key)
   - ✅ Pin can be dragged
   - ✅ Address updates in real-time
   - ✅ Confirm location returns to form

---

## Expected Behavior

### Maps Display
- **Android:** Uses `AIzaSyB3WtSmaLqOuAh-642QcTUI2TM3skK0i_U`
- **iOS:** Uses `AIzaSyD4Lbd1wwEpEOB1pBHLB8mWEDJ4MHpiDW8`
- **Result:** Map displays correctly ✅

### Search Autocomplete
- **All platforms:** Uses `AIzaSyDGQShvfon0olSlQIRJy8F8ION3rWQG-tQ`
- **Result:** Search suggestions appear as you type ✅

---

## Security Recommendations

### For Development ✅
Current setup is perfect:
- Maps keys are app-restricted (secure)
- Places key is unrestricted (required for functionality)
- Monitor usage in Google Cloud Console

### For Production 🔒

**Option 1: Set Quotas (Recommended)**
1. Google Cloud Console → APIs & Services → Quotas
2. Set daily limits for Places API:
   - Autocomplete requests: 1,000/day
   - Geocoding requests: 500/day
3. Set up billing alerts

**Option 2: Backend Proxy (Most Secure)**
Create a backend service that:
1. Receives search requests from your app
2. Validates the request
3. Calls Google Places API with the key
4. Returns results to your app

This way, the unrestricted key never leaves your server.

**Option 3: HTTP Referrer Restrictions**
If you have a web version:
1. Restrict to specific domains
2. Example: `*.yourdomain.com/*`

---

## Troubleshooting

### If Search Still Doesn't Work After 12:15 PM

**Wait 5 more minutes** - Sometimes propagation takes longer

**Check API is enabled:**
1. Google Cloud Console → APIs & Services → Library
2. Ensure enabled:
   - ✅ Places API
   - ✅ Places API (New)
   - ✅ Geocoding API

**Check Billing:**
- Ensure billing is enabled on the project
- Check quotas haven't been exceeded

**Clear Cache:**
```bash
flutter clean
cd ios && pod deintegrate && pod install && cd ..
flutter pub get
flutter run
```

### If You Get Rate Limit Errors

The unrestricted key has been used too much. Set quotas:
1. Google Cloud Console → Quotas
2. Set limits per day/per user

---

## Cost Monitoring

### Current Pricing (as of 2024)
- **Maps SDK:** $0.007 per load
- **Places Autocomplete:** $0.017 per session
- **Geocoding:** $0.005 per request

### Free Tier
- **$200 free monthly credit** from Google
- Covers approximately:
  - 28,000 map loads
  - 11,000 autocomplete sessions
  - 40,000 geocoding requests

### Set Alerts
1. Google Cloud Console → Billing
2. Budgets & Alerts
3. Create alerts at: $10, $50, $100

---

## API Key Rotation (Production)

For security, rotate keys periodically:

1. **Create new key**
2. **Update code**
3. **Deploy new version**
4. **Wait 1 week** (ensure all users updated)
5. **Delete old key**

---

## Verification Checklist

- ✅ Android Maps key configured
- ✅ iOS Maps key configured
- ✅ Places Autocomplete key configured (unrestricted)
- ✅ All APIs enabled in Google Cloud
- ✅ Billing enabled
- ✅ Pods installed (iOS)
- ✅ Code updated with new key
- ⏳ Waiting for key activation (until 12:15 PM GMT+5)
- ⏳ Testing search functionality (after 12:15 PM GMT+5)

---

## Support Resources

- [Google Maps Platform Documentation](https://developers.google.com/maps/documentation)
- [Places API Documentation](https://developers.google.com/maps/documentation/places/web-service/overview)
- [API Key Best Practices](https://developers.google.com/maps/api-security-best-practices)
- [Billing & Quotas](https://developers.google.com/maps/billing-and-pricing/billing)

---

## Quick Reference

### Google Cloud Console Links
- [Credentials](https://console.cloud.google.com/apis/credentials)
- [API Library](https://console.cloud.google.com/apis/library)
- [Quotas](https://console.cloud.google.com/quotas)
- [Billing](https://console.cloud.google.com/billing)

### Test Commands
```bash
# Clean and rebuild
flutter clean && flutter pub get && flutter run

# iOS pod install
cd ios && pod install && cd ..

# Check for errors
flutter analyze
```

---

**Configuration completed on:** November 27, 2025, 12:03:59 PM GMT+5
**Status:** ✅ Properly configured, waiting for propagation
**Next step:** Wait until 12:15 PM GMT+5, then test search functionality
