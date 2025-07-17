import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:sylonow_user/features/theater/models/private_theater_model.dart';
import 'package:sylonow_user/features/theater/repositories/theater_repository.dart';

// Repository provider
final theaterRepositoryProvider = Provider<TheaterRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return TheaterRepository(supabase);
});

// Theater list provider
final theatersProvider = FutureProvider<List<PrivateTheaterModel>>((ref) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaters();
});

// Theater by ID provider
final theaterByIdProvider = FutureProvider.family<PrivateTheaterModel?, String>((ref, id) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterById(id);
});

// Search theaters provider
final searchTheatersProvider = FutureProvider.family<List<PrivateTheaterModel>, String>((ref, query) async {
  if (query.isEmpty) return [];
  
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.searchTheaters(query);
});

// Nearby theaters provider
final nearbyTheatersProvider = FutureProvider.family<List<PrivateTheaterModel>, Map<String, double>>((ref, location) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getNearbyTheaters(
    latitude: location['latitude']!,
    longitude: location['longitude']!,
    radiusKm: location['radius'] ?? 10.0,
  );
});