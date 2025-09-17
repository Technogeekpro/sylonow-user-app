import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';

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
  const LocationBlockedScreen({
    super.key,
    required this.onRetry,
    this.isServiceDisabled = false,
  });

  final VoidCallback onRetry;
  final bool isServiceDisabled;

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
              Icon(
                isServiceDisabled
                    ? Icons.location_disabled
                    : Icons.location_off,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                isServiceDisabled
                    ? 'Location Service Required'
                    : 'Location Required',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isServiceDisabled
                    ? 'Location services are disabled on your device. Tap the button below to enable location services.'
                    : 'This app requires location access to show nearby services. Please enable location access to continue.',
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isServiceDisabled
                        ? 'Enable Location Services'
                        : 'Allow Location Access',
                    style: const TextStyle(fontSize: 16, fontFamily: 'Okra'),
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
