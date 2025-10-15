import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/features/home/models/category_model.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';

/// Cached categories provider with 5-minute cache
final cachedCategoriesProvider = FutureProvider.autoDispose<List<CategoryModel>>((ref) async {
  // Keep the cache alive for 5 minutes
  ref.keepAlive();
  final timer = Timer(const Duration(minutes: 5), () {
    ref.invalidateSelf();
  });
  
  ref.onDispose(() => timer.cancel());
  
  // Fetch from the original provider
  return ref.watch(categoriesProvider.future);
});

/// Cached featured services provider with lazy loading and pagination
class CachedFeaturedServicesNotifier extends StateNotifier<AsyncValue<List<ServiceListingModel>>> {
  final Ref ref;
  List<ServiceListingModel> _cachedServices = [];
  int _currentPage = 0;
  static const int _pageSize = 6;
  bool _hasMore = true;
  DateTime? _lastFetch;
  static const Duration _cacheExpiry = Duration(minutes: 10);

  CachedFeaturedServicesNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      // Check if we have valid cached data
      if (_isDataValid()) {
        state = AsyncValue.data(_cachedServices);
        return;
      }

      // Load fresh data
      await _loadPage(0, reset: true);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  bool _isDataValid() {
    return _cachedServices.isNotEmpty && 
           _lastFetch != null && 
           DateTime.now().difference(_lastFetch!) < _cacheExpiry;
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    try {
      await _loadPage(_currentPage + 1);
    } catch (error) {
      // Don't update state on error when loading more, just log it
      print('Error loading more services: $error');
    }
  }

  Future<void> refresh() async {
    _currentPage = 0;
    _hasMore = true;
    await _loadPage(0, reset: true);
  }

  Future<void> _loadPage(int page, {bool reset = false}) async {
    final repository = ref.read(homeRepositoryProvider);
    
    try {
      final newServices = await repository.getFeaturedServices(
        limit: _pageSize,
        offset: page * _pageSize,
      );

      if (reset) {
        _cachedServices = newServices;
      } else {
        _cachedServices.addAll(newServices);
      }

      _currentPage = page;
      _hasMore = newServices.length == _pageSize;
      _lastFetch = DateTime.now();
      
      state = AsyncValue.data(List.from(_cachedServices));
    } catch (error, stackTrace) {
      if (reset || _cachedServices.isEmpty) {
        state = AsyncValue.error(error, stackTrace);
      }
      rethrow;
    }
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => state.isLoading && _cachedServices.isNotEmpty;
}

final cachedFeaturedServicesProvider = StateNotifierProvider<CachedFeaturedServicesNotifier, AsyncValue<List<ServiceListingModel>>>((ref) {
  return CachedFeaturedServicesNotifier(ref);
});

/// Cached services by category with lazy loading
final cachedServicesByCategoryProvider = FutureProvider.family.autoDispose<List<ServiceListingModel>, String>((ref, categoryName) async {
  // Keep cache for 5 minutes
  ref.keepAlive();
  final timer = Timer(const Duration(minutes: 5), () {
    ref.invalidateSelf();
  });
  
  ref.onDispose(() => timer.cancel());
  
  // Fetch from repository
  final repository = ref.read(homeRepositoryProvider);
  return repository.getServicesByCategory(categoryName: categoryName);
});

/// Memory-efficient service detail provider with caching
final cachedServiceDetailProvider = FutureProvider.family.autoDispose<ServiceListingModel?, String>((ref, serviceId) async {
  // Keep cache for 10 minutes since service details don't change often
  ref.keepAlive();
  final timer = Timer(const Duration(minutes: 10), () {
    ref.invalidateSelf();
  });
  
  ref.onDispose(() => timer.cancel());
  
  // Check if we already have this service in featured services cache
  final featuredServicesState = ref.read(cachedFeaturedServicesProvider);
  if (featuredServicesState.hasValue) {
    final cachedService = featuredServicesState.value!
        .where((service) => service.id == serviceId)
        .firstOrNull;
    if (cachedService != null) {
      return cachedService;
    }
  }
  
  // Fetch from repository if not in cache
  final repository = ref.read(homeRepositoryProvider);
  return repository.getServiceById(serviceId);
});

/// Optimized home screen data provider with intelligent caching
final optimizedHomeScreenDataProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  // Use cached providers for better performance
  final categories = await ref.watch(cachedCategoriesProvider.future);
  final featuredServicesValue = ref.watch(cachedFeaturedServicesProvider);
  final featuredServices = featuredServicesValue.when(
    data: (data) => data,
    loading: () => <ServiceListingModel>[],
    error: (_, __) => <ServiceListingModel>[],
  );
  
  // Use original providers for less frequently accessed data
  final popularNearby = await ref.watch(popularNearbyServicesProvider.future);
  final dailyQuote = await ref.watch(dailyQuoteProvider.future);

  return {
    'categories': categories,
    'featuredServices': featuredServices,
    'popularNearbyServices': popularNearby,
    'dailyQuote': dailyQuote,
  };
});

// Extension to add firstOrNull method if not available
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}