# App Update Feature - Testing Guide

## Current Setup

✅ **Code Implementation**: Complete
✅ **Database Table**: `app_versions` table exists
✅ **Test Data**: You have inserted iOS versions in database

## Your Current Data

From Supabase:
```
iOS 99.0.0 - Test prompt (active)
iOS 1.1.0  - Force update (active)
Android 1.0.0 - Force update (active)
```

Your app version (from pubspec.yaml): **1.0.1**

## Testing Steps

### Step 1: Stop the App Completely
**Important**: Hot Restart may not always work. You need a **full app restart**.

```bash
# Stop the app completely
# In VS Code: Press the red stop button in debug toolbar
# OR kill the app on your device/simulator
```

### Step 2: Start Fresh Run

```bash
# Full restart (NOT hot restart)
flutter run
```

### Step 3: Check Debug Console

After the app starts, you should see these debug logs in your console:

```
🔄 Checking for app updates...
📱 Current app version: 1.0.1
📱 Platform: ios  (or android)
📱 Database response: {version: 99.0.0, force_update: false, ...}
📱 Latest version from DB: 99.0.0
📱 Force update: false
📱 Should update: true
🔄 Update check result: Update available!
🔄 Current version: 1.0.1
🔄 Latest version: 99.0.0
🔄 Force update: false
🔄 Showing update dialog...
```

### Step 4: Dialog Should Appear

After ~500ms of app launch, you should see the update dialog:

- **Title**: "Update Available" with orange icon
- **Message**: "Test prompt!" (your custom message)
- **Version Info**: "Version 99.0.0 is now available"
- **Buttons**:
  - "Later" (gray) - dismisses dialog
  - "Update Now" (orange) - opens App Store URL

## Troubleshooting

### If No Dialog Appears:

#### 1. Check Debug Console for Errors

Look for these messages:

**Error 1: No logs at all**
```
Solution: Make sure you did FULL restart, not hot restart
```

**Error 2: "No versions found in database"**
```
Solution: Check platform - if testing on Android, need Android version in DB
SQL: SELECT * FROM app_versions WHERE platform = 'android' AND is_active = true;
```

**Error 3: "Should update: false"**
```
Solution: Database version is not higher than app version
Your app: 1.0.1
Database must be: 1.0.2 or higher (or 1.1.0, 2.0.0, etc.)
```

**Error 4: Database connection error**
```
Solution: Check Supabase initialization in main.dart
Verify AppConstants.supabaseUrl and AppConstants.supabaseAnonKey
```

#### 2. Verify Database Data

Using Supabase MCP or SQL Editor:

```sql
-- Check what's in database
SELECT platform, version, is_active, force_update
FROM app_versions
WHERE is_active = true
ORDER BY created_at DESC;
```

#### 3. Verify Platform Match

Check your simulator/device:
- **iOS Simulator/Device**: Need `platform = 'ios'` in database
- **Android Emulator/Device**: Need `platform = 'android'` in database

```sql
-- If testing on iOS
SELECT * FROM app_versions WHERE platform = 'ios' AND is_active = true;

-- If testing on Android
SELECT * FROM app_versions WHERE platform = 'android' AND is_active = true;
```

#### 4. Check App Version

```bash
# Verify your app version
grep "version:" pubspec.yaml
# Should show: version: 1.0.1+1
```

The version is `1.0.1` (before the `+`)

## Quick Test Commands

### Test 1: Optional Update (iOS)
```sql
-- Insert test version (make sure it's higher than 1.0.1)
INSERT INTO app_versions (platform, version, force_update, update_message, store_url, is_active)
VALUES (
  'ios',
  '2.0.0',
  false,
  'New features available! Update now to get the latest improvements.',
  'https://apps.apple.com',
  true
);

-- Then: Full app restart
-- Expected: Dialog appears with "Later" and "Update Now" buttons
```

### Test 2: Force Update (iOS)
```sql
-- Update to force update
UPDATE app_versions
SET force_update = true
WHERE platform = 'ios' AND version = '2.0.0';

-- Then: Full app restart
-- Expected: Dialog appears with ONLY "Update Now" button (no "Later")
-- Expected: Cannot dismiss dialog, cannot go back
```

### Test 3: Clean Up
```sql
-- Remove test data
DELETE FROM app_versions WHERE version = '2.0.0';

-- Verify only real versions remain
SELECT * FROM app_versions;
```

## Expected Behavior

### Optional Update (force_update = false)
- ✅ Dialog appears
- ✅ "Later" button visible
- ✅ Can dismiss by tapping "Later"
- ✅ Can dismiss by tapping outside dialog
- ✅ Can go back with device back button
- ✅ "Update Now" opens App Store URL

### Force Update (force_update = true)
- ✅ Dialog appears
- ❌ No "Later" button
- ❌ Cannot dismiss by tapping outside
- ❌ Cannot go back with device back button
- ✅ MUST tap "Update Now" to proceed
- ✅ "Update Now" opens App Store URL

## Version Comparison Logic

The service compares versions using semantic versioning:

```
Examples (assuming current version is 1.0.1):

1.0.0 → 1.0.1 ❌ No update (current is newer)
1.0.1 → 1.0.1 ❌ No update (same version)
1.0.1 → 1.0.2 ✅ Update available
1.0.1 → 1.1.0 ✅ Update available
1.0.1 → 2.0.0 ✅ Update available
1.0.1 → 99.0.0 ✅ Update available
```

## Debug Logging Guide

When app starts, you'll see these emoji indicators:

- 🔄 - Main app update check flow
- 📱 - App update service internals
- 🔥 - Firebase initialization
- 🗄️ - Supabase initialization
- 🔍 - Location services
- 🔔 - FCM/notifications
- 🎯 - Welcome overlay

**Focus on 🔄 and 📱 emojis for update testing**

## Common Issues & Solutions

### Issue 1: Dialog Appears Every Time
**Cause**: App checks on every full restart
**Solution**: This is expected behavior. In production, users update app so version matches and dialog won't appear again.

### Issue 2: Hot Restart Doesn't Show Dialog
**Cause**: `initState()` with context needs full restart
**Solution**: Always use full app restart for testing (stop → run)

### Issue 3: Wrong Platform Version Returned
**Cause**: Testing on iOS but only have Android version in DB (or vice versa)
**Solution**: Insert version for correct platform
```sql
-- Check your device/simulator platform
-- iOS: Need platform = 'ios'
-- Android: Need platform = 'android'
```

### Issue 4: Multiple Versions in Database
**Cause**: Multiple active versions for same platform
**Solution**: Query returns most recent (`ORDER BY created_at DESC LIMIT 1`)
```sql
-- See which version will be returned
SELECT * FROM app_versions
WHERE platform = 'ios' AND is_active = true
ORDER BY created_at DESC
LIMIT 1;
```

## Production Usage

### When Releasing Version 1.0.2 to App Store:

1. **Before releasing to store**, insert into database:
```sql
INSERT INTO app_versions (platform, version, force_update, update_message, store_url, is_active)
VALUES (
  'ios',
  '1.0.2',
  false,  -- or true for critical updates
  'Version 1.0.2 is available with bug fixes and improvements!',
  'https://apps.apple.com/app/sylonow/idXXXXXXXX',
  true
);
```

2. **After app is live**, users on 1.0.1 will see update prompt

3. **To disable prompt** (e.g., if issue found):
```sql
UPDATE app_versions SET is_active = false WHERE version = '1.0.2';
```

## Files Modified (for reference)

1. ✅ `lib/main.dart` - Added update check in initState with debug logging
2. ✅ `lib/core/services/app_update_service.dart` - Added comprehensive debug logs
3. ✅ `supabase/migrations/20251130000000_create_app_versions_table.sql` - Database schema

## Next Steps

1. **Do a full app restart** (not hot restart)
2. **Watch the debug console** for 🔄 and 📱 logs
3. **Check if dialog appears** after ~500ms
4. **Test both optional and force update modes**
5. **Clean up test data** when done

---

**Date**: November 30, 2025
**Status**: Ready for Testing
