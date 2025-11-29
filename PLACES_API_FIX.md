# Fix: "Invalid API Key" Error in Places Autocomplete

## Problem

The Google Maps is working fine, but when searching for a location, you get "Invalid API Key" error in the Places Autocomplete search.

## Root Cause

The `google_places_flutter` package makes **HTTP requests** to Google Places API, which requires:
1. **Places API (New)** to be enabled
2. An **unrestricted API key** OR proper HTTP referrer restrictions

Your current Android/iOS restricted keys work for Maps SDK but NOT for HTTP-based Places API calls.

## Solution

You have 2 options:

---

## Option 1: Create Unrestricted API Key (Quick Fix for Testing)

### Step 1: Create New API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to: **APIs & Services** → **Credentials**
3. Click **"Create Credentials"** → **"API Key"**
4. Copy the new API key

### Step 2: Enable Places API (New)

1. Go to **APIs & Services** → **Library**
2. Search for **"Places API (New)"**
3. Click **"Enable"**
4. Also search and enable **"Places API"** (legacy) if not already enabled

### Step 3: Configure the New Key

**For Testing (Development):**
- Leave the key **unrestricted** temporarily
- This allows HTTP requests from anywhere

**For Production (Recommended):**
- Click "Restrict Key"
- Under "API restrictions", select:
  - ✅ Places API (New)
  - ✅ Places API
  - ✅ Geocoding API
- Under "Application restrictions":
  - Select "HTTP referrers (web sites)"
  - Add: `*` (for testing) or your domain

### Step 4: Update Your Code

Replace the API key in the location picker:

```dart
// In lib/features/address/screens/location_picker_screen.dart
static const String _googleApiKey = 'YOUR_NEW_UNRESTRICTED_API_KEY_HERE';
```

---

## Option 2: Use Different Package (Alternative Solution)

If you prefer not to use an unrestricted key, you can implement a custom autocomplete using Flutter's built-in packages.

### Install Alternative Package

```yaml
# In pubspec.yaml
dependencies:
  flutter_google_places_hoc081098: ^1.1.0
```

This package has better support for mobile app restrictions.

---

## Option 3: Backend Proxy (Most Secure - Production)

For maximum security, create a backend endpoint that proxies the Places API requests:

1. **Backend API** (Node.js/Python/etc.) makes the request with unrestricted key
2. **Flutter app** calls your backend
3. **Your backend** validates the request and forwards to Google

This way, the API key never leaves your server.

---

## Quick Fix Steps (Recommended)

### 1. Check Current API Key Restrictions

```bash
# Go to Google Cloud Console
# APIs & Services → Credentials
# Click on: AIzaSyB3WtSmaLqOuAh-642QcTUI2TM3skK0i_U
```

Check if it shows:
- **Application restrictions**: Android apps (or iOS apps)
- This is WHY it doesn't work for HTTP requests!

### 2. Create Unrestricted Key

```bash
# In Google Cloud Console
# Click "Create Credentials" → "API Key"
# Name: "Places Autocomplete - Unrestricted"
# Leave "Application restrictions" as "None"
```

### 3. Enable Required APIs

Ensure these are enabled:
- ✅ Maps SDK for Android
- ✅ Maps SDK for iOS
- ✅ **Places API (New)** ← Most important
- ✅ Places API (legacy)
- ✅ Geocoding API

### 4. Update Code

```dart
// lib/features/address/screens/location_picker_screen.dart
static const String _googleApiKey = 'YOUR_NEW_UNRESTRICTED_KEY';
```

### 5. Test

```bash
flutter clean
flutter pub get
flutter run
```

---

## Verification Steps

### Test if API Key Works:

You can test the API key directly:

```bash
curl "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Mumbai&key=YOUR_API_KEY"
```

**Expected Response:**
```json
{
  "predictions": [...],
  "status": "OK"
}
```

**If you get error:**
```json
{
  "status": "REQUEST_DENIED",
  "error_message": "This API key is not authorized..."
}
```
→ The key needs to be unrestricted or have HTTP referrer restrictions.

---

## Security Best Practices

### Development Environment:
✅ Use unrestricted key
✅ Monitor usage in Google Cloud Console
✅ Set daily quotas to prevent abuse

### Production Environment:

**Option A: HTTP Referrer Restrictions**
```
Allowed HTTP referrers:
*yourdomain.com/*
*yourapp.page.link/*
```

**Option B: Backend Proxy (Most Secure)**
```
Mobile App → Your Backend → Google Places API
           (API key hidden on server)
```

**Option C: Use both keys**
```dart
// For Maps SDK (restricted to Android/iOS)
static const String _mapsApiKey = 'AIzaSyB3WtSmaLqOuAh-642QcTUI2TM3skK0i_U';

// For Places Autocomplete (unrestricted or HTTP referrer restricted)
static const String _placesApiKey = 'AIzaSy...NewUnrestrictedKey';
```

---

## Why This Happens

### The Technical Reason:

1. **Maps SDK** (google_maps_flutter):
   - Uses **native Android/iOS SDKs**
   - Validates API key using **package name + SHA-1** (Android) or **bundle ID** (iOS)
   - Works with app-restricted keys ✅

2. **Places Autocomplete** (google_places_flutter):
   - Makes **HTTP REST API calls**
   - Google's servers validate using **HTTP referer** or **IP address**
   - Does NOT work with Android/iOS app restrictions ❌

### The Solution:

Either:
- Use **unrestricted** key (with quotas)
- Use **HTTP referrer** restrictions
- Use **backend proxy** to hide the key

---

## Cost Monitoring

Places Autocomplete pricing:
- **Autocomplete - Per Session**: $0.017 per session
- **Autocomplete - Per Request**: $0.00283 per request

Set billing alerts:
1. Google Cloud Console → Billing → Budgets & Alerts
2. Set alert at $10, $50, $100

---

## Troubleshooting

### Still Getting Invalid API Key?

1. **Wait 5 minutes** - API key changes take time to propagate
2. **Clear app cache**: `flutter clean && flutter run`
3. **Check API is enabled**: Places API (New) in Google Cloud
4. **Check quotas**: Ensure you haven't hit daily limits
5. **Check billing**: Ensure billing is enabled on the project

### Error: "This API project is not authorized..."

→ **Places API is not enabled**. Go enable it in Library.

### Error: "The provided API key is invalid"

→ **Key is restricted**. Use unrestricted key or change restrictions.

---

## Immediate Action Items

1. ✅ Go to Google Cloud Console
2. ✅ Create a new unrestricted API key
3. ✅ Enable "Places API (New)"
4. ✅ Update `location_picker_screen.dart` with new key
5. ✅ Test the autocomplete search
6. ✅ Set billing alerts to monitor usage

---

## Contact Support

If issues persist after following these steps, check:
- [Google Maps Platform Support](https://developers.google.com/maps/support)
- [Stack Overflow - google-places-api](https://stackoverflow.com/questions/tagged/google-places-api)
