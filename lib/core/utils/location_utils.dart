import 'dart:math';

/// Utility class for location-based calculations
/// 
/// Provides methods for distance calculation, pricing adjustments,
/// and location-based filtering
class LocationUtils {
  /// Earth's radius in kilometers
  static const double earthRadiusKm = 6371.0;
  
  /// Distance threshold in kilometers for price adjustment
  static const double priceAdjustmentThreshold = 10.0;
  
  /// Price increase amount for services beyond threshold distance
  static const double distancePriceIncrease = 100.0;

  /// Calculate distance between two geographic points using Haversine formula
  /// 
  /// Returns distance in kilometers with 2 decimal precision
  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    // Convert latitude and longitude from degrees to radians
    final lat1Rad = _degreesToRadians(lat1);
    final lon1Rad = _degreesToRadians(lon1);
    final lat2Rad = _degreesToRadians(lat2);
    final lon2Rad = _degreesToRadians(lon2);

    // Calculate differences
    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    // Haversine formula
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    // Calculate distance
    final distance = earthRadiusKm * c;
    
    // Return distance rounded to 2 decimal places
    return double.parse(distance.toStringAsFixed(2));
  }

  /// Calculate adjusted price based on distance from user location
  /// 
  /// Adds [distancePriceIncrease] to the original price if distance
  /// exceeds [priceAdjustmentThreshold] kilometers
  static double calculateAdjustedPrice({
    required double originalPrice,
    required double distanceKm,
  }) {
    if (distanceKm > priceAdjustmentThreshold) {
      return originalPrice + distancePriceIncrease;
    }
    return originalPrice;
  }

  /// Format distance for display in UI
  /// 
  /// Returns formatted string like "5.2 km" or "500 m" for distances < 1 km
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1.0) {
      final meters = (distanceKm * 1000).round();
      return '$meters m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  /// Check if a location is within specified radius
  /// 
  /// Returns true if the distance between user location and service location
  /// is within the specified radius in kilometers
  static bool isWithinRadius({
    required double userLat,
    required double userLon,
    required double serviceLat,
    required double serviceLon,
    required double radiusKm,
  }) {
    final distance = calculateDistance(
      lat1: userLat,
      lon1: userLon,
      lat2: serviceLat,
      lon2: serviceLon,
    );
    return distance <= radiusKm;
  }

  /// Get price adjustment indicator for UI
  /// 
  /// Returns a map with information about price adjustment
  static Map<String, dynamic> getPriceAdjustmentInfo(double distanceKm) {
    final isAdjusted = distanceKm > priceAdjustmentThreshold;
    return {
      'isAdjusted': isAdjusted,
      'reason': isAdjusted 
          ? 'Additional ₹${distancePriceIncrease.toInt()} for distance > ${priceAdjustmentThreshold.toInt()}km'
          : null,
      'adjustmentAmount': isAdjusted ? distancePriceIncrease : 0.0,
      'distance': distanceKm,
    };
  }

  /// Validate latitude value
  static bool isValidLatitude(double? lat) {
    return lat != null && lat >= -90.0 && lat <= 90.0;
  }

  /// Validate longitude value
  static bool isValidLongitude(double? lon) {
    return lon != null && lon >= -180.0 && lon <= 180.0;
  }

  /// Validate coordinate pair
  static bool isValidCoordinate(double? lat, double? lon) {
    return isValidLatitude(lat) && isValidLongitude(lon);
  }

  /// Convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  /// Sort services by distance from user location
  /// 
  /// Takes a list of services with their coordinates and sorts them
  /// by distance from the user's location
  static List<T> sortByDistance<T>({
    required List<T> services,
    required double userLat,
    required double userLon,
    required double Function(T) getServiceLat,
    required double Function(T) getServiceLon,
  }) {
    // Create a list of services with their calculated distances
    final servicesWithDistance = services.map((service) {
      final distance = calculateDistance(
        lat1: userLat,
        lon1: userLon,
        lat2: getServiceLat(service),
        lon2: getServiceLon(service),
      );
      return {'service': service, 'distance': distance};
    }).toList();

    // Sort by distance
    servicesWithDistance.sort((a, b) => 
        (a['distance'] as double).compareTo(b['distance'] as double));

    // Return only the services in sorted order
    return servicesWithDistance
        .map((item) => item['service'] as T)
        .toList();
  }

  /// Filter services within a specific radius
  /// 
  /// Returns only services that are within the specified radius
  /// from the user's location
  static List<T> filterByRadius<T>({
    required List<T> services,
    required double userLat,
    required double userLon,
    required double radiusKm,
    required double Function(T) getServiceLat,
    required double Function(T) getServiceLon,
  }) {
    return services.where((service) {
      return isWithinRadius(
        userLat: userLat,
        userLon: userLon,
        serviceLat: getServiceLat(service),
        serviceLon: getServiceLon(service),
        radiusKm: radiusKm,
      );
    }).toList();
  }
}