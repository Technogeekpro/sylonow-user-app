import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/theater_screen_model.dart';

class TheaterService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetches theater screens with optimized pricing from time slots
  Future<List<TheaterScreen>> fetchTheaterScreensWithPricing() async {
    try {
      print('Starting optimized theater screens fetch with pricing...');

      // Use more efficient query with specific column selection
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
            theater_time_slots!inner(
              base_price,
              discounted_price,
              is_active
            )
          ''')
          .eq('is_active', true)
          .eq('theater_time_slots.is_active', true)
          .order('screen_name', ascending: true);

      print('Query response: ${response.length} screens with time slots');

      final screens = <TheaterScreen>[];
      
      for (int i = 0; i < response.length; i++) {
        try {
          final screenData = Map<String, dynamic>.from(response[i]);
          
          // Extract and process minimum pricing
          final minPrice = _calculateMinimumPrice(screenData);
          
          // Clean up data structure
          screenData.remove('theater_time_slots');
          screenData['hourly_rate'] = minPrice;
          
          final screen = TheaterScreen.fromJson(screenData);
          screens.add(screen);
        } catch (parseError) {
          print('Error parsing screen $i: $parseError');
          // Continue processing other screens instead of failing completely
        }
      }
      
      print('Successfully parsed ${screens.length} screens with pricing');
      return screens;
    } catch (e, stackTrace) {
      print('Theater service error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Calculate minimum price from time slots with fallback logic
  double _calculateMinimumPrice(Map<String, dynamic> screenData) {
    final timeSlots = screenData['theater_time_slots'] as List? ?? [];
    double minPrice = double.infinity;

    for (final slot in timeSlots) {
      final basePrice = (slot['base_price'] as num?)?.toDouble();
      final discountedPrice = (slot['discounted_price'] as num?)?.toDouble();

      // Use discounted price if available, otherwise use base price
      final slotPrice = discountedPrice ?? basePrice ?? 0.0;

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
            theater_time_slots!inner(
              base_price,
              discounted_price,
              is_active
            )
          ''')
          .inFilter('id', ids)
          .eq('is_active', true)
          .eq('theater_time_slots.is_active', true);

      return response.map((data) {
        final screenData = Map<String, dynamic>.from(data);
        final minPrice = _calculateMinimumPrice(screenData);
        screenData.remove('theater_time_slots');
        screenData['hourly_rate'] = minPrice;
        return TheaterScreen.fromJson(screenData);
      }).toList();
    } catch (e) {
      print('Error fetching screens by IDs: $e');
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
            theater_time_slots!inner(
              base_price,
              discounted_price,
              is_active
            )
          ''')
          .or('screen_name.ilike.%$query%,description.ilike.%$query%')
          .eq('is_active', true)
          .eq('theater_time_slots.is_active', true)
          .limit(20); // Limit results for performance

      return response.map((data) {
        final screenData = Map<String, dynamic>.from(data);
        final minPrice = _calculateMinimumPrice(screenData);
        screenData.remove('theater_time_slots');
        screenData['hourly_rate'] = minPrice;
        return TheaterScreen.fromJson(screenData);
      }).toList();
    } catch (e) {
      print('Error searching theater screens: $e');
      rethrow;
    }
  }
}