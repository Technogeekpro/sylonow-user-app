import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../models/theater_booking_model.dart';
import '../providers/theater_providers.dart';

class TheaterBookingHistoryScreen extends ConsumerStatefulWidget {
  const TheaterBookingHistoryScreen({super.key});

  static const String routeName = '/profile/theater-bookings';

  @override
  ConsumerState<TheaterBookingHistoryScreen> createState() => _TheaterBookingHistoryScreenState();
}

class _TheaterBookingHistoryScreenState extends ConsumerState<TheaterBookingHistoryScreen> {
  String _selectedFilter = 'all';
  final List<String> _filters = ['all', 'confirmed', 'completed', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    final bookingsAsyncValue = ref.watch(userTheaterBookingsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Theater Bookings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: bookingsAsyncValue.when(
              data: (bookings) {
                final filteredBookings = _filterBookings(bookings);
                
                if (filteredBookings.isEmpty) {
                  return _buildEmptyState();
                }
                
                return _buildBookingsList(filteredBookings);
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
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilterChip(
                label: Text(
                  _getFilterDisplayName(filter),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontFamily: 'Okra',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primaryColor,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'all':
        return 'All';
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return filter;
    }
  }

  List<TheaterBookingModel> _filterBookings(List<TheaterBookingModel> bookings) {
    if (_selectedFilter == 'all') return bookings;
    return bookings.where((booking) => booking.bookingStatus == _selectedFilter).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No theater bookings found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t made any theater bookings yet.',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Okra',
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/theater'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Book a Theater',
              style: TextStyle(
                fontSize: 16,
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
      child: CircularProgressIndicator(
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading bookings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Okra',
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(userTheaterBookingsProvider),
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
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<TheaterBookingModel> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(TheaterBookingModel booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBookingDetails(booking),
          borderRadius: BorderRadius.circular(12),
          child: _buildTicketCard(booking),
        ),
      ),
    );
  }

  Widget _buildTicketCard(TheaterBookingModel booking) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main ticket content
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with theater name and status
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.theaterName ?? 'Theater',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Okra',
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'BOOKING ID: ${booking.id.substring(0, 8).toUpperCase()}',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Okra',
                              color: Colors.grey[600],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.bookingStatus).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getStatusColor(booking.bookingStatus),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        booking.bookingStatus.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                          color: _getStatusColor(booking.bookingStatus),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Ticket details row
                Row(
                  children: [
                    // Left side - Theater image and details
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Theater image
                          Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[100],
                            ),
                            child: booking.theaterImages?.isNotEmpty == true
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: booking.theaterImages!.first,
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
                                        size: 32,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.movie_outlined,
                                    color: Colors.grey,
                                    size: 32,
                                  ),
                          ),

                          const SizedBox(height: 12),

                          // Date and time
                          _buildTicketDetail('DATE', DateFormat('MMM dd, yyyy').format(booking.bookingDate)),
                          const SizedBox(height: 8),
                          _buildTicketDetail('TIME', '${booking.startTime} - ${booking.endTime}'),
                          const SizedBox(height: 8),
                          _buildTicketDetail('GUESTS', '${booking.numberOfPeople} People'),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Right side - QR Code and price
                    Column(
                      children: [
                        // QR Code
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: QrImageView(
                              data: booking.id,
                              version: QrVersions.auto,
                              size: 72,
                              foregroundColor: Colors.black87,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Price
                        Text(
                          '₹${_formatAmount(booking.totalAmount)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Okra',
                            color: AppTheme.primaryColor,
                          ),
                        ),

                        Text(
                          'Total',
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

                if (booking.addons?.isNotEmpty == true) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${booking.addons!.length} Add-ons included',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Okra',
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Dotted line separator
          _buildDottedLine(),

          // Navigation section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theater Location',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.theaterAddress ?? 'Address not available',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Okra',
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _navigateToTheater(booking),
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text(
                    'Navigate',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDottedLine() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(
          50,
          (index) => Expanded(
            child: Container(
              height: 1,
              color: index.isEven ? Colors.grey[300] : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTheater(TheaterBookingModel booking) async {
    try {
      // For now, navigate using the theater address
      // In a real app, you'd use the latitude/longitude from the database
      if (booking.theaterAddress != null && booking.theaterAddress!.isNotEmpty) {
        final query = Uri.encodeComponent(booking.theaterAddress!);
        final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$query';
        final appleMapsUrl = 'http://maps.apple.com/?q=$query';

        // Try to launch Google Maps first
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
        } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
          await launchUrl(Uri.parse(appleMapsUrl), mode: LaunchMode.externalApplication);
        } else {
          _showSnackBar('No maps app available', Colors.orange);
        }
      } else {
        _showSnackBar('Theater address not available', Colors.orange);
      }
    } catch (e) {
      _showSnackBar('Unable to open maps', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontFamily: 'Okra'),
          ),
          backgroundColor: color,
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'no_show':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0);
  }

  void _showBookingDetails(TheaterBookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 24),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.all(8),
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
                      // QR Code Section
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: QrImageView(
                              data: booking.id,
                              version: QrVersions.auto,
                              size: 168,
                              foregroundColor: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          'Show this QR code at the theater',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Okra',
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildDetailSection('Theater', booking.theaterName ?? 'N/A'),
                      _buildDetailSection('Date', DateFormat('MMM dd, yyyy').format(booking.bookingDate)),
                      _buildDetailSection('Time', '${booking.startTime} - ${booking.endTime}'),
                      _buildDetailSection('Booking ID', booking.id),
                      _buildDetailSection('Contact Name', booking.contactName),
                      _buildDetailSection('Contact Phone', booking.contactPhone),
                      if (booking.contactEmail != null)
                        _buildDetailSection('Contact Email', booking.contactEmail!),
                      if (booking.celebrationName != null)
                        _buildDetailSection('Celebration', booking.celebrationName!),
                      _buildDetailSection('Number of People', booking.numberOfPeople.toString()),
                      _buildDetailSection('Total Amount', '₹${_formatAmount(booking.totalAmount)}'),
                      _buildDetailSection('Booking Status', booking.bookingStatus.toUpperCase()),
                      _buildDetailSection('Payment Status', booking.paymentStatus.toUpperCase()),
                      if (booking.specialRequests != null)
                        _buildDetailSection('Special Requests', booking.specialRequests!),

                      // Theater Address and Navigation
                      if (booking.theaterAddress != null && booking.theaterAddress!.isNotEmpty) ...[
                        _buildDetailSection('Theater Address', booking.theaterAddress!),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _navigateToTheater(booking),
                            icon: const Icon(Icons.directions, size: 20),
                            label: const Text(
                              'Navigate to Theater',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Okra',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      if (booking.addons?.isNotEmpty == true) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Add-ons & Services',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Okra',
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...booking.addons!.map((addon) => _buildAddonItem(addon)),
                      ],
                      
                      if (booking.bookingStatus == 'confirmed')
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _cancelBooking(booking.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel Booking',
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddonItem(TheaterBookingAddonModel addon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          if (addon.addonImageUrl != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: addon.addonImageUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addon.addonName ?? 'Add-on',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Qty: ${addon.quantity} × ₹${addon.unitPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Okra',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${addon.totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _cancelBooking(String bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Cancel Booking',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel this theater booking? This action cannot be undone.',
            style: TextStyle(fontFamily: 'Okra'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'No',
                style: TextStyle(color: Colors.grey[600], fontFamily: 'Okra'),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _performCancellation(bookingId);
              },
              child: Text(
                'Yes, Cancel',
                style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performCancellation(String bookingId) async {
    try {
      await ref.read(theaterBookingCancellationProvider.notifier).cancelBooking(bookingId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Booking cancelled successfully',
              style: TextStyle(fontFamily: 'Okra'),
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh the bookings list
        ref.invalidate(userTheaterBookingsProvider);
        
        // Close the modal
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to cancel booking: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Okra'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
