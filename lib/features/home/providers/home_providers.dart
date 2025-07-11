import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/features/home/repositories/home_repository.dart';
import 'package:sylonow_user/features/home/repositories/quote_repository.dart';
import 'package:sylonow_user/features/home/models/quote_model.dart';
import 'package:sylonow_user/features/home/models/vendor_model.dart';
import 'package:sylonow_user/features/home/models/service_type_model.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';
import 'package:sylonow_user/features/home/models/category_model.dart';

/// Provider for Supabase client
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for home repository
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return HomeRepository(supabase);
});

/// Provider for quote repository
final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  return QuoteRepository();
});

/// Provider for daily quote
final dailyQuoteProvider = FutureProvider<QuoteModel?>((ref) async {
  final repository = ref.watch(quoteRepositoryProvider);
  return repository.getTrulyRandomQuote();
});

/// Provider for featured partners
final featuredPartnersProvider = FutureProvider<List<VendorModel>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getFeaturedPartners();
});

/// Provider for service categories
final serviceCategoriesProvider = FutureProvider<List<ServiceTypeModel>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getServiceCategories();
});

/// State for featured services pagination
class FeaturedServicesState {
  final List<ServiceListingModel> services;
  final bool hasMore;
  final int page;

  FeaturedServicesState({
    this.services = const [],
    this.hasMore = true,
    this.page = 0,
  });

  FeaturedServicesState copyWith({
    List<ServiceListingModel>? services,
    bool? hasMore,
    int? page,
  }) {
    return FeaturedServicesState(
      services: services ?? this.services,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

/// Notifier for featured services
class FeaturedServicesNotifier extends StateNotifier<FeaturedServicesState> {
  final HomeRepository _repository;
  static const int _pageSize = 5;
  bool _isLoading = false;

  FeaturedServicesNotifier(this._repository) : super(FeaturedServicesState()) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (!state.hasMore || _isLoading) return;

    _isLoading = true;

    try {
      final newServices = await _repository.getFeaturedServices(
        limit: _pageSize,
        offset: state.page * _pageSize,
      );

      if (newServices.length < _pageSize) {
        state = state.copyWith(hasMore: false);
      }

      state = state.copyWith(
        services: [...state.services, ...newServices],
        page: state.page + 1,
      );
    } catch (e) {
      // Handle error appropriately
    } finally {
      _isLoading = false;
    }
  }
}

/// Provider for featured services with pagination
final featuredServicesProvider =
    StateNotifierProvider<FeaturedServicesNotifier, FeaturedServicesState>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return FeaturedServicesNotifier(repository);
});

/// Provider for private theater services
final privateTheaterServicesProvider = FutureProvider<List<ServiceListingModel>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getPrivateTheaterServices();
});

/// Provider for popular nearby services
final popularNearbyServicesProvider = FutureProvider<List<ServiceListingModel>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getPopularNearbyServices();
});

/// Provider for all home screen data
final homeScreenDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getHomeScreenData();
});

/// Provider for categories
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getCategories();
});

/// Provider for services by category
final servicesByCategoryProvider = FutureProvider.family<List<ServiceListingModel>, String>((ref, categoryName) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getServicesByCategory(categoryName: categoryName);
}); 