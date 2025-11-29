import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppUpdateService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Check if app update is available
  Future<Map<String, dynamic>?> checkForUpdate() async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final platform = Platform.isAndroid ? 'android' : 'ios';

      debugPrint('📱 Current app version: $currentVersion');
      debugPrint('📱 Platform: $platform');

      // Fetch latest version from Supabase
      final response = await _supabase
          .from('app_versions')
          .select()
          .eq('platform', platform)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      debugPrint('📱 Database response: $response');

      if (response.isEmpty) {
        debugPrint('📱 No versions found in database');
        return null;
      }

      final latestVersion = response['version'] as String;
      final isForceUpdate = response['force_update'] as bool? ?? false;
      final updateMessage = response['update_message'] as String? ??
          'A new version of the app is available. Please update to continue using the app.';
      final storeUrl = response['store_url'] as String?;

      debugPrint('📱 Latest version from DB: $latestVersion');
      debugPrint('📱 Force update: $isForceUpdate');

      // Compare versions
      final shouldUpdate = _shouldUpdate(currentVersion, latestVersion);
      debugPrint('📱 Should update: $shouldUpdate');

      if (shouldUpdate) {
        return {
          'current_version': currentVersion,
          'latest_version': latestVersion,
          'force_update': isForceUpdate,
          'update_message': updateMessage,
          'store_url': storeUrl,
        };
      }

      return null;
    } catch (e) {
      debugPrint('📱 ❌ Error checking for update: $e');
      return null;
    }
  }

  /// Compare version numbers (semantic versioning)
  bool _shouldUpdate(String currentVersion, String latestVersion) {
    try {
      final current = currentVersion.split('.').map(int.parse).toList();
      final latest = latestVersion.split('.').map(int.parse).toList();

      // Pad with zeros if needed
      while (current.length < 3) {
        current.add(0);
      }
      while (latest.length < 3) {
        latest.add(0);
      }

      // Compare major.minor.patch
      for (var i = 0; i < 3; i++) {
        if (latest[i] > current[i]) return true;
        if (latest[i] < current[i]) return false;
      }

      return false; // Versions are equal
    } catch (e) {
      debugPrint('Error comparing versions: $e');
      return false;
    }
  }

  /// Show update dialog
  Future<void> showUpdateDialog(
    BuildContext context,
    Map<String, dynamic> updateInfo,
  ) async {
    final isForceUpdate = updateInfo['force_update'] as bool;
    final updateMessage = updateInfo['update_message'] as String;
    final storeUrl = updateInfo['store_url'] as String?;

    await showDialog(
      context: context,
      barrierDismissible: !isForceUpdate,
      builder: (context) => PopScope(
        canPop: !isForceUpdate,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.system_update,
                color: Colors.orange[700],
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Update Available',
                style: TextStyle(
                  fontFamily: 'Okra',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                updateMessage,
                style: const TextStyle(
                  fontFamily: 'Okra',
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Version ${updateInfo['latest_version']} is now available',
                        style: TextStyle(
                          fontFamily: 'Okra',
                          fontSize: 13,
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            if (!isForceUpdate)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'Later',
                  style: TextStyle(
                    fontFamily: 'Okra',
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                if (storeUrl != null) {
                  final uri = Uri.parse(storeUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.orange[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Update Now',
                style: TextStyle(
                  fontFamily: 'Okra',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
