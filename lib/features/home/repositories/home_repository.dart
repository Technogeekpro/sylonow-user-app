import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/features/home/models/quote_model.dart';
import 'package:sylonow_user/features/home/models/vendor_model.dart';
import 'package:sylonow_user/features/home/models/service_type_model.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';

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
          .order('vendors.rating', ascending: false)
          .order('vendors.total_reviews', ascending: false)
          .limit(limit);

      return response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();
    } catch (e) {
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
              owner_name,
              rating,
              total_reviews,
              total_jobs_completed,
              profile_picture_url,
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
  Future<List<ServiceListingModel>> getRelatedServices({
    required String currentServiceId,
    String? category,
    int limit = 4,
  }) async {
    try {
      var query = _supabase
          .from('service_listings')
          .select('''
            *,
            vendors(
              id,
              business_name,
              owner_name,
              rating,
              total_reviews
            )
          ''')
          .eq('is_active', true)
          .neq('id', currentServiceId) // Exclude current service
          .limit(limit);

      // Filter by category if provided
      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }

      final response = await query.order('rating', ascending: false);

      return response
          .map<ServiceListingModel>((data) => ServiceListingModel.fromJson(data))
          .toList();
    } catch (e) {
      // Return empty list on error
      return [];
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
      ]);

      return {
        'dailyQuote': results[0] as QuoteModel?,
        'featuredPartners': results[1] as List<VendorModel>,
        'serviceCategories': results[2] as List<ServiceTypeModel>,
        'featuredServices': results[3] as List<ServiceListingModel>,
        'privateTheaterServices': results[4] as List<ServiceListingModel>,
        'popularNearbyServices': results[5] as List<ServiceListingModel>,
      };
    } catch (e) {
      throw Exception('Failed to fetch home screen data: $e');
    }
  }
} 