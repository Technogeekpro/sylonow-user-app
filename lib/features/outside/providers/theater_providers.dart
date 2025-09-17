import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/theater_screen_model.dart';
import '../services/theater_service.dart';

// Service provider
final theaterServiceProvider = Provider<TheaterService>((ref) {
  return TheaterService();
});

// Theater screens provider with optimized query
final theaterScreensProvider = FutureProvider<List<TheaterScreen>>((ref) async {
  final service = ref.read(theaterServiceProvider);
  return await service.fetchTheaterScreensWithPricing();
});

// Filtered screens provider for better performance
final filteredTheaterScreensProvider = Provider.family<List<TheaterScreen>, FilterParams>((ref, params) {
  final screens = ref.watch(theaterScreensProvider).value ?? [];
  
  return screens.where((screen) {
    // Search filter
    final matchesSearch = params.searchQuery.isEmpty ||
        screen.screenName.toLowerCase().contains(params.searchQuery.toLowerCase()) ||
        (screen.description?.toLowerCase().contains(params.searchQuery.toLowerCase()) ?? false);

    // Category filter
    final matchesFilter = params.selectedFilter == 'All' || 
        _applyFilter(screen, params.selectedFilter);

    return matchesSearch && matchesFilter;
  }).toList();
});

bool _applyFilter(TheaterScreen screen, String filter) {
  switch (filter) {
    case 'High Rating':
      return screen.capacity >= 20; // High capacity screens
    case 'Budget Friendly':
      return screen.hourlyRate <= 1000;
    case 'Premium':
      return screen.hourlyRate > 2000;
    default:
      return true;
  }
}

// Filter parameters class
class FilterParams {
  final String searchQuery;
  final String selectedFilter;

  const FilterParams({
    required this.searchQuery,
    required this.selectedFilter,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterParams &&
        other.searchQuery == searchQuery &&
        other.selectedFilter == selectedFilter;
  }

  @override
  int get hashCode => searchQuery.hashCode ^ selectedFilter.hashCode;
}