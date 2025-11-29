# Theater Price Tax Calculation - Backend Implementation

## Overview
Implemented automatic tax calculation for theater time slot prices on the **backend (database level)** instead of frontend calculations. This ensures consistent pricing across the entire application.

## Tax Formula
```
serviceWithTax = servicePrice + serviceFixedTax + (servicePrice * percentTax/100)
```

### Configuration
- **serviceFixedTax**: 0.0 (no fixed tax)
- **percentTax**: 6.4%

### Example
- Base price (price_per_hour): ₹1000
- Fixed tax: ₹0
- Percent tax: ₹1000 × 6.4% = ₹64
- **Final price shown to users**: ₹1064

## Database Changes

### 1. Created Database VIEW (Migration)
**Migration**: `create_theater_time_slots_with_tax_view`
**View Name**: `theater_time_slots_with_tax`

Created a PostgreSQL VIEW that automatically calculates tax-inclusive prices on every query:

```sql
CREATE OR REPLACE VIEW theater_time_slots_with_tax AS
SELECT
  id,
  theater_id,
  screen_id,
  start_time,
  end_time,
  base_price,
  discounted_price,
  is_available,
  is_active,
  created_at,
  updated_at,
  -- All other columns from theater_time_slots
  -- Calculate price_with_tax using the formula
  -- Formula: price + fixed_tax(0) + (price * 6.4%)
  ROUND(price_per_hour + (price_per_hour * 6.4 / 100), 2) AS price_with_tax,
  price_per_hour
FROM theater_time_slots;
```

### 2. Why a VIEW Instead of Generated Column?
- **Real-time Calculation**: Price is calculated on every query with latest data
- **No Storage Overhead**: Doesn't store computed values, saves disk space
- **Automatic Updates**: When `price_per_hour` changes, `price_with_tax` updates immediately
- **Transparent**: App queries the VIEW just like a table

### 3. Performance Optimization
The VIEW uses existing indexes on the base `theater_time_slots` table:

```sql
CREATE INDEX idx_theater_time_slots_with_tax_theater_id
  ON theater_time_slots(theater_id);
CREATE INDEX idx_theater_time_slots_with_tax_screen_id
  ON theater_time_slots(screen_id);
CREATE INDEX idx_theater_time_slots_with_tax_active
  ON theater_time_slots(is_active) WHERE is_active = true;
```

## Frontend Changes

### 1. Updated Data Models
**File**: `lib/features/outside/models/time_slot_model.dart`

Changed the `fromJson` factory to read `price_with_tax` instead of `base_price`:

```dart
factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
  // Use price_with_tax (auto-calculated by database) as the base price
  final priceWithTax = (json['price_with_tax'] as num?)?.toDouble() ?? 0.0;

  return TimeSlotModel(
    // ...
    basePrice: priceWithTax,  // Now includes tax automatically
    // ...
  );
}
```

### 2. Updated Services
**Files Modified**:
- `lib/features/outside/services/theater_service.dart`
- `lib/features/outside/services/theater_screen_detail_service.dart`

Changed all database queries to fetch `price_with_tax` instead of `base_price`:

```dart
// BEFORE
theater_time_slots!inner(
  base_price,
  discounted_price,
  is_active
)

// AFTER
theater_time_slots!inner(
  price_with_tax,  // Auto-calculated by database
  discounted_price,
  is_active
)
```

Updated `_calculateMinimumPrice()` method to use the new column:

```dart
double _calculateMinimumPrice(Map<String, dynamic> screenData) {
  for (final slot in timeSlots) {
    // Use price_with_tax (already includes tax from database)
    final priceWithTax = (slot['price_with_tax'] as num?)?.toDouble();
    final discountedPrice = (slot['discounted_price'] as num?)?.toDouble();

    final slotPrice = discountedPrice ?? priceWithTax ?? 0.0;
    // ...
  }
}
```

### 3. Simplified UI Components
**File**: `lib/features/outside/widgets/theater_screen_card.dart`

Removed all frontend tax calculations:

```dart
// BEFORE
const double serviceFixedTax = 0.0;
const double percentTax = 6.4;
final priceWithTax = basePrice + serviceFixedTax + (basePrice * percentTax / 100);

// AFTER
// The hourlyRate from screen already includes tax (calculated by database)
final basePrice = screen.hourlyRate;
```

## Benefits of Backend Calculation

### ✅ Consistency
- Tax calculation logic exists in ONE place (database)
- No risk of frontend/backend calculation mismatch
- All parts of the app show the same price

### ✅ Performance
- Database computes prices automatically when data changes
- Generated column is stored (no computation on every read)
- Indexed for fast querying

### ✅ Maintainability
- Easy to update tax rate: just modify the database function
- No need to update Flutter code when tax rates change
- Single source of truth for pricing logic

### ✅ Data Integrity
- Tax calculation happens at database level
- Cannot be bypassed or manipulated from frontend
- Prices are always accurate and up-to-date

## How to Change Tax Rates in Future

If tax rates need to be updated:

1. **Update the Database VIEW**:
```sql
CREATE OR REPLACE VIEW theater_time_slots_with_tax AS
SELECT
  *,
  -- Update the percentage here (currently 6.4%)
  ROUND(price_per_hour + (price_per_hour * 6.4 / 100), 2) AS price_with_tax
FROM theater_time_slots;
```

2. **That's it!** The VIEW recalculates prices on every query automatically.

3. **No Frontend Changes Required!** The Flutter app will immediately see the new calculated prices.

## Testing

To verify the implementation:

1. **Check Database VIEW Calculation**:
```sql
SELECT
  id,
  start_time,
  end_time,
  price_per_hour as base_price,
  price_with_tax,
  (price_with_tax - price_per_hour) as tax_amount,
  ROUND(((price_with_tax - price_per_hour) / price_per_hour * 100), 2) as tax_percentage
FROM theater_time_slots_with_tax
WHERE price_per_hour > 0;
```

Expected result for ₹1000 slot:
- `base_price`: 1000.00
- `price_with_tax`: 1064.00
- `tax_amount`: 64.00
- `tax_percentage`: 6.40%

Expected result for ₹199 slot:
- `base_price`: 199.00
- `price_with_tax`: 211.74
- `tax_amount`: 12.74
- `tax_percentage`: 6.40%

2. **Verify Frontend Display**:
- Open the Outside screen (theater listings)
- Check that prices shown are tax-inclusive (e.g., ₹1064 for ₹1000 base)
- Verify time slot detail screen shows the same prices
- All prices across the app should show the tax-inclusive amount

## Migrations Applied
✅ Migration `add_theater_price_with_tax_calculation` - Initial function approach
✅ Migration `create_theater_time_slots_with_tax_view` - Final VIEW approach (recommended)

## Files Modified
1. **Database**:
   - New migration: `create_theater_time_slots_with_tax_view`
   - New VIEW: `theater_time_slots_with_tax`
   - Calculates: `price_with_tax = ROUND(price_per_hour + (price_per_hour * 6.4 / 100), 2)`

2. **Flutter Models**:
   - `lib/features/outside/models/time_slot_model.dart` - Uses `price_with_tax` from JSON

3. **Flutter Services** (Updated to query VIEW instead of table):
   - `lib/features/outside/services/theater_service.dart` - Queries `theater_time_slots_with_tax`
   - `lib/features/outside/services/theater_screen_detail_service.dart` - Queries `theater_time_slots_with_tax`

4. **Flutter UI**:
   - `lib/features/outside/widgets/theater_screen_card.dart` - Displays backend-calculated price

## Database Schema
**Original Table**: `theater_time_slots` (stores `price_per_hour`)
**VIEW**: `theater_time_slots_with_tax` (adds computed `price_with_tax` column)
**App Queries**: `theater_time_slots_with_tax` VIEW everywhere

## Implementation Date
2025-01-29
