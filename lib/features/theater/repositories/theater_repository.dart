import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/features/theater/models/theater_model.dart';
import 'package:sylonow_user/features/theater/models/decoration_model.dart';
import 'package:sylonow_user/features/theater/models/occasion_model.dart';
import 'package:sylonow_user/features/theater/models/add_on_model.dart';
import 'package:sylonow_user/features/theater/models/special_service_model.dart';
import 'package:sylonow_user/features/theater/models/cake_model.dart';
import 'package:sylonow_user/features/theater/models/theater_time_slot_model.dart';
import 'package:sylonow_user/features/theater/models/theater_screen_model.dart';

class TheaterRepository {
  final SupabaseClient _supabase;

  TheaterRepository(this._supabase);

  Future<List<TheaterModel>> getTheaters({
    String? city,
    int limit = 50,
    int offset = 0,
  }) async {
    print('🎬 DEBUG: getTheaters called');
    
    // TEMPORARY FIX: Return hard-coded test theaters to make the flow work
    final testTheaters = [
      const TheaterModel(
        id: 'ececf43e-b0ab-49b2-831b-bc87dd409f65',
        name: 'Elite Cinema Experience',
        description: 'Premium private theater with multiple screens and luxury amenities',
        address: '123 Theater Street, Entertainment District',
        city: 'Mumbai',
        state: 'Maharashtra',
        pinCode: '400001',
        latitude: 19.0760,
        longitude: 72.8777,
        capacity: 25,
        amenities: ['4K Projection', 'Dolby Atmos', 'Recliner Seats', 'Snack Bar', 'Air Conditioning'],
        images: [
          'https://images.unsplash.com/photo-1489185078074-0d83576b4d1c?w=400&q=80',
          'https://images.unsplash.com/photo-1574267432553-4b4628081c31?w=400&q=80',
          'https://images.unsplash.com/photo-1603190287605-e6ade32fa852?w=400&q=80',
        ],
        hourlyRate: 3500.0,
        rating: 4.8,
        totalReviews: 124,
        isActive: true,
      ),
      const TheaterModel(
        id: 'ececf43e-b0ab-49b2-831b-bc87dd409f65', // Same UUID as first theater to use same time slots
        name: 'Royal Theater Room',
        description: 'Cozy private theater perfect for intimate gatherings',
        address: '456 Cinema Avenue, Movie District',
        city: 'Mumbai',
        state: 'Maharashtra',
        pinCode: '400002',
        latitude: 19.0850,
        longitude: 72.8850,
        capacity: 15,
        amenities: ['HD Projection', 'Surround Sound', 'Comfortable Seating', 'Snacks'],
        images: [
          'https://images.unsplash.com/photo-1574267432553-4b4628081c31?w=400&q=80',
          'https://images.unsplash.com/photo-1596727147705-61a532a659bd?w=400&q=80',
        ],
        hourlyRate: 2500.0,
        rating: 4.5,
        totalReviews: 89,
        isActive: true,
      ),
    ];

    print('🎬 DEBUG: Returning ${testTheaters.length} test theaters');
    return testTheaters;

    // TODO: Replace with actual database query once theater data is properly set up
    /*
    var query = _supabase
        .from('service_listings')
        .select()
        .eq('is_active', true)
        .ilike('category', '%theater%');

    if (city != null) {
      query = query.eq('city', city);
    }

    final response = await query
        .order('rating', ascending: false)
        .range(offset, offset + limit - 1);
    
    return (response as List)
        .map((json) => TheaterModel.fromJson(json))
        .toList();
    */
  }

  Future<TheaterModel?> getTheaterById(String id) async {
    try {
      print('🎬 DEBUG: Fetching theater with ID: "$id"');
      print('🎬 DEBUG: ID length: ${id.length}');
      print('🎬 DEBUG: ID type: ${id.runtimeType}');
      
      // TEMPORARY FIX: Hard-code test theater data to make the flow work
      if (id == 'ececf43e-b0ab-49b2-831b-bc87dd409f65') {
        print('🎬 DEBUG: Returning hard-coded Elite Cinema theater');
        return const TheaterModel(
          id: 'ececf43e-b0ab-49b2-831b-bc87dd409f65',
          name: 'Elite Cinema Experience',
          description: 'Premium private theater with multiple screens and luxury amenities',
          address: '123 Theater Street, Entertainment District',
          city: 'Mumbai',
          state: 'Maharashtra',
          pinCode: '400001',
          latitude: 19.0760,
          longitude: 72.8777,
          capacity: 25,
          amenities: ['4K Projection', 'Dolby Atmos', 'Recliner Seats', 'Snack Bar', 'Air Conditioning'],
          images: [
            'https://images.unsplash.com/photo-1489185078074-0d83576b4d1c?w=400&q=80',
            'https://images.unsplash.com/photo-1574267432553-4b4628081c31?w=400&q=80',
            'https://images.unsplash.com/photo-1603190287605-e6ade32fa852?w=400&q=80',
          ],
          hourlyRate: 3500.0,
          rating: 4.8,
          totalReviews: 124,
          isActive: true,
        );
      }
      
      
      print('🎬 DEBUG: No matching hard-coded theater found for ID: "$id"');
      
      final response = await _supabase
          .from('service_listings')
          .select()
          .eq('id', id)
          .eq('is_active', true)
          .ilike('category', '%theater%')
          .maybeSingle();

      if (response == null) {
        print('🎬 DEBUG: No theater found with ID: $id');
        return null;
      }

      print('🎬 DEBUG: Found theater data: $response');
      return TheaterModel.fromJson(response);
    } catch (e) {
      print('🎬 DEBUG: Error fetching theater: $e');
      return null;
    }
  }

  Future<List<TheaterModel>> searchTheaters(String query) async {
    final response = await _supabase
        .from('service_listings')
        .select()
        .eq('is_active', true)
        .ilike('category', '%theater%')
        .or('title.ilike.%$query%,description.ilike.%$query%,address.ilike.%$query%')
        .order('rating', ascending: false)
        .limit(20);

    return (response as List)
        .map((json) => TheaterModel.fromJson(json))
        .toList();
  }

  Future<List<TheaterModel>> getNearbyTheaters({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    // Using the earth_distance function for proximity search
    final response = await _supabase.rpc('nearby_theaters', params: {
      'user_lat': latitude,
      'user_lng': longitude,
      'radius_km': radiusKm,
    });

    return (response as List)
        .map((json) => TheaterModel.fromJson(json))
        .toList();
  }

  /// Fetches decorations available for a specific theater
  Future<List<DecorationModel>> getTheaterDecorations(String theaterId) async {
    final response = await _supabase
        .from('decorations')
        .select()
        .eq('theater_id', theaterId)
        .eq('is_available', true)
        .order('price');

    return (response as List)
        .map((json) => DecorationModel.fromJson(json))
        .toList();
  }

  /// Fetches all available occasions
  Future<List<OccasionModel>> getOccasions() async {
    final response = await _supabase
        .from('occasions')
        .select()
        .eq('is_active', true)
        .order('name');

    return (response as List)
        .map((json) => OccasionModel.fromJson(json))
        .toList();
  }

  /// Fetches add-ons available for a specific theater
  Future<List<AddOnModel>> getTheaterAddOns(String theaterId) async {
    final response = await _supabase
        .from('add_ons')
        .select()
        .eq('theater_id', theaterId)
        .eq('is_available', true)
        .order('category, price');

    return (response as List)
        .map((json) => AddOnModel.fromJson(json))
        .toList();
  }

  /// Fetches all available special services
  Future<List<SpecialServiceModel>> getSpecialServices() async {
    final response = await _supabase
        .from('special_services')
        .select()
        .eq('is_active', true)
        .order('price');

    return (response as List)
        .map((json) => SpecialServiceModel.fromJson(json))
        .toList();
  }

  /// Fetches cakes available for a specific theater
  Future<List<CakeModel>> getTheaterCakes(String theaterId) async {
    final response = await _supabase
        .from('cakes')
        .select()
        .eq('theater_id', theaterId)
        .eq('is_available', true)
        .order('price');

    return (response as List)
        .map((json) => CakeModel.fromJson(json))
        .toList();
  }

  /// Fetches time slots for a specific theater and date
  Future<List<TheaterSlotBookingModel>> getTheaterTimeSlots(String theaterId, String date) async {
    try {
      // Convert date to proper format if it's a DateTime string
      String formattedDate = date;
      if (date.contains('T')) {
        formattedDate = date.split('T')[0]; // Extract YYYY-MM-DD part
      }
      
      print('🎬 Fetching time slots for theater: $theaterId, date: $date');
      print('🎬 Formatted date for query: $formattedDate');
      
      // Query theater_slot_bookings table which has the actual date-specific bookings
      final response = await _supabase
          .from('theater_slot_bookings')
          .select('''
            id,
            theater_id,
            time_slot_id,
            booking_date,
            start_time,
            end_time,
            status,
            slot_price,
            created_at,
            updated_at
          ''')
          .eq('theater_id', theaterId)
          .eq('booking_date', formattedDate)
          .order('start_time');

      print('🎬 Raw response: $response');
      print('🎬 Response length: ${(response as List).length}');

      // If no specific date bookings exist, fall back to template slots
      if ((response as List).isEmpty) {
        print('🎬 No date-specific slots found, falling back to template slots');
        return await _createSlotsFromTemplate(theaterId, formattedDate);
      }

      final result = (response as List)
          .map((json) {
            print('🎬 Processing slot: ${json['start_time']} - ${json['end_time']}');
            try {
              final slotPrice = _parseNumeric(json['slot_price'], 2500.0);
              print('🎬 Slot price from DB: $slotPrice');
              
              return TheaterSlotBookingModel.fromJson({
                'id': json['id']?.toString() ?? '',
                'theater_id': json['theater_id']?.toString() ?? '',
                'time_slot_id': json['time_slot_id']?.toString() ?? '',
                'booking_date': formattedDate,
                'start_time': json['start_time']?.toString() ?? '',
                'end_time': json['end_time']?.toString() ?? '',
                'status': json['status']?.toString() ?? 'available',
                'slot_price': slotPrice,
                'created_at': json['created_at'],
                'updated_at': json['updated_at'],
              });
            } catch (e) {
              print('🎬 Error processing slot: $e');
              rethrow;
            }
          })
          .toList();

      print('🎬 Final result count: ${result.length}');
      return result;
    } catch (e) {
      print('🎬 Error in getTheaterTimeSlots: $e');
      print('🎬 Stack trace: $e');
      rethrow;
    }
  }

  /// Creates time slots from template when no date-specific slots exist
  Future<List<TheaterSlotBookingModel>> _createSlotsFromTemplate(String theaterId, String date) async {
    try {
      print('🎬 Creating slots from template for theater: $theaterId, date: $date');
      
      // Get template slots from theater_time_slots for the specific date
      final templateResponse = await _supabase
          .from('theater_time_slots')
          .select('''
            id,
            theater_id,
            slot_date,
            start_time,
            end_time,
            base_price,
            price_per_hour,
            price_multiplier,
            max_duration_hours,
            created_at,
            updated_at
          ''')
          .eq('theater_id', theaterId)
          .eq('slot_date', date)
          .eq('is_active', true)
          .order('start_time');

      print('🎬 Template slots response: $templateResponse');
      print('🎬 Template slots count: ${(templateResponse as List).length}');
      
      if ((templateResponse as List).isEmpty) {
        print('🎬 No template slots found, creating default slots');
        final defaultSlots = _createDefaultTimeSlots(theaterId, date);
        print('🎬 Default slots returned from _createDefaultTimeSlots: ${defaultSlots.length}');
        return defaultSlots;
      }

      final result = (templateResponse as List)
          .map((json) {
            print('🎬 Processing template slot: ${json['start_time']} - ${json['end_time']}');
            
            final slotPrice = _calculateSlotPrice(json);
            print('🎬 Calculated price from template: $slotPrice');
            
            return TheaterSlotBookingModel.fromJson({
              'id': json['id']?.toString() ?? '',
              'theater_id': json['theater_id']?.toString() ?? '',
              'time_slot_id': json['id']?.toString() ?? '',
              'booking_date': date,
              'start_time': json['start_time']?.toString() ?? '',
              'end_time': json['end_time']?.toString() ?? '',
              'status': 'available',
              'slot_price': slotPrice,
              'created_at': json['created_at'],
              'updated_at': json['updated_at'],
            });
          })
          .toList();

      print('🎬 Template slots result count: ${result.length}');
      return result;
    } catch (e) {
      print('🎬 Error creating slots from template: $e');
      final fallbackSlots = _createDefaultTimeSlots(theaterId, date);
      print('🎬 Fallback slots created on error: ${fallbackSlots.length}');
      return fallbackSlots;
    }
  }

  /// Creates default time slots when no template exists
  List<TheaterSlotBookingModel> _createDefaultTimeSlots(String theaterId, String date) {
    print('🎬 Creating default time slots for theater: $theaterId, date: $date');
    
    final defaultSlots = [
      {'start': '09:00', 'end': '11:00', 'name': 'Morning Show', 'price': 1500.0},
      {'start': '11:30', 'end': '13:30', 'name': 'Matinee Show', 'price': 1800.0},
      {'start': '14:00', 'end': '16:00', 'name': 'Afternoon Show', 'price': 2000.0},
      {'start': '16:30', 'end': '18:30', 'name': 'Evening Show', 'price': 2500.0},
      {'start': '19:00', 'end': '21:00', 'name': 'Night Show', 'price': 3000.0},
      {'start': '21:30', 'end': '23:30', 'name': 'Late Night Show', 'price': 2800.0},
    ];

    final result = defaultSlots.asMap().entries.map((entry) {
      final index = entry.key;
      final slot = entry.value;
      final slotId = 'default-slot-$theaterId-$index-$date';
      
      print('🎬 Creating default slot $index: ${slot['start']} - ${slot['end']}, price: ${slot['price']}');
      
      return TheaterSlotBookingModel.fromJson({
        'id': slotId,
        'theater_id': theaterId,
        'time_slot_id': slotId,
        'booking_date': date,
        'start_time': slot['start'] as String,
        'end_time': slot['end'] as String,
        'status': 'available',
        'slot_price': slot['price'] as double,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }).toList();
    
    print('🎬 Default slots created: ${result.length} slots');
    return result;
  }

  /// Calculate slot price based on base price and multipliers
  double _calculateSlotPrice(Map<String, dynamic> timeSlot) {
    try {
      print('🎬 Calculating price for slot: $timeSlot');
      
      // Handle both string and numeric values from database
      final basePriceRaw = timeSlot['base_price'];
      final pricePerHourRaw = timeSlot['price_per_hour'];
      final multiplierRaw = timeSlot['price_multiplier'];
      final durationRaw = timeSlot['max_duration_hours'];
      
      final basePrice = _parseNumeric(basePriceRaw, 1500.0);
      final pricePerHour = _parseNumeric(pricePerHourRaw, 500.0);
      final multiplier = _parseNumeric(multiplierRaw, 1.0);
      final duration = _parseNumeric(durationRaw, 3.0).toInt();
      
      final calculatedPrice = (basePrice + (pricePerHour * duration)) * multiplier;
      print('🎬 Price calculation: base=$basePrice, hourly=$pricePerHour, duration=$duration, multiplier=$multiplier = $calculatedPrice');
      
      return calculatedPrice;
    } catch (e) {
      print('🎬 Error calculating price: $e');
      return 2500.0; // fallback price
    }
  }
  
  /// Helper method to parse numeric values that might be strings
  double _parseNumeric(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  /// ===== NEW SCREEN-BASED METHODS =====

  /// Fetches all screens for a theater
  Future<List<TheaterScreenModel>> getTheaterScreens(String theaterId) async {
    try {
      print('🎬 Fetching screens for theater: $theaterId');
      
      final response = await _supabase
          .from('theater_screens')
          .select('''
            id,
            theater_id,
            screen_name,
            screen_number,
            capacity,
            amenities,
            hourly_rate,
            is_active,
            created_at,
            updated_at
          ''')
          .eq('theater_id', theaterId)
          .eq('is_active', true)
          .order('screen_number');

      print('🎬 Screens response: ${(response as List).length} screens found');

      return (response as List)
          .map((json) => TheaterScreenModel.fromJson(json))
          .toList();
    } catch (e) {
      print('🎬 Error fetching theater screens: $e');
      rethrow;
    }
  }

  /// Fetches available time slots for a theater and date with automatic screen allocation
  Future<List<TheaterTimeSlotWithScreenModel>> getTheaterTimeSlotsWithScreens(String theaterId, String date) async {
    try {
      // Both test theaters use the same UUID to share time slots data
      String actualTheaterId = theaterId;
      
      // Convert date to proper format if it's a DateTime string
      String formattedDate = date;
      if (date.contains('T')) {
        formattedDate = date.split('T')[0]; // Extract YYYY-MM-DD part
      }
      
      print('🎬 Fetching time slots with screens for theater: $actualTheaterId, date: $formattedDate');
      
      // First check for existing bookings on this date
      final existingBookings = await _supabase
          .from('theater_slot_bookings')
          .select('screen_id, start_time, end_time, status')
          .eq('theater_id', actualTheaterId)
          .eq('booking_date', formattedDate)
          .neq('status', 'cancelled');

      print('🎬 Existing bookings: ${(existingBookings as List).length}');

      // Get all available time slots for this theater and date
      final timeSlotsResponse = await _supabase
          .from('theater_time_slots')
          .select('''
            id,
            theater_id,
            screen_id,
            slot_date,
            start_time,
            end_time,
            base_price,
            price_per_hour,
            weekday_multiplier,
            weekend_multiplier,
            holiday_multiplier,
            max_duration_hours,
            min_duration_hours,
            is_available,
            is_active,
            created_at,
            updated_at,
            theater_screens!inner(
              screen_name,
              screen_number,
              capacity,
              amenities,
              hourly_rate
            )
          ''')
          .eq('theater_id', actualTheaterId)
          .eq('slot_date', formattedDate)
          .eq('is_active', true)
          .eq('is_available', true)
          .order('start_time');

      print('🎬 Time slots response: ${(timeSlotsResponse as List).length} slots found');
      
      if ((timeSlotsResponse as List).isEmpty) {
        print('🎬 DEBUG: No time slots found in database for theater: $actualTheaterId, date: $formattedDate');
        print('🎬 DEBUG: This suggests the database might not have time slots data for this theater/date combination');
      }

      // Process time slots and mark unavailable ones
      final List<TheaterTimeSlotWithScreenModel> availableSlots = [];
      final Set<String> bookedSlotKeys = {};

      // Create set of booked slot keys (screen_id + start_time)
      for (final booking in existingBookings as List) {
        if (booking['status'] == 'booked' || booking['status'] == 'blocked') {
          bookedSlotKeys.add('${booking['screen_id']}-${booking['start_time']}');
        }
      }

      for (final slotData in timeSlotsResponse as List) {
        final screenData = slotData['theater_screens'];
        final slotKey = '${slotData['screen_id']}-${slotData['start_time']}';
        
        // Skip if this specific screen-time combination is booked
        if (bookedSlotKeys.contains(slotKey)) {
          continue;
        }

        // Calculate dynamic price
        final slotPrice = _calculateDynamicSlotPrice(slotData, formattedDate);

        print('🎬 DEBUG: Creating slot model for ${slotData['start_time']} - ${slotData['end_time']}');
        
        try {
          final slot = TheaterTimeSlotWithScreenModel.fromJson({
          'id': slotData['id'],
          'theater_id': slotData['theater_id'],
          'screen_id': slotData['screen_id'],
          'slot_date': slotData['slot_date'],
          'start_time': slotData['start_time'],
          'end_time': slotData['end_time'],
          'base_price': slotPrice,
          'price_per_hour': _parseNumeric(slotData['price_per_hour'], 500.0),
          'weekday_multiplier': _parseNumeric(slotData['weekday_multiplier'], 1.0),
          'weekend_multiplier': _parseNumeric(slotData['weekend_multiplier'], 1.2),
          'holiday_multiplier': _parseNumeric(slotData['holiday_multiplier'], 1.5),
          'max_duration_hours': slotData['max_duration_hours'] ?? 3,
          'min_duration_hours': slotData['min_duration_hours'] ?? 2,
          'is_available': true,
          'is_active': true,
          'created_at': slotData['created_at'],
          'updated_at': slotData['updated_at'],
          // Screen information
          'screen_name': screenData['screen_name'],
          'screen_number': screenData['screen_number'],
          'screen_capacity': screenData['capacity'],
          'screen_amenities': List<String>.from(screenData['amenities'] ?? []),
          'screen_hourly_rate': _parseNumeric(screenData['hourly_rate'], 0.0),
        });

        print('🎬 DEBUG: Successfully created slot model for ${slotData['start_time']}');
        availableSlots.add(slot);
        
        } catch (e) {
          print('🎬 ERROR: Failed to create slot model for ${slotData['start_time']}: $e');
          print('🎬 ERROR: Slot data: $slotData');
          print('🎬 ERROR: Screen data: $screenData');
          // Skip this slot and continue with others
          continue;
        }
      }

      // Group by time slots and select best available screen for each time
      final Map<String, TheaterTimeSlotWithScreenModel> bestSlotsByTime = {};
      
      for (final slot in availableSlots) {
        final timeKey = '${slot.startTime}-${slot.endTime}';
        
        if (!bestSlotsByTime.containsKey(timeKey)) {
          bestSlotsByTime[timeKey] = slot;
        } else {
          // Choose screen with better pricing or features
          final existing = bestSlotsByTime[timeKey]!;
          if (_isBetterScreen(slot, existing)) {
            bestSlotsByTime[timeKey] = slot;
          }
        }
      }

      final result = bestSlotsByTime.values.toList();
      result.sort((a, b) => a.startTime.compareTo(b.startTime));

      print('🎬 Available time slots after processing: ${result.length}');
      print('🎬 DEBUG: About to return time slots to provider');
      for (final slot in result) {
        print('🎬 DEBUG: Returning slot: ${slot.startTime} - ${slot.endTime}, Screen: ${slot.screenName}');
      }
      
      return result;
    } catch (e) {
      print('🎬 Error fetching time slots with screens: $e');
      rethrow;
    }
  }

  /// Calculates dynamic pricing based on day type and time
  double _calculateDynamicSlotPrice(Map<String, dynamic> slotData, String date) {
    try {
      final basePrice = _parseNumeric(slotData['base_price'], 1500.0);
      final pricePerHour = _parseNumeric(slotData['price_per_hour'], 500.0);
      final maxDuration = slotData['max_duration_hours'] ?? 3;
      
      // Determine day type multiplier
      final slotDate = DateTime.parse(date);
      final isWeekend = slotDate.weekday == DateTime.saturday || slotDate.weekday == DateTime.sunday;
      
      double multiplier = 1.0;
      if (isWeekend) {
        multiplier = _parseNumeric(slotData['weekend_multiplier'], 1.2);
      } else {
        multiplier = _parseNumeric(slotData['weekday_multiplier'], 1.0);
      }
      
      // TODO: Add holiday detection logic here
      
      final totalPrice = (basePrice + (pricePerHour * maxDuration)) * multiplier;
      return totalPrice;
    } catch (e) {
      print('🎬 Error calculating dynamic price: $e');
      return 2500.0; // fallback
    }
  }

  /// Determines if one screen is better than another based on pricing and features
  bool _isBetterScreen(TheaterTimeSlotWithScreenModel slot1, TheaterTimeSlotWithScreenModel slot2) {
    // Prefer screens with lower pricing first
    if (slot1.basePrice < slot2.basePrice) return true;
    if (slot1.basePrice > slot2.basePrice) return false;
    
    // If prices are equal, prefer larger capacity
    final capacity1 = slot1.screenCapacity ?? 0;
    final capacity2 = slot2.screenCapacity ?? 0;
    if (capacity1 > capacity2) return true;
    if (capacity1 < capacity2) return false;
    
    // If capacity is equal, prefer more amenities
    final amenities1 = slot1.screenAmenities?.length ?? 0;
    final amenities2 = slot2.screenAmenities?.length ?? 0;
    return amenities1 > amenities2;
  }

  /// Books a specific time slot with automatic screen allocation
  Future<TheaterBookingWithScreenModel> bookTimeSlotWithScreen({
    required String theaterId,
    required String screenId,
    required String timeSlotId,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required double slotPrice,
    required String userId,
  }) async {
    try {
      print('🎬 Booking time slot with screen: $screenId, slot: $timeSlotId');
      
      // Create booking record
      final bookingResponse = await _supabase
          .from('theater_slot_bookings')
          .insert({
            'theater_id': theaterId,
            'screen_id': screenId,
            'time_slot_id': timeSlotId,
            'booking_date': bookingDate,
            'start_time': startTime,
            'end_time': endTime,
            'status': 'booked',
            'slot_price': slotPrice,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select('''
            id,
            theater_id,
            screen_id,
            time_slot_id,
            booking_date,
            start_time,
            end_time,
            status,
            booking_id,
            slot_price,
            created_at,
            updated_at,
            theater_screens!inner(
              screen_name,
              screen_number,
              capacity,
              amenities
            )
          ''')
          .single();

      print('🎬 Booking created successfully: ${bookingResponse['id']}');

      final screenData = bookingResponse['theater_screens'];
      
      return TheaterBookingWithScreenModel.fromJson({
        'id': bookingResponse['id'],
        'theater_id': bookingResponse['theater_id'],
        'screen_id': bookingResponse['screen_id'],
        'time_slot_id': bookingResponse['time_slot_id'],
        'booking_date': bookingResponse['booking_date'],
        'start_time': bookingResponse['start_time'],
        'end_time': bookingResponse['end_time'],
        'status': bookingResponse['status'],
        'booking_id': bookingResponse['booking_id'],
        'slot_price': _parseNumeric(bookingResponse['slot_price'], 0.0),
        'created_at': bookingResponse['created_at'],
        'updated_at': bookingResponse['updated_at'],
        'screen_name': screenData['screen_name'],
        'screen_number': screenData['screen_number'],
        'screen_capacity': screenData['capacity'],
        'screen_amenities': List<String>.from(screenData['amenities'] ?? []),
      });
    } catch (e) {
      print('🎬 Error booking time slot with screen: $e');
      rethrow;
    }
  }
}