import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../home/models/service_listing_model.dart';
import '../../address/models/address_model.dart';
import '../../address/providers/address_providers.dart';
import '../providers/booking_providers.dart';

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
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedTimeSlot = '';
  List<String> addOns = [];
  String? selectedAddressId;
  String specialRequirements = '';
  bool isProcessing = false;

  // Time slots for booking
  final List<String> timeSlots = [
    '09:00-11:00',
    '11:00-13:00',
    '13:00-15:00',
    '15:00-17:00',
    '17:00-19:00',
    '19:00-21:00',
    '21:00-23:00',
  ];

  @override
  void initState() {
    super.initState();
    selectedAddressId = widget.selectedAddressId;
    
    // If no address is pre-selected, we'll select the first one when addresses load
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
    
    // Initialize from customization data if available
    if (widget.customization != null) {
      final customization = widget.customization!;
      if (customization['date'] != null && customization['date'] != 'Select Date') {
        // Parse date from customization
        try {
          final dateParts = customization['date'].split('/');
          if (dateParts.length == 3) {
            selectedDate = DateTime(
              int.parse(dateParts[2]),
              int.parse(dateParts[1]),
              int.parse(dateParts[0]),
            );
          }
        } catch (e) {
          // Keep default date if parsing fails
        }
      }
      
      if (customization['time'] != null && customization['time'] != 'Select Time') {
        selectedTimeSlot = customization['time'];
      } else {
        selectedTimeSlot = timeSlots.first;
      }
      
      if (customization['addOns'] != null) {
        addOns = List<String>.from(customization['addOns']);
      }
      
      if (customization['comments'] != null) {
        specialRequirements = customization['comments'];
      }
    } else {
      selectedTimeSlot = timeSlots.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAddresses = ref.watch(addressesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Okra',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary Section
                  _buildOrderSummary(),
                  const SizedBox(height: 16),

                  // Address Section
                  _buildAddressSection(userAddresses),
                  const SizedBox(height: 16),

                  // Date and Time Selection
                  _buildDateTimeSection(),
                  const SizedBox(height: 16),

                  // Customization Summary
                  if (widget.customization != null)
                    _buildCustomizationSummary(),
                  if (widget.customization != null) const SizedBox(height: 16),

                  // Special Requirements
                  _buildSpecialRequirements(),
                  const SizedBox(height: 16),

                  // Price Breakdown
                  _buildPriceBreakdown(),
                  
                  const SizedBox(height: 100), // Space for button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCheckoutButton(),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                ),
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildServiceImage(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (widget.service.description != null) ...[
                      Text(
                        widget.service.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'Okra',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      '₹${_formatPrice(_getServicePrice())}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontFamily: 'Okra',
                      ),
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

  Widget _buildServiceImage() {
    // Get the best available image
    String imageUrl = '';
    if (widget.service.photos?.isNotEmpty == true) {
      imageUrl = widget.service.photos!.first;
    } else if (widget.service.image.isNotEmpty) {
      imageUrl = widget.service.image;
    }

    if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      return Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: Icon(
          Icons.celebration,
          color: AppTheme.primaryColor,
          size: 24,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: Icon(
          Icons.celebration,
          color: AppTheme.primaryColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAddressSection(AsyncValue<List<Address>> userAddresses) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Event Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                ),
              ),
              TextButton(
                onPressed: () => _showAddressSelector(userAddresses),
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          userAddresses.when(
            data: (addresses) {
              if (addresses.isEmpty) {
                return _buildAddAddressButton();
              }
              
              // Show first 3 addresses as selectable options
              final displayAddresses = addresses.take(3).toList();
              
              return Column(
                children: [
                  ...displayAddresses.map((address) => _buildSelectableAddressCard(address)),
                  if (addresses.length > 3) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.more_horiz,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${addresses.length - 3} more addresses available',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Okra',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => _buildAddAddressButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableAddressCard(Address address) {
    final isSelected = selectedAddressId == address.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddressId = address.id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.addressFor.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.address,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey[800],
                      fontFamily: 'Okra',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (address.area != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      address.area!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.grey[700] : Colors.grey[600],
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
  }

  Widget _buildAddAddressButton() {
    return GestureDetector(
      onTap: () {
        context.push('/profile/addresses/add');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
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

  Widget _buildDateTimeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Date & Time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 16),
          
          // Date Selection
          Text(
            'Date',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('EEEE, dd MMM yyyy').format(selectedDate),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time Slot Selection
          Text(
            'Time Slot',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: timeSlots.map((slot) => _buildTimeSlotChip(slot)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotChip(String timeSlot) {
    final isSelected = selectedTimeSlot == timeSlot;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeSlot = timeSlot;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          timeSlot,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontFamily: 'Okra',
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationSummary() {
    if (widget.customization == null) return const SizedBox.shrink();
    
    final customization = widget.customization!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Customizations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 12),
          if (customization['theme'] != null && customization['theme'] != 'Option')
            _buildCustomizationItem('Theme', customization['theme']),
          if (customization['venueType'] != null && customization['venueType'] != 'Option')
            _buildCustomizationItem('Venue Type', customization['venueType']),
          if (customization['serviceEnvironment'] != null && customization['serviceEnvironment'] != 'Option')
            _buildCustomizationItem('Environment', customization['serviceEnvironment']),
          if (customization['addOns'] != null && (customization['addOns'] as List).isNotEmpty)
            _buildCustomizationItem('Add-ons', (customization['addOns'] as List).join(', ')),
        ],
      ),
    );
  }

  Widget _buildCustomizationItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialRequirements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Special Requirements',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: specialRequirements,
            onChanged: (value) => specialRequirements = value,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Share any special requirements or messages for your event setup...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
                fontFamily: 'Okra',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primaryColor),
              ),
            ),
            style: const TextStyle(fontFamily: 'Okra'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final servicePrice = _getServicePrice();
    final deliveryFee = 0.0; // Free delivery
    final totalAmount = servicePrice + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceRow('Service Total', servicePrice),
          const SizedBox(height: 8),
          _buildPriceRow(
            'Delivery Fee', 
            deliveryFee, 
            isFree: true,
            originalPrice: 35.0,
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildPriceRow('Total Payable', totalAmount, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {
    bool isTotal = false,
    bool isFree = false,
    double? originalPrice,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontFamily: 'Okra',
          ),
        ),
        Row(
          children: [
            if (isFree && originalPrice != null) ...[
              Text(
                '₹${originalPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  decoration: TextDecoration.lineThrough,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'FREE',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green[700],
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
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: isTotal ? AppTheme.primaryColor : Colors.black,
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CustomButton(
        text: isProcessing ? 'Processing...' : 'Proceed to Payment',
        onPressed: isProcessing ? () {} : _proceedToPayment,
        backgroundColor: isProcessing ? Colors.grey : AppTheme.primaryColor,
        textColor: Colors.white,
      ),
    );
  }

  double _getServicePrice() {
    return widget.service.offerPrice ?? widget.service.originalPrice ?? 0.0;
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showAddressSelector(AsyncValue<List<Address>> userAddresses) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    context.pop(); // Close the bottom sheet
                    context.push('/profile/addresses/add').then((_) {
                      // Refresh addresses after adding new address
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
            const SizedBox(height: 20),
            Flexible(
              child: userAddresses.when(
                data: (addresses) {
                  if (addresses.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.location_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No addresses found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontFamily: 'Okra',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first address to continue',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    );
                  }
                  
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final isSelected = selectedAddressId == address.id;
                      
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        tileColor: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        leading: Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSelected ? AppTheme.primaryColor : Colors.grey[400],
                        ),
                        title: Text(
                          address.address,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Okra',
                            color: isSelected ? Colors.black : Colors.grey[800],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.addressFor.toString().split('.').last.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                                fontFamily: 'Okra',
                              ),
                            ),
                            if (address.area != null)
                              Text(
                                address.area!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontFamily: 'Okra',
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            selectedAddressId = address.id;
                          });
                          context.pop();
                        },
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
                error: (error, stack) => Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading addresses',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[600],
                        fontFamily: 'Okra',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please try again',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontFamily: 'Okra',
                      ),
                    ),
                  ],
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

    if (selectedTimeSlot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a time slot'),
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

    // Simulate processing delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
        
        // Navigate to payment screen
        context.push('/payment', extra: {
          'service': widget.service,
          'customization': widget.customization,
          'selectedDate': selectedDate,
          'selectedTimeSlot': selectedTimeSlot,
          'selectedAddressId': selectedAddressId,
          'totalAmount': _getServicePrice(),
          'specialRequirements': specialRequirements,
          'addOns': addOns,
        });
      }
    });
  }
} 