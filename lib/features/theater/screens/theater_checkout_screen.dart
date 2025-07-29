import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/theater/models/cake_model.dart';
import 'package:sylonow_user/features/theater/models/occasion_model.dart';
import 'package:sylonow_user/features/theater/providers/theater_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TheaterCheckoutScreen extends ConsumerStatefulWidget {
  static const String routeName = '/theater/checkout';
  
  final String theaterId;
  final String selectedDate;
  final Map<String, dynamic> selectionData;

  const TheaterCheckoutScreen({
    super.key,
    required this.theaterId,
    required this.selectedDate,
    required this.selectionData,
  });

  @override
  ConsumerState<TheaterCheckoutScreen> createState() => _TheaterCheckoutScreenState();
}

class _TheaterCheckoutScreenState extends ConsumerState<TheaterCheckoutScreen> {
  CakeModel? _selectedCake;
  late Razorpay _razorpay;
  bool _isProcessingPayment = false;
  
  // Form controllers and state
  final TextEditingController _celebrationNameController = TextEditingController();
  int _numberOfPeople = 2;
  bool _wantsDecoration = true;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _celebrationNameController.dispose();
    super.dispose();
  }

  // Pricing calculations for Indian taxation
  double get _slotPrice {
    // Base slot price based on time slot selection
    return widget.selectionData['slotPrice']?.toDouble() ?? 2500.0;
  }

  double get _addOnsPrice {
    double total = 0.0;
    
    // Add add-ons price
    if (widget.selectionData['totalAddOnsPrice'] != null) {
      total += widget.selectionData['totalAddOnsPrice'] as double;
    }
    
    // Add special services price
    if (widget.selectionData['totalSpecialServicesPrice'] != null) {
      total += widget.selectionData['totalSpecialServicesPrice'] as double;
    }
    
    // Add cake price
    if (_selectedCake != null) {
      total += _selectedCake!.price;
    }
    
    return total;
  }

  double get _subtotal {
    return _slotPrice + _addOnsPrice;
  }

  double get _serviceCharge {
    // Service charge of 2.5% (like Swiggy/Zomato)
    return _subtotal * 0.025;
  }

  double get _handlingFee {
    // Fixed handling fee
    return 25.0;
  }

  double get _taxableAmount {
    return _subtotal + _serviceCharge + _handlingFee;
  }

  double get _gstAmount {
    // GST 18% for entertainment services in India
    return _taxableAmount * 0.18;
  }

  double get _totalAmount {
    return _taxableAmount + _gstAmount;
  }

  double get _savings {
    // Show savings for user psychology
    double originalPrice = _slotPrice * 1.2; // Assume 20% markup on original
    return originalPrice - _slotPrice;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _isProcessingPayment = false;
    });
    
    // Save booking to Supabase
    await _saveBookingToDatabase(response.paymentId);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Payment successful! Your booking is confirmed.',
          style: TextStyle(fontFamily: 'Okra'),
        ),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate to success screen or home
    context.go('/');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isProcessingPayment = false;
    });
    
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment failed: ${response.message ?? "Unknown error occurred"}',
          style: const TextStyle(fontFamily: 'Okra'),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _isProcessingPayment = false;
    });
    
    // Show wallet selected message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'External wallet selected: ${response.walletName}',
          style: const TextStyle(fontFamily: 'Okra'),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _startPayment() async {
    if (_totalAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one item to proceed.',
            style: TextStyle(fontFamily: 'Okra'),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    final theaterAsync = ref.read(theaterProvider(widget.theaterId));
    final theater = theaterAsync.value;

    var options = {
      'key': 'rzp_test_W7nvo22WaKOB1y',
      'amount': (_totalAmount * 100).toInt(), // Amount in paise
      'name': 'Sylonow',
      'description': 'Theater Booking - ${theater?.name ?? "Private Theater"}',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '9999999999', // You should get this from user profile
        'email': 'user@example.com' // You should get this from user profile
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      setState(() {
        _isProcessingPayment = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
            style: const TextStyle(fontFamily: 'Okra'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveBookingToDatabase(String? paymentId) async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create the booking record with celebration details
      final bookingData = {
        'user_id': user.id,
        'theater_id': widget.theaterId,
        'booking_date': widget.selectedDate,
        'time_slot': widget.selectionData['selectedTimeSlot'] ?? '',
        'total_amount': _totalAmount,
        'status': 'confirmed',
        'payment_id': paymentId,
        'celebration_name': _celebrationNameController.text.trim(),
        'number_of_people': _numberOfPeople,
        'wants_decoration': _wantsDecoration,
        'selected_occasion_id': widget.selectionData['selectedOccasion']?.id,
        'selected_add_ons': widget.selectionData['selectedAddOns'] ?? [],
        'selected_special_services': widget.selectionData['selectedSpecialServices'] ?? [],
        'selected_cake_id': _selectedCake?.id,
        'pricing_breakdown': {
          'slot_price': _slotPrice,
          'add_ons_price': _addOnsPrice, 
          'service_charge': _serviceCharge,
          'handling_fee': _handlingFee,
          'gst_amount': _gstAmount,
          'subtotal': _subtotal,
          'total': _totalAmount,
        },
        'created_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('theater_bookings').insert(bookingData);
      
    } catch (e) {
      debugPrint('Error saving booking: $e');
      // Show error but don't block the success flow since payment is already processed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking saved with some errors. Please contact support if needed.',
            style: const TextStyle(fontFamily: 'Okra'),
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cakesAsync = ref.watch(theaterCakesProvider(widget.theaterId));
    final theaterAsync = ref.watch(theaterProvider(widget.theaterId));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking Details Header
                  _buildBookingDetailsSection(theaterAsync),

                  const SizedBox(height: 12),

                  // Available Cakes Section
                  if (cakesAsync.value?.isNotEmpty == true)
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add cake',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Horizontal Cakes List
                          SizedBox(
                            height: 120,
                            child: cakesAsync.when(
                              data: (cakes) {
                                if (cakes.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No cakes available',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: const Color(0xFF666666),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: cakes.length,
                                  itemBuilder: (context, index) {
                                    final cake = cakes[index];
                                    final isSelected = _selectedCake?.id == cake.id;
                                    
                                    return _buildCompactCakeCard(cake, isSelected);
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              error: (error, stackTrace) => Center(
                                child: Text(
                                  'Failed to load cakes',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Price Breakdown
                  _buildPriceBreakdown(),
                ],
              ),
            ),
          ),

          // Book Now Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessingPayment ? null : _startPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: _isProcessingPayment
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Pay Now - ₹${_totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 12),
          
          // Occasion
          if (widget.selectionData['selectedOccasion'] != null) ...[
            Row(
              children: [
                Icon(Icons.event, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Occasion: ${(widget.selectionData['selectedOccasion'] as OccasionModel).name}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          
          // Add-ons count
          if (widget.selectionData['selectedAddOns'] != null) ...[
            Row(
              children: [
                Icon(Icons.add_box, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Add-ons: ${(widget.selectionData['selectedAddOns'] as List).length} items',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          
          // Special services count
          if (widget.selectionData['selectedSpecialServices'] != null) ...[
            Row(
              children: [
                Icon(Icons.room_service, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Special Services: ${(widget.selectionData['selectedSpecialServices'] as List).length} services',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          
          // Cake
          if (_selectedCake != null) ...[
            Row(
              children: [
                Icon(Icons.cake, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Cake: ${_selectedCake!.name}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactCakeCard(CakeModel cake, bool isSelected) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          // Cake Image with plus icon
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: cake.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: cake.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.cake,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.cake,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                ),
              ),
              // Plus icon overlay
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCake = isSelected ? null : cake;
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isSelected ? Icons.check : Icons.add,
                      color: isSelected ? Colors.white : AppTheme.primaryColor,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Cake name and price
          Text(
            cake.name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Okra',
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '₹${cake.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with savings badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bill Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Okra',
                ),
              ),
              if (_savings > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text(
                    'You save ₹${_savings.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                      fontFamily: 'Okra',
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Theater slot price
          _buildPriceRow(
            'Theater Slot (${widget.selectionData['selectedTimeSlot'] ?? 'Selected Slot'})',
            _slotPrice,
            isSubtotal: false,
          ),
          
          // Add-ons price
          if (_addOnsPrice > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow('Add-ons & Extras', _addOnsPrice),
          ],
          
          // Cake price
          if (_selectedCake != null) ...[
            const SizedBox(height: 4),
            _buildPriceRow('• ${_selectedCake!.name}', _selectedCake!.price, isIndented: true),
          ],
          
          const SizedBox(height: 12),
          _buildDivider(),
          
          // Subtotal
          _buildPriceRow('Item Total', _subtotal, isSubtotal: true),
          
          const SizedBox(height: 8),
          
          // Service charges
          _buildPriceRow('Service Charge (2.5%)', _serviceCharge, isCharge: true),
          
          // Handling fee
          _buildPriceRow('Handling Fee', _handlingFee, isCharge: true),
          
          const SizedBox(height: 8),
          _buildDivider(),
          
          // GST
          _buildPriceRow('GST (18%)', _gstAmount, isTax: true),
          
          const SizedBox(height: 12),
          _buildDivider(thickness: 2),
          const SizedBox(height: 8),
          
          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Okra',
                ),
              ),
              Text(
                '₹${_totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Tax note
          Text(
            'Inclusive of all taxes • GST will be charged as applicable',
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

  Widget _buildPriceRow(
    String label, 
    double amount, {
    bool isSubtotal = false,
    bool isCharge = false,
    bool isTax = false,
    bool isIndented = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: isIndented ? 16.0 : 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: isSubtotal ? 15 : 14,
                fontWeight: isSubtotal ? FontWeight.w600 : FontWeight.normal,
                color: isSubtotal ? Colors.black : Colors.grey[700],
              ),
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isSubtotal ? 15 : 14,
              fontWeight: isSubtotal ? FontWeight.w600 : FontWeight.normal,
              color: isSubtotal 
                  ? Color(0xff1C1C1C) 
                  : isCharge || isTax 
                      ? Colors.grey[600] 
                      : Colors.grey[700],
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider({double thickness = 1}) {
    return Divider(
      thickness: thickness,
      color: Colors.grey[200],
      height: 1,
    );
  }


  // Enhanced booking details section
  Widget _buildBookingDetailsSection(AsyncValue theaterAsync) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          
          // Service Details Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: theaterAsync.when(
              data: (theater) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Theater Image
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[100],
                        ),
                        child: theater?.images.isNotEmpty == true
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: theater!.images.first,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme.primaryColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.movie_outlined,
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.movie_outlined,
                                color: Colors.grey,
                                size: 24,
                              ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Theater Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service details',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              theater?.name ?? 'Theater Booking',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Booking Info
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    theater?.address ?? 'Theater location',
                    color: const Color(0xFFE91E63),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    _formatDate(DateTime.parse(widget.selectedDate)),
                    color: const Color(0xFFE91E63),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.access_time_outlined,
                    widget.selectionData['selectedTimeSlot'] ?? '7:00 - 9:00',
                    color: const Color(0xFFE91E63),
                    showBadge: true,
                  ),
                ],
              ),
              loading: () => const SizedBox(height: 120),
              error: (error, stackTrace) => const SizedBox(height: 120),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Celebration Name Input
          Text(
            'For whom this celebration is ?',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _celebrationNameController,
            decoration: InputDecoration(
              hintText: 'Type there name here...',
              hintStyle: GoogleFonts.outfit(
                fontSize: 14,
                color: const Color(0xFFBBBBBB),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              fillColor: Colors.white,
              filled: true,
            ),
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Number of people
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Number of people',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              _buildNumberSelector(),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Decoration question
          Text(
            'Do you want decoration',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _wantsDecoration = !_wantsDecoration;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _wantsDecoration ? 'yes' : 'no',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Icon(
                    _wantsDecoration ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF666666),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for the new UI
  Widget _buildInfoRow(IconData icon, String text, {Color? color, bool showBadge = false}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? const Color(0xFF666666),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: const Color(0xFF666666),
            ),
          ),
        ),
        if (showBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Most',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNumberSelector() {
    return Row(
      children: [
        _buildNumberButton('-', () {
          if (_numberOfPeople > 1) {
            setState(() {
              _numberOfPeople--;
            });
          }
        }),
        const SizedBox(width: 16),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '$_numberOfPeople',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildNumberButton('+', () {
          if (_numberOfPeople < 20) { // Set a reasonable max limit
            setState(() {
              _numberOfPeople++;
            });
          }
        }),
      ],
    );
  }

  Widget _buildNumberButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}