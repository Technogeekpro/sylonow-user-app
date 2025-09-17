import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/screen_package_model.dart';

class ScreenPackageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all packages available for a specific screen
  Future<List<ScreenPackageModel>> getPackagesByScreenId(String screenId) async {
    try {
      print('Fetching packages for screen: $screenId');

      final response = await _supabase
          .from('screen_packages')
          .select('*')
          .eq('screen_id', screenId)
          .order('package_price', ascending: true);

      if (response.isEmpty) {
        print('No packages found for screen: $screenId');
        return [];
      }

      final packages = response.map((packageData) {
        return ScreenPackageModel.fromJson(packageData);
      }).toList();

      print('Successfully fetched ${packages.length} packages');
      return packages;
    } catch (e, stackTrace) {
      print('Error fetching screen packages: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get a specific package by ID
  Future<ScreenPackageModel?> getPackageById(String packageId) async {
    try {
      final response = await _supabase
          .from('screen_packages')
          .select('*')
          .eq('id', packageId)
          .single();

      return ScreenPackageModel.fromJson(response);
    } catch (e) {
      print('Error fetching package by ID: $e');
      return null;
    }
  }

  /// Get featured/popular packages (you can modify the logic as needed)
  Future<List<ScreenPackageModel>> getFeaturedPackages({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('screen_packages')
          .select('*')
          .order('created_at', ascending: false)
          .limit(limit);

      return response.map((packageData) {
        return ScreenPackageModel.fromJson(packageData);
      }).toList();
    } catch (e) {
      print('Error fetching featured packages: $e');
      return [];
    }
  }

  /// Get packages within a price range
  Future<List<ScreenPackageModel>> getPackagesByPriceRange({
    required double minPrice,
    required double maxPrice,
    String? screenId,
  }) async {
    try {
      var query = _supabase
          .from('screen_packages')
          .select('*')
          .gte('package_price', minPrice)
          .lte('package_price', maxPrice);

      if (screenId != null) {
        query = query.eq('screen_id', screenId);
      }

      final response = await query.order('package_price', ascending: true);

      return response.map((packageData) {
        return ScreenPackageModel.fromJson(packageData);
      }).toList();
    } catch (e) {
      print('Error fetching packages by price range: $e');
      return [];
    }
  }

  /// Search packages by name or description
  Future<List<ScreenPackageModel>> searchPackages({
    required String query,
    String? screenId,
  }) async {
    try {
      var supabaseQuery = _supabase
          .from('screen_packages')
          .select('*')
          .or('package_name.ilike.%$query%,package_description.ilike.%$query%');

      if (screenId != null) {
        supabaseQuery = supabaseQuery.eq('screen_id', screenId);
      }

      final response = await supabaseQuery.order('package_name', ascending: true);

      return response.map((packageData) {
        return ScreenPackageModel.fromJson(packageData);
      }).toList();
    } catch (e) {
      print('Error searching packages: $e');
      return [];
    }
  }

  /// Get package statistics (helper method for analytics)
  Future<Map<String, dynamic>> getPackageStats(String screenId) async {
    try {
      final packages = await getPackagesByScreenId(screenId);
      
      if (packages.isEmpty) {
        return {
          'totalPackages': 0,
          'averagePrice': 0.0,
          'minPrice': 0.0,
          'maxPrice': 0.0,
        };
      }

      final prices = packages.map((p) => p.packagePrice).toList();
      final totalPackages = packages.length;
      final averagePrice = prices.reduce((a, b) => a + b) / totalPackages;
      final minPrice = prices.reduce((a, b) => a < b ? a : b);
      final maxPrice = prices.reduce((a, b) => a > b ? a : b);

      return {
        'totalPackages': totalPackages,
        'averagePrice': averagePrice,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
      };
    } catch (e) {
      print('Error getting package stats: $e');
      return {
        'totalPackages': 0,
        'averagePrice': 0.0,
        'minPrice': 0.0,
        'maxPrice': 0.0,
      };
    }
  }
}