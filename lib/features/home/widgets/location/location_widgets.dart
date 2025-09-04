import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Loading screen displayed while getting user location
class LocationLoadingScreen extends StatelessWidget {
  const LocationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Lottie.asset('assets/animations/truck.json'),
            ),
            SizedBox(height: 16),
            Text(
              'Getting your location...',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Okra',
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen displayed when location access is blocked
class LocationBlockedScreen extends StatelessWidget {
  const LocationBlockedScreen({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 100, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Location Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This app requires location access to function properly. Please enable location services to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Enable Location',
                    style: TextStyle(fontSize: 16, fontFamily: 'Okra'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog for requesting location permission
class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({
    super.key,
    required this.onPermissionGranted,
    required this.onOpenSettings,
    required this.locationService,
  });

  final VoidCallback onPermissionGranted;
  final VoidCallback onOpenSettings;
  final dynamic locationService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Location Access Required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Location access is mandatory to use this app.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final status = await locationService.requestPermission();
              if (status.toString().contains('whileInUse') ||
                  status.toString().contains('always')) {
                onPermissionGranted();
              } else if (status.toString().contains('deniedForever')) {
                onOpenSettings();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Allow Location Access'),
          ),
        ),
      ],
    );
  }
}

/// Dialog for opening app settings
class OpenSettingsDialog extends StatelessWidget {
  const OpenSettingsDialog({
    super.key,
    required this.onSettingsOpened,
    required this.locationService,
  });

  final VoidCallback onSettingsOpened;
  final dynamic locationService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.settings, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Location Permission Required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Please enable location permission in app settings.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await locationService.openAppSettings();
              onSettingsOpened();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Open Settings'),
          ),
        ),
      ],
    );
  }
}

/// Dialog for enabling location service
class EnableLocationDialog extends StatelessWidget {
  const EnableLocationDialog({
    super.key,
    required this.onLocationEnabled,
    required this.locationService,
  });

  final VoidCallback onLocationEnabled;
  final dynamic locationService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_off, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Location Service Required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Please enable device location to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await locationService.openLocationSettings();
              onLocationEnabled();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Enable Location Service'),
          ),
        ),
      ],
    );
  }
}
