import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cake_model.dart';

class CakeRepository {
  final SupabaseClient _supabase;

  CakeRepository(this._supabase);

  /// Get all available cakes for a specific theater
  Future<List<CakeModel>> getCakesForTheater({
    required String theaterId,
    int? limit,
    String? category,
  }) async {
    try {
      dynamic query = _supabase
          .from('cakes')
          .select()
          .eq('theater_id', theaterId)
          .eq('is_available', true);

      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.eq('flavor', category);
      }

      query = query.order('created_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;

      return (response as List)
          .map((cake) => CakeModel.fromJson(_mapToModel(cake)))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch cakes: $e');
    }
  }

  /// Get all available cake categories/flavors for a theater
  Future<List<String>> getCakeCategoriesForTheater(String theaterId) async {
    try {
      final response = await _supabase
          .from('cakes')
          .select('flavor')
          .eq('theater_id', theaterId)
          .eq('is_available', true);

      final categories = (response as List)
          .map((item) => item['flavor'] as String?)
          .where((flavor) => flavor != null)
          .cast<String>()
          .toSet()
          .toList();

      categories.sort();
      return ['All', ...categories];
    } catch (e) {
      throw Exception('Failed to fetch cake categories: $e');
    }
  }

  /// Get a specific cake by ID
  Future<CakeModel?> getCakeById(String cakeId) async {
    try {
      final response = await _supabase
          .from('cakes')
          .select()
          .eq('id', cakeId)
          .eq('is_available', true)
          .maybeSingle();

      if (response == null) return null;

      return CakeModel.fromJson(_mapToModel(response));
    } catch (e) {
      throw Exception('Failed to fetch cake: $e');
    }
  }

  /// Get limited cakes for quick selection (used in checkout)
  Future<List<CakeModel>> getQuickSelectCakes({
    required String theaterId,
    int limit = 10,
  }) async {
    return getCakesForTheater(
      theaterId: theaterId,
      limit: limit,
    );
  }

  /// Search cakes by name
  Future<List<CakeModel>> searchCakes({
    required String theaterId,
    required String query,
    String? category,
  }) async {
    try {
      dynamic supabaseQuery = _supabase
          .from('cakes')
          .select()
          .eq('theater_id', theaterId)
          .eq('is_available', true)
          .ilike('name', '%$query%');

      if (category != null && category.isNotEmpty && category != 'All') {
        supabaseQuery = supabaseQuery.eq('flavor', category);
      }

      supabaseQuery = supabaseQuery.order('created_at', ascending: false);

      final response = await supabaseQuery;

      return (response as List)
          .map((cake) => CakeModel.fromJson(_mapToModel(cake)))
          .toList();
    } catch (e) {
      throw Exception('Failed to search cakes: $e');
    }
  }

  /// Map database response to model format
  Map<String, dynamic> _mapToModel(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'theaterId': data['theater_id'],
      'name': data['name'],
      'description': data['description'],
      'imageUrl': data['image_url'],
      'price': double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
      'size': data['size'],
      'flavor': data['flavor'],
      'isAvailable': data['is_available'] ?? true,
      'preparationTimeMinutes': data['preparation_time_minutes'] ?? 60,
      'createdAt': data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
      'updatedAt': data['updated_at'] != null 
          ? DateTime.parse(data['updated_at']) 
          : null,
    };
  }
}