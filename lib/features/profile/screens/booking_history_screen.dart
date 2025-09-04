import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../booking/models/order_model.dart';
import '../../booking/providers/booking_providers.dart';

class BookingHistoryScreen extends ConsumerStatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  ConsumerState<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends ConsumerState<BookingHistoryScreen> {
  String _selectedFilter = 'all';
  final List<String> _filters = ['all', 'pending', 'confirmed', 'completed', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    final ordersAsyncValue = ref.watch(userOrdersProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Booking History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: AppTheme.headingColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor, size: 24),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: ordersAsyncValue.when(
              data: (orders) {
                final filteredOrders = _filterOrders(orders);
                
                if (filteredOrders.isEmpty) {
                  return _buildEmptyState();
                }
                
                return _buildOrdersList(filteredOrders);
              },
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  filter.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                backgroundColor: Colors.transparent,
                selectedColor: AppTheme.primaryColor,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    if (_selectedFilter == 'all') {
      return orders;
    }
    return orders.where((order) => order.status == _selectedFilter).toList();
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image, title and QR
            Row(
              children: [
                // Service Image
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: order.serviceImageUrl != null 
                        ? Image.network(
                            order.serviceImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.home_repair_service,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                          )
                        : Icon(
                            Icons.home_repair_service,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Service Title
                Expanded(
                  child: Text(
                    order.serviceTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: AppTheme.textPrimaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // QR Code for Order ID
                Container(
                 
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: QrImageView(
                    data: order.id,
                    version: QrVersions.auto,
                    size: 70,
                    backgroundColor: Colors.transparent,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: AppTheme.textPrimaryColor,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress Bar
            _buildProgressBar(order.status),
            
            const SizedBox(height: 16),

            //Order Cost
            _buildOrderCost(order),

            // Booking Time
            
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatBookingDateTime(order),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Okra',
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showOrderDetails(order),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ),
                if (order.status == 'pending') ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showCancelDialog(order),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCost(OrderModel order) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Order Cost - ₹${_formatAmount(order.totalAmount)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: AppTheme.textPrimaryColor,
            ),
          ),
          
          //Payment Status
          _buildPaymentStatus(order.paymentStatus),
        ],
      ),
    );
  }

  Widget _buildPaymentStatus(String paymentStatus) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: paymentStatus.toLowerCase() == 'pending' ? Colors.orange.shade200 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(paymentStatus,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Okra',
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    bool fullWidth = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 6),
        if (fullWidth) 
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondaryColor,
                fontFamily: 'Okra',
              ),
            ),
          )
        else
          Flexible(
            
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondaryColor,
                fontFamily: 'Okra',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        break;
      case 'confirmed':
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'completed':
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      default:
        backgroundColor = Colors.grey.shade50;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'Okra',
          color: textColor,
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!$))'),
      (Match m) => '${m[1]},',
    );
  }

  String _formatPaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'advance_paid':
        return 'Advance Paid';
      case 'completed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return status.toUpperCase();
    }
  }

  Widget _buildProgressBar(String status) {
    final steps = _getHorizontalTimelineSteps(status);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal Timeline
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                // Step Circle
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: steps[i]['completed'] ? AppTheme.successColor : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: steps[i]['completed']
                      ? const Icon(Icons.check, size: 10, color: Colors.white)
                      : null,
                ),
                
                // Connecting Line (except for last step)
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: steps[i]['completed'] && steps[i + 1]['completed'] 
                            ? AppTheme.successColor 
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ],  
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Step Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps.map<Widget>((step) => Expanded(
            child: Text(
              step['title'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
                color: step['completed'] 
                    ? AppTheme.textPrimaryColor 
                    : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )).toList(),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Order Confirmed';
      case 'confirmed':
        return 'Vendor Assigned';
      case 'in_progress':
        return 'Service In Progress';
      case 'completed':
        return 'Service Completed';
      case 'cancelled':
        return 'Order Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  String _formatBookingDateTime(OrderModel order) {
    final date = DateFormat('MMM dd, yyyy').format(order.bookingDate);
    final time = order.bookingTime != null 
        ? DateFormat('h:mm a').format(
            DateTime.parse('2000-01-01 ${order.bookingTime}')
          ).toUpperCase()
        : 'Time TBD';
    return '$date at $time';
  }

  List<Map<String, dynamic>> _getHorizontalTimelineSteps(String currentStatus) {
    final steps = [
      {
        'title': 'Order Accepted',
        'completed': true, // Always completed once order exists
      },
      {
        'title': 'Service Verified',
        'completed': ['confirmed', 'in_progress', 'completed'].contains(currentStatus.toLowerCase()),
      },
      {
        'title': 'Completed',
        'completed': currentStatus.toLowerCase() == 'completed',
      },
    ];

    // Handle cancelled orders
    if (currentStatus.toLowerCase() == 'cancelled') {
      return [
        {
          'title': 'Order Accepted',
          'completed': true,
        },
        {
          'title': 'Cancelled',
          'completed': true,
        },
        {
          'title': 'Completed',
          'completed': false,
        },
      ];
    }

    return steps;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'No bookings yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your booking history will appear here',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Okra',
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Explore Services',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load bookings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Okra',
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.invalidate(userOrdersProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOrderDetailsSheet(order),
    );
  }

  Widget _buildOrderDetailsSheet(OrderModel order) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Help',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Info Card
                  _buildServiceInfoCard(order),
                  const SizedBox(height: 24),
                  
                  // Order Timeline
                  _buildOrderTimeline(order),
                  const SizedBox(height: 24),
                  
                  // Order Summary
                  _buildOrderSummary(order),
                  const SizedBox(height: 24),
                  
                  // Rating Section (only for completed orders)
                  if (order.status.toLowerCase() == 'completed')
                    _buildRatingSection(order),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfoCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.home_repair_service,
              color: AppTheme.primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.serviceTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                if (order.serviceDescription != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    order.serviceDescription!,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Okra',
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getTimelineTitle(order.status),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const Spacer(),
              if (order.status.toLowerCase() == 'completed')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          if (order.status.toLowerCase() != 'cancelled') ...[
            const SizedBox(height: 8),
            Text(
              _getTimelineSubtitle(order.status),
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Okra',
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 24),
          
          // Timeline Steps
          _buildTimelineSteps(order),
          
          const SizedBox(height: 20),
          
          // Order Info
          _buildOrderInfo(order),
        ],
      ),
    );
  }

  Widget _buildTimelineSteps(OrderModel order) {
    final steps = _getOrderSteps(order.status);
    
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;
        
        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: step['completed'] ? Colors.green : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: step['completed']
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: step['completed'] 
                          ? AppTheme.textPrimaryColor 
                          : Colors.grey.shade600,
                    ),
                  ),
                  if (step['date'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      step['date'],
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Okra',
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildOrderInfo(OrderModel order) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Okra',
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              '₹${_formatAmount(order.totalAmount)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        if (_getFormattedAddress(order).isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getFormattedAddress(order),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Okra',
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOrderSummary(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Order ID', order.id),
          _buildSummaryRow('Booking Date', DateFormat('MMM dd, yyyy').format(order.bookingDate)),
          _buildSummaryRow('Booking Time', order.bookingTime ?? 'Time TBD'),
          _buildSummaryRow('Customer', order.customerName),
          if (order.customerPhone != null)
            _buildSummaryRow('Phone', order.customerPhone!),
          _buildSummaryRow('Payment Status', _formatPaymentStatus(order.paymentStatus)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Okra',
              color: Colors.grey.shade600,
            ),
          ),
          Flexible(
            //Show only last 12 characters
            child: Text(
              value.length > 12 ? value.substring(value.length - 12) : value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate your experience',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Star Rating
          _buildStarRating(),
          
          const SizedBox(height: 20),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle rating submission
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your feedback!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit Rating',
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
    );
  }

  Widget _buildStarRating() {
    return StatefulBuilder(
      builder: (context, setState) {
        int selectedRating = 0;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedRating = index + 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  index < selectedRating ? Icons.star : Icons.star_border,
                  size: 40,
                  color: Colors.amber,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  String _getTimelineTitle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Order Confirmed';
      case 'confirmed':
        return 'Vendor Assigned';
      case 'in_progress':
        return 'Service In Progress';
      case 'completed':
        return 'Service Completed';
      case 'cancelled':
        return 'Order Cancelled';
      default:
        return 'Order Status';
    }
  }

  String _getTimelineSubtitle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Your order has been confirmed and we are looking for a vendor.';
      case 'confirmed':
        return 'A vendor has been assigned to your order.';
      case 'in_progress':
        return 'The vendor is currently working on your service.';
      case 'completed':
        return 'Your service has been completed successfully.';
      default:
        return '';
    }
  }

  List<Map<String, dynamic>> _getOrderSteps(String currentStatus) {
    final allSteps = [
      {
        'title': 'Order Confirmed',
        'date': DateFormat('MMM dd, yyyy').format(DateTime.now()),
        'completed': true,
      },
      {
        'title': 'Vendor Assigned',
        'date': currentStatus != 'pending' ? DateFormat('MMM dd, yyyy').format(DateTime.now()) : null,
        'completed': ['confirmed', 'in_progress', 'completed'].contains(currentStatus.toLowerCase()),
      },
      {
        'title': 'Service In Progress',
        'date': ['in_progress', 'completed'].contains(currentStatus.toLowerCase()) 
            ? DateFormat('MMM dd, yyyy').format(DateTime.now()) : null,
        'completed': ['in_progress', 'completed'].contains(currentStatus.toLowerCase()),
      },
      {
        'title': 'Service Completed',
        'date': currentStatus.toLowerCase() == 'completed' 
            ? DateFormat('MMM dd, yyyy').format(DateTime.now()) : null,
        'completed': currentStatus.toLowerCase() == 'completed',
      },
    ];

    return allSteps;
  }


  void _showCancelDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Cancel Order',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel this order?',
          style: TextStyle(fontFamily: 'Okra'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontFamily: 'Okra',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelOrder(order);
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelOrder(OrderModel order) async {
    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.updateOrderStatus(
        orderId: order.id,
        status: 'cancelled',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        ref.invalidate(userOrdersProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel order: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Helper method to format address from order data
  String _getFormattedAddress(OrderModel order) {
    if (order.addressFull == null && order.addressId == null) {
      return '';
    }

    List<String> addressParts = [];
    
    // Add name if available
    if (order.addressName?.isNotEmpty == true) {
      addressParts.add(order.addressName!);
    }
    
    // Add main address
    if (order.addressFull?.isNotEmpty == true) {
      addressParts.add(order.addressFull!);
    }
    
    // Add floor if available
    if (order.addressFloor?.isNotEmpty == true) {
      addressParts.add('Floor: ${order.addressFloor!}');
    }
    
    // Add area
    if (order.addressArea?.isNotEmpty == true) {
      addressParts.add(order.addressArea!);
    }
    
    // Add nearby landmark
    if (order.addressNearby?.isNotEmpty == true) {
      addressParts.add('Near ${order.addressNearby!}');
    }
    
    // If no address info is available, fall back to address ID
    if (addressParts.isEmpty && order.addressId != null) {
      return 'Address ID: ${order.addressId!.substring(order.addressId!.length - 8)}'; // Show last 8 chars
    }
    
    return addressParts.join(', ');
  }
}