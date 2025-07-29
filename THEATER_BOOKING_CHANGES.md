# Theater Booking System - Major Business Logic Changes

## Overview
The theater booking system has been redesigned to support **multiple screens per theater** with automatic screen allocation based on availability and user preferences.

## New Business Flow
1. **User selects Private Theater** → Shows theater details
2. **User selects Time Slot** → System automatically allocates best available screen  
3. **User proceeds with existing flow** → Occasions → Decorations → Add-ons → Checkout

## Database Schema Changes

### New Tables Created

#### 1. `theater_screens` table
```sql
CREATE TABLE theater_screens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theater_id UUID NOT NULL REFERENCES private_theaters(id) ON DELETE CASCADE,
    screen_name VARCHAR(100) NOT NULL,
    screen_number INTEGER NOT NULL,
    capacity INTEGER NOT NULL DEFAULT 0,
    amenities TEXT[] DEFAULT '{}',
    hourly_rate NUMERIC(10,2) NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(theater_id, screen_number)
);
```

### Modified Tables

#### 1. `theater_time_slots` table
- **Added**: `screen_id UUID REFERENCES theater_screens(id)`
- **Modified**: Unique constraint changed from `(theater_id, slot_date, start_time)` to `(screen_id, slot_date, start_time)`

#### 2. `theater_slot_bookings` table  
- **Added**: `screen_id UUID REFERENCES theater_screens(id)`

## Sample Data Created

### Theater Screens (10 screens across 4 theaters)
- **Royal Theater Room**: 3 screens (15, 12, 8 capacity)
- **Luxury Cinema Pod**: 2 screens (10, 8 capacity) 
- **Cozy Movie Den**: 2 screens (20, 15 capacity)
- **Elite Cinema Experience**: 3 screens (25, 18, 12 capacity)

### Time Slots
- **320 total slots** created for next 8 days
- **4 time slots per day** per screen: 09:00-12:00, 12:30-15:30, 16:00-19:00, 19:30-22:30
- **Dynamic pricing** based on screen quality and time of day

## Code Changes

### 1. New Models Created

#### `theater_screen_model.dart`
- `TheaterScreenModel`: Represents individual theater screens
- `TheaterTimeSlotWithScreenModel`: Time slots with screen information
- `TheaterBookingWithScreenModel`: Bookings with screen details

### 2. Repository Updates

#### `theater_repository.dart` - New Methods
- `getTheaterScreens()`: Fetch all screens for a theater
- `getTheaterTimeSlotsWithScreens()`: Get available slots with automatic screen allocation
- `bookTimeSlotWithScreen()`: Book specific time slot with screen
- `_calculateDynamicSlotPrice()`: Calculate pricing based on day type
- `_isBetterScreen()`: Screen selection algorithm

### 3. Provider Updates

#### `theater_providers.dart` - New Providers
- `theaterScreensProvider`: Manages theater screens
- `theaterTimeSlotsWithScreensProvider`: Handles screen-based time slots
- `theaterBookingSelectionProvider`: State management for booking flow
- `TheaterBookingSelectionState`: Complete booking state
- `TheaterBookingSelectionNotifier`: Booking flow management

### 4. UI Updates

#### `theater_detail_screen_new.dart`
- **Enhanced time slot display**: Shows screen name, capacity, and amenities
- **Automatic screen allocation**: User doesn't choose screen manually
- **Real-time availability**: Checks existing bookings
- **Dynamic pricing display**: Shows calculated prices based on screen and time
- **Improved UX**: Clear indication of allocated screen in button text

## Key Features

### 1. Automatic Screen Allocation Algorithm
- **Availability Check**: Verifies no conflicts with existing bookings
- **Best Screen Selection**: Chooses optimal screen based on:
  - Lower pricing (preferred)
  - Higher capacity (if price equal)
  - More amenities (if capacity equal)

### 2. Dynamic Pricing System
- **Base Price**: From screen hourly rate
- **Day Type Multipliers**: Weekday (1.0x), Weekend (1.2x), Holiday (1.5x)
- **Time Slot Pricing**: Different rates for different time periods
- **Screen Quality**: Premium screens have higher base rates

### 3. Real-time Availability
- **Conflict Detection**: Checks existing bookings before showing slots
- **Screen-specific Blocking**: Only blocks specific screen-time combinations
- **Instant Updates**: Refreshes availability in real-time

### 4. Enhanced User Experience
- **Screen Information**: Shows allocated screen details in UI
- **Capacity Display**: Shows seating capacity for transparency
- **Amenity Visibility**: Displays screen-specific amenities
- **Price Transparency**: Clear pricing breakdown

## State Management

### Booking Selection State
```dart
class TheaterBookingSelectionState {
  final TheaterModel? selectedTheater;
  final TheaterTimeSlotWithScreenModel? selectedTimeSlot;
  final String? selectedDate;
  final List<OccasionModel> selectedOccasions;
  final List<DecorationModel> selectedDecorations;
  final List<AddOnModel> selectedAddOns;
  final List<SpecialServiceModel> selectedSpecialServices;
  final List<CakeModel> selectedCakes;
  final double totalAmount;
  final Map<String, dynamic> additionalData;
}
```

## Testing Data Available

### Sample Query Results
- **Theater**: Elite Cinema Experience (ececf43e-b0ab-49b2-831b-bc87dd409f65)
- **Date**: 2025-07-29
- **Available Slots**: 5+ time slots across 3 different screens
- **Price Range**: ₹3,500 - ₹4,500 based on screen quality

## Migration Path

### For Testing
1. Use `TheaterDetailScreenNew` for testing new flow
2. Compare with existing `TheaterDetailScreen` 
3. Existing booking data remains intact

### For Production
1. Replace `TheaterDetailScreen` with `TheaterDetailScreenNew`
2. Update router to use new screen
3. Update any existing bookings to include screen_id references

## Benefits

1. **Better Resource Utilization**: Multiple screens per theater
2. **Flexible Pricing**: Screen-based dynamic pricing
3. **Improved Availability**: More time slots available
4. **Enhanced User Choice**: Better screen allocation algorithm
5. **Scalability**: Easy to add more screens to existing theaters
6. **Revenue Optimization**: Premium screens can charge premium rates

## Files Created/Modified

### New Files
- `lib/features/theater/models/theater_screen_model.dart`
- `lib/features/theater/screens/theater_detail_screen_new.dart`
- `THEATER_BOOKING_CHANGES.md`

### Modified Files
- `lib/features/theater/repositories/theater_repository.dart`
- `lib/features/theater/providers/theater_providers.dart`

### Database Migrations
- `add_theater_screens_table`
- `fix_theater_time_slots_unique_constraint`
- `populate_theater_time_slots_with_screens`