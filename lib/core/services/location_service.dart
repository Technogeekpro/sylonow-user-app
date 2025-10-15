import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'logger.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Logger.warning('Location service not enabled', tag: 'LocationService');
        return null;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Logger.warning('Location permission denied', tag: 'LocationService');
          return null;
        }
      } 

      if (permission == LocationPermission.deniedForever) {
        Logger.warning('Location permission denied forever', tag: 'LocationService');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      Logger.success(
        'Position obtained: ${position.latitude}, ${position.longitude}',
        tag: 'LocationService',
      );
      return position;
    } catch (e) {
      Logger.error('Error in getCurrentLocation', tag: 'LocationService', error: e);
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
