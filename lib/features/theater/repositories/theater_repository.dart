import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/features/theater/models/private_theater_model.dart';

class TheaterRepository {
  final SupabaseClient _supabase;

  TheaterRepository(this._supabase);

  Future<List<PrivateTheaterModel>> getTheaters({
    String? city,
    int limit = 10,
    int offset = 0,
  }) async {
    var query = _supabase
        .from('private_theaters')
        .select()
        .eq('is_active', true);

    if (city != null) {
      query = query.eq('city', city);
    }

    final response = await query
        .order('rating', ascending: false)
        .range(offset, offset + limit - 1);
    
    return (response as List)
        .map((json) => PrivateTheaterModel.fromJson(json))
        .toList();
  }

  Future<PrivateTheaterModel?> getTheaterById(String id) async {
    final response = await _supabase
        .from('private_theaters')
        .select()
        .eq('id', id)
        .eq('is_active', true)
        .single();

    return PrivateTheaterModel.fromJson(response);
  }

  Future<List<PrivateTheaterModel>> searchTheaters(String query) async {
    final response = await _supabase
        .from('private_theaters')
        .select()
        .eq('is_active', true)
        .or('name.ilike.%$query%,description.ilike.%$query%,address.ilike.%$query%')
        .order('rating', ascending: false)
        .limit(20);

    return (response as List)
        .map((json) => PrivateTheaterModel.fromJson(json))
        .toList();
  }

  Future<List<PrivateTheaterModel>> getNearbyTheaters({
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
        .map((json) => PrivateTheaterModel.fromJson(json))
        .toList();
  }
}