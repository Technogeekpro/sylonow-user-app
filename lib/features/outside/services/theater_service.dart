import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/theater_screen_model.dart';

class TheaterService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetches theater screens with location-based filtering and distance calculation
  Future<List<TheaterScreen>> fetchTheaterScreensWithLocation({
    double? userLat,
    double? userLon,
    double radiusKm = 60.0, // Default 60km radius
  }) async {
    try {
      // If user location is provided, use RPC function for distance-based filtering
      if (userLat != null && userLon != null) {
        final response = await _supabase.rpc(
          'get_theater_screens_with_distance',
          params: {
            'user_lat': userLat,
            'user_lon': userLon,
            'radius_km': radiusKm,
          },
        );

        if (response == null) return [];

        final screens = <TheaterScreen>[];
        for (var screenData in response as List) {
          try {
            final screen = TheaterScreen.fromJson(screenData as Map<String, dynamic>);
            screens.add(screen);
          } catch (parseError) {
            // Continue processing other screens
          }
        }
        return screens;
      }

      // Fallback to original method if no location provided
      return await fetchTheaterScreensWithPricing();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches theater screens with optimized pricing from time slots (legacy method)
  Future<List<TheaterScreen>> fetchTheaterScreensWithPricing() async {
    try {
      // Use more efficient query with specific column selection and join private_theaters for theater name
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
            description,
            time_slots,
            what_included,
            category_id,
            private_theaters!inner(name, approval_status),
            theater_time_slots_with_tax!inner(
              price_with_tax,
              discounted_price_with_tax,
              is_active
            )
          ''')
          .eq('is_active', true)
          .eq('private_theaters.approval_status', 'approved')
          .eq('theater_time_slots_with_tax.is_active', true)
          .order('screen_name', ascending: true);

      final screens = <TheaterScreen>[];

      for (int i = 0; i < response.length; i++) {
        try {
          final screenData = Map<String, dynamic>.from(response[i]);

          // Extract and process minimum pricing
          final minPrice = _calculateMinimumPrice(screenData);

          // Extract theater name from private_theaters join
          final theaters = screenData['private_theaters'];
          if (theaters != null && theaters is Map) {
            final theaterName = theaters['name'] as String?;
            if (theaterName != null) {
              screenData['theater_name'] = theaterName;
            }
          }

          // Clean up data structure
          screenData.remove('theater_time_slots_with_tax');
          screenData['hourly_rate'] = minPrice;

          final screen = TheaterScreen.fromJson(screenData);
          screens.add(screen);
        } catch (parseError) {
          // Continue processing other screens instead of failing completely
        }
      }

      return screens;
    } catch (e) {
      rethrow;
    }
  }

  /// Calculate minimum price from time slots with fallback logic
  /// Uses price_with_tax which already includes tax calculation from database view
  double _calculateMinimumPrice(Map<String, dynamic> screenData) {
    final timeSlots = screenData['theater_time_slots_with_tax'] as List? ?? [];
    double minPrice = double.infinity;

    for (final slot in timeSlots) {
      // Use price_with_tax (already includes 6.4% tax calculation from database)
      final priceWithTax = (slot['price_with_tax'] as num?)?.toDouble();
      final discountedPriceWithTax = (slot['discounted_price_with_tax'] as num?)?.toDouble();

      // Use discounted price with tax if available, otherwise use regular price with tax
      final slotPrice = (discountedPriceWithTax != null && discountedPriceWithTax > 0)
          ? discountedPriceWithTax
          : (priceWithTax ?? 0.0);

      if (slotPrice > 0 && slotPrice < minPrice) {
        minPrice = slotPrice;
      }
    }

    // Fallback to original hourly_rate if no valid time slot prices found
    if (minPrice == double.infinity) {
      minPrice = (screenData['hourly_rate'] as num?)?.toDouble() ?? 0.0;
    }

    return minPrice;
  }

  /// Fetch theater screens by IDs (for caching optimization)
  Future<List<TheaterScreen>> fetchTheaterScreensByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    try {
      final response = await _supabase
          .from('theater_screens')
          .select('''
            *,
            private_theaters!inner(name, approval_status),
            theater_time_slots_with_tax!inner(
              price_with_tax,
              discounted_price_with_tax,
              is_active
            )
          ''')
          .inFilter('id', ids)
          .eq('is_active', true)
          .eq('private_theaters.approval_status', 'approved')
          .eq('theater_time_slots_with_tax.is_active', true);

      return response.map((data) {
        final screenData = Map<String, dynamic>.from(data);
        final minPrice = _calculateMinimumPrice(screenData);

        // Extract theater name from private_theaters join
        final theaters = screenData['private_theaters'];
        if (theaters != null && theaters is Map) {
          final theaterName = theaters['name'] as String?;
          if (theaterName != null) {
            screenData['theater_name'] = theaterName;
          }
        }

        screenData.remove('theater_time_slots');
        screenData['hourly_rate'] = minPrice;
        return TheaterScreen.fromJson(screenData);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Search theater screens with optimized query
  Future<List<TheaterScreen>> searchTheaterScreens(String query) async {
    if (query.trim().isEmpty) {
      return fetchTheaterScreensWithPricing();
    }

    try {
      final response = await _supabase
          .from('theater_screens')
          .select('''
            *,
            private_theaters!inner(name, approval_status),
            theater_time_slots_with_tax!inner(
              price_with_tax,
              discounted_price_with_tax,
              is_active
            )
          ''')
          .or('screen_name.ilike.%$query%,description.ilike.%$query%')
          .eq('is_active', true)
          .eq('private_theaters.approval_status', 'approved')
          .eq('theater_time_slots_with_tax.is_active', true)
          .limit(20); // Limit results for performance

      return response.map((data) {
        final screenData = Map<String, dynamic>.from(data);
        final minPrice = _calculateMinimumPrice(screenData);

        // Extract theater name from private_theaters join
        final theaters = screenData['private_theaters'];
        if (theaters != null && theaters is Map) {
          final theaterName = theaters['name'] as String?;
          if (theaterName != null) {
            screenData['theater_name'] = theaterName;
          }
        }

        screenData.remove('theater_time_slots');
        screenData['hourly_rate'] = minPrice;
        return TheaterScreen.fromJson(screenData);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}