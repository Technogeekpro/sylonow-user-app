import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/services/image_upload_service.dart';
import '../../address/models/address_model.dart';
import '../../address/providers/address_providers.dart';
import '../../home/models/service_listing_model.dart';
import '../../coupons/models/coupon_model.dart';
import '../../coupons/providers/coupon_providers.dart';
import '../providers/booking_providers.dart';
import '../../theater/models/add_on_model.dart';
import '../../theater/models/selected_add_on_model.dart';
import '../../theater/models/theater_screen_model.dart';
import 'payment_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final ServiceListingModel service;
  final Map<String, dynamic>? customization;
  final String? selectedAddressId;
  final TheaterTimeSlotWithScreenModel? selectedTimeSlot; // Theater time slot data
  final TheaterScreenModel? selectedScreen; // Theater screen data
  final String? selectedDate; // Selected date for booking

  const CheckoutScreen({
    super.key,
    required this.service,
    this.customization,
    this.selectedAddressId,
    this.selectedTimeSlot,
    this.selectedScreen,
    this.selectedDate,
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

  @override
  void initState() {
    super.initState();
    selectedAddressId = widget.selectedAddressId;

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
      debugPrint('🔄 [CHECKOUT] New time slot: ${widget.selectedTimeSlot?.startTime} - ${widget.selectedTimeSlot?.endTime}');
      
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
              _buildUpgradeServiceSection(),
              const SizedBox(height: 12),
              if (widget.customization != null) ...[
                _buildCustomizationSummary(),
                const SizedBox(height: 12),
              ],
              // Only show coupon section if service has available coupons
              FutureBuilder<bool>(
                future: _hasAvailableCoupons(),
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return Column(
                      children: [
                        _buildCouponSection(),
                        const SizedBox(height: 12),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              _buildServiceDetailsSection(),
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
        icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor, size: 24),
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
                border: Border.all(color: AppTheme.successColor.withOpacity(0.4)),
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
                  widget.selectedTimeSlot != null ? Icons.movie : Icons.receipt_long,
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
                  '1 item',
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
                        const Icon(Icons.calendar_today, size: 12, color: AppTheme.textSecondaryColor),
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
                        const Icon(Icons.access_time, size: 12, color: AppTheme.textSecondaryColor),
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
                        (widget.selectedTimeSlot != null && widget.selectedTimeSlot!.screenName != null)) ...[
                      Row(
                        children: [
                          const Icon(Icons.movie, size: 12, color: AppTheme.textSecondaryColor),
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
                        const Icon(Icons.location_on, size: 12, color: AppTheme.textSecondaryColor),
                        const SizedBox(width: 4),
                        Text(
                          widget.selectedTimeSlot != null ? 'Theater Service' : 'Home Service',
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
                            widget.service.originalPrice! > widget.service.offerPrice!) ...[
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
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
        ],
      ),
    );
  }

  int _calculateDiscount() {
    if (widget.service.originalPrice != null && widget.service.offerPrice != null) {
      final discount =
          ((widget.service.originalPrice! - widget.service.offerPrice!) / widget.service.originalPrice!) * 100;
      return discount.round();
    }
    return 0;
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
        child: Icon(
          Icons.celebration,
          color: AppTheme.primaryColor,
          size: 28,
        ),
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
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.celebration,
          color: AppTheme.primaryColor,
          size: 28,
        ),
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

              return _buildZomatoStyleAddressCard(selectedAddress, userAddresses);
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
              child: Icon(
                Icons.access_time,
                color: Colors.grey[600],
                size: 18,
              ),
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

  Widget _buildZomatoStyleAddressCard(Address address, AsyncValue<List<Address>> userAddresses) {
    final currentUser = ref.watch(currentUserProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Delivery at Home section
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.grey[600],
              size: 20,
            ),
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
            Icon(
              Icons.call,
              color: Colors.grey[600],
              size: 20,
            ),
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
                  const SnackBar(content: Text('Edit contact feature coming soon!')),
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
                  hintText: 'Add any special instructions for the service provider...',
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
                style: const TextStyle(
                  fontFamily: 'Okra',
                  fontSize: 14,
                ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        address.addressFor.toString().split('.').last.toUpperCase(),
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
            Icon(
              Icons.add,
              color: AppTheme.primaryColor,
              size: 20,
            ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                height: MediaQuery.of(context).size.width * 0.45, // Increased height for better card proportions
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 4),
                  itemCount: addOns.take(4).length,
                  itemBuilder: (context, index) {
                    final addOn = addOns[index];
                    final selectedQuantity = ref.watch(selectedAddOnsProvider.notifier).getItemQuantity(addOn.id);
                    
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.42, // Slightly wider for better content fit
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 16),
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
                      ...selectedAddOns.map((selectedAddOn) => _buildSelectedAddOnItem(selectedAddOn)),
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
        border: selectedQuantity > 0 ? Border.all(
          color: AppTheme.primaryColor,
          width: 1.5,
        ) : null,
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
                            if (addOn.description != null && addOn.description!.isNotEmpty)
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
                                  onTap: () => ref.read(selectedAddOnsProvider.notifier).removeAddOn(addOn.id),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                  onTap: () => ref.read(selectedAddOnsProvider.notifier).addAddOn(addOn),
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
                            onTap: () => ref.read(selectedAddOnsProvider.notifier).addAddOn(addOn),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                onTap: () => ref.read(selectedAddOnsProvider.notifier).removeAddOn(selectedAddOn.id),
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
                  final selectedQuantity = ref.watch(selectedAddOnsProvider.notifier).getItemQuantity(addOn.id);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selectedQuantity > 0 ? AppTheme.primaryColor.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedQuantity > 0 ? AppTheme.primaryColor : AppTheme.backgroundColor,
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
                          child: addOn.imageUrl != null && addOn.imageUrl!.isNotEmpty
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
                                  color: selectedQuantity > 0 ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
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
                                onTap: () => ref.read(selectedAddOnsProvider.notifier).removeAddOn(addOn.id),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.remove, size: 16, color: Colors.red),
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
                                onTap: () => ref.read(selectedAddOnsProvider.notifier).addAddOn(addOn),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.add, size: 16, color: AppTheme.primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          GestureDetector(
                            onTap: () => ref.read(selectedAddOnsProvider.notifier).addAddOn(addOn),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          final selectedAddOns = ref.watch(selectedAddOnsProvider);
                          final totalAmount = ref.read(selectedAddOnsProvider.notifier).getTotalAmount();
                          
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
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                child: const Icon(
                  Icons.tune,
                  color: Colors.purple,
                  size: 20,
                ),
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
    return (customization['theme'] != null && customization['theme'] != 'Option') ||
        (customization['venueType'] != null && customization['venueType'] != 'Option') ||
        (customization['serviceEnvironment'] != null && customization['serviceEnvironment'] != 'Option') ||
        (customization['addOns'] != null && customization['addOns'] is List && (customization['addOns'] as List).isNotEmpty) ||
        (customization['placeImage'] != null);
  }

  List<Widget> _buildCustomizationItems(Map<String, dynamic> customization) {
    final items = <Widget>[];

    if (customization['theme'] != null && customization['theme'] != 'Option') {
      items.add(_buildCustomizationItem('Theme', customization['theme']));
    }
    if (customization['venueType'] != null && customization['venueType'] != 'Option') {
      items.add(_buildCustomizationItem('Venue Type', customization['venueType']));
    }
    if (customization['serviceEnvironment'] != null && customization['serviceEnvironment'] != 'Option') {
      items.add(_buildCustomizationItem('Environment', customization['serviceEnvironment']));
    }
    if (customization['addOns'] != null && customization['addOns'] is List && (customization['addOns'] as List).isNotEmpty) {
      items.add(_buildCustomizationItem('Add-ons', (customization['addOns'] as List).join(', ')));
    }
    
    // Add place image if provided
    if (customization['placeImage'] != null && customization['placeImage'] is XFile) {
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
              const Icon(
                Icons.image,
                color: AppTheme.primaryColor,
                size: 16,
              ),
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
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 16,
              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      borderSide: const BorderSide(color: AppTheme.backgroundColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isCouponApplied ? AppTheme.successColor : AppTheme.backgroundColor,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppTheme.successColor.withOpacity(0.3),
                      ),
                    ),
                    filled: true,
                    fillColor: isCouponApplied ? AppTheme.successColor.withOpacity(0.05) : AppTheme.backgroundColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    prefixIcon: Icon(
                      Icons.local_offer_outlined,
                      color: isCouponApplied ? AppTheme.successColor : AppTheme.textSecondaryColor,
                      size: 20,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Okra',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isCouponApplied ? AppTheme.successColor : AppTheme.textPrimaryColor,
                  ),
                  initialValue: isCouponApplied ? couponCode : '',
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isCouponApplied ? _removeCoupon : (isApplyingCoupon ? null : _applyCoupon),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCouponApplied ? Colors.red.shade400 : AppTheme.primaryColor,
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.celebration, color: AppTheme.successColor, size: 16),
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
    final serviceCouponsAsync = ref.watch(serviceCouponsProvider(
      ServiceCouponParams(
        serviceId: widget.service.id,
        orderAmount: servicePrice,
      ),
    ));

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
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
      loading: () => [
        const CircularProgressIndicator(strokeWidth: 2),
      ],
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
              content: Text('Coupon applied! You saved ₹${_formatPrice(couponDiscount)}'),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Invalid coupon code or not applicable for this service'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    final addOnsTotal = ref.read(selectedAddOnsProvider.notifier).getTotalAmount();
    
    // Initialize all variables with default values
    double subtotal = 0.0;
    double serviceCharge = 0.0;
    double handlingFee = 0.0;
    double taxableAmount = 0.0;
    double gst = 0.0;
    double totalAmount = 0.0;
    double payableAmount = 0.0;
    double remainingAmount = 0.0;
    double platformFee = 0.0;
    double deliveryFee = 0.0;
    
    if (widget.selectedTimeSlot != null) {
      // Theater-specific pricing
      subtotal = servicePrice + addOnsTotal;
      serviceCharge = subtotal * 0.025; // 2.5% service charge
      handlingFee = 25.0; // Fixed handling fee
      taxableAmount = subtotal + serviceCharge + handlingFee;
      gst = taxableAmount * 0.18; // 18% GST
      totalAmount = taxableAmount + gst - couponDiscount;
      payableAmount = totalAmount * 0.6; // 60% of total
      remainingAmount = totalAmount - payableAmount;
    } else {
      // Original service listing calculations
      subtotal = servicePrice + addOnsTotal;
      platformFee = _calculatePlatformFee(subtotal);
      gst = _calculateGST(subtotal);
      deliveryFee = 0.0; // Free delivery
      totalAmount = subtotal + platformFee + gst + deliveryFee - couponDiscount;
      payableAmount = totalAmount * 0.6; // 60% of total
      remainingAmount = totalAmount - payableAmount;
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
          // Header with collapse/expand functionality
          GestureDetector(
            onTap: () {
              setState(() {
                isBillDetailsExpanded = !isBillDetailsExpanded;
              });
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.receipt,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bill Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      if (!isBillDetailsExpanded) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'To pay ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                                fontFamily: 'Okra',
                              ),
                            ),
                            Text(
                              '₹${_formatPrice(payableAmount)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                                fontFamily: 'Okra',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  isBillDetailsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppTheme.textSecondaryColor,
                ),
              ],
            ),
          ),
          
          // Expanded details
          if (isBillDetailsExpanded) ...[
            const SizedBox(height: 16),
            _buildBillRow('Service total', servicePrice),
            if (addOnsTotal > 0)
              _buildBillRow('Add-ons', addOnsTotal),
            if (widget.selectedTimeSlot != null) ...[
              _buildBillRow('Service charge (2.5%)', serviceCharge),
              _buildBillRow('Handling fee', handlingFee),
              _buildBillRow('GST (18%)', gst),
            ] else ...[
              _buildBillRow('Platform fee', platformFee),
              _buildBillRow('GST (18%)', gst),
              _buildBillRow(
                'Delivery fee',
                deliveryFee,
                isFree: true,
                originalPrice: 49.0,
              ),
            ],
            if (isCouponApplied && couponDiscount > 0)
              _buildBillRow('Coupon discount', -couponDiscount, isDiscount: true),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppTheme.backgroundColor, thickness: 1),
            ),
            _buildBillRow('Total Amount', totalAmount, isTotal: true),
            const SizedBox(height: 12),
            
            // Show booking details for theater bookings
            if (widget.selectedTimeSlot != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Details',
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
                        const Icon(Icons.calendar_today, size: 14, color: AppTheme.textSecondaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Date: ${_getSelectedDate()}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Time: ${_getSelectedTimeRange()}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                    if (widget.selectedScreen != null || 
                        (widget.selectedTimeSlot != null && widget.selectedTimeSlot!.screenName != null)) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.movie, size: 14, color: AppTheme.textSecondaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Screen: ${_getScreenName()}',
                            style: const TextStyle(
                              fontSize: 13,
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
              const SizedBox(height: 12),
            ],
            
            // Payment split information
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pay now (60%)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                          fontFamily: 'Okra',
                        ),
                      ),
                      Text(
                        '₹${_formatPrice(payableAmount)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pay after service (40%)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade600,
                          fontFamily: 'Okra',
                        ),
                      ),
                      Text(
                        '₹${_formatPrice(remainingAmount)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            if (widget.selectedTimeSlot == null) // Only show savings for non-theater bookings
              const SizedBox(height: 12),
            if (widget.selectedTimeSlot == null) // Only show savings for non-theater bookings
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.savings, color: AppTheme.successColor, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'You\'re saving ₹49 on delivery fee!',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.successColor,
                        fontFamily: 'Okra',
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

  Widget _buildBillRow(String label, double amount, {
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
              color: isTotal ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
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
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                isFree ? '₹0' : (isDiscount ? '-₹${_formatPrice(amount.abs())}' : '₹${_formatPrice(amount)}'),
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

  double _calculatePlatformFee(double servicePrice) {
    final fee = servicePrice * 0.02;
    return fee < 10 ? 10 : fee;
  }

  double _calculateGST(double servicePrice) {
    return servicePrice * 0.18;
  }

  Widget _buildCheckoutButton() {
    final totalAmount = _getTotalAmount();
    final payableAmount = totalAmount * 0.6; // 60% of total

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
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
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
                        const Icon(Icons.calendar_today, size: 14, color: AppTheme.textSecondaryColor),
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
                        const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondaryColor),
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
                        (widget.selectedTimeSlot != null && widget.selectedTimeSlot!.screenName != null)) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.movie, size: 14, color: AppTheme.textSecondaryColor),
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
                      widget.selectedTimeSlot != null 
                        ? 'Pay 60% now, remaining 40% after service completion in cash or UPI'
                        : 'Pay 60% now, remaining 40% after service completion in cash or UPI',
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
              text: isProcessing ? 'Processing...' : 'Pay ₹${_formatPrice(payableAmount)}',
              onPressed: isProcessing ? () {} : _proceedToRazorpay,
            ),
          ],
        ),
      ),
    );
  }

  /// Calculate the total amount using theater-specific pricing if available
  double _getTotalAmount() {
    final servicePrice = _getServicePrice();
    final addOnsTotal = ref.read(selectedAddOnsProvider.notifier).getTotalAmount();
    
    // If we have theater data, use theater-specific calculations
    if (widget.selectedTimeSlot != null) {
      // Theater-specific pricing (similar to TheaterCheckoutScreen)
      final subtotal = servicePrice + addOnsTotal;
      final serviceCharge = subtotal * 0.025; // 2.5% service charge
      final handlingFee = 25.0; // Fixed handling fee
      final taxableAmount = subtotal + serviceCharge + handlingFee;
      final gst = taxableAmount * 0.18; // 18% GST
      final totalAmount = taxableAmount + gst;
      return totalAmount - couponDiscount;
    }
    
    // Fallback to original service listing calculations
    final subtotal = servicePrice + addOnsTotal;
    final platformFee = _calculatePlatformFee(subtotal);
    final gst = _calculateGST(subtotal);
    final deliveryFee = 0.0;
    return subtotal + platformFee + gst + deliveryFee - couponDiscount;
  }

  /// Get the service price from theater time slot if available, otherwise from service listing
  double _getServicePrice() {
    // If we have theater time slot data, use the slot price
    if (widget.selectedTimeSlot != null) {
      return widget.selectedTimeSlot!.basePrice;
    }
    
    // Fallback to service listing prices
    return widget.service.offerPrice ?? widget.service.originalPrice ?? 0.0;
  }
  
  /// Get the selected date for display
  String _getSelectedDate() {
    // Try widget.selectedDate first
    String? dateToUse = widget.selectedDate;
    
    // If not available, try customization data
    if ((dateToUse == null || dateToUse.isEmpty) && widget.customization != null && widget.customization!['date'] != null) {
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
        return '$day/${month}/${date.year}';
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
    return '$day/${month}/${tomorrow.year}';
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
    } else if (widget.selectedTimeSlot != null && widget.selectedTimeSlot!.screenName != null) {
      return widget.selectedTimeSlot!.screenName!;
    }
    
    // Fallback to generic screen
    return 'Screen';
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
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
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
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
                            color: isSelected ? AppTheme.primaryColor.withOpacity(0.05) : AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryColor : AppTheme.backgroundColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
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
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            address.addressFor.toString().split('.').last.toUpperCase(),
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
                                        color: isSelected ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
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
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
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
      final addressExists = userAddresses.any((addr) => addr.id == selectedAddressId);
      if (!addressExists) {
        debugPrint('❌ [CHECKOUT] Selected address not found in user addresses');
        throw Exception('Selected address not found');
      }
      debugPrint('✅ [CHECKOUT] Address verification passed');

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
        debugPrint('📸 [CHECKOUT] Place image found, will upload after payment');
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
        selectedTimeSlotStr = '${widget.selectedTimeSlot!.startTime} - ${widget.selectedTimeSlot!.endTime}';
        debugPrint('✅ [CHECKOUT] Theater date: $selectedDateStr, time: $selectedTimeSlotStr');
      } else {
        debugPrint('🛠️ [CHECKOUT] Regular service booking');
        // Use default date (tomorrow)
        bookingDate = DateTime.now().add(const Duration(days: 1));
        selectedDateStr = '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
        selectedTimeSlotStr = 'TBD';
        debugPrint('✅ [CHECKOUT] Default date: $selectedDateStr, time: $selectedTimeSlotStr');
      }
      
      debugPrint('🚀 [CHECKOUT] Starting order creation process');
      
      // Determine if this is a theater booking or regular service booking
      if (widget.selectedTimeSlot != null) {
        debugPrint('❌ [CHECKOUT] Theater bookings should use different flow');
        // This is a theater booking - should go to private_theater_bookings table
        // For now, we'll still use the order creation but add a comment for future implementation
        // TODO: Implement theater booking creation for private_theater_bookings table
        throw Exception('Theater bookings should be handled through theater booking flow, not service orders');
      }
      
      debugPrint('📊 [CHECKOUT] Preparing order data for regular service booking');
      debugPrint('📊 [CHECKOUT] Service ID: ${widget.service.id}');
      debugPrint('📊 [CHECKOUT] Service Name: ${widget.service.name}');
      debugPrint('📊 [CHECKOUT] Vendor ID: ${widget.service.vendorId}');
      debugPrint('📊 [CHECKOUT] Address ID: $selectedAddressId');
      debugPrint('📊 [CHECKOUT] Total Amount: $totalAmount');
      debugPrint('📊 [CHECKOUT] Place Image URL: $placeImageUrl');
      
      // This is a regular decoration service booking - goes to orders table
      debugPrint('🏗️ [CHECKOUT] Calling orderCreationNotifier.createOrder()');
      final order = await orderCreationNotifier.createOrder(
        userId: currentUser.id,
        vendorId: widget.service.vendorId ?? '',
        customerName: currentUser.userMetadata?['full_name'] ?? currentUser.email ?? 'Guest User',
        serviceListingId: widget.service.id,
        serviceTitle: widget.service.name,
        bookingDate: bookingDate,
        totalAmount: totalAmount,
        customerPhone: currentUser.userMetadata?['phone'] ?? currentUser.phone,
        customerEmail: currentUser.email,
        serviceDescription: widget.service.description,
        bookingTime: null, // Regular services don't have specific time slots
        specialRequirements: null,
        addressId: selectedAddressId,
        placeImageUrl: placeImageUrl,
      );
      
      debugPrint('✅ [CHECKOUT] Order created successfully! Order ID: ${order.id}');

      if (mounted) {
        setState(() {
          isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order created successfully! Order ID: ${order.id}'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        
        // Navigate to payment screen for processing
        context.push(PaymentScreen.routeName, extra: {
          'service': widget.service,
          'customization': widget.customization,
          'placeImage': widget.customization?['placeImage'], // Pass place image data for later upload
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
        });
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          _buildServiceDetailItem('Service Type', widget.selectedTimeSlot != null ? 'Private Theater Booking' : 'Decoration Service'),
          const SizedBox(height: 12),
          _buildServiceDetailItem('Scheduled Date', _getSelectedDate()),
          const SizedBox(height: 12),
          _buildServiceDetailItem('Scheduled Time', _getSelectedTimeRange()),
          const SizedBox(height: 12),
          _buildServiceDetailItem('Service Location', widget.selectedTimeSlot != null ? 'Theater Venue' : 'Customer Address'),
          if (widget.selectedTimeSlot != null && _getScreenName() != 'Screen') ...[
            const SizedBox(height: 12),
            _buildServiceDetailItem('Screen/Hall', _getScreenName()),
          ],
          const SizedBox(height: 12),
          _buildServiceDetailItem('Payment Mode', 'Pay 60% now, 40% after service'),
          if (widget.customization != null && _hasValidCustomizations(widget.customization!)) ...[
            const SizedBox(height: 12),
            _buildServiceDetailItem('Customizations', 'Applied as per your preferences'),
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
}