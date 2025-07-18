import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/theater/models/private_theater_model.dart';
import 'package:sylonow_user/features/theater/providers/theater_providers.dart';

class TheaterDetailScreen extends ConsumerStatefulWidget {
  const TheaterDetailScreen({
    super.key, 
    required this.theaterId,
    this.selectedDate,
  });

  final String theaterId;
  final String? selectedDate;
  static const routeName = '/theater';

  @override
  ConsumerState<TheaterDetailScreen> createState() => _TheaterDetailScreenState();
}

class _TheaterDetailScreenState extends ConsumerState<TheaterDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      _selectedDate = DateTime.parse(widget.selectedDate!);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theaterAsync = ref.watch(theaterByIdProvider(widget.theaterId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: theaterAsync.when(
        data: (theater) {
          if (theater == null) {
            return const Center(
              child: Text(
                'Theater not found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return _buildTheaterDetail(theater);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Error loading theater details',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(theaterByIdProvider(widget.theaterId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTheaterDetail(PrivateTheaterModel theater) {
    return CustomScrollView(
      slivers: [
        // Image carousel app bar
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                // Image carousel
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemCount: theater.images.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: theater.images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.movie, size: 64, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                // Image indicator
                if (theater.images.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        theater.images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Theater details
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theater name and rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            theater.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Okra',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, 
                                       color: Colors.grey, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  theater.address,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontFamily: 'Okra',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            theater.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${theater.totalReviews})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Description
                if (theater.description != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        theater.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                          fontFamily: 'Okra',
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                // Amenities
                if (theater.amenities.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Amenities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: theater.amenities.map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              amenity,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                // Theater info
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.people,
                        title: 'Capacity',
                        value: '${theater.capacity} people',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.access_time,
                        title: 'Duration',
                        value: '3 hours',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Date selection
                if (_selectedDate != null) ...[
                  const Text(
                    'Selected Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatDate(_selectedDate!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Time slot selection
                const Text(
                  'Select Time Slot',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                  ),
                ),
                const SizedBox(height: 12),
                _buildTimeSlotGrid(theater),
                const SizedBox(height: 24),
                // Booking button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _selectedTimeSlot != null
                        ? () {
                            // Navigate to booking screen with selected details
                            _showBookingConfirmation(theater);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Book Now - ₹${theater.hourlyRate.toInt()}/hr',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Okra',
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotGrid(PrivateTheaterModel theater) {
    // Sample time slots - in real app, these would come from theater.availableTimeSlots
    final timeSlots = [
      {'start_time': '09:00', 'end_time': '11:00', 'label': 'Morning Show'},
      {'start_time': '11:30', 'end_time': '13:30', 'label': 'Matinee Show'},
      {'start_time': '14:00', 'end_time': '16:00', 'label': 'Afternoon Show'},
      {'start_time': '16:30', 'end_time': '18:30', 'label': 'Evening Show'},
      {'start_time': '19:00', 'end_time': '21:00', 'label': 'Night Show'},
      {'start_time': '21:30', 'end_time': '23:30', 'label': 'Late Night Show'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = timeSlots[index];
        final timeSlotKey = '${timeSlot['start_time']}-${timeSlot['end_time']}';
        final isSelected = _selectedTimeSlot == timeSlotKey;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedTimeSlot = timeSlotKey;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timeSlot['label']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
                    fontFamily: 'Okra',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${timeSlot['start_time']} - ${timeSlot['end_time']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey[600],
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  void _showBookingConfirmation(PrivateTheaterModel theater) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Confirmation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 16),
            _buildBookingDetailRow('Theater', theater.name),
            _buildBookingDetailRow('Date', _formatDate(_selectedDate!)),
            _buildBookingDetailRow('Time', _getTimeSlotLabel()),
            _buildBookingDetailRow('Duration', '2 hours'),
            _buildBookingDetailRow('Price', '₹${theater.hourlyRate.toInt() * 2}'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _processBooking(theater);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm & Pay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

  Widget _buildBookingDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeSlotLabel() {
    if (_selectedTimeSlot == null) return '';
    
    final parts = _selectedTimeSlot!.split('-');
    return '${parts[0]} - ${parts[1]}';
  }

  void _processBooking(PrivateTheaterModel theater) {
    // Here you would integrate with Razorpay for payment
    // For now, just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking confirmed! Payment integration pending.'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}