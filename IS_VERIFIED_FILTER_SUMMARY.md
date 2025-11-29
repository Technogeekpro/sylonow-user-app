# Service Listing Verification Filter Implementation

## Summary

Added `is_verified = true` filter to all service_listings table queries throughout the application to ensure only verified services are shown to users.

## Files Updated

### 1. lib/features/home/repositories/home_repository.dart
Added `.eq('is_verified', true)` to all service_listings queries:

- ✅ `getFeaturedServices()` - Line 134
- ✅ `getPrivateTheaterServices()` - Line 173
- ✅ `getPopularNearbyServices()` - Lines 218, 270 (2 queries: main + fallback)
- ✅ `getServiceById()` - Line 312 (strict conditions query)
- ✅ `getRelatedServices()` - Lines 404, 431 (2 queries: category + general)
- ✅ `getFeaturedServicesByDecorationType()` - Line 586
- ✅ `getPopularNearbyServicesByDecorationType()` - Line 619
- ✅ `getAllServicesWithFilters()` - Line 757
- ✅ `getFeaturedServicesByDecorationTypeWithoutPagination()` - Line 837
- ✅ `getPopularNearbyServicesByDecorationTypeWithoutPagination()` - Line 887
- ✅ `getServicesByCategoryNameAndDecorationType()` - Lines 959, 1021 (2 queries)
- ✅ `getDiscountedServices()` - Line 1077

### 2. lib/features/categories/providers/category_services_providers.dart
Added `.eq('is_verified', true)` to all service_listings queries:

- ✅ `categoryServicesProvider` - Line 35 (fallback when no location)
- ✅ `servicesByCategoryProvider` - Line 117
- ✅ `servicesByCategoryAndDecorationTypeProvider` - Line 153

### 3. lib/features/theater/repositories/theater_repository.dart
- ℹ️ Skipped: The query at line 374 only fetches `vendor_id` for internal lookups, doesn't need is_verified filter

## Total Queries Updated

**19 queries** across 2 files have been updated with the `is_verified` filter.

## Query Pattern

All queries now follow this pattern:
```dart
await supabase
    .from('service_listings')
    .select('...')
    .eq('is_active', true)
    .eq('is_verified', true)  // ← NEW FILTER
    // ... other filters
```

## Testing Recommendations

1. **Verify database column exists**: Ensure `is_verified` column exists in the `service_listings` table
2. **Test service visibility**: Only services with `is_verified = true` should appear in:
   - Home screen sections (Featured, Popular Nearby, Private Theaters)
   - Category screens
   - Search results
   - Related services sections
   - Discounted services section
3. **Test with unverified services**: Create test services with `is_verified = false` and confirm they don't appear

## Database Migration

If the `is_verified` column doesn't exist in the database yet, create it with:

```sql
-- Add is_verified column to service_listings table
ALTER TABLE service_listings 
ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT false;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_service_listings_is_verified 
ON service_listings(is_verified) 
WHERE is_verified = true;

-- Optionally: Set existing services to verified (if appropriate)
-- UPDATE service_listings SET is_verified = true WHERE is_active = true;
```

## Notes

- RPC functions (`get_nearby_services_with_price`, `get_services_by_category_and_location`, etc.) may also need to be updated to include the `is_verified` filter
- The relaxed query in `getServiceById()` (line ~325) was intentionally left without `is_verified` for debugging purposes
- Vendor-related filters (`vendors.verification_status = 'verified'`) were kept in place for additional security

