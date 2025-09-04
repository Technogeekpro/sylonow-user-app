import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../features/address/providers/address_providers.dart';
import '../providers/core_providers.dart';
import '../services/logger.dart';

/// Helper class to get user location coordinates for location-based features
class UserLocationHelper {
  /// Get user coordinates from selectedAddressProvider or current location
  /// 
  /// Returns a map with 'latitude' and 'longitude' keys, or null if location unavailable
  static Future<Map<String, double>?> getUserCoordinates(WidgetRef ref) async {
    try {
      Logger.debug('getUserCoordinates: Starting...', tag: 'UserLocationHelper');
      
      // First try to get coordinates from selectedAddress if it has them
      final selectedAddress = ref.read(selectedAddressProvider);
      Logger.debug('getUserCoordinates: selectedAddress = $selectedAddress', tag: 'UserLocationHelper');
      
      // For now, we'll get current location using the location service
      // In the future, you might want to store coordinates in the address model
      final locationService = ref.read(locationServiceProvider);
      Logger.debug('getUserCoordinates: locationService obtained', tag: 'UserLocationHelper');
      
      // Check if we have permission
      Logger.debug('getUserCoordinates: Checking permissions...', tag: 'UserLocationHelper');
      final permission = await locationService.getPermissionStatus();
      Logger.debug('getUserCoordinates: Permission status = $permission', tag: 'UserLocationHelper');
      
      if (permission != LocationPermission.whileInUse && 
          permission != LocationPermission.always) {
        Logger.warning('getUserCoordinates: Insufficient permissions, returning null', tag: 'UserLocationHelper');
        return null;
      }
      
      // Get current position
      Logger.debug('getUserCoordinates: Getting current location...', tag: 'UserLocationHelper');
      final position = await locationService.getCurrentLocation();
      Logger.debug('getUserCoordinates: Position = $position', tag: 'UserLocationHelper');
      
      if (position != null) {
        final coordinates = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
        Logger.success('getUserCoordinates: Returning coordinates = $coordinates', tag: 'UserLocationHelper');
        return coordinates;
      }
      
      Logger.warning('getUserCoordinates: Position is null, returning null', tag: 'UserLocationHelper');
      return null;
    } catch (e) {
      Logger.error('getUserCoordinates: Error getting user coordinates', tag: 'UserLocationHelper', error: e);
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
      Logger.debug('Getting location params...', tag: 'UserLocationHelper');
      final coordinates = await getUserCoordinates(ref);
      Logger.debug('Location coordinates result: $coordinates', tag: 'UserLocationHelper');
      
      if (coordinates == null) {
        Logger.warning('No coordinates available, returning null', tag: 'UserLocationHelper');
        return null;
      }

      final params = {
        'userLat': coordinates['latitude']!,
        'userLon': coordinates['longitude']!,
        if (decorationType != null) 'decorationType': decorationType,
        if (radiusKm != null) 'radiusKm': radiusKm,
      };
      
      Logger.success('Location params created: $params', tag: 'UserLocationHelper');
      return params;
    } catch (e) {
      Logger.error('Error in getLocationParams', tag: 'UserLocationHelper', error: e);
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