import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    try {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
        print('🚫 Location service not enabled');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
          print('🚫 Location permission denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
        print('🚫 Location permission denied forever');
        return null;
      }

      print('🎯 Getting current position...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      print('📍 Position obtained: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('💥 Error in getCurrentLocation: $e');
      return null;
    }
  }

  Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      return "${place.street}, ${place.locality}, ${place.postalCode}";
    } catch (e) {
      return "Location not found";
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<LocationPermission> getPermissionStatus() async {
    return await Geolocator.checkPermission();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
} 