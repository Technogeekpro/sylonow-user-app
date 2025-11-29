# Quick Testing Guide - Nearby Services Location Feature

## 🧪 5-Minute Test Plan

### Test 1: Fresh Install - GPS Location ⏱️ 1 min

**Steps:**
1. Uninstall app (or use fresh emulator)
2. Install and launch app
3. **Observe:** Permission rationale dialog appears
4. Grant location permission
5. Wait for home screen to load
6. Scroll to "Near By You" section

**✅ Success Criteria:**
- Permission dialog shows rationale BEFORE system dialog
- Current location appears in top bar
- "Near By You" shows services

**Debug Logs to Check:**
```
🔍 With coordinates: (lat, lng)
🔍 getUserCoordinates: Returning GPS coordinates
```

---

### Test 2: Add New Address via Map ⏱️ 2 min

**Steps:**
1. Tap profile icon → Addresses
2. Tap "Add New Address" (+)
3. Tap "Select Location on Map" button
4. Search for a location (e.g., "Marine Drive, Mumbai")
5. Or drag pin to different location
6. Tap "Confirm location"
7. Fill name: "Work"
8. Select type: Work
9. Save address

**✅ Success Criteria:**
- Location picker shows map
- Search autocomplete works
- Address fields auto-populate
- Address saved successfully

**Verify in Database:**
```sql
SELECT name, address, latitude, longitude
FROM addresses
WHERE name = 'Work';
```
Should show coordinates!

---

### Test 3: Switch Addresses & See Different Services ⏱️ 1 min

**Setup:** Need 2+ addresses in different locations

**Steps:**
1. On home screen, tap location selector (top left)
2. Select "Work" address
3. Note which services appear in "Near By You"
4. Tap location selector again
5. Select "Home" address
6. Check "Near By You" services

**✅ Success Criteria:**
- Services change when switching addresses
- Different services for different locations
- No GPS request needed

**Debug Logs to Check:**
```
✅ getUserCoordinates: Using selected address coordinates = {latitude: X, longitude: Y}
```

---

### Test 4: Edit Address Preserves Coordinates ⏱️ 30 sec

**Steps:**
1. Profile → Addresses
2. Tap on existing address with coordinates
3. Change name from "Work" to "Office"
4. Save

**✅ Success Criteria:**
- Edit successful
- Coordinates still present in database
- Nearby services still work when selected

---

### Test 5: Permission Denied Handling ⏱️ 30 sec

**Steps:**
1. Open location picker
2. When rationale dialog appears, tap "Not Now"
3. Try to use current location button

**✅ Success Criteria:**
- App doesn't crash
- Shows appropriate message
- Search still works on map
- Can manually pin location

---

## 🐛 Common Issues & Solutions

### Issue: "Near By You" shows wrong location

**Diagnosis:**
```bash
# Check debug logs
flutter run | grep getUserCoordinates
```

**Look for:**
- Which coordinates are being used
- Selected address has coordinates?

**Solution:**
- Ensure address has `latitude` and `longitude` in DB
- Re-save address via location picker if needed

---

### Issue: Location picker search not working

**Check:**
1. API key is unrestricted ✅ (already done)
2. Internet connection
3. Places API enabled in Google Cloud

**Debug:**
```dart
// In location_picker_screen.dart
static const String _googleApiKey = 'AIzaSyDGQShvfon0olSlQIRJy8F8ION3rWQG-tQ';
```

---

### Issue: Coordinates not saving

**Check Logs:**
```
🔍 Setting address: [address text]
🔍 With coordinates: (lat, lng)
```

If coordinates missing, check:
1. Location picker returns lat/lng in result
2. `_selectedLatitude` and `_selectedLongitude` assigned
3. Included in Address object on save

---

## 📊 Database Verification

### Check if coordinates are being saved:

```sql
-- See all addresses with coordinates
SELECT
    name,
    address,
    latitude,
    longitude,
    created_at
FROM addresses
WHERE latitude IS NOT NULL
ORDER BY created_at DESC;
```

### Check coordinate index:

```sql
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'addresses'
AND indexname = 'idx_addresses_coordinates';
```

Should return the index definition.

---

## 🎯 Expected Behavior Summary

| Action | Expected Result |
|--------|----------------|
| Fresh install | GPS location used, coordinates saved |
| Add address via map | Coordinates saved to database |
| Select different address | "Near By You" updates immediately |
| Edit address | Coordinates preserved |
| Delete address | Coordinates removed with address |
| No GPS permission | App still works, map search functional |
| Old address (no coords) | Falls back to GPS gracefully |
| Switch to address with coords | No GPS needed, instant update |

---

## ✅ Quick Verification Checklist

Before submitting to stores:

- [ ] Location permission rationale shows BEFORE system dialog
- [ ] Privacy statement visible in rationale
- [ ] App works without location permission
- [ ] Location picker saves coordinates
- [ ] "Near By You" respects selected address
- [ ] No crashes when switching addresses
- [ ] Smooth experience with/without GPS
- [ ] Old addresses without coordinates still work
- [ ] Database has latitude/longitude columns
- [ ] Index created for performance

---

## 🚀 Ready for Production When:

1. ✅ All 5 tests pass
2. ✅ No crashes in any scenario
3. ✅ Coordinates saving correctly
4. ✅ Services update when switching addresses
5. ✅ Permission handling smooth
6. ✅ Database migration successful

---

**Time to Test:** ~5 minutes
**Time to Fix Issues:** Variable (usually quick)
**Production Ready:** When all ✅ are checked!
