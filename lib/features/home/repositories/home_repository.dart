import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/features/home/models/quote_model.dart';
import 'package:sylonow_user/features/home/models/vendor_model.dart';
import 'package:sylonow_user/features/home/models/service_type_model.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';
import 'package:sylonow_user/features/home/models/category_model.dart';
import 'package:sylonow_user/core/utils/location_utils.dart';

/// Repository class for handling home screen data operations
/// 
/// This class provides methods to fetch data for different sections
/// of the home screen from Supabase database
class HomeRepository {
  /// Supabase client instance
  final SupabaseClient _supabase;

  /// Creates a new HomeRepository instance
  const HomeRepository(this._supabase);

  /// Fetches a random daily quote from the quotes table
  /// 
  /// Returns a random motivational quote or null if not found
  Future<QuoteModel?> getDailyQuote() async {
    try {
      final response = await _supabase
          .rpc('get_random_quote');

      if (response != null) {
        return QuoteModel.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch daily quote: $e');
    }
  }

  /// Fetches featured partners/vendors
  /// 
  /// Returns a list of verified and active vendors
  /// Limited to [limit] number of vendors (default: 10)
  Future<List<VendorModel>> getFeaturedPartners({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('vendors')
          .select()
          .eq('is_active', true)
          .eq('is_verified', true)
          .order('rating', ascending: false)
          .order('total_jobs_completed', ascending: false)
          .limit(limit);

      return response
          .map<VendorModel>((data) => VendorModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch featured partners: $e');
    }
  }

  /// Fetches service categories/types
  /// 
  /// Returns a list of active service types
  /// Limited to [limit] number of categories (default: 8)
  Future<List<ServiceTypeModel>> getServiceCategories({int limit = 8}) async {
    try {
      final response = await _supabase
          .from('service_types')
          .select()
          .eq('is_active', true)
          .order('name')
          .limit(limit);

      return response
          .map<ServiceTypeModel>((data) => ServiceTypeModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch service categories: $e');
    }
  }

  /// Fetches featured services
  /// 
  /// Returns a list of featured and active service listings
  /// Limited to [limit] number of services (default: 10)
  Future<List<ServiceListingModel>> getFeaturedServices(
      {int limit = 10, int offset = 0}) async {
    try {
      final response = await _supabase
          .from('service_listings')
          .select()
          .eq('is_featured', true)
          .eq('is_active', true)
          .limit(limit)
          .range(offset, offset + limit - 1);

      if (response.isEmpty) {
        return [];
      }

      return response
          .map((item) => ServiceListingModel.fromJson(item))
          .toList();
    } catch (e) {
      // TODO: Add robust error handling, e.g., logging
      rethrow;
    }
  }

  /// Fetches private theater services
  /// 
  /// Returns a list of private theater related service listings
  /// Limited to [limit] number of services (default: 4)
  Future<List<ServiceListingModel>> getPrivateTheaterServices({int limit = 4}) async {
    try {
      final response = await _supabase
          .from('service_listings')
          .select()
          .eq('is_active', true)
          .ilike('category', '%theater%')
          .order('created_at', ascending: false)
          .limit(limit);

      return response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch private theater services: $e');
    }
  }

  /// Fetches popular nearby services
  /// 
  /// Returns a list of popular services based on ratings and reviews
  /// This is a simplified version - in production, you'd use user location
  /// Limited to [limit] number of services (default: 6)
  Future<List<ServiceListingModel>> getPopularNearbyServices({int limit = 6}) async {
    try {
      print('🔍 Repository: getPopularNearbyServices (fallback) called');
      
      final response = await _supabase
          .from('service_listings')
          .select('''
            *,
            vendors(
              rating,
              total_reviews,
              total_jobs_completed
            )
          ''')
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(limit);

      print('🔍 Repository: Fallback service count: ${(response as List).length}');

      return response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();
    } catch (e) {
      print('🔍 Repository: Error in getPopularNearbyServices: $e');
      throw Exception('Failed to fetch popular nearby services: $e');
    }
  }

  /// Fetches a specific service by ID
  /// 
  /// Returns the service details if found, null otherwise
  Future<ServiceListingModel?> getServiceById(String serviceId) async {
    try {
      final response = await _supabase
          .from('service_listings')
          .select('''
            *,
            vendors(
              id,
              business_name,
              full_name,
              rating,
              total_reviews,
              total_jobs_completed,
              profile_image_url,
              location
            )
          ''')
          .eq('id', serviceId)
          .eq('is_active', true)
          .single();

      return ServiceListingModel.fromJson(response);
    } catch (e) {
      // Return null if service not found or any error occurs
      return null;
    }
  }

  /// Fetches related services by category
  /// 
  /// Returns a list of services in the same category, excluding the current service
  /// If no services found in same category, returns other services
  Future<List<ServiceListingModel>> getRelatedServices({
    required String currentServiceId,
    String? category,
    int limit = 4,
  }) async {
    try {
      List<ServiceListingModel> results = [];

      // First, try to get services in the same category
      if (category != null && category.isNotEmpty) {
        final categoryResponse = await _supabase
            .from('service_listings')
            .select('''
              *,
              vendors(
                id,
                business_name,
                full_name,
                rating,
                total_reviews
              )
            ''')
            .eq('is_active', true)
            .eq('category', category)
            .neq('id', currentServiceId)
            .limit(limit)
            .order('rating', ascending: false);

        results = categoryResponse
            .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
            .toList();
      }

      // If no services found in same category, get any other services
      if (results.isEmpty) {
        final generalResponse = await _supabase
            .from('service_listings')
            .select('''
              *,
              vendors(
                id,
                business_name,
                full_name,
                rating,
                total_reviews
              )
            ''')
            .eq('is_active', true)
            .neq('id', currentServiceId)
            .limit(limit)
            .order('rating', ascending: false);

        results = generalResponse
            .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
            .toList();
      }

      return results;
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  /// Fetches all categories
  /// 
  /// Returns a list of active categories sorted by sort_order
  Future<List<CategoryModel>> getCategories({int? limit}) async {
    try {
      var query = _supabase
          .from('categories')
          .select()
          .eq('is_active', true)
          .order('sort_order');

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;

      return response
          .map<CategoryModel>((data) => CategoryModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  /// Fetches services by category
  /// 
  /// Returns a list of services filtered by category
  Future<List<ServiceListingModel>> getServicesByCategory({
    required String categoryName,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('service_listings')
          .select('''
            *,
            vendors(
              id,
              business_name,
              full_name,
              rating,
              total_reviews
            )
          ''')
          .eq('category', categoryName)
          .eq('is_active', true)
          .limit(limit)
          .range(offset, offset + limit - 1)
          .order('rating', ascending: false);

      return response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch services by category: $e');
    }
  }

  /// Fetches services by decoration type
  /// 
  /// Returns a list of services filtered by decoration type ('inside', 'outside', or 'both')
  /// Used to differentiate between inside and outside decoration services
  Future<List<ServiceListingModel>> getServicesByDecorationType({
    required String decorationType,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('service_listings')
          .select('''
            *,
            vendors(
              id,
              business_name,
              full_name,
              rating,
              total_reviews
            )
          ''')
          .eq('is_active', true)
          .or('decoration_type.eq.$decorationType,decoration_type.eq.both')
          .limit(limit)
          .range(offset, offset + limit - 1)
          .order('rating', ascending: false);

      return response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch services by decoration type: $e');
    }
  }

  /// Fetches featured services by decoration type
  /// 
  /// Returns a list of featured services filtered by decoration type
  Future<List<ServiceListingModel>> getFeaturedServicesByDecorationType({
    required String decorationType,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('service_listings')
          .select('''
            *,
            vendors(
              id,
              business_name,
              full_name,
              rating,
              total_reviews
            )
          ''')
          .eq('is_featured', true)
          .eq('is_active', true)
          .or('decoration_type.eq.$decorationType,decoration_type.eq.both')
          .limit(limit)
          .range(offset, offset + limit - 1)
          .order('rating', ascending: false);

      return response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch featured services by decoration type: $e');
    }
  }

  /// Fetches popular nearby services by decoration type
  /// 
  /// Returns a list of popular services filtered by decoration type
  Future<List<ServiceListingModel>> getPopularNearbyServicesByDecorationType({
    required String decorationType,
    int limit = 6,
  }) async {
    try {
      final response = await _supabase
          .from('service_listings')
          .select('''
            *,
            vendors!inner(
              rating,
              total_reviews,
              total_jobs_completed
            )
          ''')
          .eq('is_active', true)
          .or('decoration_type.eq.$decorationType,decoration_type.eq.both')
          .order('vendors.rating', ascending: false)
          .order('vendors.total_reviews', ascending: false)
          .limit(limit);

      return response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch popular nearby services by decoration type: $e');
    }
  }

  /// Fetches all home screen data at once
  /// 
  /// Returns a map containing all the home screen data
  /// This is useful for loading all sections simultaneously
  Future<Map<String, dynamic>> getHomeScreenData() async {
    try {
      final results = await Future.wait([
        getDailyQuote(),
        getFeaturedPartners(),
        getServiceCategories(),
        getFeaturedServices(),
        getPrivateTheaterServices(),
        getPopularNearbyServices(),
        getCategories(limit: 8), // Add categories to home screen data
      ]);

      return {
        'dailyQuote': results[0] as QuoteModel?,
        'featuredPartners': results[1] as List<VendorModel>,
        'serviceCategories': results[2] as List<ServiceTypeModel>,
        'featuredServices': results[3] as List<ServiceListingModel>,
        'privateTheaterServices': results[4] as List<ServiceListingModel>,
        'popularNearbyServices': results[5] as List<ServiceListingModel>,
        'categories': results[6] as List<CategoryModel>,
      };
    } catch (e) {
      throw Exception('Failed to fetch home screen data: $e');
    }
  }

  /// Fetches home screen data filtered by decoration type
  /// 
  /// Returns a map containing home screen data filtered for specific decoration type
  Future<Map<String, dynamic>> getHomeScreenDataByDecorationType(String decorationType) async {
    try {
      final results = await Future.wait([
        getDailyQuote(),
        getFeaturedPartners(),
        getServiceCategories(),
        getFeaturedServicesByDecorationType(decorationType: decorationType),
        getPrivateTheaterServices(),
        getPopularNearbyServicesByDecorationType(decorationType: decorationType),
        getCategories(limit: 8),
      ]);

      return {
        'dailyQuote': results[0] as QuoteModel?,
        'featuredPartners': results[1] as List<VendorModel>,
        'serviceCategories': results[2] as List<ServiceTypeModel>,
        'featuredServices': results[3] as List<ServiceListingModel>,
        'privateTheaterServices': results[4] as List<ServiceListingModel>,
        'popularNearbyServices': results[5] as List<ServiceListingModel>,
        'categories': results[6] as List<CategoryModel>,
      };
    } catch (e) {
      throw Exception('Failed to fetch home screen data by decoration type: $e');
    }
  }

  /// Apply location-based calculations to a list of services
  /// 
  /// Calculates distance from user location and adjusts prices for services > 10km away
  List<ServiceListingModel> _applyLocationCalculations({
    required List<ServiceListingModel> services,
    required double? userLat,
    required double? userLon,
    bool sortByDistance = false,
    double? radiusFilter,
  }) {
    if (userLat == null || userLon == null) {
      return services;
    }

    // Apply location calculations to each service
    List<ServiceListingModel> processedServices = services
        .where((service) => service.latitude != null && service.longitude != null)
        .map((service) => service.copyWithLocationData(
              userLat: userLat,
              userLon: userLon,
            ))
        .toList();

    // Filter by radius if specified
    if (radiusFilter != null) {
      processedServices = processedServices
          .where((service) => service.distanceKm != null && service.distanceKm! <= radiusFilter)
          .toList();
    }

    // Sort by distance if requested
    if (sortByDistance) {
      processedServices.sort((a, b) => 
          (a.distanceKm ?? double.infinity).compareTo(b.distanceKm ?? double.infinity));
    }

    return processedServices;
  }

  /// Fetches services with location-based filtering and pricing
  /// 
  /// Returns services sorted by distance with location-based price adjustments
  Future<List<ServiceListingModel>> getServicesWithLocation({
    required double userLat,
    required double userLon,
    String? decorationType,
    String? category,
    double? radiusKm,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      var query = _supabase
          .from('service_listings')
          .select('''
            *,
            vendors(
              id,
              business_name,
              full_name,
              rating,
              total_reviews
            )
          ''')
          .eq('is_active', true);

      // Apply decoration type filter
      if (decorationType != null) {
        query = query.or('decoration_type.eq.$decorationType,decoration_type.eq.both');
      }

      // Apply category filter
      if (category != null) {
        query = query.eq('category', category);
      }

      final response = await query
          .limit(limit)
          .range(offset, offset + limit - 1);

      final services = response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();

      // Apply location calculations
      return _applyLocationCalculations(
        services: services,
        userLat: userLat,
        userLon: userLon,
        sortByDistance: true,
        radiusFilter: radiusKm,
      );
    } catch (e) {
      throw Exception('Failed to fetch services with location: $e');
    }
  }

  /// Fetches services by decoration type with location calculations
  /// 
  /// Enhanced version of getServicesByDecorationType with location features
  Future<List<ServiceListingModel>> getServicesByDecorationTypeWithLocation({
    required String decorationType,
    required double userLat,
    required double userLon,
    double? radiusKm,
    int limit = 10,
    int offset = 0,
  }) async {
    return getServicesWithLocation(
      userLat: userLat,
      userLon: userLon,
      decorationType: decorationType,
      radiusKm: radiusKm,
      limit: limit,
      offset: offset,
    );
  }

  /// Fetches featured services with location calculations
  /// 
  /// Enhanced version of getFeaturedServices with location features
  Future<List<ServiceListingModel>> getFeaturedServicesWithLocation({
    required double userLat,
    required double userLon,
    String? decorationType,
    double? radiusKm,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      var query = _supabase
          .from('service_listings')
          .select('''
            *,
            vendors(
              id,
              business_name,
              full_name,
              rating,
              total_reviews
            )
          ''')
          .eq('is_featured', true)
          .eq('is_active', true);

      // Apply decoration type filter
      if (decorationType != null) {
        query = query.or('decoration_type.eq.$decorationType,decoration_type.eq.both');
      }

      final response = await query
          .limit(limit)
          .range(offset, offset + limit - 1);

      final services = response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();

      // Apply location calculations
      return _applyLocationCalculations(
        services: services,
        userLat: userLat,
        userLon: userLon,
        sortByDistance: true,
        radiusFilter: radiusKm,
      );
    } catch (e) {
      throw Exception('Failed to fetch featured services with location: $e');
    }
  }

  /// Fetches popular nearby services with enhanced location calculations
  /// 
  /// Enhanced version that actually considers user location for "nearby"
  Future<List<ServiceListingModel>> getPopularNearbyServicesWithLocation({
    required double userLat,
    required double userLon,
    String? decorationType,
    double radiusKm = 25.0, // Default 25km radius for "nearby"
    int limit = 6,
  }) async {
    try {
      print('🔍 Repository: getPopularNearbyServicesWithLocation called with lat: $userLat, lon: $userLon, radius: $radiusKm');
      
      var query = _supabase
          .from('service_listings')
          .select('''
            *,
            vendors(
              rating,
              total_reviews,
              total_jobs_completed
            )
          ''')
          .eq('is_active', true);

      // Apply decoration type filter
      if (decorationType != null) {
        query = query.or('decoration_type.eq.$decorationType,decoration_type.eq.both');
      }

      print('🔍 Repository: Executing query...');
      final response = await query
          .order('created_at', ascending: false) // Order by creation date since vendor data might be empty
          .limit(limit * 3); // Fetch more to have options after radius filtering

      print('🔍 Repository: Raw response count: ${(response as List).length}');

      final services = response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();

      print('🔍 Repository: Parsed services count: ${services.length}');

      // Apply location calculations with radius filter
      final locationFilteredServices = _applyLocationCalculations(
        services: services,
        userLat: userLat,
        userLon: userLon,
        sortByDistance: true,
        radiusFilter: radiusKm,
      );

      print('🔍 Repository: Location filtered services count: ${locationFilteredServices.length}');

      // Return only the requested limit
      final result = locationFilteredServices.take(limit).toList();
      print('🔍 Repository: Final result count: ${result.length}');
      return result;
    } catch (e) {
      print('🔍 Repository: Error in getPopularNearbyServicesWithLocation: $e');
      throw Exception('Failed to fetch popular nearby services with location: $e');
    }
  }
} 