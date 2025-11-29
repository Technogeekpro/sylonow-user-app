# Google Maps API Setup Guide

This guide explains how to set up Google Maps API for the location picker feature in the Sylonow User app.

## Prerequisites

- Google Cloud Platform account
- Project with billing enabled

## Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable billing for the project

## Step 2: Enable Required APIs

Enable the following APIs in your Google Cloud project:

1. **Maps SDK for Android**
   - Go to APIs & Services → Library
   - Search for "Maps SDK for Android"
   - Click "Enable"

2. **Maps SDK for iOS**
   - Search for "Maps SDK for iOS"
   - Click "Enable"

3. **Places API**
   - Search for "Places API"
   - Click "Enable"

4. **Geocoding API**
   - Search for "Geocoding API"
   - Click "Enable"

## Step 3: Create API Keys

### For Android

1. Go to APIs & Services → Credentials
2. Click "Create Credentials" → "API Key"
3. Copy the API key
4. Click "Restrict Key"
5. Under "Application restrictions", select "Android apps"
6. Click "Add an item"
7. Add your package name: `com.sylonowusr.sylonow_user`
8. Get your SHA-1 fingerprint:
   ```bash
   # For debug key
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

   # For release key (use your keystore path)
   keytool -list -v -keystore /path/to/your/keystore.jks -alias your-alias
   ```
9. Add the SHA-1 fingerprint
10. Under "API restrictions", select "Restrict key"
11. Select the APIs you enabled above
12. Save

### For iOS

1. Create another API key for iOS
2. Under "Application restrictions", select "iOS apps"
3. Add your bundle identifier: (check your ios/Runner.xcodeproj for bundle ID)
4. Under "API restrictions", select "Restrict key"
5. Select the APIs you enabled above
6. Save

## Step 4: Configure Android App

1. Open `android/app/src/main/AndroidManifest.xml`

2. Add the API key inside the `<application>` tag:

```xml
<application>
    <!-- Add this meta-data tag -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_ANDROID_API_KEY_HERE"/>

    <!-- Rest of your application configuration -->
</application>
```

3. Add permissions (if not already present):

```xml
<manifest>
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

    <application>
        <!-- ... -->
    </application>
</manifest>
```

## Step 5: Configure iOS App

1. Open `ios/Runner/AppDelegate.swift`

2. Add the import at the top:

```swift
import GoogleMaps
```

3. Add the API key in the `application` method:

```swift
import UIKit
import Flutter
import GoogleMaps  // Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Add this line with your iOS API key
    GMSServices.provideAPIKey("YOUR_IOS_API_KEY_HERE")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

4. Update `ios/Podfile` to set minimum iOS version (if needed):

```ruby
platform :ios, '12.0'
```

5. Run pod install:

```bash
cd ios
pod install
cd ..
```

## Step 6: Update Location Picker Screen

1. Open `lib/features/address/screens/location_picker_screen.dart`

2. Replace the placeholder API key:

```dart
// Find this line (around line 42)
static const String _googleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

// Replace with your actual API key
static const String _googleApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
```

**Note:** The same API key can be used here, or you can create a separate unrestricted key for the Places Autocomplete widget.

## Step 7: Test the Implementation

1. Run the app:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. Navigate to Add Address screen
3. Click "Select Location on Map"
4. Verify:
   - Map loads correctly
   - Current location button works
   - Search autocomplete works
   - Pin movement updates address
   - Confirm location returns data

## Important Security Notes

### Production Best Practices

1. **API Key Restrictions:**
   - Always restrict API keys by application (package name/bundle ID)
   - Restrict by SHA-1 fingerprint for Android
   - Restrict to specific APIs only

2. **Environment Variables:**
   - Consider using environment variables for API keys
   - Use `--dart-define` for Flutter:
     ```bash
     flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_key_here
     ```
   - Access in code:
     ```dart
     static const String _googleApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
     ```

3. **Git Security:**
   - Never commit API keys to Git
   - Add to `.gitignore`:
     ```
     # Google Maps API Keys
     android/app/src/main/AndroidManifest.xml
     ios/Runner/AppDelegate.swift
     lib/core/config/api_keys.dart
     ```
   - Create a template file for team members

4. **Monitoring:**
   - Set up billing alerts in Google Cloud Console
   - Monitor API usage regularly
   - Set quotas to prevent unexpected charges

## Troubleshooting

### Map Not Showing

- Check API key is correctly added
- Verify Maps SDK is enabled in Google Cloud
- Check bundle ID/package name matches restrictions
- Look for errors in console

### Autocomplete Not Working

- Verify Places API is enabled
- Check API key restrictions allow Places API
- Ensure internet permission is added
- Check console for API errors

### iOS Build Issues

- Run `cd ios && pod install`
- Clean build folder in Xcode
- Ensure minimum iOS version is 12.0 or higher

### Android Build Issues

- Check SHA-1 fingerprint matches
- Verify package name is correct
- Clean and rebuild: `flutter clean && flutter pub get`

## Billing Information

Google Maps Platform has a [free tier](https://mapsplatform.google.com/pricing/):
- $200 monthly credit
- Maps SDK for Android/iOS: $0.007 per load (after free tier)
- Places API: $0.032 per request (after free tier)
- Geocoding API: $0.005 per request (after free tier)

Set up billing alerts to monitor usage!

## Additional Resources

- [Google Maps Platform Documentation](https://developers.google.com/maps/documentation)
- [Flutter Google Maps Plugin](https://pub.dev/packages/google_maps_flutter)
- [Flutter Places Plugin](https://pub.dev/packages/google_places_flutter)
- [API Key Best Practices](https://developers.google.com/maps/api-security-best-practices)
