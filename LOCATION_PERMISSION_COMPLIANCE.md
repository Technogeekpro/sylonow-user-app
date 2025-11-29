# Location Permission Compliance - App Store & Play Store

## ✅ Implementation Complete

The location picker now follows **App Store and Google Play Store** guidelines for permission handling.

---

## Implementation Details

### 1. Permission Flow (Store Compliant)

**Step 1: Check Permission Status**
- Before requesting location, we first check the current permission status
- Prevents unnecessary permission prompts

**Step 2: Show Rationale Dialog (Required by Stores)**
- **BEFORE** requesting permission, show a dialog explaining:
  - Why we need location access
  - What we'll use it for
  - How the data is used
- User can choose "Allow" or "Not Now"

**Step 3: Request Permission**
- Only if user clicks "Allow" in the rationale dialog
- Uses native permission request dialog

**Step 4: Handle Denied States**
- **Temporarily Denied**: Show snackbar with "Settings" button
- **Permanently Denied**: Show dialog explaining how to enable in settings

---

## Store Guidelines Compliance

### ✅ Apple App Store Requirements

**1. Permission Descriptions in Info.plist**
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Sylonow needs your location to show nearby service providers and deliver accurate services to your area.</string>
```
- ✅ Clear, specific explanation
- ✅ Tells user what data is collected
- ✅ Explains how it's used

**2. Contextual Permission Requests**
- ✅ Permission requested when user taps "Current Location" button
- ✅ Not requested immediately on app launch
- ✅ Rationale shown before system permission dialog

**3. Graceful Degradation**
- ✅ App works without location permission
- ✅ User can still search and manually select locations
- ✅ No blocking permission requests

### ✅ Google Play Store Requirements

**1. Permissions in AndroidManifest.xml**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```
- ✅ Only necessary permissions requested
- ✅ No background location permission

**2. Runtime Permission Handling**
- ✅ Rationale shown before requesting (Android best practice)
- ✅ User can deny without breaking app functionality
- ✅ Clear path to settings if permission denied

**3. Data Usage Transparency**
- ✅ Rationale dialog explains data usage
- ✅ Explicitly states "not shared with third parties"
- ✅ Lists specific use cases

---

## User Experience Flow

### Scenario 1: First Time User Taps "Current Location"

1. **Rationale Dialog Appears:**
   ```
   Title: Location Access

   Sylonow needs access to your location to:

   • Show your current location on the map
   • Help you select accurate delivery addresses
   • Provide better service recommendations

   Your location data is only used for address selection
   and is not shared with third parties.

   [Not Now]  [Allow]
   ```

2. **User Clicks "Allow":**
   - Native permission dialog appears
   - User grants permission
   - Map moves to current location ✅

3. **User Clicks "Not Now":**
   - No permission requested
   - User can still use map and search
   - Can try again later

### Scenario 2: User Denied Permission

1. **User Clicks "Current Location" Again:**
   ```
   Snackbar: Location access is required to use this feature
   [Settings] button → Opens app settings
   ```

### Scenario 3: Permission Permanently Denied

1. **User Clicks "Current Location":**
   ```
   Dialog: Location Access Denied

   Location permission has been permanently denied.
   To use this feature, please enable location access
   in your device settings.

   [Cancel]  [Open Settings]
   ```

2. **User Clicks "Open Settings":**
   - Opens device app settings
   - User can manually enable location

---

## Code Implementation

### File: `lib/features/address/screens/location_picker_screen.dart`

**Permission Check Before Request:**
```dart
final permissionStatus = await locationService.getPermissionStatus();

if (permissionStatus == LocationPermission.deniedForever) {
  _showPermissionDeniedDialog();
  return;
}

if (permissionStatus == LocationPermission.denied) {
  final shouldRequest = await _showPermissionRationaleDialog();
  if (!shouldRequest) return;
}
```

**Rationale Dialog:**
```dart
Future<bool> _showPermissionRationaleDialog() async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.location_on, color: AppTheme.primaryColor),
          SizedBox(width: 8),
          Text('Location Access'),
        ],
      ),
      content: const Text(
        'Sylonow needs access to your location to:\n\n'
        '• Show your current location on the map\n'
        '• Help you select accurate delivery addresses\n'
        '• Provide better service recommendations\n\n'
        'Your location data is only used for address selection
         and is not shared with third parties.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Not Now'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Allow'),
        ),
      ],
    ),
  ) ?? false;
}
```

**Settings Dialog:**
```dart
void _showPermissionDeniedDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.location_off, color: Colors.red),
          Text('Location Access Denied'),
        ],
      ),
      content: const Text(
        'Location permission has been permanently denied.
         To use this feature, please enable location access
         in your device settings.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Geolocator.openAppSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
}
```

---

## Testing Checklist

### iOS Testing

- [ ] First launch → Tap current location → Rationale dialog appears
- [ ] Tap "Allow" → Native permission dialog appears
- [ ] Grant permission → Map moves to current location
- [ ] Deny permission → Snackbar with "Settings" appears
- [ ] Tap "Settings" → Opens iOS app settings
- [ ] Permanently deny → Dialog explains how to enable
- [ ] Verify Info.plist description appears in native dialog

### Android Testing

- [ ] First launch → Tap current location → Rationale dialog appears
- [ ] Tap "Allow" → Native permission dialog appears
- [ ] Grant permission → Map moves to current location
- [ ] Deny permission → Snackbar with "Settings" appears
- [ ] Tap "Settings" → Opens Android app settings
- [ ] Tap "Don't ask again" + Deny → Permanent denial dialog
- [ ] Verify app works without location (search still functional)

---

## Store Submission Notes

### For App Store Reviewers

**Location Usage:**
- Permission is only requested when user explicitly taps "Use Current Location"
- Clear rationale is shown before the system permission dialog
- The feature gracefully degrades if permission is denied
- Users can still search and select locations manually

**Privacy Compliance:**
- Location data is only used for address selection
- Not shared with third parties
- Not collected in the background
- Clear privacy explanation in Info.plist

### For Play Store Reviewers

**Permission Justification:**
- `ACCESS_FINE_LOCATION`: For accurate current location on map
- `ACCESS_COARSE_LOCATION`: Fallback for approximate location
- Both requested only when user taps "Current Location" button
- Not requested for core app functionality

**User Control:**
- Users can deny permission without app crash
- Clear explanation of why permission is needed
- Easy access to settings to change permission

---

## Best Practices Followed

✅ **Permission Minimalism**: Only request when needed
✅ **Contextual Requests**: Request at point of use
✅ **Clear Communication**: Explain what and why
✅ **User Control**: Easy to deny or revoke
✅ **Graceful Degradation**: App works without permission
✅ **Privacy Transparency**: State data usage explicitly
✅ **Easy Settings Access**: One-tap to app settings
✅ **No Blocking Dialogs**: Never block app usage
✅ **Rationale Before Request**: Show explanation first
✅ **Handle All States**: Denied, permanent denial, granted

---

## References

- [Apple - Requesting Authorization for Location Services](https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services)
- [Google - Request Location Permissions](https://developer.android.com/training/location/permissions)
- [App Store Review Guidelines - 5.1.1 Data Collection and Storage](https://developer.apple.com/app-store/review/guidelines/#data-collection-and-storage)
- [Play Store - User Data Policy](https://support.google.com/googleplay/android-developer/answer/10787469)

---

**Status:** ✅ Fully Compliant with App Store & Play Store Guidelines
**Last Updated:** November 27, 2025
**Tested:** Pending QA
