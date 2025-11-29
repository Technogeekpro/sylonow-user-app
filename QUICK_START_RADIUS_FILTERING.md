# 🚀 Quick Start - 20km Radius Filtering

## ✅ What's Implemented

Your app now shows **only services within 20km** of the selected address.

---

## 🎯 Quick Test Guide

### Step 1: Check Your Addresses Have Coordinates

```sql
-- Run this in Supabase SQL Editor
SELECT
    id,
    name,
    address,
    latitude,
    longitude,
    state,
    city
FROM addresses
WHERE user_id = 'YOUR_USER_ID'
ORDER BY created_at DESC;
```

**Expected:**
- ✅ Addresses should have `latitude` and `longitude` values
- ✅ If null, add address again using location picker

### Step 2: Test in App

1. **Open app** → Home screen
2. **Tap location icon** (top left)
3. **Select address** (e.g., Mumbai)
4. **Check "Near By You" section**
5. **Services shown** = Only within 20km of that address ✅

### Step 3: Verify in Console

**Expected logs:**
```
🔍 Filtering services within 20.0km of (18.9851, 73.1081)
🔍 Found 1 services within 20.0km radius
```

---

## 🔍 Quick Database Checks

### Check Service Coordinates

```sql
-- See which services have coordinates
SELECT
    id,
    title,
    latitude,
    longitude,
    is_active
FROM service_listings
WHERE latitude IS NOT NULL
  AND longitude IS NOT NULL
ORDER BY created_at DESC
LIMIT 10;
```

### Check Vendor Status

```sql
-- See which vendors are active
SELECT
    v.id,
    v.business_name,
    v.is_active,
    v.verification_status,
    COUNT(sl.id) as total_services
FROM vendors v
LEFT JOIN service_listings sl ON v.id = sl.vendor_id
GROUP BY v.id, v.business_name, v.is_active, v.verification_status
ORDER BY v.is_active DESC, total_services DESC;
```

### Activate Inactive Vendors (If Needed)

```sql
-- Activate specific vendor
UPDATE vendors
SET is_active = true
WHERE business_name = 'Vendor Name Here';

-- Activate all verified vendors
UPDATE vendors
SET is_active = true
WHERE verification_status = 'verified'
  AND is_active = false;
```

---

## 🧪 Test Distance Calculation

```sql
-- Test: Services near Mumbai (Panvel area)
SELECT
    sl.id,
    sl.title,
    sl.latitude,
    sl.longitude,
    v.business_name,
    calculate_distance(
        18.9851,  -- Mumbai test point
        73.1081,
        sl.latitude,
        sl.longitude
    ) as distance_km
FROM service_listings sl
INNER JOIN vendors v ON sl.vendor_id = v.id
WHERE sl.latitude IS NOT NULL
  AND sl.longitude IS NOT NULL
  AND sl.is_active = true
  AND v.is_active = true
ORDER BY distance_km
LIMIT 10;
```

**Expected:**
- Services sorted by distance from test point
- Only services from active vendors
- Distance in kilometers

---

## 🎮 Quick Actions

### Add New Address with Coordinates

1. Go to Profile → Addresses
2. Tap "Add Address"
3. Tap "Select Location on Map"
4. Search or pin location
5. Save
6. ✅ Coordinates saved automatically

### Switch Address and See Different Services

1. Home screen
2. Tap location (top left)
3. Select different address
4. Watch "Near By You" refresh
5. ✅ Different services shown based on 20km radius

---

## 🔧 Quick Fixes

### Issue: No Services Showing

**Possible reasons:**

1. **No services within 20km**
   ```sql
   -- Check nearest service to your address
   SELECT
       title,
       calculate_distance(
           YOUR_LAT,  -- Replace with your address lat
           YOUR_LON,  -- Replace with your address lon
           latitude,
           longitude
       ) as distance_km
   FROM service_listings
   WHERE latitude IS NOT NULL
   ORDER BY distance_km
   LIMIT 1;
   ```

2. **Vendors are inactive**
   ```sql
   -- Check and activate
   UPDATE vendors SET is_active = true
   WHERE verification_status = 'verified';
   ```

3. **Address missing coordinates**
   - Re-add address using location picker
   - Or manually update:
   ```sql
   UPDATE addresses
   SET latitude = 18.9851, longitude = 73.1081
   WHERE id = 'ADDRESS_ID';
   ```

### Issue: All Services Showing (No Filtering)

**Reason:** Address has no coordinates

**Fix:**
```sql
-- Check if address has coordinates
SELECT latitude, longitude FROM addresses WHERE id = 'ADDRESS_ID';

-- If null, update it
UPDATE addresses
SET latitude = YOUR_LAT, longitude = YOUR_LON
WHERE id = 'ADDRESS_ID';
```

---

## 📊 Quick Stats Query

```sql
-- See how many services by distance from a point
SELECT
    CASE
        WHEN distance <= 5 THEN '0-5 km'
        WHEN distance <= 10 THEN '5-10 km'
        WHEN distance <= 20 THEN '10-20 km'
        WHEN distance <= 50 THEN '20-50 km'
        ELSE '50+ km'
    END as distance_range,
    COUNT(*) as service_count
FROM (
    SELECT
        calculate_distance(
            18.9851,  -- Test point
            73.1081,
            latitude,
            longitude
        ) as distance
    FROM service_listings
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
      AND is_active = true
) distances
GROUP BY distance_range
ORDER BY
    CASE distance_range
        WHEN '0-5 km' THEN 1
        WHEN '5-10 km' THEN 2
        WHEN '10-20 km' THEN 3
        WHEN '20-50 km' THEN 4
        ELSE 5
    END;
```

---

## ⚡ Change Radius (Optional)

### From 20km to 30km:

**File:** `lib/features/home/providers/home_providers.dart`

**Line 140:**
```dart
return repository.getPopularNearbyServices(
  userLat: userLat,
  userLon: userLon,
  radiusKm: 30.0, // Changed from 20.0
);
```

---

## 📱 Expected Behavior

### Mumbai Address Selected (18.9851, 73.1081)
- ✅ Shows: Services within 20km
- ✅ Example: Muskan Business (0 km away)
- ❌ Hides: Services >20km away
- ❌ Hides: Bangalore services (600+ km)

### Bangalore Address Selected (12.9583, 77.5385)
- ✅ Shows: Services within 20km
- ✅ Example: Services near that coordinate
- ❌ Hides: Mumbai services (600+ km)

### Address Without Coordinates
- ⚠️ Fallback: Shows all services (no filtering)
- 💡 Solution: Re-add address with location picker

---

## 🎯 Production Checklist

- [x] Database function working
- [x] Repository using radius filtering
- [x] Provider passing coordinates
- [x] Addresses have coordinates
- [x] Vendors are active
- [x] Services have coordinates
- [x] Distance calculation accurate
- [x] Graceful fallbacks working

---

## 📞 Quick Support Queries

### Query 1: How many services do I have total?
```sql
SELECT COUNT(*) as total_services
FROM service_listings
WHERE is_active = true;
```

### Query 2: How many have coordinates?
```sql
SELECT
    COUNT(*) as services_with_coordinates
FROM service_listings
WHERE latitude IS NOT NULL
  AND longitude IS NOT NULL
  AND is_active = true;
```

### Query 3: How many active vendors?
```sql
SELECT COUNT(*) as active_vendors
FROM vendors
WHERE is_active = true
  AND verification_status = 'verified';
```

---

**Status:** ✅ Ready to Use
**Documentation:** See [RADIUS_BASED_SERVICE_FILTERING.md](RADIUS_BASED_SERVICE_FILTERING.md)

🚀 **Your 20km radius filtering is live!** 🚀
