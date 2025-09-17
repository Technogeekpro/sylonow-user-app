import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/welcome_providers.dart';
import '../../../core/services/image_upload_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/models/service_listing_model.dart';
import '../../home/models/vendor_model.dart';
import '../../home/providers/home_providers.dart';
import '../../profile/providers/profile_providers.dart';
import 'checkout_screen.dart';

class ServiceBookingScreen extends ConsumerStatefulWidget {
  final ServiceListingModel service;
  final Map<String, Map<String, dynamic>> addedAddons;

  const ServiceBookingScreen({
    super.key,
    required this.service,
    this.addedAddons = const {},
  });

  static const String routeName = '/service-booking';

  @override
  ConsumerState<ServiceBookingScreen> createState() =>
      _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends ConsumerState<ServiceBookingScreen> {
  String selectedVenueType = 'Option';
  String selectedDate = 'Select Date';
  String selectedTime = '';
  String selectedEnvironment = 'Option';
  List<String> selectedAddOns = [];
  final TextEditingController commentsController = TextEditingController();

  // Customer info controllers
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerAgeController = TextEditingController();
  final TextEditingController occasionController = TextEditingController();

  // Image upload related state
  XFile? selectedPlaceImage;
  bool isUploadingImage = false;
  final ImageUploadService _imageUploadService = ImageUploadService();

  // Banner related state
  XFile? selectedBannerImage;
  bool isUploadingBannerImage = false;
  final TextEditingController bannerTextController = TextEditingController();

  // Dynamic lists based on service data
  late List<String> venueTypes;
  late List<String> serviceEnvironments;
  late List<Map<String, dynamic>> availableAddOns;
  List<String> timeSlots = [];

  // Vendor availability state
  VendorModel? _vendor;
  bool _isVendorOnline = false;
  String? _vendorStartTime; // HH:mm
  String? _vendorCloseTime; // HH:mm

  @override
  void initState() {
    super.initState();
    _initializeOptionsFromService();
    _loadUserProfileAndSetDate()
        .then((_) {
          return _loadWelcomePreferences();
        })
        .then((_) {
          // Ensure selected values are valid after loading preferences
          _validateSelectedValues();
        });
    _loadVendorAndBuildTimeSlots();
  }

  void _validateSelectedValues() async {
    try {
      final availableDates = await _getAvailableDatesWithVendorBlocking();

      // Validate selected date
      if (!availableDates.contains(selectedDate)) {
        setState(() {
          // If current selected date is not available, auto-select the first available date
          selectedDate = availableDates.isNotEmpty
              ? availableDates.first
              : 'Select Date';
          debugPrint('📅 Auto-selected new date: $selectedDate');
        });

        // Rebuild time slots for the new selected date
        if (selectedDate != 'Select Date') {
          _rebuildTimeSlotsForSelectedDate();
        }
      }
    } catch (e) {
      debugPrint('❌ Error validating selected values: $e');
      // Fallback to basic validation if async fails
      final fallbackDates = _getAvailableDates();
      if (!fallbackDates.contains(selectedDate)) {
        setState(() {
          selectedDate = fallbackDates.isNotEmpty
              ? fallbackDates.first
              : 'Select Date';
        });
      }
    }

    // Validate selected time
    if (!timeSlots.contains(selectedTime)) {
      setState(() {
        selectedTime = '';
      });
    }

    // Validate selected venue type
    if (!venueTypes.contains(selectedVenueType)) {
      setState(() {
        selectedVenueType = 'Option';
      });
    }

    // Validate selected environment
    if (!serviceEnvironments.contains(selectedEnvironment)) {
      setState(() {
        selectedEnvironment = 'Option';
      });
    }
  }

  void _initializeOptionsFromService() {
    // Initialize venue types from service data or fallback to defaults
    venueTypes = widget.service.venueTypes?.isNotEmpty == true
        ? widget.service.venueTypes!
        : ['Home', 'Community Hall', 'Restaurant', 'Park'];

    // Initialize service environments
    serviceEnvironments = widget.service.serviceEnvironment?.isNotEmpty == true
        ? widget.service.serviceEnvironment!
              .map((env) => env.toUpperCase())
              .toList()
        : ['INDOOR', 'OUTDOOR'];

    // Initialize add-ons from service data
    availableAddOns = widget.service.addOns ?? [];

    debugPrint('🎨 Booking screen initialized with:');
    debugPrint('  - Venue types: $venueTypes');
    debugPrint('  - Service environments: $serviceEnvironments');
    debugPrint('  - Available add-ons: ${availableAddOns.length}');
  }

  Future<void> _loadVendorAndBuildTimeSlots() async {
    try {
      debugPrint('🕒 ===== STARTING VENDOR LOAD =====');
      final repo = ref.read(homeRepositoryProvider);
      final vendorId = widget.service.vendorId;
      debugPrint('🕒 Service vendor ID: $vendorId');
      debugPrint('🕒 Service ID: ${widget.service.id}');
      debugPrint('🕒 Service name: ${widget.service.name}');

      if (vendorId == null) {
        debugPrint('❌ Vendor ID is null for service ${widget.service.id}');
        setState(() {
          timeSlots = [];
        });
        return;
      }

      debugPrint('🕒 Calling repo.getVendorById($vendorId)');
      final vendor = await repo.getVendorById(vendorId);
      debugPrint('🕒 Repository returned vendor: $vendor');

      _vendor = vendor;
      _isVendorOnline = vendor?.isOnline ?? false;
      _vendorStartTime = vendor?.startTime; // expected HH:mm or HH:mm:ss
      _vendorCloseTime = vendor?.closeTime; // expected HH:mm or HH:mm:ss

      debugPrint('🕒 ===== VENDOR DEBUG INFO =====');
      debugPrint('🕒 Vendor ID: $vendorId');
      debugPrint('🕒 Vendor from DB: $vendor');
      debugPrint('🕒 Raw isOnline value: ${vendor?.isOnline}');
      debugPrint('🕒 Parsed _isVendorOnline: $_isVendorOnline');
      debugPrint(
        '🕒 Business hours: ${_vendorStartTime ?? 'null'} to ${_vendorCloseTime ?? 'null'}',
      );
      debugPrint(
        '🕒 Advance booking hours: ${vendor?.advanceBookingHours ?? 'null'}',
      );
      debugPrint('🕒 ===============================');

      // Note: Now using exact booking notice parsing directly in time slot generation

      // Force state update and rebuild time slots
      setState(() {});

      // Validate selected values after vendor data is loaded
      _validateSelectedValues();

      _rebuildTimeSlotsForSelectedDate();
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to load vendor/time slots: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      setState(() {
        timeSlots = [];
      });
    }
  }

  Future<List<String>> _getExistingBookings(
    String serviceId,
    DateTime date,
  ) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      debugPrint(
        '🔍 Fetching existing bookings for service $serviceId on $formattedDate',
      );

      final repo = ref.read(homeRepositoryProvider);
      final result = await repo.getExistingBookings(serviceId, formattedDate);

      debugPrint('🔍 Found ${result.length} existing bookings: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Error fetching existing bookings: $e');
      return [];
    }
  }

  void _rebuildTimeSlotsForSelectedDate() async {
    debugPrint('🕒 _rebuildTimeSlotsForSelectedDate called');
    debugPrint('🕒 Vendor online: $_isVendorOnline');
    debugPrint(
      '🕒 Start time: $_vendorStartTime, Close time: $_vendorCloseTime',
    );
    debugPrint('🕒 Selected date: $selectedDate');

    // If vendor is offline, do not show time slots
    if (!_isVendorOnline) {
      debugPrint('🕒 Vendor is offline, clearing time slots');
      setState(() {
        timeSlots = [];
      });
      return;
    }

    // Require vendor business hours
    if (_vendorStartTime == null || _vendorCloseTime == null) {
      debugPrint('🕒 Vendor has no business hours set, clearing time slots');
      setState(() {
        timeSlots = [];
      });
      return;
    }

    // Parse selected date
    DateTime? date;
    try {
      if (selectedDate != 'Select Date') {
        final parts = selectedDate.split('/'); // dd/MM/yyyy
        date = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
        debugPrint(
          '🕒 Parsed selected date: ${DateFormat('yyyy-MM-dd').format(date)}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error parsing selected date: $e');
    }

    if (date == null) {
      debugPrint('🕒 Using current date as fallback');
      date = DateTime.now();
    }

    // Check if the selected date is today
    final today = DateTime.now();
    final isToday =
        DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(today);
    debugPrint('🕒 Selected date is today: $isToday');

    // Build DateTime for start and end using vendor hours (HH:mm)
    DateTime? startDateTime = _combineDateWithHm(date, _vendorStartTime!);
    DateTime? endDateTime = _combineDateWithHm(date, _vendorCloseTime!);
    if (startDateTime == null || endDateTime == null) {
      setState(() {
        timeSlots = [];
      });
      return;
    }

    // Respect exact booking notice time relative to now
    final now = DateTime.now();
    final exactBookingNoticeHours = _parseBookingNoticeToHours(
      widget.service.bookingNotice,
    );
    debugPrint(
      '🕒 Local current time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}',
    );
    debugPrint('🕒 Local timezone: ${now.timeZoneName}');
    debugPrint('🕒 Is UTC: ${now.timeZoneOffset == Duration.zero}');
    debugPrint('🕒 Exact booking notice: $exactBookingNoticeHours hours');
    final minStart = now.add(Duration(hours: exactBookingNoticeHours));
    if (minStart.isAfter(DateTime(date.year, date.month, date.day, 23, 59))) {
      // If viewing today and minStart pushes booking to future day, shift to next day business hours
      final nextDay = DateTime(
        date.year,
        date.month,
        date.day,
      ).add(const Duration(days: 1));
      startDateTime = _combineDateWithHm(nextDay, _vendorStartTime!);
      endDateTime = _combineDateWithHm(nextDay, _vendorCloseTime!);
      if (startDateTime == null || endDateTime == null) {
        setState(() {
          timeSlots = [];
        });
        return;
      }
    } else if (minStart.isAfter(startDateTime)) {
      // Use the exact minStart time (preserve hours AND minutes) but round up to nearest hour for time slots
      startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        minStart.minute > 0
            ? minStart.hour + 1
            : minStart.hour, // Round up to next hour if there are minutes
        0,
      );
      debugPrint(
        '🕒 Booking notice time: ${DateFormat('HH:mm').format(minStart)}',
      );
      debugPrint(
        '🕒 Rounded start time for slots: ${DateFormat('HH:mm').format(startDateTime)}',
      );
    }

    // Ensure start < end
    final sdt = startDateTime;
    final edt = endDateTime;
    if (!(sdt.isBefore(edt))) {
      setState(() {
        timeSlots = [];
      });
      return;
    }

    // Fetch existing bookings for this service and date
    final existingBookings = await _getExistingBookings(
      widget.service.id,
      date,
    );
    debugPrint('🔒 Existing bookings to exclude: $existingBookings');

    // Generate hourly start times between startDateTime and endDateTime (inclusive of start, exclusive of end)
    final slots = <String>[];
    final formatter = DateFormat('hh:mm a');
    DateTime cursor = DateTime(sdt.year, sdt.month, sdt.day, sdt.hour, 0);
    debugPrint(
      '🕒 Generating time slots from ${formatter.format(sdt)} to ${formatter.format(edt)}',
    );
    debugPrint('🕒 Current time: ${formatter.format(now)}');
    debugPrint('🕒 Selected date string: $selectedDate');
    debugPrint('🕒 Parsed date: $date');
    debugPrint(
      '🕒 Is today: ${DateFormat('dd/MM/yyyy').format(DateTime.now()) == selectedDate}',
    );
    debugPrint(
      '🕒 Start DateTime: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(sdt)}',
    );
    debugPrint(
      '🕒 End DateTime: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(edt)}',
    );

    while (cursor.isBefore(edt)) {
      final timeSlot = formatter.format(cursor);

      // Check if this time slot is available
      bool isCurrentTimeValid = true; // Default to true for future dates

      // Apply exact booking notice restrictions for all dates
      final bookingNoticeTime = now.add(
        Duration(hours: exactBookingNoticeHours),
      );
      isCurrentTimeValid =
          cursor.isAfter(bookingNoticeTime) ||
          cursor.isAtSameMomentAs(bookingNoticeTime);

      // Debug logging for time slot validation
      if (isToday) {
        debugPrint('🔍 Checking slot for TODAY: $timeSlot');
      } else {
        debugPrint('🔍 Checking slot for FUTURE DATE: $timeSlot');
      }
      debugPrint(
        '  - Current time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}',
      );
      debugPrint(
        '  - Cursor time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(cursor)}',
      );
      debugPrint(
        '  - Booking notice deadline: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(bookingNoticeTime)}',
      );
      debugPrint('  - Is after booking notice: $isCurrentTimeValid');

      final isNotBooked = !existingBookings.contains(
        timeSlot,
      ); // Not already booked
      debugPrint('  - Is not booked: $isNotBooked');

      if (isCurrentTimeValid && isNotBooked) {
        slots.add(timeSlot);
        debugPrint('🕒 Added available time slot: $timeSlot');
      } else {
        if (!isCurrentTimeValid) {
          debugPrint('🕒 Skipped time slot (too soon): $timeSlot');
        }
        if (!isNotBooked) {
          debugPrint('🔒 Skipped booked time slot: $timeSlot');
        }
      }
      cursor = cursor.add(const Duration(hours: 1));
    }

    debugPrint('🕒 Generated ${slots.length} available time slots: $slots');
    setState(() {
      timeSlots = slots;
      if (!timeSlots.contains(selectedTime)) {
        selectedTime = '';
      }
    });
  }

  DateTime? _combineDateWithHm(DateTime date, String hm) {
    try {
      final parts = hm.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      // Handle both HH:mm and HH:mm:ss formats from database
      return DateTime(date.year, date.month, date.day, h, m);
    } catch (e) {
      debugPrint('❌ Error parsing time format "$hm": $e');
      return null;
    }
  }

  Future<void> _loadUserProfileAndSetDate() async {
    try {
      // Load user profile to get celebration date
      final userProfile = await ref.read(currentUserProfileProvider.future);

      if (userProfile?.celebrationDate != null && mounted) {
        final celebrationDate = userProfile!.celebrationDate!;
        final formattedCelebrationDate = DateFormat(
          'dd/MM/yyyy',
        ).format(celebrationDate);
        final availableDates = await _getAvailableDatesWithVendorBlocking();

        // Auto-select celebration date if it exists in available dates
        if (availableDates.contains(formattedCelebrationDate)) {
          setState(() {
            selectedDate = formattedCelebrationDate;
          });
          debugPrint('🎉 Auto-selected user celebration date: $selectedDate');
        } else {
          debugPrint(
            '🎉 User celebration date $formattedCelebrationDate not in available dates, keeping default',
          );
        }

        // Auto-select celebration time if available
        if (userProfile.celebrationTime != null) {
          final celebrationTime = userProfile.celebrationTime!;
          // Parse celebration time string (assuming format like "14:30" or "02:30 PM")
          try {
            DateTime timeOfDay;
            if (celebrationTime.contains('AM') ||
                celebrationTime.contains('PM')) {
              // Handle 12-hour format
              timeOfDay = DateFormat('hh:mm a').parse(celebrationTime);
            } else {
              // Handle 24-hour format
              final timeParts = celebrationTime.split(':');
              timeOfDay = DateTime(
                2000,
                1,
                1,
                int.parse(timeParts[0]),
                int.parse(timeParts[1]),
              );
            }

            // Find matching time slot based on celebration time
            final celebrationHour = timeOfDay.hour;
            String? matchingTimeSlot;

            for (final slot in timeSlots) {
              final slotParts = slot.split(' ');
              if (slotParts.length >= 2) {
                final timeStr = '${slotParts[0]} ${slotParts[1]}';
                try {
                  final slotTime = DateFormat('hh:mm a').parse(timeStr);
                  if (slotTime.hour == celebrationHour) {
                    matchingTimeSlot = slot;
                    break;
                  }
                } catch (_) {}
              }
            }

            if (matchingTimeSlot != null && mounted) {
              setState(() {
                selectedTime = matchingTimeSlot!;
              });
              debugPrint(
                '🎉 Auto-selected user celebration time: $selectedTime',
              );
            }
          } catch (e) {
            debugPrint('Error parsing celebration time: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile for auto-date selection: $e');
    }
  }

  Future<void> _loadWelcomePreferences() async {
    try {
      final welcomeService = ref.read(welcomePreferencesServiceProvider);

      // Load saved celebration date and time (only if not already set from user profile)
      if (selectedDate == 'Select Date') {
        final savedDate = await welcomeService.getCelebrationDate();
        if (savedDate != null && mounted) {
          final formattedSavedDate = DateFormat('dd/MM/yyyy').format(savedDate);
          final availableDates = await _getAvailableDatesWithVendorBlocking();

          // Only set the saved date if it exists in the available dates
          if (availableDates.contains(formattedSavedDate)) {
            setState(() {
              selectedDate = formattedSavedDate;
            });
            debugPrint('🎯 Loaded saved celebration date: $selectedDate');
          } else {
            debugPrint(
              '🎯 Saved date $formattedSavedDate not in available dates, keeping default',
            );
          }
        }
      }

      if (selectedTime.isEmpty) {
        final savedTime = await welcomeService.getCelebrationTime();
        if (savedTime != null && mounted) {
          // Find the closest time slot that matches the saved time
          final savedHour = savedTime.hour;
          String? matchingTimeSlot;

          for (final slot in timeSlots) {
            try {
              final slotTime = DateFormat('hh:mm a').parse(slot);
              if (slotTime.hour == savedHour) {
                matchingTimeSlot = slot;
                break;
              }
            } catch (_) {}
          }

          if (matchingTimeSlot != null) {
            setState(() {
              selectedTime = matchingTimeSlot!;
            });
            debugPrint(
              '🎯 Loaded saved celebration time: $selectedTime (from ${savedTime.hour}:${savedTime.minute})',
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading welcome preferences: $e');
    }
  }

  @override
  void dispose() {
    commentsController.dispose();
    bannerTextController.dispose();
    customerNameController.dispose();
    customerAgeController.dispose();
    occasionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Book Service',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Okra',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Info Section
            _buildServiceInfoCard(),
            const SizedBox(height: 24),

            // Venue Type Section
            _buildSectionTitle('Venue type'),
            const SizedBox(height: 12),
            ...venueTypes.map(
              (venue) => _buildRadioOption(
                venue,
                selectedVenueType,
                (value) => setState(() => selectedVenueType = value),
              ),
            ),
            const SizedBox(height: 24),

            // Service Environment Section (if available)
            if (serviceEnvironments.isNotEmpty) ...[
              _buildSectionTitle('Service environment'),
              const SizedBox(height: 12),
              ...serviceEnvironments.map(
                (env) => _buildRadioOption(
                  env,
                  selectedEnvironment,
                  (value) => setState(() => selectedEnvironment = value),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Add-ons Section (if available)
            if (availableAddOns.isNotEmpty) ...[
              _buildSectionTitle('Add-ons (optional)'),
              const SizedBox(height: 12),
              _buildAddOnsSection(),
              const SizedBox(height: 24),
            ],

            // Date Section
            _buildSectionTitle('Select Date'),
            const SizedBox(height: 12),
            _buildDateSelection(),
            const SizedBox(height: 24),

            // Time Slot Section
            _buildSectionTitle('Select Time Slot'),
            const SizedBox(height: 12),
            _buildTimeSlotSelection(),
            const SizedBox(height: 24),

            // Inclusions Section (if available)
            if (widget.service.inclusions?.isNotEmpty == true) ...[
              _buildSectionTitle('What\'s included'),
              const SizedBox(height: 12),
              _buildInclusionsSection(),
              const SizedBox(height: 24),
            ],

            // Exclusions Section (if available)
            if (widget.service.exclusions?.isNotEmpty == true) ...[
              _buildSectionTitle('What\'s not included'),
              const SizedBox(height: 12),
              _buildExclusionsSection(),
              const SizedBox(height: 24),
            ],

            // Banner Section (if service provides banner)
            if (widget.service.providesBanner == true) ...[
              _buildSectionTitle('Banner Details'),
              const SizedBox(height: 8),
              Text(
                'Upload a banner image and provide text for your celebration',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 12),
              _buildBannerSection(),
              const SizedBox(height: 24),
            ],

            // Customer Info Section
            _buildSectionTitle('Booking Details'),
            const SizedBox(height: 12),
            _buildCustomerInfoSection(),
            const SizedBox(height: 24),

            // Place Image Upload Section
            _buildSectionTitle('Upload place image (optional)'),
            const SizedBox(height: 8),
            Text(
              'Help us understand your decoration requirements by uploading an image of the place',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 12),
            _buildImageUploadSection(),
            const SizedBox(height: 120), // Space for bottom button
          ],
        ),
      ),
      // Continue Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _validateAndContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceInfoCard() {
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
              Icon(Icons.info_outline, size: 20, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Service Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          if (widget.service.setupTime?.isNotEmpty == true ||
              widget.service.bookingNotice?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            if (widget.service.setupTime?.isNotEmpty == true)
              _buildInfoRow('Setup Time', widget.service.setupTime!),
            if (widget.service.bookingNotice?.isNotEmpty == true)
              _buildInfoRow('Advance Booking', widget.service.bookingNotice!),
          ],
          if (widget.service.customizationAvailable == true) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Customization available',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOnsSection() {
    return Column(
      children: availableAddOns.map((addon) {
        final addonName = addon['name']?.toString() ?? 'Add-on';
        final addonPrice = addon['price']?.toString() ?? '';
        final isSelected = selectedAddOns.contains(addonName);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedAddOns.remove(addonName);
              } else {
                selectedAddOns.add(addonName);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    addonName,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Okra',
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (addonPrice.isNotEmpty)
                  Text(
                    '+₹$addonPrice',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateSelection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getDatessWithAvailabilityStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 60,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          debugPrint('❌ Error loading dates with availability: ${snapshot.error}');
          return SizedBox(
            height: 60,
            child: Center(
              child: Text(
                'Error loading dates',
                style: TextStyle(color: Colors.red[600], fontFamily: 'Okra'),
              ),
            ),
          );
        }

        final datesWithStatus = snapshot.data ?? [];

        if (datesWithStatus.isEmpty) {
          return Container(
            height: 60,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[300]!),
            ),
            child: Center(
              child: Text(
                'No dates available for this service',
                style: TextStyle(
                  color: Colors.orange[600],
                  fontFamily: 'Okra',
                  fontSize: 14,
                ),
              ),
            ),
          );
        }

        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: datesWithStatus.length,
            itemBuilder: (context, index) {
              final dateInfo = datesWithStatus[index];
              final dateStr = dateInfo['date'] as String;
              final isAvailable = dateInfo['isAvailable'] as bool;
              final blockReason = dateInfo['blockReason'] as String?;
              final isSelected = selectedDate == dateStr;

              // Parse date for display
              final parts = dateStr.split('/');
              final date = DateTime(
                int.parse(parts[2]),
                int.parse(parts[1]),
                int.parse(parts[0]),
              );

              return Container(
                margin: EdgeInsets.only(
                  right: index < datesWithStatus.length - 1 ? 12 : 0,
                ),
                child: Tooltip(
                  message: isAvailable 
                      ? 'Available for booking'
                      : blockReason ?? 'Not available',
                  child: InkWell(
                    onTap: isAvailable ? () {
                      setState(() {
                        selectedDate = dateStr;
                      });
                      _rebuildTimeSlotsForSelectedDate();
                    } : null, // No onTap for blocked dates
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isAvailable 
                            ? Colors.grey[200] // Greyed out for blocked dates
                            : isSelected 
                                ? AppTheme.primaryColor 
                                : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: !isAvailable 
                              ? Colors.grey[400]! // Grey border for blocked dates
                              : isSelected 
                                  ? AppTheme.primaryColor 
                                  : Colors.grey[300]!,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('dd').format(date),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !isAvailable 
                                      ? Colors.grey[500] // Greyed out text for blocked dates
                                      : isSelected 
                                          ? Colors.white 
                                          : Colors.black87,
                                  fontFamily: 'Okra',
                                ),
                              ),
                              Text(
                                DateFormat('MMM').format(date),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: !isAvailable 
                                      ? Colors.grey[500] // Greyed out text for blocked dates
                                      : isSelected 
                                          ? Colors.white 
                                          : Colors.grey[600],
                                  fontFamily: 'Okra',
                                ),
                              ),
                            ],
                          ),
                          // Block indicator for unavailable dates
                          if (!isAvailable)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.red[400],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.block,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Categorize time slots by time of day
  Map<String, List<String>> _categorizeTimeSlots() {
    final categories = {
      'Morning': <String>[],
      'Afternoon': <String>[],
      'Evening': <String>[],
      'Night': <String>[],
    };

    for (final timeSlot in timeSlots) {
      try {
        final dateTime = DateFormat('hh:mm a').parse(timeSlot);
        final hour = dateTime.hour;

        if (hour >= 6 && hour < 12) {
          categories['Morning']!.add(timeSlot);
        } else if (hour >= 12 && hour < 16) {
          categories['Afternoon']!.add(timeSlot);
        } else if (hour >= 16 && hour < 20) {
          categories['Evening']!.add(timeSlot);
        } else {
          categories['Night']!.add(timeSlot);
        }
      } catch (e) {
        // If parsing fails, add to a default category
        categories['Morning']!.add(timeSlot);
      }
    }

    // Remove empty categories
    categories.removeWhere((key, value) => value.isEmpty);
    return categories;
  }

  Widget _buildTimeSlotChip(String timeSlot) {
    final isSelected = selectedTime == timeSlot;

    return InkWell(
      onTap: () {
        setState(() {
          selectedTime = timeSlot;
        });
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeSlot,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
                fontFamily: 'Okra',
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(Icons.check_circle, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotCategory(String title, List<String> slots) {
    if (slots.isEmpty) return const SizedBox.shrink();

    IconData getIcon() {
      switch (title) {
        case 'Morning':
          return Icons.wb_sunny;
        case 'Afternoon':
          return Icons.wb_cloudy;
        case 'Evening':
          return Icons.wb_twighlight;
        case 'Night':
          return Icons.nights_stay;
        default:
          return Icons.schedule;
      }
    }

    Color getColor() {
      switch (title) {
        case 'Morning':
          return Colors.orange[400]!;
        case 'Afternoon':
          return Colors.blue[400]!;
        case 'Evening':
          return Colors.deepOrange[400]!;
        case 'Night':
          return Colors.indigo[400]!;
        default:
          return Colors.grey[400]!;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(getIcon(), size: 20, color: getColor()),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: getColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${slots.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: getColor(),
                  fontFamily: 'Okra',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots
              .map((timeSlot) => _buildTimeSlotChip(timeSlot))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    if (!_isVendorOnline) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.offline_bolt, color: Colors.red[600], size: 20),
            const SizedBox(width: 8),
            Text(
              'Vendor is currently offline',
              style: TextStyle(
                color: Colors.red[600],
                fontFamily: 'Okra',
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (timeSlots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule, color: Colors.orange[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedDate == 'Select Date'
                    ? 'Please select a date first'
                    : 'No available time slots for selected date',
                style: TextStyle(
                  color: Colors.orange[600],
                  fontFamily: 'Okra',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final categorizedSlots = _categorizeTimeSlots();

    return Column(
      children: categorizedSlots.entries.map((entry) {
        return Column(
          children: [
            _buildTimeSlotCategory(entry.key, entry.value),
            if (entry != categorizedSlots.entries.last)
              const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildInclusionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.service.inclusions!.map((inclusion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    inclusion,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Okra',
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExclusionsSection() {
    if (widget.service.exclusions == null ||
        widget.service.exclusions!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.service.exclusions!.map((exclusion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.cancel, size: 16, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    exclusion,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Okra',
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCustomerInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Field
        Text(
          'Name *',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: customerNameController,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'Okra'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          style: const TextStyle(fontFamily: 'Okra', fontSize: 14),
        ),
        const SizedBox(height: 16),

        // Age Field
        Text(
          'Age *',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: customerAgeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter your age',
            hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'Okra'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          style: const TextStyle(fontFamily: 'Okra', fontSize: 14),
        ),
        const SizedBox(height: 16),

        // Occasion Field
        Text(
          'Occasion *',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: occasionController,
          decoration: InputDecoration(
            hintText: 'e.g., Birthday, Anniversary, Wedding',
            hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'Okra'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          style: const TextStyle(fontFamily: 'Okra', fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          'This helps us prepare the perfect setup for your celebration',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontFamily: 'Okra',
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Okra',
        color: Colors.black87,
      ),
    );
  }

  Widget _buildRadioOption(
    String option,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(option),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedValue == option
                      ? AppTheme.primaryColor
                      : Colors.grey[400]!,
                  width: 2,
                ),
                color: selectedValue == option
                    ? AppTheme.primaryColor
                    : Colors.transparent,
              ),
              child: selectedValue == option
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              option,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Okra',
                color: selectedValue == option
                    ? AppTheme.primaryColor
                    : Colors.black87,
                fontWeight: selectedValue == option
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get available dates considering vendor blocking logic and one-order-per-day restriction
  List<String> _getAvailableDates() {
    final now = DateTime.now();

    // Parse booking notice from service data (e.g., "2 days", "1 day", "6 hours")
    final int advanceBookingHours = _parseBookingNoticeToHours(
      widget.service.bookingNotice,
    );
    debugPrint(
      '📋 Service booking notice: ${widget.service.bookingNotice} -> $advanceBookingHours hours advance required',
    );

    // Calculate the earliest date available for booking based on exact booking notice hours
    final earliestBookingDateTime = now.add(
      Duration(hours: advanceBookingHours),
    );
    final earliestBookingDate = DateTime(
      earliestBookingDateTime.year,
      earliestBookingDateTime.month,
      earliestBookingDateTime.day,
    );

    debugPrint(
      '🕐 Current time: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}',
    );
    debugPrint(
      '📅 Earliest booking time (after $advanceBookingHours hours notice): ${DateFormat('dd/MM/yyyy HH:mm').format(earliestBookingDateTime)}',
    );
    debugPrint(
      '📅 Earliest booking date: ${DateFormat('dd/MM/yyyy').format(earliestBookingDate)}',
    );

    // Generate initial list of 15 dates from earliest booking date
    final List<String> potentialDates = List.generate(15, (index) {
      final date = earliestBookingDate.add(Duration(days: index));
      return '${date.day}/${date.month}/${date.year}';
    });

    debugPrint(
      '🗓️ Generated ${potentialDates.length} potential dates from ${DateFormat('dd/MM/yyyy').format(earliestBookingDate)}',
    );
    return potentialDates;
  }

  /// Get all dates with their availability status (available/blocked)
  Future<List<Map<String, dynamic>>> _getDatessWithAvailabilityStatus() async {
    if (widget.service.vendorId == null) {
      debugPrint(
        '⚠️ No vendor ID available, returning basic date list with all available status',
      );
      final dates = _getAvailableDates();
      return dates
          .map(
            (dateStr) => {
              'date': dateStr,
              'isAvailable': true,
              'blockReason': null,
            },
          )
          .toList();
    }

    try {
      // Get vendor blocked dates
      final repo = ref.read(homeRepositoryProvider);
      final blockedDates = await repo.getVendorBlockedDates(
        widget.service.vendorId!,
      );

      // Get initial available dates
      final potentialDates = _getAvailableDates();
      final datesWithStatus = <Map<String, dynamic>>[];

      for (final dateStr in potentialDates) {
        // Parse date string
        final parts = dateStr.split('/');
        final date = DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );

        // Check if this date is blocked
        final isBlocked = blockedDates.any(
          (blockedDate) =>
              DateFormat('yyyy-MM-dd').format(blockedDate) ==
              DateFormat('yyyy-MM-dd').format(date),
        );

        datesWithStatus.add({
          'date': dateStr,
          'isAvailable': !isBlocked,
          'blockReason': isBlocked ? 'Vendor booking conflict' : null,
        });

        if (!isBlocked) {
          debugPrint('✅ Date available: $dateStr');
        } else {
          debugPrint('🚫 Date blocked: $dateStr (Vendor booking conflict)');
        }
      }

      final availableCount = datesWithStatus
          .where((d) => d['isAvailable'] == true)
          .length;
      debugPrint(
        '📅 Date status: $availableCount/${potentialDates.length} available, ${potentialDates.length - availableCount} blocked',
      );
      return datesWithStatus;
    } catch (e) {
      debugPrint('❌ Error getting vendor blocking info: $e');
      // Fallback to basic date list with all available status
      final dates = _getAvailableDates();
      return dates
          .map(
            (dateStr) => {
              'date': dateStr,
              'isAvailable': true,
              'blockReason': null,
            },
          )
          .toList();
    }
  }

  /// Get vendor blocked dates and filter available dates (backward compatibility)
  Future<List<String>> _getAvailableDatesWithVendorBlocking() async {
    final datesWithStatus = await _getDatessWithAvailabilityStatus();
    return datesWithStatus
        .where((dateInfo) => dateInfo['isAvailable'] == true)
        .map((dateInfo) => dateInfo['date'] as String)
        .toList();
  }

  /// Parse booking notice string to hours (for exact time calculation)
  int _parseBookingNoticeToHours(String? bookingNotice) {
    if (bookingNotice == null || bookingNotice.isEmpty) {
      debugPrint('📋 No booking notice specified, defaulting to 0 hours');
      return 0; // No advance booking required
    }

    final lowerCaseNotice = bookingNotice.toLowerCase().trim();

    // Extract numbers from the string
    final RegExp numberRegex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = numberRegex.firstMatch(lowerCaseNotice);

    if (match == null) {
      debugPrint(
        '📋 Could not parse booking notice: $bookingNotice, defaulting to 0 hours',
      );
      return 0;
    }

    final double number = double.tryParse(match.group(1)!) ?? 0;

    // Convert based on time unit to hours
    if (lowerCaseNotice.contains('day')) {
      final hours = (number * 24).round();
      debugPrint('📋 Parsed booking notice: $number days -> $hours hours');
      return hours;
    } else if (lowerCaseNotice.contains('hour')) {
      debugPrint('📋 Parsed booking notice: $number hours');
      return number.round();
    } else if (lowerCaseNotice.contains('week')) {
      final hours = (number * 7 * 24).round();
      debugPrint('📋 Parsed booking notice: $number weeks -> $hours hours');
      return hours;
    }

    // Default assumption: if no unit specified, assume days and convert to hours
    final hours = (number * 24).round();
    debugPrint(
      '📋 Parsed booking notice (assuming days): $number days -> $hours hours',
    );
    return hours;
  }

  Widget _buildImageUploadSection() {
    return Container(
      child: selectedPlaceImage != null
          ? _buildSelectedImageWidget()
          : _buildImageSelectionWidget(),
    );
  }

  Widget _buildImageSelectionWidget() {
    return GestureDetector(
      onTap: isUploadingImage ? null : _selectImage,
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: Colors.grey[400]!,
          strokeWidth: 1.5,
          dashPattern: const [6, 3], // Dotted line style
        ),
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: Center(
            child: isUploadingImage
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(strokeWidth: 2.5),
                      SizedBox(height: 10),
                      Text(
                        'Processing image...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Upload an image',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[700],
                          fontFamily: 'Okra',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Supported: JPG, PNG (max 10MB)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImageWidget() {
    return Container(
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(selectedPlaceImage!.path),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPlaceImage = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'Image selected',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectImage() async {
    try {
      setState(() {
        isUploadingImage = true;
      });

      // Show image source selection dialog
      final ImageSource? source = await _imageUploadService
          .showImageSourceDialog(context);
      if (source == null) {
        setState(() {
          isUploadingImage = false;
        });
        return;
      }

      // Pick image
      final XFile? pickedImage = await _imageUploadService.pickImage(
        source: source,
      );
      if (pickedImage == null) {
        setState(() {
          isUploadingImage = false;
        });
        return;
      }

      // Validate image
      if (!_imageUploadService.validateImageFile(pickedImage)) {
        setState(() {
          isUploadingImage = false;
        });
        _showError('Please select a valid image file (JPG, PNG, WebP)');
        return;
      }

      setState(() {
        selectedPlaceImage = pickedImage;
        isUploadingImage = false;
      });

      debugPrint('✅ Image selected: ${pickedImage.path}');
    } catch (e) {
      setState(() {
        isUploadingImage = false;
      });
      debugPrint('❌ Error selecting image: $e');
      _showError('Failed to select image. Please try again.');
    }
  }

  // Banner image selection
  Future<void> _selectBannerImage() async {
    try {
      setState(() {
        isUploadingBannerImage = true;
      });

      // Show image source selection dialog
      final ImageSource? source = await _imageUploadService
          .showImageSourceDialog(context);
      if (source == null) {
        setState(() {
          isUploadingBannerImage = false;
        });
        return;
      }

      // Pick image
      final XFile? pickedImage = await _imageUploadService.pickImage(
        source: source,
      );
      if (pickedImage == null) {
        setState(() {
          isUploadingBannerImage = false;
        });
        return;
      }

      // Validate image
      if (!_imageUploadService.validateImageFile(pickedImage)) {
        setState(() {
          isUploadingBannerImage = false;
        });
        _showError('Please select a valid image file (JPG, PNG, WebP)');
        return;
      }

      setState(() {
        selectedBannerImage = pickedImage;
        isUploadingBannerImage = false;
      });

      debugPrint('✅ Banner image selected: ${pickedImage.path}');
    } catch (e) {
      setState(() {
        isUploadingBannerImage = false;
      });
      debugPrint('❌ Error selecting banner image: $e');
      _showError('Failed to select banner image. Please try again.');
    }
  }

  Widget _buildBannerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner Image Upload
        Text(
          'Banner Image',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          child: selectedBannerImage != null
              ? _buildSelectedBannerImageWidget()
              : _buildBannerImageSelectionWidget(),
        ),
        const SizedBox(height: 16),

        // Banner Text Input
        Text(
          'Banner Text',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: bannerTextController,
          maxLines: 3,
          maxLength: 200,
          decoration: InputDecoration(
            hintText:
                'Enter text for your banner (e.g., "Happy Birthday John!")',
            hintStyle: TextStyle(color: Colors.grey[400], fontFamily: 'Okra'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          style: const TextStyle(fontFamily: 'Okra', fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          'This text will appear on your celebration banner',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontFamily: 'Okra',
          ),
        ),
      ],
    );
  }

  Widget _buildBannerImageSelectionWidget() {
    return GestureDetector(
      onTap: isUploadingBannerImage ? null : _selectBannerImage,
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: AppTheme.primaryColor.withOpacity(0.5),
          strokeWidth: 1.5,
          dashPattern: const [6, 3],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 120,
          child: Center(
            child: isUploadingBannerImage
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(strokeWidth: 2.5),
                      SizedBox(height: 8),
                      Text(
                        'Processing banner image...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 32,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload Banner Image',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                          fontFamily: 'Okra',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'JPG, PNG (max 10MB)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedBannerImageWidget() {
    return Container(
      height: 120,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(selectedBannerImage!.path),
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedBannerImage = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 12),
                  const SizedBox(width: 4),
                  const Text(
                    'Banner selected',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndContinue() {
    // Validate venue type selection
    if (selectedVenueType == 'Option') {
      _showError('Please select a venue type');
      return;
    }

    // Validate service environment if available
    if (serviceEnvironments.isNotEmpty && selectedEnvironment == 'Option') {
      _showError('Please select a service environment');
      return;
    }

    // Validate date selection
    if (selectedDate == 'Select Date') {
      _showError('Please select a date');
      return;
    }

    // Validate time selection
    if (selectedTime.isEmpty) {
      _showError('Please select a time slot');
      return;
    }

    // Validate banner fields if service provides banner
    if (widget.service.providesBanner == true) {
      if (selectedBannerImage == null) {
        _showError('Please upload a banner image');
        return;
      }
      if (bannerTextController.text.trim().isEmpty) {
        _showError('Please enter banner text');
        return;
      }
    }

    // Validate customer info fields
    if (customerNameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return;
    }
    if (customerAgeController.text.trim().isEmpty) {
      _showError('Please enter your age');
      return;
    }
    if (occasionController.text.trim().isEmpty) {
      _showError('Please enter the occasion');
      return;
    }

    // Validate age is a valid number
    final age = int.tryParse(customerAgeController.text.trim());
    if (age == null || age <= 0 || age > 120) {
      _showError('Please enter a valid age');
      return;
    }

    // Validate service essential fields
    if (widget.service.id.isEmpty) {
      debugPrint('❌ Service ID is empty');
      _showError('Invalid service. Please try again.');
      return;
    }

    if (widget.service.name.isEmpty) {
      debugPrint('❌ Service name is empty');
      _showError('Service information incomplete. Please try again.');
      return;
    }

    // Check pricing information
    if (widget.service.originalPrice == null &&
        widget.service.offerPrice == null) {
      debugPrint('⚠️ Service has no pricing information');
    }

    // Create comprehensive customization data
    final customizationData = {
      'venueType': selectedVenueType,
      'serviceEnvironment': serviceEnvironments.isNotEmpty
          ? selectedEnvironment
          : null,
      'date': selectedDate,
      'time': selectedTime,
      'addOns': selectedAddOns,
      'comments': commentsController.text.trim(),
      'setupTime': widget.service.setupTime,
      'bookingNotice': widget.service.bookingNotice,
      'placeImage': selectedPlaceImage, // Add the selected image
      'bannerImage': selectedBannerImage, // Add the selected banner image
      'bannerText': bannerTextController.text.trim(), // Add the banner text
      // Customer info
      'customerName': customerNameController.text.trim(),
      'customerAge': int.tryParse(customerAgeController.text.trim()) ?? 0,
      'occasion': occasionController.text.trim(),
    };

    debugPrint('✅ Navigating to checkout with enhanced data:');
    debugPrint('  - Service: ${widget.service.name} (${widget.service.id})');
    debugPrint('  - Venue: $selectedVenueType');
    debugPrint('  - Environment: $selectedEnvironment');
    debugPrint('  - Date & Time: $selectedDate at $selectedTime');
    debugPrint('  - Simple Add-ons: $selectedAddOns');
    debugPrint('  - Complex Add-ons: ${widget.addedAddons.keys.toList()}');
    debugPrint(
      '  - Comments: ${commentsController.text.isNotEmpty ? "Added" : "None"}',
    );
    debugPrint(
      '  - Place Image: ${selectedPlaceImage != null ? "Selected" : "None"}',
    );
    debugPrint(
      '  - Banner Image: ${selectedBannerImage != null ? "Selected" : "None"}',
    );
    debugPrint(
      '  - Banner Text: ${bannerTextController.text.isNotEmpty ? "\"${bannerTextController.text.trim()}\"" : "None"}',
    );
    debugPrint('  - Customer Name: ${customerNameController.text.trim()}');
    debugPrint('  - Customer Age: ${customerAgeController.text.trim()}');
    debugPrint('  - Occasion: ${occasionController.text.trim()}');

    try {
      // Combine both types of add-ons for checkout
      final combinedAddOns = <String, Map<String, dynamic>>{};

      // Add complex customizable add-ons from main screen
      combinedAddOns.addAll(widget.addedAddons);

      // Add simple add-ons from customization screen
      for (int i = 0; i < selectedAddOns.length; i++) {
        final addonName = selectedAddOns[i];
        final addonId =
            'simple_addon_$i'; // Generate unique ID for simple add-ons

        // Find the add-on details from service data
        final addonDetails = availableAddOns.firstWhere(
          (addon) => addon['name'] == addonName,
          orElse: () => <String, dynamic>{},
        );

        final addonPrice =
            double.tryParse(addonDetails['price']?.toString() ?? '0') ?? 0.0;

        combinedAddOns[addonId] = {
          'name': addonName,
          'price': addonPrice,
          'totalPrice': addonPrice,
          'characterCount': 1, // Default for simple add-ons
          'customText': '', // No customization for simple add-ons
          'isCustomizable': false,
        };
      }

      debugPrint(
        '  - Combined Add-ons for checkout: ${combinedAddOns.keys.toList()}',
      );
      debugPrint('  - Total add-ons count: ${combinedAddOns.length}');

      // Navigate to checkout with enhanced data including separate date and time parameters
      context.push(
        CheckoutScreen.routeName,
        extra: {
          'service': widget.service,
          'customization': customizationData,
          'selectedDate': selectedDate,
          'selectedTimeSlot':
              null, // Theater time slots not used for regular services
          'selectedScreen': null,
          'selectedAddressId': null,
          'selectedAddOns': combinedAddOns.isNotEmpty ? combinedAddOns : null,
        },
      );
    } catch (e) {
      debugPrint('❌ Navigation error: $e');
      _showError('Unable to proceed to checkout. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
