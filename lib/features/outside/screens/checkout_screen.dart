import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';

import '../models/screen_package_model.dart';
import '../models/theater_screen_model.dart';
import '../models/time_slot_model.dart';
import '../models/addon_model.dart';
import '../providers/theater_screen_detail_providers.dart';
import '../services/razorpay_payment_service.dart';
import '../services/theater_booking_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.screen,
    required this.selectedPackage,
    required this.selectedDate,
    required this.timeSlot,
    required this.screenId,
    required this.selectedAddons,
    required this.totalAddonPrice,
    required this.selectedExtraSpecials,
    required this.totalExtraSpecialPrice,
    required this.selectedSpecialServices,
    required this.totalSpecialServicesPrice,
  });

  final TheaterScreen screen;
  final ScreenPackageModel? selectedPackage;
  final String selectedDate;
  final TimeSlotModel timeSlot;
  final String screenId;
  final List<AddonModel> selectedAddons;
  final double totalAddonPrice;
  final List<AddonModel> selectedExtraSpecials;
  final double totalExtraSpecialPrice;
  final List<AddonModel> selectedSpecialServices;
  final double totalSpecialServicesPrice;

  static const String routeName = '/checkout';

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  List<AddonModel> _selectedCakes = [];
  double _totalCakePrice = 0.0;
  int _peopleCount = 1;
  bool _isProcessingPayment = false;
  late RazorpayPaymentService _razorpayService;

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayPaymentService();
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cakes = ref.watch(addonsByCategoryProvider(AddonCategoryParams(
      theaterId: widget.screen.theaterId,
      category: 'cake',
    )));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking Summary
                  _buildBookingSummary(),
                  const SizedBox(height: 20),

                  // People Count Section
                  _buildPeopleCountSection(),
                  const SizedBox(height: 20),

                  // Cakes Section
                  _buildCakesSection(cakes),
                  const SizedBox(height: 20),

                  // Order Summary
                  _buildOrderSummary(),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),

          // Bottom Payment Bar
          _buildBottomPaymentBar(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          _buildProgressDot(true, 'Add-ons'),
          _buildProgressLine(),
          _buildProgressDot(true, 'Extra Special'),
          _buildProgressLine(),
          _buildProgressDot(true, 'Special Services'),
          _buildProgressLine(),
          _buildProgressDot(true, 'Checkout'),
        ],
      ),
    );
  }

  Widget _buildProgressDot(bool isActive, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryColor : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: isActive
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: 'Okra',
              color: isActive ? AppTheme.primaryColor : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine() {
    return Container(
      height: 2,
      width: 20,
      color: Colors.grey[300],
      margin: const EdgeInsets.only(bottom: 24),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),

          // Screen details
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.screen.images?.isNotEmpty == true
                    ? Image.network(
                        widget.screen.images!.first,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.theaters, color: Colors.grey),
                          );
                        },
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.theaters, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.screen.screenName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.event_seat, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.screen.allowedCapacity ?? widget.screen.capacity} Seats',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date and time
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(widget.selectedDate))}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Time: ${_formatTime(widget.timeSlot.startTime)} - ${_formatTime(widget.timeSlot.endTime)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleCountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Number of People',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How many people will be attending?',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Okra',
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: _peopleCount > 1
                    ? () {
                        setState(() {
                          _peopleCount--;
                        });
                      }
                    : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: _peopleCount > 1 ? AppTheme.primaryColor : Colors.grey[400],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_peopleCount',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: _peopleCount < (widget.screen.allowedCapacity ?? widget.screen.capacity)
                    ? () {
                        setState(() {
                          _peopleCount++;
                        });
                      }
                    : null,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: _peopleCount < (widget.screen.allowedCapacity ?? widget.screen.capacity)
                      ? AppTheme.primaryColor
                      : Colors.grey[400],
                ),
              ),
              const Spacer(),
              Text(
                'Max: ${widget.screen.allowedCapacity ?? widget.screen.capacity}',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Okra',
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCakesSection(AsyncValue<List<AddonModel>> cakes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Cakes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make your celebration special with delicious cakes',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Okra',
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          cakes.when(
            data: (cakesList) {
              if (cakesList.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No cakes available',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Okra',
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cakesList.length,
                  itemBuilder: (context, index) {
                    final cake = cakesList[index];
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      child: _buildCakeCard(cake),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Error loading cakes',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Okra',
                  color: Colors.red[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCakeCard(AddonModel cake) {
    final isSelected = _selectedCakes.contains(cake);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCakes.remove(cake);
            _totalCakePrice -= cake.price;
          } else {
            _selectedCakes.add(cake);
            _totalCakePrice += cake.price;
          }
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: cake.hasImage
                      ? CachedNetworkImage(
                          imageUrl: cake.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.cake,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.cake, color: Colors.grey, size: 30),
                        ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cake.displayName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cake.formattedPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final basePrice = widget.timeSlot.effectivePrice;
    final totalExtraPrice = widget.totalAddonPrice +
                          widget.totalExtraSpecialPrice +
                          widget.totalSpecialServicesPrice +
                          _totalCakePrice;
    final grandTotal = basePrice + totalExtraPrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),

          // Base price
          _buildSummaryRow('Time Slot Base Price', '₹${basePrice.round()}'),

          if (widget.selectedAddons.isNotEmpty)
            _buildSummaryRow('Add-ons (${widget.selectedAddons.length})', '₹${widget.totalAddonPrice.round()}'),

          if (widget.selectedExtraSpecials.isNotEmpty)
            _buildSummaryRow('Extra Special (${widget.selectedExtraSpecials.length})', '₹${widget.totalExtraSpecialPrice.round()}'),

          if (widget.selectedSpecialServices.isNotEmpty)
            _buildSummaryRow('Special Services (${widget.selectedSpecialServices.length})', '₹${widget.totalSpecialServicesPrice.round()}'),

          if (_selectedCakes.isNotEmpty)
            _buildSummaryRow('Cakes (${_selectedCakes.length})', '₹${_totalCakePrice.round()}'),

          _buildSummaryRow('People Count', '$_peopleCount', showPrice: false),

          const Divider(height: 24),

          _buildSummaryRow('Total', '₹${grandTotal.round()}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, bool showPrice = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Okra',
              color: isTotal ? const Color(0xFF1F2937) : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontFamily: 'Okra',
              color: isTotal ? AppTheme.primaryColor : const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPaymentBar() {
    final grandTotal = widget.timeSlot.effectivePrice +
                      widget.totalAddonPrice +
                      widget.totalExtraSpecialPrice +
                      widget.totalSpecialServicesPrice +
                      _totalCakePrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                    ),
                  ),
                  Text(
                    '₹${grandTotal.round()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _isProcessingPayment ? null : _initiatePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isProcessingPayment
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String timeString) {
    final time = TimeOfDay.fromDateTime(
      DateTime.parse('2000-01-01 $timeString'),
    );
    return time.format(context);
  }

  void _initiatePayment() async {
    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final grandTotal = widget.timeSlot.effectivePrice +
                        widget.totalAddonPrice +
                        widget.totalExtraSpecialPrice +
                        widget.totalSpecialServicesPrice +
                        _totalCakePrice;

      // For testing without backend, we'll skip order creation
      // final orderId = await _razorpayService.createOrder(
      //   amount: grandTotal,
      //   currency: 'INR',
      // );
      final orderId = 'test_order_${DateTime.now().millisecondsSinceEpoch}';

      // Create booking first (with pending status)
      final bookingService = ref.read(theaterBookingServiceProvider);
      final bookingId = await bookingService.createPrivateTheaterBooking(
        userId: user.id,
        screen: widget.screen,
        timeSlot: widget.timeSlot,
        selectedDate: widget.selectedDate,
        peopleCount: _peopleCount,
        totalAmount: grandTotal,
        selectedAddons: widget.selectedAddons,
        selectedExtraSpecials: widget.selectedExtraSpecials,
        selectedSpecialServices: widget.selectedSpecialServices,
        selectedCakes: _selectedCakes,
        selectedPackage: widget.selectedPackage,
      );

      // Create time slot booking
      await bookingService.createTimeSlotBooking(
        timeSlotId: widget.timeSlot.id,
        selectedDate: widget.selectedDate,
      );

      // Initiate Razorpay payment
      await _razorpayService.initiatePayment(
        amount: grandTotal,
        orderId: orderId,
        customerName: user.email?.split('@').first ?? 'User',
        customerEmail: user.email ?? 'user@example.com',
        customerPhone: user.phone ?? '+919999999999',
        description: 'Theater booking for ${widget.screen.screenName}',
        onSuccess: (PaymentSuccessResponse response) {
          _handlePaymentSuccess(response, bookingId, bookingService);
        },
        onError: (PaymentFailureResponse response) {
          _handlePaymentError(response, bookingId, bookingService);
        },
        onExternalWallet: (ExternalWalletResponse response) {
          print('External wallet selected: ${response.walletName}');
        },
      );

    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
        _showErrorDialog('Booking failed: ${e.toString()}');
      }
    }
  }

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
    String bookingId,
    TheaterBookingService bookingService,
  ) async {
    try {
      // Update booking with payment details
      await bookingService.updateBookingStatus(
        bookingId: bookingId,
        bookingStatus: 'confirmed',
        paymentStatus: 'paid',
        paymentId: response.paymentId,
      );

      // Mark time slot as booked
      await bookingService.markTimeSlotAsBooked(
        widget.timeSlot.id,
        widget.selectedDate,
      );

      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
        _showSuccessDialog();
      }
    } catch (e) {
      print('Error updating booking after payment success: $e');
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
        _showErrorDialog('Payment successful but booking update failed. Please contact support.');
      }
    }
  }

  void _handlePaymentError(
    PaymentFailureResponse response,
    String bookingId,
    TheaterBookingService bookingService,
  ) async {
    try {
      // Update booking as failed
      await bookingService.updateBookingStatus(
        bookingId: bookingId,
        bookingStatus: 'failed',
        paymentStatus: 'failed',
      );

      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
        _showErrorDialog('Payment failed: ${response.message ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error updating booking after payment failure: $e');
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
        _showErrorDialog('Payment failed: ${response.message ?? 'Unknown error'}');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your theater booking has been confirmed',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Okra',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go to Home',
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
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Failed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Okra',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _initiatePayment();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Retry',
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
          ],
        ),
      ),
    );
  }
}