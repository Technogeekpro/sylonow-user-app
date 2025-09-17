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
    try {
      print('🎬 DEBUG: getTheaters called with city: $city, limit: $limit, offset: $offset');
      
      // First try with strict conditions (is_active = true)
      try {
        var strictQuery = _supabase
            .from('private_theaters')
            .select('''
              id,
              name,
              description,
              address,
              city,
              state,
              pin_code,
              latitude,
              longitude,
              capacity,
              amenities,
              images,
              hourly_rate,
              rating,
              total_reviews,
              is_active,
              screens
            ''')
            .eq('is_active', true);

        if (city != null) {
          strictQuery = strictQuery.eq('city', city);
        }

        final strictResponse = await strictQuery
            .order('rating', ascending: false)
            .range(offset, offset + limit - 1);
        
        print('🎬 DEBUG: Found ${(strictResponse as List).length} theaters with strict conditions (is_active=true)');
        
        if ((strictResponse as List).isNotEmpty) {
          return _convertToTheaterModels(strictResponse as List);
        }
      } catch (strictError) {
        print('🎬 DEBUG: Error with strict conditions: $strictError');
      }

      // If no theaters found with strict conditions, try with relaxed conditions for debugging
      try {
        print('🎬 DEBUG: No theaters found with strict conditions, trying relaxed conditions...');
        
        var relaxedQuery = _supabase
            .from('private_theaters')
            .select('''
              id,
              name,
              description,
              address,
              city,
              state,
              pin_code,
              latitude,
              longitude,
              capacity,
              amenities,
              images,
              hourly_rate,
              rating,
              total_reviews,
              is_active,
              screens
            ''');

        if (city != null) {
          relaxedQuery = relaxedQuery.eq('city', city);
        }

        final relaxedResponse = await relaxedQuery
            .order('rating', ascending: false)
            .range(offset, offset + limit - 1);
        
        print('🎬 DEBUG: Found ${(relaxedResponse as List).length} theaters with relaxed conditions (no is_active filter)');
        
        // Debug output for each theater
        for (final theater in relaxedResponse as List) {
          print('🎬 DEBUG: Theater: ${theater['name']}, is_active: ${theater['is_active']}, city: ${theater['city']}');
        }
        
        return _convertToTheaterModels(relaxedResponse as List);
      } catch (relaxedError) {
        print('🎬 DEBUG: Error even with relaxed conditions: $relaxedError');
      }

      // If still no results, check table existence
      try {
        print('🎬 DEBUG: Checking if private_theaters table has any data...');
        final countResponse = await _supabase
            .from('private_theaters')
            .select('id')
            .limit(50); // Get up to 50 to count manually
        
        print('🎬 DEBUG: Total theaters in table (first 50): ${(countResponse as List).length}');
      } catch (countError) {
        print('🎬 DEBUG: Error checking table count: $countError');
      }
      
      return [];
    } catch (e) {
      print('🎬 ERROR: Failed to fetch theaters from database: $e');
      rethrow;
    }
  }

  List<TheaterModel> _convertToTheaterModels(List<dynamic> theatersData) {
    return theatersData.map((json) {
      // Convert to TheaterModel compatible format
      return TheaterModel.fromJson({
        'id': json['id']?.toString(),
        'name': json['name']?.toString(),
        'description': json['description'],
        'address': json['address']?.toString(),
        'city': json['city']?.toString(),
        'state': json['state']?.toString(),
        'pinCode': json['pin_code']?.toString(),
        'latitude': _parseNumeric(json['latitude'], 0.0),
        'longitude': _parseNumeric(json['longitude'], 0.0),
        'capacity': json['capacity'],
        'amenities': json['amenities'] != null ? List<String>.from(json['amenities']) : null,
        'images': json['images'] != null ? List<String>.from(json['images']) : null,
        'hourlyRate': _parseNumeric(json['hourly_rate'], 0.0),
        'rating': _parseNumeric(json['rating'], 0.0),
        'totalReviews': json['total_reviews'],
        'isActive': json['is_active'],
        'screens': json['screens'],
      });
    }).toList();
  }

  Future<TheaterModel?> getTheaterById(String id) async {
    try {
      print('🎬 DEBUG: Fetching theater with ID: "$id"');
      
      final response = await _supabase
          .from('private_theaters')
          .select('''
            id,
            name,
            description,
            address,
            city,
            state,
            pin_code,
            latitude,
            longitude,
            capacity,
            amenities,
            images,
            hourly_rate,
            rating,
            total_reviews,
            is_active,
            screens
          ''')
          .eq('id', id)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) {
        print('🎬 DEBUG: No theater found with ID: $id');
        return null;
      }

      print('🎬 DEBUG: Found theater data: ${response['name']}');
      
      return TheaterModel.fromJson({
        'id': response['id'],
        'name': response['name'],
        'description': response['description'],
        'address': response['address'],
        'city': response['city'],
        'state': response['state'],
        'pinCode': response['pin_code'],
        'latitude': _parseNumeric(response['latitude'], 0.0),
        'longitude': _parseNumeric(response['longitude'], 0.0),
        'capacity': response['capacity'],
        'amenities': response['amenities'] != null ? List<String>.from(response['amenities']) : null,
        'images': response['images'] != null ? List<String>.from(response['images']) : null,
        'hourlyRate': _parseNumeric(response['hourly_rate'], 0.0),
        'rating': _parseNumeric(response['rating'], 0.0),
        'totalReviews': response['total_reviews'],
        'isActive': response['is_active'],
        'screens': response['screens'],
      });
    } catch (e) {
      print('🎬 DEBUG: Error fetching theater: $e');
      return null;
    }
  }

  Future<List<TheaterModel>> searchTheaters(String query) async {
    try {
      final response = await _supabase
          .from('private_theaters')
          .select('''
            id,
            name,
            description,
            address,
            city,
            state,
            pin_code,
            latitude,
            longitude,
            capacity,
            amenities,
            images,
            hourly_rate,
            rating,
            total_reviews,
            is_active,
            screens
          ''')
          .eq('is_active', true)
          .or('name.ilike.%$query%,description.ilike.%$query%,address.ilike.%$query%,city.ilike.%$query%')
          .order('rating', ascending: false)
          .limit(20);

          return (response as List)
        .map((json) {
          return TheaterModel.fromJson({
            'id': json['id']?.toString(),
            'name': json['name']?.toString(),
            'description': json['description'],
            'address': json['address']?.toString(),
            'city': json['city']?.toString(),
            'state': json['state']?.toString(),
            'pinCode': json['pin_code']?.toString(),
            'latitude': _parseNumeric(json['latitude'], 0.0),
            'longitude': _parseNumeric(json['longitude'], 0.0),
            'capacity': json['capacity'],
            'amenities': json['amenities'] != null ? List<String>.from(json['amenities']) : null,
            'images': json['images'] != null ? List<String>.from(json['images']) : null,
            'hourlyRate': _parseNumeric(json['hourly_rate'], 0.0),
            'rating': _parseNumeric(json['rating'], 0.0),
            'totalReviews': json['total_reviews'],
            'isActive': json['is_active'],
            'screens': json['screens'],
          });
        })
        .toList();
    } catch (e) {
      print('🎬 ERROR: Failed to search theaters: $e');
      rethrow;
    }
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
    try {
      print('🎬 DEBUG: Fetching add-ons for theater: $theaterId');
      
      // First get the theater's owner_id
      final theaterResponse = await _supabase
          .from('private_theaters')
          .select('owner_id')
          .eq('id', theaterId)
          .single();

      final ownerId = theaterResponse['owner_id'];
      print('🎬 DEBUG: Theater owner_id: $ownerId');

      if (ownerId == null) {
        print('🎬 DEBUG: No owner_id found for theater, returning empty list');
        return [];
      }

      // Query add-ons with vendor_id filter
      final response = await _supabase
          .from('add_ons')
          .select()
          .or('vendor_id.eq.$ownerId,theater_id.eq.$theaterId,vendor_id.is.null') // Include vendor-specific, theater-specific, and global add-ons
          .eq('is_active', true)
          .order('category, price');

      print('🎬 DEBUG: Found ${(response as List).length} add-ons for theater owner');
      
      // Debug: Show which add-ons were found
      for (final addon in response as List) {
        print('🎬 DEBUG: Add-on: ${addon['name']}, vendor_id: ${addon['vendor_id']}, theater_id: ${addon['theater_id']}, category: ${addon['category']}');
      }

      return (response as List)
          .map((json) => AddOnModel.fromJson(json))
          .toList();
    } catch (e) {
      print('🎬 ERROR: Failed to fetch theater add-ons: $e');
      return [];
    }
  }

  /// Fetches add-ons available for a specific service listing
  Future<List<AddOnModel>> getServiceAddOns(String serviceId) async {
    try {
      print('🎬 Attempting to fetch service add-ons for service: $serviceId');
      
      // Step 1: Get the vendor_id from the service_listings table
      // The service_add_ons table is linked to vendors, not directly to service listings
      String? vendorId;
      
      try {
        final serviceResponse = await _supabase
            .from('service_listings')
            .select('vendor_id')
            .eq('id', serviceId)
            .single();
            
        vendorId = serviceResponse['vendor_id'] as String?;
        print('🎬 Found vendor_id: $vendorId for service: $serviceId');
      } catch (e) {
        print('🎬 ❌ Failed to get vendor_id for service: $e');
      }
      
      // Step 2: If we have a vendor_id, get add-ons for that vendor
      if (vendorId != null) {
        try {
          final response = await _supabase
              .from('service_add_ons')
              .select()
              .eq('vendor_id', vendorId)
              .eq('is_available', true)
              .order('sort_order, name');

          if (response.isNotEmpty) {
            print('🎬 ✅ Found ${response.length} service add-ons for vendor: $vendorId');
            print('🎬 Sample add-on: ${response[0]}');
            
            // Convert service_add_ons data to AddOnModel format
            return (response as List).map((json) {
              // Map service_add_ons schema to AddOnModel schema
              final addOnData = <String, dynamic>{
                'id': json['id'],
                'name': json['name'],
                'description': json['description'],
                'price': (json['discount_price'] ?? json['original_price'] ?? 0.0).toDouble(),
                'category': json['type'] ?? 'general',
                'image_url': (json['images'] != null && (json['images'] as List).isNotEmpty) 
                    ? (json['images'] as List).first 
                    : null,
                'is_active': json['is_available'] ?? true,
                'created_at': json['created_at'],
                'updated_at': json['updated_at'],
              };
              return AddOnModel.fromJson(addOnData);
            }).toList();
          } else {
            print('🎬 No service add-ons found for vendor: $vendorId');
          }
          
        } catch (e1) {
          print('🎬 ❌ service_add_ons query by vendor_id failed: $e1');
        }
      }
      
      // Fallback: Use general add-ons from add_ons table
      // Get non-theater-specific add-ons that could apply to services
      print('🎬 🔄 Falling back to general add-ons from add_ons table');
      
      try {
        final fallbackResponse = await _supabase
            .from('add_ons')
            .select()
            .eq('is_active', true)
            .or('theater_id.is.null,vendor_id.is.null')
            .order('category, price')
            .limit(8); // Reasonable limit for checkout screen

        if (fallbackResponse.isNotEmpty) {
          print('🎬 ✅ Using ${fallbackResponse.length} general add-ons as fallback');
          return (fallbackResponse as List)
              .map((json) => AddOnModel.fromJson(json))
              .toList();
        } else {
          print('🎬 ⚠️ No general add-ons available either');
        }
      } catch (fallbackError) {
        print('🎬 💥 Fallback to add_ons table also failed: $fallbackError');
      }
      
      print('🎬 ❌ No add-ons found for service: $serviceId');
      return [];
      
    } catch (e) {
      print('🎬 💥 CRITICAL ERROR in getServiceAddOns: $e');
      return [];
    }
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
      
      // Query theater_time_slot_bookings table which has the actual date-specific bookings
      final response = await _supabase
          .from('theater_time_slot_bookings')
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
            screen_id,
            start_time,
            end_time,
            base_price,
            discounted_price,
            is_available,
            is_available,
            is_active,
            price_multiplier,
            created_at,
            updated_at
          ''')
          .eq('theater_id', theaterId)
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

  /// Calculate slot price using base price and discounted price
  double _calculateSlotPrice(Map<String, dynamic> timeSlot) {
    try {
      print('🎬 Calculating price for slot: $timeSlot');

      final basePrice = _parseNumeric(timeSlot['base_price'], 1500.0);
      final discountedPrice = _parseNumeric(timeSlot['discounted_price'], 0.0);

      // Use discounted price if available, otherwise use base price
      final finalPrice = discountedPrice > 0 ? discountedPrice : basePrice;

      print('🎬 Price calculation: base=$basePrice, discounted=$discountedPrice, final=$finalPrice');

      return finalPrice;
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
            updated_at,
            total_capacity,
            allowed_capacity,
            charges_extra_per_person,
            video_url,
            images,
            original_hourly_price,
            discounted_hourly_price
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
          .from('theater_time_slot_bookings')
          .select('time_slot_id, booked_date')
          .eq('booked_date', formattedDate);

      print('🎬 Existing bookings: ${(existingBookings as List).length}');

      // Get all available time slots for this theater (no date filtering needed as slots are templates)
      final timeSlotsResponse = await _supabase
          .from('theater_time_slots')
          .select('''
            id,
            theater_id,
            screen_id,
            start_time,
            end_time,
            base_price,
            discounted_price,
            is_available,
            is_available,
            is_active,
            created_at,
            updated_at,
            theater_screens!inner(
              screen_name,
              screen_number,
              capacity,
              amenities,
              original_hourly_price,
              discounted_hourly_price,
              total_capacity,
              allowed_capacity,
              charges_extra_per_person
            )
          ''')
          .eq('theater_id', actualTheaterId)
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
      final Set<String> bookedTimeSlotIds = {};

      // Create set of booked time slot IDs
      for (final booking in existingBookings as List) {
        bookedTimeSlotIds.add(booking['time_slot_id'].toString());
      }

      for (final slotData in timeSlotsResponse as List) {
        final screenData = slotData['theater_screens'];
        final timeSlotId = slotData['id'].toString();
        
        // Skip if this time slot is already booked
        if (bookedTimeSlotIds.contains(timeSlotId)) {
          continue;
        }

        // Calculate pricing from theater_screens table
        final double originalPrice = _parseNumeric(screenData['original_hourly_price'], 1500.0);
        final double discountedPrice = _parseNumeric(screenData['discounted_hourly_price'], 0.0);
        final double slotPrice = discountedPrice > 0 ? discountedPrice : originalPrice;

        print('🎬 DEBUG: Creating slot model for ${slotData['start_time']} - ${slotData['end_time']}');
        
        try {
          final slot = TheaterTimeSlotWithScreenModel.fromJson({
          'id': slotData['id'],
          'theater_id': slotData['theater_id'],
          'screen_id': slotData['screen_id'],
          'slot_date': formattedDate, // Use the requested date instead of database field
          'start_time': slotData['start_time'],
          'end_time': slotData['end_time'],
          'base_price': slotPrice,
          'discounted_price': _parseNumeric(slotData['discounted_price'], 0.0),
          'is_available': true,
          'is_active': true,
          'created_at': slotData['created_at'],
          'updated_at': slotData['updated_at'],
          // Screen information
          'screen_name': screenData['screen_name'],
          'screen_number': screenData['screen_number'],
          'screen_capacity': screenData['capacity'],
          'screen_amenities': List<String>.from(screenData['amenities'] ?? []),
          'screen_hourly_rate': slotPrice, // Use calculated price for backward compatibility
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

  /// Fetches time slots directly from theater_time_slots with booking status checking
  Future<List<Map<String, dynamic>>> getTheaterTimeSlotsDirectWithBookingStatus(String theaterId, String date) async {
    try {
      // Normalize date to YYYY-MM-DD
      String formattedDate = date;
      if (formattedDate.contains('T')) {
        formattedDate = formattedDate.split('T')[0];
      }

      print('🎬 Fetching direct time slots for theater: $theaterId, date: $formattedDate');

      // Get time slots with screen information
      final timeSlotsResponse = await _supabase
          .from('theater_time_slots')
          .select('''
            id,
            theater_id,
            screen_id,
            start_time,
            end_time,
            is_available,
            is_active,
            base_price,
            price_per_hour,
            theater_screens!inner(
              screen_name,
              screen_number,
              capacity,
              amenities,
              original_hourly_price,
              discounted_hourly_price,
              total_capacity,
              allowed_capacity,
              charges_extra_per_person
            )
          ''')
          .eq('theater_id', theaterId)
          .eq('is_active', true)
          .eq('is_available', true)
          .order('start_time');

      print('🎬 Found ${(timeSlotsResponse as List).length} time slots');

      // Get booked time slot IDs for this date
      final bookedSlotsResponse = await _supabase
          .from('theater_time_slot_bookings')
          .select('time_slot_id')
          .eq('booked_date', formattedDate);

      final Set<String> bookedSlotIds = {};
      for (final booking in bookedSlotsResponse as List) {
        bookedSlotIds.add(booking['time_slot_id'].toString());
      }

      print('🎬 Found ${bookedSlotIds.length} booked slots for date: $formattedDate');

      // Process slots with booking status and pricing
      final List<Map<String, dynamic>> processedSlots = [];
      for (final slotData in timeSlotsResponse as List) {
        final screenData = slotData['theater_screens'];
        final String slotId = slotData['id'];
        final bool isBooked = bookedSlotIds.contains(slotId);

        // Calculate pricing from theater_screens table
        final double originalPrice = _parseNumeric(screenData['original_hourly_price'], 500.0);
        final double discountedPrice = _parseNumeric(screenData['discounted_hourly_price'], 0.0);
        final double finalPrice = discountedPrice > 0 ? discountedPrice : originalPrice;
        final bool hasDiscount = discountedPrice > 0 && discountedPrice < originalPrice;

        processedSlots.add({
          'id': slotId,
          'theater_id': slotData['theater_id'],
          'screen_id': slotData['screen_id'],
          'start_time': slotData['start_time'],
          'end_time': slotData['end_time'],
          'is_available': !isBooked && (slotData['is_available'] ?? true),
          'is_booked': isBooked,
          'screen_name': screenData['screen_name'],
          'screen_number': screenData['screen_number'],
          'screen_capacity': screenData['capacity'],
          'original_hourly_price': originalPrice,
          'discounted_hourly_price': discountedPrice,
          'final_price': finalPrice,
          'has_discount': hasDiscount,
          'total_capacity': _parseNumeric(screenData['total_capacity'], 0),
          'allowed_capacity': _parseNumeric(screenData['allowed_capacity'], 0),
          'charges_extra_per_person': _parseNumeric(screenData['charges_extra_per_person'], 0.0),
          'screen_amenities': List<String>.from(screenData['amenities'] ?? []),
        });
      }

      print('🎬 Processed ${processedSlots.length} time slots with booking status');
      return processedSlots;
    } catch (e) {
      print('🎬 Error fetching direct time slots with booking status: $e');
      rethrow;
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
      
      // Create booking record (only use columns that exist in the actual table)
      final bookingResponse = await _supabase
          .from('theater_time_slot_bookings')
          .insert({
            'time_slot_id': timeSlotId,
            'booked_date': bookingDate,
          })
          .select('''
            id,
            time_slot_id,
            booked_date,
            created_at,
            updated_at
          ''')
          .single();

      print('🎬 Booking created successfully: ${bookingResponse['id']}');

      // Fetch screen data separately since booking table has limited columns
      final screenData = await _supabase
          .from('theater_screens')
          .select('screen_name, screen_number, capacity, amenities')
          .eq('id', screenId)
          .single();
      
      return TheaterBookingWithScreenModel.fromJson({
        'id': bookingResponse['id'],
        'theater_id': theaterId,
        'screen_id': screenId,
        'time_slot_id': bookingResponse['time_slot_id'],
        'booking_date': bookingResponse['booked_date'],
        'start_time': startTime,
        'end_time': endTime,
        'status': 'booked',
        'booking_id': null,
        'slot_price': slotPrice,
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

  /// Gets screen-specific time slots with availability checking
  Future<List<Map<String, dynamic>>> getScreenTimeSlotsWithAvailability(String screenId, String date) async {
    try {
      print('🎬 Fetching time slots for screen: $screenId, date: $date');

      // Normalize date to YYYY-MM-DD
      String formattedDate = date;
      if (formattedDate.contains('T')) {
        formattedDate = formattedDate.split('T')[0];
      }

      // Get screen details first - focusing on pricing columns
      final screenData = await _supabase
          .from('theater_screens')
          .select('''
            id,
            screen_name,
            screen_number,
            capacity,
            amenities,
            original_hourly_price,
            discounted_hourly_price,
            total_capacity,
            allowed_capacity,
            charges_extra_per_person
          ''')
          .eq('id', screenId)
          .single();

      // Get template time slots for this screen from theater_time_slots
      final List<dynamic> timeSlotsResponse = await _supabase
          .from('theater_time_slots')
          .select('''
            id,
            theater_id,
            screen_id,
            start_time,
            end_time,
            is_available,
            is_active,
            base_price,
            discounted_price,
            is_available
          ''')
          .eq('screen_id', screenId)
          .eq('is_active', true)
          .order('start_time');

      if (timeSlotsResponse.isEmpty) {
        print('🎬 No template time slots found for screen: $screenId');
        return [];
      }

      // Check bookings for these slots on the given date
      final List<String> slotIds = timeSlotsResponse.map((e) => e['id'] as String).toList();

      // If there are many slots, split into batches to avoid query limits
      final Set<String> bookedSlotIds = <String>{};
      const int batchSize = 100;
      for (int i = 0; i < slotIds.length; i += batchSize) {
        final batch = slotIds.sublist(i, i + batchSize > slotIds.length ? slotIds.length : i + batchSize);
        final List<dynamic> bookings = await _supabase
            .from('theater_time_slot_bookings')
            .select('time_slot_id')
            .eq('booked_date', formattedDate)
            .filter('time_slot_id', 'in', batch);
        for (final row in bookings) {
          final id = row['time_slot_id'] as String?;
          if (id != null) {
            bookedSlotIds.add(id);
          }
        }
      }

      print('🎬 Screen template slots: ${timeSlotsResponse.length}, booked on date: ${bookedSlotIds.length}');

      // Build processed slots list
      final List<Map<String, dynamic>> processedSlots = [];
      for (final slot in timeSlotsResponse) {
        final String id = slot['id'] as String;
        final String startTime = slot['start_time'];
        final String endTime = slot['end_time'];
        final bool slotFlagAvailable = (slot['is_available'] as bool?) ?? true;
        final bool isBooked = bookedSlotIds.contains(id);
        final bool isAvailable = slotFlagAvailable && !isBooked;

        // Use discounted price if available, otherwise original price
        final double originalPrice = _parseNumeric(screenData['original_hourly_price'], 1500.0);
        final double discountedPrice = _parseNumeric(screenData['discounted_hourly_price'], 0.0);
        final double finalPrice = discountedPrice > 0 ? discountedPrice : originalPrice;
        
        processedSlots.add({
          'id': id,
          'start_time': startTime,
          'end_time': endTime,
          'label': null,
          'is_available': isAvailable,
          'screen_id': screenId,
          'screen_name': screenData['screen_name'],
          'screen_capacity': screenData['capacity'],
          'original_hourly_price': originalPrice,
          'discounted_hourly_price': discountedPrice,
          'hourly_rate': finalPrice, // For backward compatibility
          'final_price': finalPrice,
          'has_discount': discountedPrice > 0 && discountedPrice < originalPrice,
          'screen_amenities': List<String>.from(screenData['amenities'] ?? []),
          'total_capacity': _parseNumeric(screenData['total_capacity'], 0),
          'allowed_capacity': _parseNumeric(screenData['allowed_capacity'], 0),
          'charges_extra_per_person': _parseNumeric(screenData['charges_extra_per_person'], 0.0),
        });
      }

      return processedSlots;
    } catch (e) {
      print('🎬 Error fetching screen time slots: $e');
      rethrow;
    }
  }

  // _timesOverlap helper removed as availability now derives from bookings table directly

  /// DEBUG METHOD: Get raw theaters data for debugging (includes inactive theaters)
  Future<List<Map<String, dynamic>>> getTheatersRaw() async {
    try {
      print('🎬 DEBUG: Getting raw theaters data for debugging...');
      
      final response = await _supabase
          .from('private_theaters')
          .select('*')
          .order('created_at', ascending: false);
      
      print('🎬 DEBUG: Raw theaters count: ${(response as List).length}');
      
      for (int i = 0; i < (response as List).length && i < 5; i++) {
        final theater = (response as List)[i];
        print('🎬 DEBUG: Theater $i: name="${theater['name']}", is_active=${theater['is_active']}, city="${theater['city']}"');
      }
      
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('🎬 DEBUG: Error getting raw theaters data: $e');
      return [];
    }
  }

  /// DEBUG METHOD: Create sample theater data if table is empty
  Future<void> createSampleTheaterData() async {
    try {
      print('🎬 DEBUG: Creating sample theater data...');
      
      final sampleTheaters = [
        {
          'name': 'Luxury Cinema Hub',
          'description': 'Premium private theater experience with luxury seating',
          'address': '123 Entertainment District',
          'city': 'Mumbai',
          'state': 'Maharashtra',
          'pin_code': '400001',
          'latitude': 19.0760,
          'longitude': 72.8777,
          'capacity': 15,
          'amenities': ['Dolby Atmos', 'Luxury Seats', 'AC', 'Snacks'],
          'images': ['https://example.com/theater1.jpg'],
          'hourly_rate': 2500.0,
          'rating': 4.8,
          'total_reviews': 150,
          'is_active': true,
          'screens': 2,
        },
        {
          'name': 'Elite Movie Lounge',
          'description': 'Cozy private screening room perfect for small groups',
          'address': '456 Film Street',
          'city': 'Mumbai',
          'state': 'Maharashtra',
          'pin_code': '400002',
          'latitude': 19.0896,
          'longitude': 72.8656,
          'capacity': 8,
          'amenities': ['HD Projector', 'Surround Sound', 'Comfortable Sofas'],
          'images': ['https://example.com/theater2.jpg'],
          'hourly_rate': 1800.0,
          'rating': 4.5,
          'total_reviews': 89,
          'is_active': true,
          'screens': 1,
        },
        {
          'name': 'Royal Theatre Experience',
          'description': 'Grand theater with royal ambiance and premium facilities',
          'address': '789 Cinema Boulevard',
          'city': 'Delhi',
          'state': 'Delhi',
          'pin_code': '110001',
          'latitude': 28.6139,
          'longitude': 77.2090,
          'capacity': 20,
          'amenities': ['4K Projection', 'Royal Seating', 'Mini Bar', 'Valet Service'],
          'images': ['https://example.com/theater3.jpg'],
          'hourly_rate': 3500.0,
          'rating': 4.9,
          'total_reviews': 234,
          'is_active': true,
          'screens': 3,
        }
      ];

      for (final theaterData in sampleTheaters) {
        try {
          await _supabase
              .from('private_theaters')
              .insert(theaterData);
          print('🎬 DEBUG: Created theater: ${theaterData['name']}');
        } catch (e) {
          print('🎬 DEBUG: Error creating theater ${theaterData['name']}: $e');
        }
      }
      
      print('🎬 DEBUG: Sample theater data creation completed');
    } catch (e) {
      print('🎬 DEBUG: Error in createSampleTheaterData: $e');
    }
  }
}