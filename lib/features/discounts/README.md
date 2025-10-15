# Discounted Services Feature

This feature provides a screen that filters and displays service listings with significant discounts (50% or more off the original price).

## Overview

When users press the "Book Now & Save" button on the home screen, they are directed to a dedicated screen that shows only services with substantial discounts.

## Key Features

### ✅ **Discount Filtering**
- Automatically filters services with 50% or more discount
- Calculates discount percentage based on `displayOriginalPrice` and `displayOfferPrice`
- Only shows services that meet the discount criteria

### ✅ **Visual Design**
- 2x2 grid layout for optimal browsing
- Prominent discount badges showing exact percentage off
- Clear price display with strikethrough for original prices
- "Save amount" indicators for each service

### ✅ **User Experience**
- Loading states while fetching data
- Empty state when no discounted services are available
- Smooth navigation to service detail screens
- Rating and review integration

### ✅ **Navigation Integration**
- Connected to home screen "Book Now & Save" button
- Proper route configuration in app router
- Maintains navigation stack for back button functionality

## Files Structure

```
lib/features/discounts/
├── screens/
│   └── discounted_services_screen.dart  # Main screen implementation
└── README.md                           # This documentation
```

## Route Configuration

**Route Path:** `/discounted-services`
**Route Name:** `DiscountedServicesScreen.routeName`

## Usage

The screen is automatically accessible when users tap:
1. "Book Now & Save" button on home screen app bar
2. The entire app bar overlay area (tappable)

## Technical Implementation

### Discount Calculation Logic

```dart
bool _hasSignificantDiscount(ServiceListingModel service) {
  if (service.displayOfferPrice == null || service.displayOriginalPrice == null) {
    return false;
  }
  
  final discountPercentage = _calculateDiscountPercentage(service);
  return discountPercentage >= 50.0;
}

double _calculateDiscountPercentage(ServiceListingModel service) {
  final originalPrice = service.displayOriginalPrice!;
  final offerPrice = service.displayOfferPrice!;
  
  if (originalPrice <= offerPrice) {
    return 0.0;
  }
  
  return ((originalPrice - offerPrice) / originalPrice) * 100;
}
```

### Price Display

- Uses `PriceCalculator.calculateTotalPriceWithTaxes()` for accurate pricing
- Shows both offer price and original price (crossed out)
- Displays total savings amount

### Data Source

Currently fetches data from `featuredServicesProvider` and filters client-side. Future enhancements could include:
- Server-side filtering for better performance
- Dedicated discount API endpoints
- Real-time discount updates

## Future Enhancements

- [ ] Add sorting options (highest discount, price, rating)
- [ ] Include time-limited offers with countdown timers
- [ ] Add wishlist integration for discounted items
- [ ] Implement push notifications for new deals
- [ ] Add category-wise discount filtering
- [ ] Include discount history and trending deals

## Dependencies

- `flutter_riverpod` - State management
- `go_router` - Navigation
- `cached_network_image` - Image loading
- `../../core/utils/price_calculator.dart` - Price calculations
- `../../home/providers/home_providers.dart` - Data providers