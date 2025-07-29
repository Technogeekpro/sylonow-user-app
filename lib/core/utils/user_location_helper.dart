import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../features/address/providers/address_providers.dart';
import '../providers/core_providers.dart';

/// Helper class to get user location coordinates for location-based features
class UserLocationHelper {
  /// Get user coordinates from selectedAddressProvider or current location
  /// 
  /// Returns a map with 'latitude' and 'longitude' keys, or null if location unavailable
  static Future<Map<String, double>?> getUserCoordinates(WidgetRef ref) async {
    try {
      print('🎯 getUserCoordinates: Starting...');
      
      // First try to get coordinates from selectedAddress if it has them
      final selectedAddress = ref.read(selectedAddressProvider);
      print('🎯 getUserCoordinates: selectedAddress = $selectedAddress');
      
      // For now, we'll get current location using the location service
      // In the future, you might want to store coordinates in the address model
      final locationService = ref.read(locationServiceProvider);
      print('🎯 getUserCoordinates: locationService obtained');
      
      // Check if we have permission
      print('🎯 getUserCoordinates: Checking permissions...');
      final permission = await locationService.getPermissionStatus();
      print('🎯 getUserCoordinates: Permission status = $permission');
      
      if (permission != LocationPermission.whileInUse && 
          permission != LocationPermission.always) {
        print('🎯 getUserCoordinates: Insufficient permissions, returning null');
        return null;
      }
      
      // Get current position
      print('🎯 getUserCoordinates: Getting current location...');
      final position = await locationService.getCurrentLocation();
      print('🎯 getUserCoordinates: Position = $position');
      
      if (position != null) {
        final coordinates = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
        print('🎯 getUserCoordinates: Returning coordinates = $coordinates');
        return coordinates;
      }
      
      print('🎯 getUserCoordinates: Position is null, returning null');
      return null;
    } catch (e) {
      print('🎯 getUserCoordinates: Error getting user coordinates: $e');
      return null;
    }
  }

  /// Check if user has granted location permissions
  static Future<bool> hasLocationPermission(WidgetRef ref) async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final permission = await locationService.getPermissionStatus();
      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Get location parameters for providers
  /// 
  /// Returns parameters ready to be passed to location-based providers
  static Future<Map<String, dynamic>?> getLocationParams(
    WidgetRef ref, {
    String? decorationType,
    double? radiusKm,
  }) async {
    try {
      print('🎯 Getting location params...');
      final coordinates = await getUserCoordinates(ref);
      print('🎯 Location coordinates result: $coordinates');
      
      if (coordinates == null) {
        print('🎯 No coordinates available, returning null');
        return null;
      }

      final params = {
        'userLat': coordinates['latitude']!,
        'userLon': coordinates['longitude']!,
        if (decorationType != null) 'decorationType': decorationType,
        if (radiusKm != null) 'radiusKm': radiusKm,
      };
      
      print('🎯 Location params created: $params');
      return params;
    } catch (e) {
      print('🎯 Error in getLocationParams: $e');
      return null;
    }
  }

  /// Helper to create location parameters for decoration type providers
  static Future<Map<String, dynamic>?> getDecorationTypeLocationParams(
    WidgetRef ref,
    String decorationType, {
    double? radiusKm,
  }) async {
    return getLocationParams(
      ref,
      decorationType: decorationType,
      radiusKm: radiusKm,
    );
  }
}