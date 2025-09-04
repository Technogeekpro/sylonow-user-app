import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cake_model.dart';
import '../repositories/cake_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final cakeRepositoryProvider = Provider<CakeRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return CakeRepository(supabase);
});

/// Parameters for theater-specific cake fetching
class TheaterCakeParams {
  final String theaterId;
  final int? limit;
  final String? category;

  TheaterCakeParams({
    required this.theaterId,
    this.limit,
    this.category,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TheaterCakeParams &&
        other.theaterId == theaterId &&
        other.limit == limit &&
        other.category == category;
  }

  @override
  int get hashCode => theaterId.hashCode ^ limit.hashCode ^ category.hashCode;
}

/// Provider for getting cakes for a specific theater
final theaterCakesProvider = FutureProvider.family<List<CakeModel>, TheaterCakeParams>((ref, params) async {
  final repository = ref.watch(cakeRepositoryProvider);
  return repository.getCakesForTheater(
    theaterId: params.theaterId,
    limit: params.limit,
    category: params.category,
  );
});

/// Provider for getting quick select cakes (limited for checkout)
final quickSelectCakesProvider = FutureProvider.family<List<CakeModel>, String>((ref, theaterId) async {
  final repository = ref.watch(cakeRepositoryProvider);
  return repository.getQuickSelectCakes(theaterId: theaterId);
});

/// Provider for getting cake categories for a theater
final cakeCategoriesProvider = FutureProvider.family<List<String>, String>((ref, theaterId) async {
  final repository = ref.watch(cakeRepositoryProvider);
  return repository.getCakeCategoriesForTheater(theaterId);
});

/// Provider for getting a specific cake by ID
final cakeByIdProvider = FutureProvider.family<CakeModel?, String>((ref, cakeId) async {
  final repository = ref.watch(cakeRepositoryProvider);
  return repository.getCakeById(cakeId);
});

/// Parameters for cake search
class CakeSearchParams {
  final String theaterId;
  final String query;
  final String? category;

  CakeSearchParams({
    required this.theaterId,
    required this.query,
    this.category,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CakeSearchParams &&
        other.theaterId == theaterId &&
        other.query == query &&
        other.category == category;
  }

  @override
  int get hashCode => theaterId.hashCode ^ query.hashCode ^ category.hashCode;
}

/// Provider for searching cakes
final cakeSearchProvider = FutureProvider.family<List<CakeModel>, CakeSearchParams>((ref, params) async {
  final repository = ref.watch(cakeRepositoryProvider);
  return repository.searchCakes(
    theaterId: params.theaterId,
    query: params.query,
    category: params.category,
  );
});

/// State provider for selected category
final selectedCakeCategoryProvider = StateProvider<String>((ref) => 'All');

/// State provider for search query
final cakeSearchQueryProvider = StateProvider<String>((ref) => '');

/// State provider for selected cakes in checkout (cake ID -> quantity)
final selectedCakesProvider = StateProvider<Map<String, int>>((ref) => {});

/// Computed provider for total cake cost
final cakesTotalCostProvider = Provider<double>((ref) {
  final selectedCakes = ref.watch(selectedCakesProvider);
  // Note: This would need actual cake data to calculate cost
  // For now, returning 0, will be computed when cakes are loaded
  return 0.0;
});