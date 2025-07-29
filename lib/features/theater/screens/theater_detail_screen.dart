import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/theater/models/theater_model.dart';
import 'package:sylonow_user/features/theater/providers/theater_providers.dart';


class TheaterDetailScreen extends ConsumerStatefulWidget {
  const TheaterDetailScreen({
    super.key, 
    required this.theaterId,
    this.selectedDate,
    this.selectionData,
  });

  final String theaterId;
  final String? selectedDate;
  final Map<String, dynamic>? selectionData;
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
    print('🎬 DEBUG: Building theater detail screen for theater ID: ${widget.theaterId}');
    final theaterAsync = ref.watch(theaterByIdProvider(widget.theaterId));
    
    print('🎬 DEBUG: Theater async state: ${theaterAsync.runtimeType}');

    return Scaffold(
      backgroundColor: Colors.white,
      body: theaterAsync.when(
        data: (theater) {
          print('🎬 DEBUG: Theater data received: ${theater?.name ?? "null"}');
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
        loading: () {
          print('🎬 DEBUG: Theater loading...');
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        },
        error: (error, stack) {
          print('🎬 DEBUG: Theater error: $error');
          return Center(
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
        );
      },
      ),
    );
  }

  Widget _buildTheaterDetail(TheaterModel theater) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
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
                      colors: const [
                        Color.fromRGBO(0, 0, 0, 0.3),
                        Colors.transparent,
                        Color.fromRGBO(0, 0, 0, 0.3),
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
                              const Icon(Ionicons.location, 
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
                        icon: Ionicons.people,
                        title: 'Capacity',
                        value: '${theater.capacity} people',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoCard(
                        icon: Ionicons.time_outline,
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
                   
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Ionicons.calendar_outline,
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
                const SizedBox(height: 100), // Add space for bottom button
              ],
            ),
          ),
        ),
      ],
    ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _selectedTimeSlot != null
                  ? () {
                      // Navigate to occasions selection screen
                      final updatedSelectionData = Map<String, dynamic>.from(widget.selectionData ?? {});
                      updatedSelectionData['selectedTimeSlot'] = _selectedTimeSlot;
                      
                      context.push(
                        '/theater/${widget.theaterId}/occasions',
                        extra: {
                          'selectedDate': widget.selectedDate!,
                          'selectionData': updatedSelectionData,
                        },
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue to Occasions',
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
        ),
      ),
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

  Widget _buildTimeSlotGrid(TheaterModel theater) {
    if (widget.selectedDate == null) {
      return const Center(
        child: Text(
          'Please select a date first',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'Okra',
          ),
        ),
      );
    }

    print('🎬 DEBUG: Theater ID: ${widget.theaterId}');
    print('🎬 DEBUG: Selected Date: ${widget.selectedDate}');

    final timeSlotsAsync = ref.watch(theaterTimeSlotsProvider({
      'theaterId': widget.theaterId,
      'date': widget.selectedDate!,
    }));

    return timeSlotsAsync.when(
      data: (timeSlots) {
        print('🎬 DEBUG: Received ${timeSlots.length} time slots');
        for (int i = 0; i < timeSlots.length; i++) {
          final slot = timeSlots[i];
          print('🎬 DEBUG: Slot $i: ${slot.startTime} - ${slot.endTime}, Status: ${slot.status}, Price: ${slot.slotPrice}');
        }
        
        if (timeSlots.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.schedule, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No time slots available for this date',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Okra',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.0,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            final timeSlot = timeSlots[index];
            final timeSlotKey = '${timeSlot.startTime}-${timeSlot.endTime}';
            final isSelected = _selectedTimeSlot == timeSlotKey;
            final isAvailable = timeSlot.status == 'available';
            final price = timeSlot.slotPrice.toInt();

            return InkWell(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(24),
              ),
              onTap: isAvailable ? () {
                setState(() {
                  _selectedTimeSlot = timeSlotKey;
                });
              } : null,
              child: Container(
                decoration: BoxDecoration(
                  color: !isAvailable 
                      ? Colors.grey[200] 
                      : isSelected 
                          ? AppTheme.primaryColor 
                          : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(24),
                  ),
                  border: Border.all(
                    color: !isAvailable 
                        ? Colors.grey[300]!
                        : isSelected 
                            ? AppTheme.primaryColor 
                            : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    if (!isAvailable)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'BOOKED',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ),
                      ),
                    Column( 
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTimeRange(timeSlotKey),
                          style: TextStyle( 
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: !isAvailable  
                                ? Colors.grey[500]
                                : isSelected 
                                    ? Colors.white 
                                    : Colors.black,
                            fontFamily: 'Okra',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${timeSlot.startTime} - ${timeSlot.endTime}',
                          style: TextStyle(
                            fontSize: 11,
                            color: !isAvailable 
                                ? Colors.grey[400]
                                : isSelected 
                                    ? Colors.white.withOpacity(0.9) 
                                    : Colors.grey[600],
                            fontFamily: 'Okra',
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isAvailable)
                          Text(
                            '₹$price',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected 
                                  ? Colors.white 
                                  : AppTheme.primaryColor,
                              fontFamily: 'Okra',
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () {
        print('🎬 DEBUG: Time slots loading...');
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
        );
      },
      error: (error, stackTrace) {
        print('🎬 DEBUG: Time slots error: $error');
        print('🎬 DEBUG: Stack trace: $stackTrace');
        return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Failed to load time slots',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(theaterTimeSlotsProvider({
                  'theaterId': widget.theaterId,
                  'date': widget.selectedDate!,
                })),
                child: const Text('Retry'),
              ), 
            ],
          ),
        ),
      );
    },
    );
  }

  Widget _buildBookingDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
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

  String _formatTimeRange(String timeSlot) {
    if (timeSlot.isEmpty) return '';
    
    try {
      final parts = timeSlot.split('-');
      if (parts.length >= 2) {
        return '${parts[0].trim()} - ${parts[1].trim()}';
      }
      return timeSlot;
    } catch (e) {
      return timeSlot;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  // Called when the book now button is pressed
  void _onBookNowPressed(TheaterModel theater) {
    if (_selectedTimeSlot == null || _selectedTimeSlot!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _processBooking(theater);
  }

  // Helper to calculate duration in hours from time range (e.g., '14:00-16:00' -> 2.0)
  double _calculateDurationHours(String timeRange) {
    try {
      final parts = timeRange.split('-');
      if (parts.length != 2) return 2.0; // Default to 2 hours if format is invalid
      
      final startTime = _parseTime(parts[0]);
      final endTime = _parseTime(parts[1]);
      
      if (startTime == null || endTime == null) return 2.0;
      
      final duration = endTime.difference(startTime);
      return duration.inMinutes / 60.0; // Convert to hours
    } catch (e) {
      return 2.0; // Default to 2 hours on error
    }
  }
  
  // Helper to parse time string (HH:mm) to DateTime
  DateTime? _parseTime(String timeStr) {
    try {
      final parts = timeStr.trim().split(':');
      if (parts.length != 2) return null;
      
      final now = DateTime.now();
      return DateTime(
        now.year, 
        now.month, 
        now.day, 
        int.parse(parts[0]), 
        int.parse(parts[1]),
      );
    } catch (e) {
      return null;
    } 
  }
  
  Future<void> _processBooking(TheaterModel theater) async {
    if (_selectedTimeSlot == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    try {
      // Calculate duration and price
      final durationHours = _calculateDurationHours(_selectedTimeSlot!);
      final totalPrice = theater.hourlyRate * durationHours;
      
      // Show booking confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookingDetailRow('Theater', theater.name),
              _buildBookingDetailRow('Date', _formatDate(_selectedDate!)),
              _buildBookingDetailRow('Time', _formatTimeRange(_selectedTimeSlot ?? '')),
              _buildBookingDetailRow('Duration', '${durationHours.toStringAsFixed(1)} hours'),
              _buildBookingDetailRow('Total Price', '₹${totalPrice.toInt()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), 
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm & Pay'),
            ),
          ],
        ),
      );
      
      if (confirmed == true) {
        // Here you would integrate with Razorpay for payment
        // For now, just show a success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking confirmed! Payment integration pending.'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process booking. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}