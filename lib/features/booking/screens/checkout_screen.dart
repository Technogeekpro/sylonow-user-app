import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../address/models/address_model.dart';
import '../../address/providers/address_providers.dart';
import '../../coupons/models/coupon_model.dart';
import '../../coupons/providers/coupon_providers.dart';
import '../../home/models/service_listing_model.dart';
import '../../profile/providers/profile_providers.dart';
import '../../theater/models/add_on_model.dart';
import '../../theater/models/selected_add_on_model.dart';
import '../../theater/models/theater_screen_model.dart';
import '../providers/booking_providers.dart';
import 'payment_screen.dart';

/// Helper function to safely convert dynamic values to double
double _safeToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed ?? 0.0;
  }
  return 0.0;
}

class CheckoutScreen extends ConsumerStatefulWidget {
  final ServiceListingModel service;
  final Map<String, dynamic>? customization;
  final String? selectedAddressId;
  final TheaterTimeSlotWithScreenModel?
  selectedTimeSlot; // Theater time slot data
  final TheaterScreenModel? selectedScreen; // Theater screen data
  final String? selectedDate; // Selected date for booking
  final Map<String, Map<String, dynamic>>?
  selectedAddOns; // Selected add-ons from service detail

  const CheckoutScreen({
    super.key,
    required this.service,
    this.customization,
    this.selectedAddressId,
    this.selectedTimeSlot,
    this.selectedScreen,
    this.selectedDate,
    this.selectedAddOns,
  });

  static const String routeName = '/checkout';

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String? selectedAddressId;
  bool isProcessing = false;
  String couponCode = '';
  double couponDiscount = 0.0;
  bool isCouponApplied = false;
  bool isApplyingCoupon = false;
  bool isBillDetailsExpanded = false;
  CouponModel? appliedCoupon;

  // Booking for section state
  bool bookingForSelf = true;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final GlobalKey<FormState> _bookingFormKey = GlobalKey<FormState>();

  // Editable addons state
  Map<String, Map<String, dynamic>>? editableAddOns;

  // Vendor GST status
  bool vendorHasGst = false;
  bool isLoadingVendorGst = false;

  // Advance payment calculation
  Map<String, dynamic>? advancePaymentData;
  bool isLoadingAdvancePayment = false;

  @override
  void initState() {
    super.initState();
    selectedAddressId = widget.selectedAddressId;

    // Initialize editable addons with a copy of the original data
    if (widget.selectedAddOns != null) {
      editableAddOns = Map<String, Map<String, dynamic>>.from(
        widget.selectedAddOns!.map(
          (key, value) => MapEntry(key, Map<String, dynamic>.from(value)),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedAddressId == null) {
        ref.read(addressesProvider).whenData((addresses) {
          if (addresses.isNotEmpty && mounted) {
            setState(() {
              selectedAddressId = addresses.first.id;
            });
          }
        });
      }

      // Load user profile data for booking
      _loadUserProfileData();

      // Load vendor GST status and then calculate advance payment
      _loadVendorGstStatus().then((_) {
        _calculateAdvancePayment();
      });
    });
  }

  @override
  void didUpdateWidget(CheckoutScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if any important parameters have changed and update the UI
    bool shouldUpdate = false;

    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.selectedTimeSlot != widget.selectedTimeSlot ||
        oldWidget.selectedScreen != widget.selectedScreen ||
        oldWidget.selectedAddressId != widget.selectedAddressId) {
      shouldUpdate = true;
    }

    if (shouldUpdate) {
      debugPrint('🔄 [CHECKOUT] Parameters updated - refreshing UI');
      debugPrint('🔄 [CHECKOUT] New date: ${widget.selectedDate}');
      debugPrint(
        '🔄 [CHECKOUT] New time slot: ${widget.selectedTimeSlot?.startTime} - ${widget.selectedTimeSlot?.endTime}',
      );

      // Update selected address if it changed
      if (oldWidget.selectedAddressId != widget.selectedAddressId) {
        selectedAddressId = widget.selectedAddressId;
      }

      // Force a rebuild by calling setState
      if (mounted) {
        setState(() {
          // Force rebuild with new parameters
        });
      }
    }
  }

  /// Check if the current service has any available coupons
  Future<bool> _hasAvailableCoupons() async {
    try {
      final servicePrice = _getServicePrice();
      final couponRepository = ref.read(couponRepositoryProvider);
      final coupons = await couponRepository.getAvailableCouponsForService(
        serviceId: widget.service.id,
        orderAmount: servicePrice,
      );
      return coupons.isNotEmpty;
    } catch (e) {
      // If there's an error fetching coupons, don't show the coupon section
      debugPrint('Error checking available coupons: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAddresses = ref.watch(addressesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              _buildOrderSummary(),
              const SizedBox(height: 12),
              _buildAddressSection(userAddresses),
              const SizedBox(height: 12),
              _buildBillDetails(),
              const SizedBox(height: 12),
              _buildCancellationPolicy(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCheckoutButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppTheme.textPrimaryColor,
          size: 24,
        ),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'Checkout',
        style: TextStyle(
          fontFamily: 'Okra',
          fontWeight: FontWeight.w600,
          color: AppTheme.headingColor,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppTheme.successColor.withOpacity(0.4),
                ),
              ),
              child: Text(
                'SECURE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.successColor,
                  fontFamily: 'Okra',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.selectedTimeSlot != null
                      ? Icons.movie
                      : Icons.receipt_long,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${1 + (editableAddOns?.length ?? 0)} item${(1 + (editableAddOns?.length ?? 0)) > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildServiceImage(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Okra',
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (widget.service.description != null) ...[
                      Text(
                        widget.service.description!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondaryColor,
                          fontFamily: 'Okra',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                    // Show service booking information for all services
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getSelectedDate(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getSelectedTimeRange(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Show screen information only for theater services
                    if (widget.selectedScreen != null ||
                        (widget.selectedTimeSlot != null &&
                            widget.selectedTimeSlot!.screenName != null)) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.movie,
                            size: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getScreenName(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondaryColor,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    // Show service category and location information
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.selectedTimeSlot != null
                              ? 'Theater Service'
                              : 'Home Service',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${_formatPrice(_getServicePrice())}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                        if (widget.service.originalPrice != null &&
                            widget.service.offerPrice != null &&
                            widget.service.originalPrice! >
                                widget.service.offerPrice!) ...[
                          const SizedBox(width: 8),
                          Text(
                            '₹${_formatPrice(widget.service.originalPrice!)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondaryColor,
                              decoration: TextDecoration.lineThrough,
                              fontFamily: 'Okra',
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${_calculateDiscount()}% OFF',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successColor,
                                fontFamily: 'Okra',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Show editable add-ons if any
          if (editableAddOns != null && editableAddOns!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: AppTheme.backgroundColor),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Your Add-ons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${editableAddOns!.length} item${editableAddOns!.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...editableAddOns!.entries.map((entry) {
              final addOnKey = entry.key;
              final addOnData = entry.value;
              final addOnName = addOnData['name'] as String;
              final addOnPrice = _safeToDouble(addOnData['price']);
              final isCustomizable =
                  addOnData['isCustomizable'] as bool? ?? false;
              final customText = addOnData['customText'] as String?;
              final characterCount = addOnData['characterCount'] as int?;
              final totalPrice = _safeToDouble(addOnData['totalPrice'] ?? addOnPrice);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Addon icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.extension,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Addon details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  addOnName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Okra',
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${_formatPrice(totalPrice)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Okra',
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Remove button
                          GestureDetector(
                            onTap: () => _removeAddOn(addOnKey),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.red.shade600,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Customization details
                      if (isCustomizable &&
                          customText != null &&
                          customText.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.edit_note,
                                    size: 14,
                                    color: Colors.orange.shade700,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Custom Message:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange.shade700,
                                      fontFamily: 'Okra',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '"$customText"',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: AppTheme.textSecondaryColor,
                                  fontFamily: 'Okra',
                                ),
                              ),
                              if (characterCount != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '$characterCount characters',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange.shade600,
                                    fontFamily: 'Okra',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  int _calculateDiscount() {
    if (widget.service.originalPrice != null &&
        widget.service.offerPrice != null) {
      final discount =
          ((widget.service.originalPrice! - widget.service.offerPrice!) /
              widget.service.originalPrice!) *
          100;
      return discount.round();
    }
    return 0;
  }

  double _calculateSelectedAddOnsTotal() {
    if (editableAddOns == null || editableAddOns!.isEmpty) {
      return 0.0;
    }

    double total = 0.0;
    debugPrint('=== ADD-ON CALCULATION DEBUG ===');
    for (final entry in editableAddOns!.entries) {
      final addOnId = entry.key;
      final addOnData = entry.value;
      final storedTotalPrice = _safeToDouble(addOnData['totalPrice']);
      final rawPrice = _safeToDouble(addOnData['price']);
      final name = addOnData['name'] as String?;
      
      debugPrint('Add-on: $name (ID: $addOnId)');
      debugPrint('  - Stored totalPrice: $storedTotalPrice');
      debugPrint('  - Raw price: $rawPrice');
      
      if (storedTotalPrice > 0) {
        total += storedTotalPrice;
        debugPrint('  - Using stored totalPrice: ₹$storedTotalPrice');
      } else if (rawPrice > 0) {
        final priceWithFees = rawPrice + (rawPrice * 0.0354);
        total += priceWithFees;
        debugPrint('  - Calculated with fees: ₹$priceWithFees');
      }
    }
    debugPrint('Selected add-ons total (with fees): ₹$total');
    debugPrint('=== END ADD-ON CALCULATION DEBUG ===');
    return total;
  }

  double _calculateSelectedAddOnsRawTotal() {
    if (editableAddOns == null || editableAddOns!.isEmpty) {
      return 0.0;
    }

    double total = 0.0;
    debugPrint('=== RAW ADD-ON CALCULATION DEBUG ===');
    for (final entry in editableAddOns!.entries) {
      final addOnId = entry.key;
      final addOnData = entry.value;
      final storedTotalPrice = _safeToDouble(addOnData['totalPrice']);
      final characterCount = addOnData['characterCount'] as int? ?? 1;
      final perUnitPrice = _safeToDouble(addOnData['price']);
      final name = addOnData['name'] as String?;
      
      debugPrint('Raw Add-on: $name (ID: $addOnId)');
      debugPrint('  - Stored totalPrice: $storedTotalPrice');
      debugPrint('  - Per-unit price: $perUnitPrice');
      debugPrint('  - Character count: $characterCount');
      
      if (storedTotalPrice > 0) {
        // Calculate raw total by removing the transaction fee from stored totalPrice
        final rawTotal = storedTotalPrice / 1.0354;
        total += rawTotal;
        debugPrint('  - Raw total (totalPrice / 1.0354): ₹$rawTotal');
      } else if (perUnitPrice > 0) {
        // Fallback: calculate raw total from per-unit price * quantity
        final rawTotal = perUnitPrice * characterCount;
        total += rawTotal;
        debugPrint('  - Raw total (per-unit * count): ₹$rawTotal');
      }
    }
    debugPrint('Selected add-ons raw total (before fees): ₹$total');
    debugPrint('=== END RAW ADD-ON CALCULATION DEBUG ===');
    return total;
  }

  void _removeAddOn(String addOnKey) {
    setState(() {
      editableAddOns?.remove(addOnKey);
    });
    // Recalculate advance payment when add-ons change
    _calculateAdvancePayment();
  }

  Widget _buildServiceImage() {
    String imageUrl = '';
    if (widget.service.photos?.isNotEmpty == true) {
      imageUrl = widget.service.photos!.first;
    } else if (widget.service.image?.isNotEmpty ?? false) {
      imageUrl = widget.service.image!;
    }

    if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.celebration, color: AppTheme.primaryColor, size: 28),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.celebration, color: AppTheme.primaryColor, size: 28),
      ),
    );
  }

  Widget _buildAddressSection(AsyncValue<List<Address>> userAddresses) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service timing section (like Zomato's delivery timing)
          _buildServiceTimingSection(),

          const SizedBox(height: 20),

          // Delivery address section
          userAddresses.when(
            data: (addresses) {
              if (addresses.isEmpty) {
                return _buildAddAddressButton();
              }

              // Ensure we have a selected address
              if (selectedAddressId == null && addresses.isNotEmpty) {
                selectedAddressId = addresses.first.id;
              }

              final selectedAddress = addresses.firstWhere(
                (addr) => addr.id == selectedAddressId,
                orElse: () => addresses.first,
              );

              return _buildZomatoStyleAddressCard(
                selectedAddress,
                userAddresses,
              );
            },
            loading: () => _buildLoadingAddressCard(),
            error: (error, stack) => _buildAddAddressButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTimingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Service delivery timing
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.access_time, color: Colors.grey[600], size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              'Service in 2-3 hours',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildZomatoStyleAddressCard(
    Address address,
    AsyncValue<List<Address>> userAddresses,
  ) {
    final currentUser = ref.watch(currentUserProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Delivery at Home section
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            const Text(
              'Service at Home',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _showAddressSelector(userAddresses),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Address details
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            address.address,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: 16),

        // Add instructions section (like Zomato's delivery instructions)
        GestureDetector(
          onTap: () {
            // TODO: Implement delivery instructions
            _showDeliveryInstructions();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              'Add instructions for service provider',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryColor,
                fontFamily: 'Okra',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Customer details section (like Zomato's contact info)
        Row(
          children: [
            Icon(Icons.call, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser?.userMetadata?['name'] ?? 'Customer',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Okra',
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentUser?.phone ?? currentUser?.email ?? 'Contact info',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Edit contact details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit contact feature coming soon!'),
                  ),
                );
              },
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeliveryInstructions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Service Instructions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Add any special instructions for the service provider...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontFamily: 'Okra',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
                style: const TextStyle(fontFamily: 'Okra', fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Instructions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedAddressCard(Address address) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getAddressTypeIcon(address.addressFor),
              color: AppTheme.primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        address.addressFor
                            .toString()
                            .split('.')
                            .last
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.successColor,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  address.address,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryColor,
                    fontFamily: 'Okra',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (address.area != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    address.area!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingAddressCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.backgroundColor),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAddressTypeIcon(AddressType addressFor) {
    switch (addressFor) {
      case AddressType.home:
        return Icons.home;
      case AddressType.work:
        return Icons.work;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildAddAddressButton() {
    return GestureDetector(
      onTap: () {
        context.push('/profile/addresses/add');
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              'Add Address',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeServiceSection() {
    final selectedAddOns = ref.watch(selectedAddOnsProvider);
    final serviceAddOns = ref.watch(serviceAddOnsProvider(widget.service.id));

    return serviceAddOns.when(
      data: (addOns) {
        if (addOns.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon section similar to Zomato's grid icon
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.apps,
                      color: AppTheme.textPrimaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Complete your service with',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                  if (selectedAddOns.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${selectedAddOns.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Horizontal list of add-ons (show first 4) - Zomato style
              SizedBox(
                height:
                    MediaQuery.of(context).size.width *
                    0.45, // Increased height for better card proportions
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 4),
                  itemCount: addOns.take(4).length,
                  itemBuilder: (context, index) {
                    final addOn = addOns[index];
                    final selectedQuantity = ref
                        .watch(selectedAddOnsProvider.notifier)
                        .getItemQuantity(addOn.id);

                    return Container(
                      width:
                          MediaQuery.of(context).size.width *
                          0.42, // Slightly wider for better content fit
                      margin: EdgeInsets.only(right: index < 3 ? 12 : 0),
                      child: _buildAddOnCard(addOn, selectedQuantity),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Add-ons starting price indicator (Zomato style)
              if (addOns.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Add-ons starting @ ₹${_formatPrice(addOns.map((a) => a.price).reduce((min, price) => price < min ? price : min))} only applied!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[700],
                          fontFamily: 'Okra',
                        ),
                      ),
                      const Spacer(),
                      if (selectedAddOns.isNotEmpty)
                        Text(
                          '- ₹${_formatPrice(ref.read(selectedAddOnsProvider.notifier).getTotalAmount())}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                            fontFamily: 'Okra',
                          ),
                        ),
                    ],
                  ),
                ),

              // View More button and selected add-ons summary
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _navigateToAddOnsListing(addOns),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: Text('View More (${addOns.length})'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (selectedAddOns.isNotEmpty)
                    Text(
                      '₹${_formatPrice(ref.read(selectedAddOnsProvider.notifier).getTotalAmount())}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                        fontFamily: 'Okra',
                      ),
                    ),
                ],
              ),

              // Selected add-ons list (if any)
              if (selectedAddOns.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Selected Add-ons',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...selectedAddOns.map(
                        (selectedAddOn) =>
                            _buildSelectedAddOnItem(selectedAddOn),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 120,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }

  Widget _buildAddOnCard(AddOnModel addOn, int selectedQuantity) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: selectedQuantity > 0
            ? Border.all(color: AppTheme.primaryColor, width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with vegetarian indicator
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Colors.grey[100],
                ),
                child: addOn.imageUrl != null && addOn.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: addOn.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.grey[400],
                                size: 24,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Icon(
                                Icons.restaurant_menu,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        color: Colors.grey[100],
                        child: Center(
                          child: Icon(
                            Icons.restaurant_menu,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                        ),
                      ),
              ),
              // Vegetarian indicator (like Zomato)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 1.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add-on name
                  Text(
                    addOn.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                      fontFamily: 'Okra',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Price and add button section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${_formatPrice(addOn.price)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                                fontFamily: 'Okra',
                              ),
                            ),
                            if (addOn.description != null &&
                                addOn.description!.isNotEmpty)
                              Text(
                                'customisable',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontFamily: 'Okra',
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Add/Remove button (Zomato style)
                      selectedQuantity > 0
                          ? Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => ref
                                        .read(selectedAddOnsProvider.notifier)
                                        .removeAddOn(addOn.id),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      '$selectedQuantity',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Okra',
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => ref
                                        .read(selectedAddOnsProvider.notifier)
                                        .addAddOn(addOn),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () => ref
                                  .read(selectedAddOnsProvider.notifier)
                                  .addAddOn(addOn),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppTheme.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'ADD',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Okra',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.add,
                                      color: AppTheme.primaryColor,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAddOnItem(SelectedAddOnModel selectedAddOn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${selectedAddOn.name} x${selectedAddOn.quantity}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => ref
                    .read(selectedAddOnsProvider.notifier)
                    .removeAddOn(selectedAddOn.id),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, size: 12, color: Colors.red),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${_formatPrice(selectedAddOn.totalPrice)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToAddOnsListing(List<AddOnModel> addOns) {
    // For now, we'll create a simple bottom sheet
    // Later this can be a dedicated page
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Service Add-ons',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: addOns.length,
                itemBuilder: (context, index) {
                  final addOn = addOns[index];
                  final selectedQuantity = ref
                      .watch(selectedAddOnsProvider.notifier)
                      .getItemQuantity(addOn.id);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selectedQuantity > 0
                          ? AppTheme.primaryColor.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedQuantity > 0
                            ? AppTheme.primaryColor
                            : AppTheme.backgroundColor,
                        width: selectedQuantity > 0 ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              addOn.imageUrl != null &&
                                  addOn.imageUrl!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: addOn.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.add_box,
                                      color: AppTheme.primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.add_box,
                                  color: AppTheme.primaryColor,
                                  size: 24,
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addOn.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: selectedQuantity > 0
                                      ? AppTheme.primaryColor
                                      : AppTheme.textPrimaryColor,
                                  fontFamily: 'Okra',
                                ),
                              ),
                              if (addOn.description != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  addOn.description!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondaryColor,
                                    fontFamily: 'Okra',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                '₹${_formatPrice(addOn.price)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                  fontFamily: 'Okra',
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selectedQuantity > 0) ...[
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => ref
                                    .read(selectedAddOnsProvider.notifier)
                                    .removeAddOn(addOn.id),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$selectedQuantity',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Okra',
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => ref
                                    .read(selectedAddOnsProvider.notifier)
                                    .addAddOn(addOn),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          GestureDetector(
                            onTap: () => ref
                                .read(selectedAddOnsProvider.notifier)
                                .addAddOn(addOn),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Okra',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final selectedAddOns = ref.watch(
                            selectedAddOnsProvider,
                          );
                          final totalAmount = ref
                              .read(selectedAddOnsProvider.notifier)
                              .getTotalAmount();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selectedAddOns.isNotEmpty) ...[
                                Text(
                                  '${selectedAddOns.length} item(s) selected',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondaryColor,
                                    fontFamily: 'Okra',
                                  ),
                                ),
                                Text(
                                  '₹${_formatPrice(totalAmount)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryColor,
                                    fontFamily: 'Okra',
                                  ),
                                ),
                              ] else
                                const Text(
                                  'No items selected',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondaryColor,
                                    fontFamily: 'Okra',
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationSummary() {
    if (widget.customization == null) return const SizedBox.shrink();

    final customization = widget.customization!;
    final hasCustomizations = _hasValidCustomizations(customization);

    if (!hasCustomizations) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.tune, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Your Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(_buildCustomizationItems(customization)),
        ],
      ),
    );
  }

  bool _hasValidCustomizations(Map<String, dynamic> customization) {
    return (customization['theme'] != null &&
            customization['theme'] != 'Option') ||
        (customization['venueType'] != null &&
            customization['venueType'] != 'Option') ||
        (customization['serviceEnvironment'] != null &&
            customization['serviceEnvironment'] != 'Option') ||
        (customization['addOns'] != null &&
            customization['addOns'] is List &&
            (customization['addOns'] as List).isNotEmpty) ||
        (customization['placeImage'] != null);
  }

  List<Widget> _buildCustomizationItems(Map<String, dynamic> customization) {
    final items = <Widget>[];

    if (customization['theme'] != null && customization['theme'] != 'Option') {
      items.add(_buildCustomizationItem('Theme', customization['theme']));
    }
    if (customization['venueType'] != null &&
        customization['venueType'] != 'Option') {
      items.add(
        _buildCustomizationItem('Venue Type', customization['venueType']),
      );
    }
    if (customization['serviceEnvironment'] != null &&
        customization['serviceEnvironment'] != 'Option') {
      items.add(
        _buildCustomizationItem(
          'Environment',
          customization['serviceEnvironment'],
        ),
      );
    }
    if (customization['addOns'] != null &&
        customization['addOns'] is List &&
        (customization['addOns'] as List).isNotEmpty) {
      items.add(
        _buildCustomizationItem(
          'Add-ons',
          (customization['addOns'] as List).join(', '),
        ),
      );
    }

    // Add place image if provided
    if (customization['placeImage'] != null &&
        customization['placeImage'] is XFile) {
      items.add(_buildPlaceImageItem(customization['placeImage'] as XFile));
    }

    return items;
  }

  Widget _buildCustomizationItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceImageItem(XFile imageFile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.image, color: AppTheme.primaryColor, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Place Image',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Okra',
                ),
              ),
              const Spacer(),
              const Icon(Icons.check_circle, color: Colors.green, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imageFile.path),
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Image will be uploaded during booking',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_offer,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Apply Coupon',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const Spacer(),
              if (isCouponApplied)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.successColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Applied',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.successColor,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (value) => couponCode = value.toUpperCase(),
                  enabled: !isCouponApplied,
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code',
                    hintStyle: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                      fontFamily: 'Okra',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.backgroundColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isCouponApplied
                            ? AppTheme.successColor
                            : AppTheme.backgroundColor,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppTheme.successColor.withOpacity(0.3),
                      ),
                    ),
                    filled: true,
                    fillColor: isCouponApplied
                        ? AppTheme.successColor.withOpacity(0.05)
                        : AppTheme.backgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.local_offer_outlined,
                      color: isCouponApplied
                          ? AppTheme.successColor
                          : AppTheme.textSecondaryColor,
                      size: 20,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Okra',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isCouponApplied
                        ? AppTheme.successColor
                        : AppTheme.textPrimaryColor,
                  ),
                  initialValue: isCouponApplied ? couponCode : '',
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isCouponApplied
                      ? _removeCoupon
                      : (isApplyingCoupon ? null : _applyCoupon),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCouponApplied
                        ? Colors.red.shade400
                        : AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: isApplyingCoupon
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          isCouponApplied ? 'Remove' : 'Apply',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Okra',
                          ),
                        ),
                ),
              ),
            ],
          ),
          if (isCouponApplied && couponDiscount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.successColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    color: AppTheme.successColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Congratulations! You saved ₹${_formatPrice(couponDiscount)} with coupon $couponCode',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.successColor,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildAvailableCoupons() {
    final servicePrice = _getServicePrice();
    final serviceCouponsAsync = ref.watch(
      serviceCouponsProvider(
        ServiceCouponParams(
          serviceId: widget.service.id,
          orderAmount: servicePrice,
        ),
      ),
    );

    return serviceCouponsAsync.when(
      data: (coupons) {
        if (coupons.isEmpty) {
          return [
            Text(
              'No coupons available for this service',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue.shade600,
                fontFamily: 'Okra',
              ),
            ),
          ];
        }

        return coupons.take(3).map((coupon) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  couponCode = coupon.code;
                });
                _applyCoupon();
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      coupon.code,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      coupon.description ?? coupon.displayDiscount,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade600,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: Colors.blue.shade600,
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
      loading: () => [const CircularProgressIndicator(strokeWidth: 2)],
      error: (error, stack) => [
        Text(
          'Unable to load offers at the moment',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontFamily: 'Okra',
          ),
        ),
      ],
    );
  }

  void _applyCoupon() async {
    if (couponCode.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a coupon code'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() {
      isApplyingCoupon = true;
    });

    try {
      final servicePrice = _getServicePrice();
      final couponRepository = ref.read(couponRepositoryProvider);

      final validatedCoupon = await couponRepository.validateCoupon(
        couponCode: couponCode.trim(),
        serviceId: widget.service.id,
        orderAmount: servicePrice,
      );

      setState(() {
        isApplyingCoupon = false;
        if (validatedCoupon != null) {
          isCouponApplied = true;
          appliedCoupon = validatedCoupon;
          couponDiscount = validatedCoupon.calculateDiscount(servicePrice);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Coupon applied! You saved ₹${_formatPrice(couponDiscount)}',
              ),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Invalid coupon code or not applicable for this service',
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      });
    } catch (e) {
      setState(() {
        isApplyingCoupon = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error validating coupon: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _removeCoupon() {
    setState(() {
      isCouponApplied = false;
      couponDiscount = 0.0;
      couponCode = '';
      appliedCoupon = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Coupon removed'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildBillDetails() {
    final servicePrice = _getServicePrice();
    final addOnsTotal = _calculateSelectedAddOnsTotal();

    // For display purposes, show service price with all fees included (no separate transaction fee)
    final servicePriceWithFees = servicePrice + 28.00 + (servicePrice * 0.0354);
    // Add-ons totalPrice already includes transaction fee from service detail screen
    final addOnsPriceWithFees = addOnsTotal; // No additional fee calculation needed
    final totalAmount =
        servicePriceWithFees + addOnsPriceWithFees - couponDiscount;

    // Use Canvas formula for accurate calculation
    final canvasResult = _calculateCanvasFormula();
    
    // Use RPC data when available, fallback to Canvas formula
    final payableAmount = advancePaymentData != null
        ? _safeToDouble(advancePaymentData!['user_advance_payment'])
        : canvasResult['user_advance_payment']!;
    final remainingAmount = advancePaymentData != null
        ? _safeToDouble(advancePaymentData!['remaining_payment'])
        : canvasResult['remaining_payment']!;
    final totalPriceUserSees = advancePaymentData != null
        ? _safeToDouble(advancePaymentData!['total_price_user_sees'])
        : canvasResult['total_price_user_sees']!;
    
    debugPrint('Canvas calculation - Advance: $payableAmount, Total: ${canvasResult['total_price_user_sees']}, Remaining: $remainingAmount');

    debugPrint('=== BILL DETAILS CALCULATION ===');
    debugPrint('Service price: $servicePrice');
    debugPrint('Service with fees: $servicePriceWithFees');
    debugPrint('Add-ons total: $addOnsTotal');
    debugPrint('Add-ons with fees: $addOnsPriceWithFees');
    debugPrint('Coupon discount: $couponDiscount');
    debugPrint('Local total: $totalAmount (should be ${servicePriceWithFees + addOnsPriceWithFees})');
    debugPrint('RPC total: ${advancePaymentData?['total_price_user_sees'] ?? 'N/A'}');
    debugPrint('Canvas total: ${canvasResult['total_price_user_sees']}');
    debugPrint('Bill Details - Total: $totalAmount, Payable: $payableAmount, RPC Data: ${advancePaymentData != null}');
    if (advancePaymentData != null) {
      debugPrint('RPC Data: $advancePaymentData');
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E7EB), // Figma stroke color
          width: 1,
        ),
      ),
      child: Column(
        spacing: 16,
        children: [
          // Header with summary
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 18, 17, 0),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF0F0F0), // Light grey border
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.receipt_outlined, // Bill icon from Figma
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Bill Summary section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bill Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Incl.all taxes & charges',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Okra',
                          color: Color(0x99000000), // 60% opacity black
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 32),
                
                // Price section with crossed out original price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        // Crossed out original price
                        if (servicePriceWithFees + addOnsPriceWithFees != totalAmount)
                          Text(
                            '₹${_formatPrice(servicePriceWithFees + addOnsPriceWithFees)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Okra',
                              color: Color(0x80000000), // 50% opacity black
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const SizedBox(width: 8),
                        // Final price
                        Text(
                          '₹${_formatPrice(totalAmount)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Okra',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Savings text
                    if (servicePriceWithFees + addOnsPriceWithFees != totalAmount)
                      Text(
                        '₹${_formatPrice((servicePriceWithFees + addOnsPriceWithFees) - totalAmount)} Saved',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Okra',
                          color: Color(0xFF569456), // Green color from Figma
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Divider(
              color: Color(0xFFECEFEE), // Light grey divider
              thickness: 2,
              height: 2,
            ),
          ),

          // Bill breakdown rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              spacing: 16,
              children: [
                // Item Total row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Item Total',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Okra',
                        color: Color(0xA6000000), // 65% opacity black
                      ),
                    ),
                    Row(
                      children: [
                        // Crossed out original price
                        Text(
                          '₹${_formatPrice(servicePriceWithFees)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Okra',
                            color: Color(0x80000000), // 50% opacity black
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Discounted price
                        Text(
                          '₹${_formatPrice(servicePriceWithFees)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Okra',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Add-ons row
                if (addOnsTotal > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add-ons',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Okra',
                          color: Color(0xA6000000), // 65% opacity black
                        ),
                      ),
                      Row(
                        children: [
                          // Crossed out original add-ons price
                          Text(
                            '₹${_formatPrice(addOnsTotal * 1.2)}', // Assume 20% markup
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Okra',
                              color: Color(0x80000000), // 50% opacity black
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Final add-ons price
                          Text(
                            '₹${_formatPrice(addOnsPriceWithFees)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Okra',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                
                // Convenience Fee row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Convenince Fee',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Okra',
                        color: Color(0xA6000000), // 65% opacity black
                      ),
                    ),
                    Row(
                      children: [
                        // Crossed out convenience fee
                        const Text(
                          '₹28',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Okra',
                            color: Color(0x80000000), // 50% opacity black
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Free convenience fee
                        const Text(
                          '₹0',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Okra',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Divider before total
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Divider(
              color: Color(0xFFECEFEE), // Light grey divider
              thickness: 2,
              height: 2,
            ),
          ),
          
          // To Pay - Advance row
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 0, 17, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'To Pay - Advance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: Color(0xFF212427), // Dark grey from Figma
                  ),
                ),
                Text(
                  '₹${_formatPrice(payableAmount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          
          // Total Savings container
          Container(
            margin: const EdgeInsets.fromLTRB(17, 0, 17, 18),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x260B4163), // 15% opacity blue background
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Savings',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Okra',
                    color: Color(0xFF011B2F), // Dark blue from Figma
                  ),
                ),
                Text(
                  '₹${_formatPrice((servicePriceWithFees + addOnsPriceWithFees + 28) - totalAmount)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: Color(0xFF011B2F), // Dark blue from Figma
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildBillRow(
    String label,
    double amount, {
    bool isTotal = false,
    bool isFree = false,
    bool isDiscount = false,
    double? originalPrice,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Okra',
              color: isTotal
                  ? AppTheme.textPrimaryColor
                  : AppTheme.textSecondaryColor,
            ),
          ),
          Row(
            children: [
              if (isFree && originalPrice != null) ...[
                Text(
                  '₹${originalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondaryColor,
                    decoration: TextDecoration.lineThrough,
                    fontFamily: 'Okra',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'FREE',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                isFree
                    ? '₹0'
                    : (isDiscount
                          ? '-₹${_formatPrice(amount.abs())}'
                          : '₹${_formatPrice(amount)}'),
                style: TextStyle(
                  fontSize: isTotal ? 15 : 14,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                  color: isTotal
                      ? AppTheme.primaryColor
                      : isDiscount
                      ? AppTheme.successColor
                      : AppTheme.textPrimaryColor,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    final totalAmount = _getTotalAmount();
    // Use advance payment from RPC calculation, fallback to 60% of total
    final payableAmount = advancePaymentData != null
        ? _safeToDouble(advancePaymentData!['user_advance_payment'])
        : totalAmount * 0.6;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show booking details for theater bookings
            if (widget.selectedTimeSlot != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                        fontFamily: 'Okra',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Date: ${_getSelectedDate()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Time: ${_getSelectedTimeRange()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                    if (widget.selectedScreen != null ||
                        (widget.selectedTimeSlot != null &&
                            widget.selectedTimeSlot!.screenName != null)) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.movie,
                            size: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Screen: ${_getScreenName()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondaryColor,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Payment note
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getPaymentInfoText(payableAmount, totalAmount),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomButton(
              width: double.infinity,
              text: isProcessing
                  ? 'Processing...'
                  : isLoadingAdvancePayment
                  ? 'Calculating...'
                  : 'Pay ₹${_formatPrice(payableAmount)}',
              onPressed: (isProcessing || isLoadingAdvancePayment)
                  ? () {}
                  : _proceedToRazorpay,
            ),
          ],
        ),
      ),
    );
  }

  /// Calculate using Canvas formula
  Map<String, double> _calculateCanvasFormula() {
    final S = _getServicePrice(); // service discounted price
    final A = _calculateSelectedAddOnsRawTotal(); // add-ons raw price (before fees)
    final F = 28.0; // fixed tax
    final p = 3.54; // percent tax
    final c = 5.0; // commission percent
    final g = 18.0; // commission GST percent
    final adv = 40.0; // advance factor
    
    final serviceWithAll = S + F + S * (p / 100);
    final addonsWithAll = A + A * (p / 100);
    final commission = (S + A) * (c / 100);
    final totalCommission = commission * (1 + g / 100);
    final totalVendorPayout = (S + A) - totalCommission;
    final totalPriceUserSees = serviceWithAll + addonsWithAll;
    final userAdvancePayment = totalPriceUserSees - totalVendorPayout * (adv / 100);
    
    debugPrint('Canvas Formula Debug:');
    debugPrint('S (service): $S');
    debugPrint('A (add-ons raw): $A');
    debugPrint('serviceWithAll: $serviceWithAll');
    debugPrint('addonsWithAll: $addonsWithAll');
    debugPrint('totalPriceUserSees: $totalPriceUserSees');
    debugPrint('userAdvancePayment: $userAdvancePayment');
    
    return {
      'total_price_user_sees': totalPriceUserSees,
      'user_advance_payment': userAdvancePayment,
      'remaining_payment': totalPriceUserSees - userAdvancePayment,
    };
  }

  /// Calculate the total amount using the new pricing logic
  double _getTotalAmount() {
    final canvasResult = _calculateCanvasFormula();
    return canvasResult['total_price_user_sees']! - couponDiscount;
  }

  /// Get payment info text for checkout button
  String _getPaymentInfoText(double payableAmount, double totalAmount) {
    if (advancePaymentData != null) {
      final remainingAmount = _safeToDouble(advancePaymentData!['remaining_payment']);
      return 'Pay ₹${_formatPrice(payableAmount)} now, remaining ₹${_formatPrice(remainingAmount)} after service completion';
    } else {
      final remainingAmount = totalAmount - payableAmount;
      return 'Pay ₹${_formatPrice(payableAmount)} now, remaining ₹${_formatPrice(remainingAmount)} after service completion';
    }
  }

  /// Get the service price from theater time slot if available, otherwise from service listing
  double _getServicePrice() {
    // If we have theater time slot data, use the slot price
    if (widget.selectedTimeSlot != null) {
      try {
        return widget.selectedTimeSlot!.basePrice;
      } catch (e) {
        debugPrint('❌ Error accessing theater time slot basePrice: $e');
        debugPrint('❌ Falling back to service listing price');
      }
    }

    // Fallback to service listing prices with safe conversion
    double? offerPrice;
    double? originalPrice;
    
    try {
      offerPrice = widget.service.offerPrice;
    } catch (e) {
      debugPrint('⚠️ Error accessing service offerPrice: $e');
      offerPrice = null;
    }
    
    try {
      originalPrice = widget.service.originalPrice;
    } catch (e) {
      debugPrint('⚠️ Error accessing service originalPrice: $e');
      originalPrice = null;
    }
    
    final price = offerPrice ?? originalPrice ?? 0.0;
    debugPrint('💰 Service price calculated: $price (offer: $offerPrice, original: $originalPrice)');
    return price;
  }

  /// Get the selected date for display
  String _getSelectedDate() {
    // Try widget.selectedDate first
    String? dateToUse = widget.selectedDate;

    // If not available, try customization data
    if ((dateToUse == null || dateToUse.isEmpty) &&
        widget.customization != null &&
        widget.customization!['date'] != null) {
      final customDate = widget.customization!['date'] as String;
      if (customDate != 'Select Date') {
        dateToUse = customDate;
      }
    }

    if (dateToUse != null && dateToUse.isNotEmpty) {
      // Parse and format the date nicely
      try {
        DateTime date;

        // Handle different date formats
        if (dateToUse.contains('-')) {
          // ISO format or yyyy-MM-dd format
          date = DateTime.parse(dateToUse);
        } else if (dateToUse.contains('/')) {
          // dd/MM/yyyy or MM/dd/yyyy format
          final parts = dateToUse.split('/');
          if (parts.length == 3) {
            // Assume dd/MM/yyyy format
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            date = DateTime(year, month, day);
          } else {
            throw FormatException('Invalid date format');
          }
        } else {
          throw FormatException('Unknown date format');
        }

        final day = date.day.toString().padLeft(2, '0');
        final month = date.month.toString().padLeft(2, '0');
        return '$day/$month/${date.year}';
      } catch (e) {
        debugPrint('❌ Error parsing date "$dateToUse": $e');
        // Return the original string if parsing fails
        return dateToUse;
      }
    }

    // Fallback to tomorrow's date for service booking
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final day = tomorrow.day.toString().padLeft(2, '0');
    final month = tomorrow.month.toString().padLeft(2, '0');
    return '$day/$month/${tomorrow.year}';
  }

  /// Get the selected time range for display
  String _getSelectedTimeRange() {
    // Check theater time slot first
    if (widget.selectedTimeSlot != null) {
      return '${widget.selectedTimeSlot!.startTime} - ${widget.selectedTimeSlot!.endTime}';
    }

    // Check customization data for regular services
    if (widget.customization != null && widget.customization!['time'] != null) {
      final selectedTime = widget.customization!['time'] as String;
      if (selectedTime != 'Select Time') {
        return selectedTime;
      }
    }

    // For regular services, show a more appropriate default time
    return 'Morning (9:00 AM - 12:00 PM)';
  }

  /// Get the screen name for display
  String _getScreenName() {
    if (widget.selectedScreen != null) {
      return widget.selectedScreen!.screenName;
    } else if (widget.selectedTimeSlot != null &&
        widget.selectedTimeSlot!.screenName != null) {
      return widget.selectedTimeSlot!.screenName!;
    }

    // Fallback to generic screen
    return 'Screen';
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!$))'),
          (Match m) => '${m[1]},',
        );
  }

  void _showAddressSelector(AsyncValue<List<Address>> userAddresses) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      context.pop();
                      context.push('/profile/addresses/add').then((_) {
                        ref.invalidate(addressesProvider);
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      color: AppTheme.primaryColor,
                      size: 18,
                    ),
                    label: Text(
                      'Add New',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: userAddresses.when(
                data: (addresses) {
                  if (addresses.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 48,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No addresses found',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondaryColor,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: addresses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final isSelected = selectedAddressId == address.id;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAddressId = address.id;
                          });
                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor.withOpacity(0.05)
                                : AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.backgroundColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            address.addressFor
                                                .toString()
                                                .split('.')
                                                .last
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.primaryColor,
                                              fontFamily: 'Okra',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      address.address,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Okra',
                                        color: isSelected
                                            ? AppTheme.textPrimaryColor
                                            : AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                    if (address.area != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        address.area!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondaryColor,
                                          fontFamily: 'Okra',
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Error loading addresses',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _proceedToRazorpay() async {
    debugPrint('🚀 [CHECKOUT] Starting booking process');
    debugPrint('🚀 [CHECKOUT] Selected address ID: $selectedAddressId');

    if (selectedAddressId == null) {
      debugPrint('❌ [CHECKOUT] No address selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select an address'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    debugPrint('✅ [CHECKOUT] Address validation passed');
    setState(() {
      isProcessing = true;
    });

    try {
      debugPrint('📱 [CHECKOUT] Getting current user');
      // Get current user
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        debugPrint('❌ [CHECKOUT] User not authenticated');
        throw Exception('User not authenticated');
      }
      debugPrint('✅ [CHECKOUT] Current user ID: ${currentUser.id}');
      debugPrint('✅ [CHECKOUT] User email: ${currentUser.email}');
      debugPrint('✅ [CHECKOUT] User metadata: ${currentUser.userMetadata}');

      debugPrint('📍 [CHECKOUT] Verifying selected address exists');
      // Verify the selected address exists
      final userAddresses = await ref.read(addressesProvider.future);
      debugPrint('✅ [CHECKOUT] User has ${userAddresses.length} addresses');
      final addressExists = userAddresses.any(
        (addr) => addr.id == selectedAddressId,
      );
      if (!addressExists) {
        debugPrint('❌ [CHECKOUT] Selected address not found in user addresses');
        throw Exception('Selected address not found');
      }
      debugPrint('✅ [CHECKOUT] Address verification passed');

      // Get customer details based on booking type
      String customerName;
      String customerPhone;

      if (bookingForSelf) {
        // Get user profile data for self booking
        final userProfile = ref.read(currentUserProfileProvider).asData?.value;
        customerName = userProfile?.fullName ?? '';
        customerPhone = userProfile?.phoneNumber ?? '';

        debugPrint('📝 [CHECKOUT] Self booking - using profile data');
        debugPrint('📝 [CHECKOUT] Profile Name: $customerName');
        debugPrint('📝 [CHECKOUT] Profile Phone: $customerPhone');

        // Validate self booking requirements
        if (customerName.isEmpty) {
          debugPrint('❌ [CHECKOUT] User profile missing name');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Please complete your profile with your name',
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          setState(() {
            isProcessing = false;
          });
          return;
        }

        if (customerPhone.isEmpty) {
          debugPrint('❌ [CHECKOUT] User profile missing phone number');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Please add your phone number to your profile',
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          setState(() {
            isProcessing = false;
          });
          return;
        }
      } else {
        // Validate form for someone else booking
        debugPrint('📝 [CHECKOUT] Someone else booking - validating form');
        if (!_bookingFormKey.currentState!.validate()) {
          debugPrint('❌ [CHECKOUT] Booking form validation failed');
          setState(() {
            isProcessing = false;
          });
          return;
        }

        customerName = _customerNameController.text.trim();
        customerPhone = _customerPhoneController.text.trim();
        debugPrint('📝 [CHECKOUT] Form Name: $customerName');
        debugPrint('📝 [CHECKOUT] Form Phone: $customerPhone');
      }

      debugPrint('✅ [CHECKOUT] Booking form validation passed');
      debugPrint('✅ [CHECKOUT] Customer Name: $customerName');
      debugPrint('✅ [CHECKOUT] Customer Phone: $customerPhone');
      debugPrint('✅ [CHECKOUT] Booking for self: $bookingForSelf');

      debugPrint('🏪 [CHECKOUT] Getting order creation notifier');
      // Get order creation notifier
      final orderCreationNotifier = ref.read(orderCreationProvider.notifier);

      debugPrint('💰 [CHECKOUT] Calculating total amount');
      // Calculate total amount
      final totalAmount = _getTotalAmount();
      debugPrint('✅ [CHECKOUT] Total amount calculated: $totalAmount');

      debugPrint('🖼️ [CHECKOUT] Checking for place image data');
      // Don't upload place image yet - store it for after payment
      String? placeImageUrl; // Will remain null until after payment
      if (widget.customization?['placeImage'] != null) {
        debugPrint(
          '📸 [CHECKOUT] Place image found, will upload after payment',
        );
      } else {
        debugPrint('ℹ️ [CHECKOUT] No place image to upload');
      }

      debugPrint('📅 [CHECKOUT] Determining booking date and time');
      // Determine booking date and time based on theater data if available
      DateTime bookingDate;
      String? selectedDateStr;
      String? selectedTimeSlotStr;

      if (widget.selectedTimeSlot != null && widget.selectedDate != null) {
        debugPrint('🎭 [CHECKOUT] Theater booking detected');
        // Use theater-specific date
        bookingDate = DateTime.parse(widget.selectedDate!);
        selectedDateStr = widget.selectedDate;
        selectedTimeSlotStr =
            '${widget.selectedTimeSlot!.startTime} - ${widget.selectedTimeSlot!.endTime}';
        debugPrint(
          '✅ [CHECKOUT] Theater date: $selectedDateStr, time: $selectedTimeSlotStr',
        );
      } else {
        debugPrint('🛠️ [CHECKOUT] Regular service booking');
        
        // Extract date from customization data first
        if (widget.customization != null && widget.customization!['date'] != null) {
          final customDate = widget.customization!['date'] as String;
          if (customDate != 'Select Date' && customDate.isNotEmpty) {
            try {
              // Parse date from dd/MM/yyyy format
              final parts = customDate.split('/');
              if (parts.length == 3) {
                bookingDate = DateTime(
                  int.parse(parts[2]), // year
                  int.parse(parts[1]), // month
                  int.parse(parts[0]), // day
                );
                selectedDateStr = customDate;
                debugPrint('✅ [CHECKOUT] Using selected date from customization: $selectedDateStr');
              } else {
                throw FormatException('Invalid date format');
              }
            } catch (e) {
              debugPrint('❌ [CHECKOUT] Error parsing selected date: $e');
              // Fallback to tomorrow
              bookingDate = DateTime.now().add(const Duration(days: 1));
              selectedDateStr = '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
            }
          } else {
            // Fallback to tomorrow if no valid date selected
            bookingDate = DateTime.now().add(const Duration(days: 1));
            selectedDateStr = '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
          }
        } else {
          // Fallback to tomorrow if no customization data
          bookingDate = DateTime.now().add(const Duration(days: 1));
          selectedDateStr = '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
        }
        
        // Extract time from customization data
        if (widget.customization != null && widget.customization!['time'] != null) {
          final selectedTime = widget.customization!['time'] as String;
          if (selectedTime != 'Select Time' && selectedTime.isNotEmpty) {
            selectedTimeSlotStr = selectedTime;
            debugPrint('✅ [CHECKOUT] Using selected time from customization: $selectedTimeSlotStr');
          } else {
            selectedTimeSlotStr = 'TBD';
          }
        } else {
          selectedTimeSlotStr = 'TBD';
        }
        
        debugPrint(
          '✅ [CHECKOUT] Regular service date: $selectedDateStr, time: $selectedTimeSlotStr',
        );
      }

      debugPrint('🚀 [CHECKOUT] Starting order creation process');

      // Determine if this is a theater booking or regular service booking
      if (widget.selectedTimeSlot != null) {
        debugPrint('❌ [CHECKOUT] Theater bookings should use different flow');
        // This is a theater booking - should go to private_theater_bookings table
        // For now, we'll still use the order creation but add a comment for future implementation
        // TODO: Implement theater booking creation for private_theater_bookings table
        throw Exception(
          'Theater bookings should be handled through theater booking flow, not service orders',
        );
      }

      debugPrint(
        '📊 [CHECKOUT] Preparing order data for regular service booking',
      );
      debugPrint('📊 [CHECKOUT] Service ID: ${widget.service.id}');
      debugPrint('📊 [CHECKOUT] Service Name: ${widget.service.name}');
      debugPrint('📊 [CHECKOUT] Vendor ID: ${widget.service.vendorId}');
      debugPrint('📊 [CHECKOUT] Address ID: $selectedAddressId');
      debugPrint('📊 [CHECKOUT] Total Amount: $totalAmount');
      debugPrint('📊 [CHECKOUT] Place Image URL: $placeImageUrl');
      
      // Calculate payment amounts based on UI logic
      final payableAmount = advancePaymentData != null
          ? _safeToDouble(advancePaymentData!['user_advance_payment'])
          : totalAmount * 0.6; // 60% if no RPC data
      final remainingAmount = advancePaymentData != null
          ? _safeToDouble(advancePaymentData!['remaining_payment'])
          : totalAmount * 0.4; // 40% if no RPC data
          
      debugPrint('📊 [CHECKOUT] Payable Amount (advance): $payableAmount');
      debugPrint('📊 [CHECKOUT] Remaining Amount: $remainingAmount');

      // Extract customer details from customization data
      final customization = widget.customization ?? <String, dynamic>{};
      final customerAge = customization['customerAge'] as int?;
      final occasion = customization['occasion'] as String?;
      final orderCustomerName = customization['customerName'] as String? ?? 
          currentUser.userMetadata?['full_name'] ??
          currentUser.email ??
          'Guest User';

      debugPrint('👤 [CHECKOUT] Customer details from customization:');
      debugPrint('👤 [CHECKOUT]   Name: $orderCustomerName');
      debugPrint('👤 [CHECKOUT]   Age: $customerAge');
      debugPrint('👤 [CHECKOUT]   Occasion: $occasion');

      // This is a regular decoration service booking - goes to orders table
      debugPrint('🏗️ [CHECKOUT] Calling orderCreationNotifier.createOrder()');
      final order = await orderCreationNotifier.createOrder(
        userId: currentUser.id,
        vendorId: widget.service.vendorId ?? '',
        customerName: orderCustomerName,
        serviceListingId: widget.service.id,
        serviceTitle: widget.service.name,
        bookingDate: bookingDate,
        totalAmount: totalAmount,
        advanceAmount: payableAmount,
        remainingAmount: remainingAmount,
        customerPhone: currentUser.userMetadata?['phone'] ?? currentUser.phone,
        customerEmail: currentUser.email,
        serviceDescription: widget.service.description,
        bookingTime: selectedTimeSlotStr, // Pass the selected time slot
        specialRequirements: null,
        addressId: selectedAddressId,
        placeImageUrl: placeImageUrl,
        age: customerAge,
        occasion: occasion,
      );

      debugPrint(
        '✅ [CHECKOUT] Order created successfully! Order ID: ${order.id}',
      );

      if (mounted) {
        setState(() {
          isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order created successfully! Order ID: ${order.id}'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // Navigate to payment screen for processing
        context.push(
          PaymentScreen.routeName,
          extra: {
            'service': widget.service,
            'customization': widget.customization,
            'placeImage': widget
                .customization?['placeImage'], // Pass place image data for later upload
            'selectedAddressId': selectedAddressId,
            'totalAmount': totalAmount,
            'advanceAmount': order.advanceAmount,
            'remainingAmount': order.remainingAmount,
            'specialRequirements': null,
            'couponCode': isCouponApplied ? couponCode : null,
            'couponDiscount': couponDiscount,
            'orderId': order.id,
            'selectedDate': selectedDateStr,
            'selectedTimeSlot': selectedTimeSlotStr,
            // Add theater-specific data if available
            'selectedScreen': widget.selectedScreen,
            'selectedTimeSlotData': widget.selectedTimeSlot,
            // Pass the edited addons data
            'selectedAddOns': editableAddOns,
          },
        );
      }
    } catch (e) {
      debugPrint('❌ [CHECKOUT] ERROR: Failed to create order');
      debugPrint('❌ [CHECKOUT] Error type: ${e.runtimeType}');
      debugPrint('❌ [CHECKOUT] Error message: $e');
      debugPrint('❌ [CHECKOUT] Full error details: ${e.toString()}');

      if (mounted) {
        setState(() {
          isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create order: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Widget _buildServiceDetailsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.indigo,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Service Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildServiceDetailItem(
            'Service Type',
            widget.selectedTimeSlot != null
                ? 'Private Theater Booking'
                : 'Decoration Service',
          ),
          const SizedBox(height: 12),
          _buildServiceDetailItem('Scheduled Date', _getSelectedDate()),
          const SizedBox(height: 12),
          _buildServiceDetailItem('Scheduled Time', _getSelectedTimeRange()),
          const SizedBox(height: 12),
          _buildServiceDetailItem(
            'Service Location',
            widget.selectedTimeSlot != null
                ? 'Theater Venue'
                : 'Customer Address',
          ),
          if (widget.selectedTimeSlot != null &&
              _getScreenName() != 'Screen') ...[
            const SizedBox(height: 12),
            _buildServiceDetailItem('Screen/Hall', _getScreenName()),
          ],
          const SizedBox(height: 12),
          _buildServiceDetailItem(
            'Payment Mode',
            'Pay 60% now, 40% after service',
          ),
          if (widget.customization != null &&
              _hasValidCustomizations(widget.customization!)) ...[
            const SizedBox(height: 12),
            _buildServiceDetailItem(
              'Customizations',
              'Applied as per your preferences',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceDetailItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondaryColor,
              fontWeight: FontWeight.w500,
              fontFamily: 'Okra',
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          ':',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondaryColor,
            fontFamily: 'Okra',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Okra',
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancellationPolicy() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cancellation Policy',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryColor,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Free cancellation up to 24 hours before service. Cancellations within 24 hours will incur a 20% charge. No refund for no-shows.',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondaryColor,
              fontFamily: 'Okra',
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'In case of any issues, contact our support team within 2 hours of service completion for assistance.',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondaryColor,
              fontFamily: 'Okra',
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  void _loadUserProfileData() {
    final userProfile = ref.read(currentUserProfileProvider).asData?.value;
    if (userProfile != null) {
      _customerNameController.text = userProfile.fullName ?? '';
      _customerPhoneController.text = userProfile.phoneNumber ?? '';
    }
  }

  /// Fetch vendor GST status from vendor_private_details table
  Future<void> _loadVendorGstStatus() async {
    if (widget.service.vendorId == null) return;

    setState(() {
      isLoadingVendorGst = true;
    });

    try {
      // Fetch vendor GST details from vendor_private_details table
      final response = await Supabase.instance.client
          .from('vendor_private_details')
          .select('gst_number')
          .eq('vendor_id', widget.service.vendorId!)
          .maybeSingle();

      if (mounted) {
        setState(() {
          // Vendor has GST if gst_number is not null and not empty
          vendorHasGst =
              response != null &&
              response['gst_number'] != null &&
              response['gst_number'].toString().trim().isNotEmpty;
          isLoadingVendorGst = false;
        });
      }
    } catch (e) {
      // If there's an error or no GST data found, assume no GST
      if (mounted) {
        setState(() {
          vendorHasGst = false;
          isLoadingVendorGst = false;
        });
      }
      debugPrint('Error loading vendor GST status: $e');
    }
  }

  void _clearCustomerData() {
    _customerNameController.clear();
    _customerPhoneController.clear();
  }

  /// Calculate advance payment using Supabase RPC function
  Future<void> _calculateAdvancePayment() async {
    if (widget.service.vendorId == null) return;

    setState(() {
      isLoadingAdvancePayment = true;
    });

    try {
      final servicePrice = _getServicePrice();
      final addOnsTotal = _calculateSelectedAddOnsRawTotal(); // Use raw total for RPC

      debugPrint(
        'Calling RPC with: vendor_id=${widget.service.vendorId}, service_price=$servicePrice, addons_raw_total=$addOnsTotal',
      );

      // Call the Supabase RPC function
      final response = await Supabase.instance.client.rpc(
        'calculate_advance_payment',
        params: {
          'p_vendor_id': widget.service.vendorId!,
          'p_service_discounted_price': servicePrice,
          'p_addons_discounted_price': addOnsTotal,
        },
      );

      if (mounted) {
        setState(() {
          advancePaymentData = response as Map<String, dynamic>;
          isLoadingAdvancePayment = false;
        });
        debugPrint('RPC Response: $response');
        debugPrint(
          'User advance payment: ${(response as Map<String, dynamic>)['user_advance_payment']}',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          advancePaymentData = null;
          isLoadingAdvancePayment = false;
        });
      }
      debugPrint('Error calculating advance payment: $e');
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }
}
