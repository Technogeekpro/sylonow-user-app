import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/theater/models/theater_model.dart';
import 'package:sylonow_user/features/theater/providers/theater_providers.dart';


class TheaterDetailScreenNew extends ConsumerStatefulWidget {
  const TheaterDetailScreenNew({
    super.key, 
    required this.theaterId,
    this.selectedDate,
    this.selectionData,
  });

  final String theaterId;
  final String? selectedDate;
  final Map<String, dynamic>? selectionData;
  static const routeName = '/theater-new';

  @override
  ConsumerState<TheaterDetailScreenNew> createState() => _TheaterDetailScreenNewState();
}

class _TheaterDetailScreenNewState extends ConsumerState<TheaterDetailScreenNew> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  DateTime? _selectedDate;
  Map<String, dynamic>? _selectedTimeSlot;
  String? _selectedScreenId;
  String? _selectedScreenName;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      _selectedDate = DateTime.parse(widget.selectedDate!);
    }
    
    // Get screen info from selection data
    if (widget.selectionData != null) {
      _selectedScreenId = widget.selectionData!['screenId'];
      _selectedScreenName = widget.selectionData!['screenName'];
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
          
          // Initialize booking selection with theater
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(theaterBookingSelectionProvider.notifier).setTheater(theater);
          });
          
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
                  itemCount: theater.images!.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: theater.images![index],
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
                if (theater.images!.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        theater.images!.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5),
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
                            theater.name!,
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
                                  theater.address!,
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
                            theater.rating!.toStringAsFixed(1),
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
                if (theater.amenities!.isNotEmpty)
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
                        children: theater.amenities!.map((amenity) {
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
                // Date and Screen selection info
                if (_selectedDate != null) ...[
                  const Text(
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
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
                        if (_selectedScreenName != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.tv_outline,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _selectedScreenName!,
                                style: const TextStyle(
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
                  const SizedBox(height: 16),
                ],
                // Time slot selection for selected screen
                Text(
                  _selectedScreenName != null 
                    ? 'Available Time Slots for ${_selectedScreenName!}'
                    : 'Select Time Slot',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedScreenName != null
                    ? 'Choose from available time slots for this screen'
                    : 'Screen will be automatically allocated based on availability',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
                      // Update booking selection with theater and date
                      final bookingNotifier = ref.read(theaterBookingSelectionProvider.notifier);
                      
                      // Set the date
                      if (widget.selectedDate != null) {
                        bookingNotifier.setDate(widget.selectedDate!);
                      }
                      
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
                    _selectedTimeSlot != null 
                        ? 'Continue to Occasions'
                        : 'Select a Time Slot',
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

    // If we have a specific screen selected, use screen-specific time slots
    if (_selectedScreenId != null) {
      final providerKey = '${_selectedScreenId!}|${widget.selectedDate!}';
      final screenTimeSlotsAsync = ref.watch(screenTimeSlotsProvider(providerKey));

      return screenTimeSlotsAsync.when(
        data: (timeSlots) {
          print('🎬 DEBUG: Screen-specific slots: ${timeSlots.length}');
          
          if (timeSlots.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(Icons.schedule, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No time slots available for this screen on selected date',
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
              childAspectRatio: 2.4,
            ),
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              final timeSlot = timeSlots[index];
              final isSelected = _selectedTimeSlot?['id'] == timeSlot['id'];
              final isAvailable = timeSlot['is_available'] ?? true;
              final double originalPrice = (timeSlot['original_hourly_price'] as num?)?.toDouble() ?? 1500.0;
              final double discountedPrice = (timeSlot['discounted_hourly_price'] as num?)?.toDouble() ?? 0.0;
              final double finalPrice = (timeSlot['final_price'] as num?)?.toDouble() ?? originalPrice;
              final bool hasDiscount = timeSlot['has_discount'] ?? false;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: isAvailable ? () {
                  setState(() {
                    _selectedTimeSlot = {
                      ...timeSlot,
                      'screen_id': _selectedScreenId,
                      'screen_name': _selectedScreenName,
                      'base_price': finalPrice,
                      'price_per_hour': finalPrice,
                      'original_hourly_price': originalPrice,
                      'discounted_hourly_price': discountedPrice,
                      'final_price': finalPrice,
                      'has_discount': hasDiscount,
                    };
                  });
                } : null,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: !isAvailable 
                        ? Colors.grey[200] 
                        : isSelected 
                            ? AppTheme.primaryColor 
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
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
                            '${_formatTimeTo12Hour(timeSlot['start_time'])} - ${_formatTimeTo12Hour(timeSlot['end_time'])}',
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
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          if (timeSlot['label'] != null)
                            Text(
                              timeSlot['label'],
                              style: TextStyle(
                                fontSize: 10,
                                color: !isAvailable 
                                    ? Colors.grey[400]
                                    : isSelected 
                                        ? Colors.white.withOpacity(0.9) 
                                        : Colors.grey[600],
                                fontFamily: 'Okra',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: 4),
                          // Price display with discount information
                       
                        ],
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
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
        ),
        error: (error, stackTrace) {
          print('🎬 DEBUG: Screen time slots error: $error');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load time slots for this screen',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.refresh(screenTimeSlotsProvider(providerKey)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // Use direct time slots provider that fetches from theater_time_slots table
    print('🎬 DEBUG: Theater ID: ${widget.theaterId}');
    print('🎬 DEBUG: Selected Date: ${widget.selectedDate}');

    final providerKey = '${widget.theaterId}|${widget.selectedDate!}';
    final timeSlotsAsync = ref.watch(theaterTimeSlotsDirectProvider(providerKey));

    return timeSlotsAsync.when(
      data: (timeSlots) {
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
            childAspectRatio: 1.6,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            final timeSlot = timeSlots[index];
            final isSelected = _selectedTimeSlot != null && _selectedTimeSlot is Map && _selectedTimeSlot!['id'] == timeSlot['id'];
            final isAvailable = timeSlot['is_available'] ?? true;
            final isBooked = timeSlot['is_booked'] ?? false;
            final double originalPrice = (timeSlot['original_hourly_price'] as num?)?.toDouble() ?? 500.0;
            final double discountedPrice = (timeSlot['discounted_hourly_price'] as num?)?.toDouble() ?? 0.0;
            final double finalPrice = (timeSlot['final_price'] as num?)?.toDouble() ?? originalPrice;
            final bool hasDiscount = timeSlot['has_discount'] ?? false;

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isAvailable ? () {
                setState(() {
                  _selectedTimeSlot = {
                    'id': timeSlot['id'],
                    'start_time': timeSlot['start_time'],
                    'end_time': timeSlot['end_time'],
                    'screen_name': timeSlot['screen_name'],
                    'screen_id': timeSlot['screen_id'],
                    'base_price': finalPrice,
                    'price_per_hour': finalPrice,
                    'final_price': finalPrice,
                    'original_hourly_price': originalPrice,
                    'discounted_hourly_price': discountedPrice,
                    'has_discount': hasDiscount,
                  };
                });
              } : null,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isBooked || !isAvailable
                      ? Colors.grey[200] 
                      : isSelected 
                          ? AppTheme.primaryColor 
                          : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isBooked || !isAvailable
                        ? Colors.grey[300]!
                        : isSelected 
                            ? AppTheme.primaryColor 
                            : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Booked indicator
                    if (isBooked)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red[600],
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
                          '${_formatTimeTo12Hour(timeSlot['start_time'])} - ${_formatTimeTo12Hour(timeSlot['end_time'])}',
                          style: TextStyle( 
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isBooked || !isAvailable
                                ? Colors.grey[500]
                                : isSelected 
                                    ? Colors.white 
                                    : Colors.black,
                            fontFamily: 'Okra',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (timeSlot['screen_name'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            timeSlot['screen_name'],
                            style: TextStyle(
                              fontSize: 10,
                              color: isBooked || !isAvailable
                                  ? Colors.grey[400]
                                  : isSelected 
                                      ? Colors.white.withOpacity(0.9) 
                                      : Colors.grey[600],
                              fontFamily: 'Okra',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 4),
                        // Price display with discount information
                        if (hasDiscount && isAvailable && !isBooked) ...[
                          // Show original price with strikethrough
                          Text(
                            '₹${originalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 9,
                              decoration: TextDecoration.lineThrough,
                              color: isSelected ? Colors.white70 : Colors.grey[600],
                              fontFamily: 'Okra',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // Show discounted price
                          Text(
                            '₹${finalPrice.toStringAsFixed(0)}/hr',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.green[700],
                              fontFamily: 'Okra',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ] else ...[
                          // Show regular price
                          Text(
                            '₹${finalPrice.toStringAsFixed(0)}/hr',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isBooked || !isAvailable
                                  ? Colors.grey[400]
                                  : isSelected 
                                      ? Colors.white 
                                      : AppTheme.primaryColor,
                              fontFamily: 'Okra',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
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
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      ),
      error: (error, stackTrace) => Center(
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
                onPressed: () => ref.refresh(theaterTimeSlotsDirectProvider(providerKey)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, y').format(date);
  }

  String _formatTimeTo12Hour(String time24) {
    try {
      final time = TimeOfDay(
        hour: int.parse(time24.split(':')[0]),
        minute: int.parse(time24.split(':')[1]),
      );
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time24; // Return original if parsing fails
    }
  }
}