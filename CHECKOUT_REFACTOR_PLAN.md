# Checkout Screen Refactoring Plan

## Current State
- **Total Lines**: 4615 lines
- **Status**: Unmaintainable, slow to compile, high context usage

## Widget Methods Found (20+)
1. `_buildOrderSummary()` - Order details card
2. `_buildAddressSection()` - Address selection
3. `_buildServiceTimingSection()` - Time slot display
4. `_buildZomatoStyleAddressCard()` - Address card UI
5. `_buildAddOnCard()` - Add-on items
6. `_buildCouponSection()` - Coupon input
7. `_buildBillDetails()` - Price breakdown
8. `_buildCheckoutButton()` - Payment button
9. Plus 12+ more unused/redundant widgets

## Refactoring Strategy

### Step 1: Create Widget Files (Priority Order)
1. ✅ `widgets/checkout_order_summary.dart` (~200 lines)
2. ✅ `widgets/checkout_address_section.dart` (~300 lines)
3. ✅ `widgets/checkout_bill_details.dart` (~400 lines)
4. ✅ `widgets/checkout_payment_button.dart` (~100 lines)

### Step 2: Extract Controllers
1. ✅ `controllers/checkout_payment_controller.dart` - Payment logic
2. ✅ `utils/checkout_calculations.dart` - Price calculations

### Step 3: Clean Main File
- Remove unused methods (6+ identified)
- Simplify state management
- **Target**: ~500 lines

## Expected Result
- Main file: 500 lines (89% reduction)
- 4 widget files: ~1000 lines total
- 2 controller files: ~300 lines total
- **Total**: ~1800 lines (60% reduction overall)
