import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/addon_model.dart';

class AddonService {
  final SupabaseClient _supabase;

  AddonService(this._supabase);

  /// Get all active addons
  Future<List<AddonModel>> getActiveAddons() async {
    try {
      final response = await _supabase
          .from('add_ons')
          .select('*')
          .eq('is_active', true)
          .order('name', ascending: true);

      return response.map((addonData) {
        return AddonModel.fromJson(addonData);
      }).toList();
    } catch (e) {
      print('Error fetching active addons: $e');
      return [];
    }
  }

  /// Get addon details by their IDs
  Future<List<AddonModel>> getAddonsByIds(List<String> addonIds) async {
    try {
      if (addonIds.isEmpty) {
        return [];
      }

      print('Fetching addons for IDs: $addonIds');

      final response = await _supabase
          .from('add_ons')
          .select('*')
          .inFilter('id', addonIds)
          .eq('is_active', true);

      if (response.isEmpty) {
        print('No addons found for IDs: $addonIds');
        return [];
      }

      final addons = response.map((addonData) {
        return AddonModel.fromJson(addonData);
      }).toList();

      print('Successfully fetched ${addons.length} addons');
      return addons;
    } catch (e, stackTrace) {
      print('Error fetching addons by IDs: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get all addons for a specific theater
  Future<List<AddonModel>> getAddonsByTheaterId(String theaterId) async {
    try {
      final response = await _supabase
          .from('add_ons')
          .select('*')
          .eq('theater_id', theaterId)
          .eq('is_active', true)
          .order('name', ascending: true);

      return response.map((addonData) {
        return AddonModel.fromJson(addonData);
      }).toList();
    } catch (e) {
      print('Error fetching addons by theater ID: $e');
      return [];
    }
  }

  /// Get addon by ID
  Future<AddonModel?> getAddonById(String addonId) async {
    try {
      final response = await _supabase
          .from('add_ons')
          .select('*')
          .eq('id', addonId)
          .eq('is_active', true)
          .single();

      return AddonModel.fromJson(response);
    } catch (e) {
      print('Error fetching addon by ID: $e');
      return null;
    }
  }

  /// Get addons by category
  Future<List<AddonModel>> getAddonsByCategory(String category) async {
    try {
      final response = await _supabase
          .from('add_ons')
          .select('*')
          .eq('category', category)
          .eq('is_active', true)
          .order('price', ascending: true);

      return response.map((addonData) {
        return AddonModel.fromJson(addonData);
      }).toList();
    } catch (e) {
      print('Error fetching addons by category: $e');
      return [];
    }
  }

  /// Search addons by name
  Future<List<AddonModel>> searchAddons(String query) async {
    try {
      final response = await _supabase
          .from('add_ons')
          .select('*')
          .ilike('name', '%$query%')
          .eq('is_active', true)
          .order('name', ascending: true);

      return response.map((addonData) {
        return AddonModel.fromJson(addonData);
      }).toList();
    } catch (e) {
      print('Error searching addons: $e');
      return [];
    }
  }
}