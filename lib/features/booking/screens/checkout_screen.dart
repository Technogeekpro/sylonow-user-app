import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../address/models/address_model.dart';
import '../../address/providers/address_providers.dart';
import '../../home/models/service_listing_model.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final ServiceListingModel service;
  final Map<String, dynamic>? customization;
  final String? selectedAddressId;

  const CheckoutScreen({
    super.key,
    required this.service,
    this.customization,
    this.selectedAddressId,
  });

  static const String routeName = '/checkout';

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String? selectedAddressId;
  String specialRequirements = '';
  bool isProcessing = false;

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

    if (widget.customization != null) {
      final customization = widget.customization!;
      if (customization['comments'] != null) {
        specialRequirements = customization['comments'];
      }
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
              if (widget.customization != null) ...[
                _buildCustomizationSummary(),
                const SizedBox(height: 12),
              ],
              _buildSpecialRequirements(),
              const SizedBox(height: 12),
              _buildBillDetails(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCheckoutButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.secondaryColor,
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
        color: AppTheme.secondaryColor,
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
                  Icons.receipt_long,
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
    } else if (widget.service.image.isNotEmpty) {
      imageUrl = widget.service.image;
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
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
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Service Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddressSelector(userAddresses),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Change'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          userAddresses.when(
            data: (addresses) {
              if (addresses.isEmpty) {
                return _buildAddAddressButton();
              }

              final selectedAddress = addresses.firstWhere(
                (addr) => addr.id == selectedAddressId,
                orElse: () => addresses.first,
              );

              return _buildSelectedAddressCard(selectedAddress);
            },
            loading: () => _buildLoadingAddressCard(),
            error: (error, stack) => _buildAddAddressButton(),
          ),
        ],
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

  Widget _buildCustomizationSummary() {
    if (widget.customization == null) return const SizedBox.shrink();

    final customization = widget.customization!;
    final hasCustomizations = _hasValidCustomizations(customization);

    if (!hasCustomizations) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
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
        (customization['addOns'] != null && (customization['addOns'] as List).isNotEmpty);
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
    if (customization['addOns'] != null && (customization['addOns'] as List).isNotEmpty) {
      items.add(_buildCustomizationItem('Add-ons', (customization['addOns'] as List).join(', ')));
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

  Widget _buildSpecialRequirements() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.note_add,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Special Requirements',
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
          TextFormField(
            initialValue: specialRequirements,
            onChanged: (value) => specialRequirements = value,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Any special requests or instructions for your service...',
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
                borderSide: const BorderSide(color: AppTheme.backgroundColor),
              ),
              filled: true,
              fillColor: AppTheme.backgroundColor,
              contentPadding: const EdgeInsets.all(14),
            ),
            style: const TextStyle(
              fontFamily: 'Okra',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetails() {
    final servicePrice = _getServicePrice();
    final platformFee = _calculatePlatformFee(servicePrice);
    final gst = _calculateGST(servicePrice);
    final deliveryFee = 0.0; // Free delivery
    final totalAmount = servicePrice + platformFee + gst + deliveryFee;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
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
              const Text(
                'Bill Details',
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
          _buildBillRow('Service total', servicePrice),
          _buildBillRow('Platform fee', platformFee),
          _buildBillRow('GST (18%)', gst),
          _buildBillRow(
            'Delivery fee',
            deliveryFee,
            isFree: true,
            originalPrice: 49.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppTheme.backgroundColor, thickness: 1),
          ),
          _buildBillRow('Total Amount', totalAmount, isTotal: true),
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
      ),
    );
  }

  Widget _buildBillRow(String label, double amount, {
    bool isTotal = false,
    bool isFree = false,
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
                isFree ? '₹0' : '₹${_formatPrice(amount)}',
                style: TextStyle(
                  fontSize: isTotal ? 15 : 14,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                  color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: isProcessing ? 'Processing...' : 'Pay ₹${_formatPrice(totalAmount)}',
          onPressed: isProcessing ? () {} : _proceedToPayment,
        ),
      ),
    );
  }

  double _getTotalAmount() {
    final servicePrice = _getServicePrice();
    final platformFee = _calculatePlatformFee(servicePrice);
    final gst = _calculateGST(servicePrice);
    final deliveryFee = 0.0;
    return servicePrice + platformFee + gst + deliveryFee;
  }

  double _getServicePrice() {
    return widget.service.offerPrice ?? widget.service.originalPrice ?? 0.0;
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
          color: AppTheme.secondaryColor,
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

  void _proceedToPayment() {
    if (selectedAddressId == null) {
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

    setState(() {
      isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });

        context.push('/payment', extra: {
          'service': widget.service,
          'customization': widget.customization,
          'selectedAddressId': selectedAddressId,
          'totalAmount': _getTotalAmount(),
          'specialRequirements': specialRequirements,
        });
      }
    });
  }
}