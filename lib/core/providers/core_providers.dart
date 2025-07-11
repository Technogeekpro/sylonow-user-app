import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/core/services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
}); 