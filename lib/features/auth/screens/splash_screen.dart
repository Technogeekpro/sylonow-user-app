import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _checkAuthAndNavigate();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'v${info.version}';
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Show splash for at least 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    try {
      // Check if user is authenticated
      final isAuthenticated = await ref.read(isAuthenticatedProvider.future);
      
      if (isAuthenticated) {
        // User is logged in, go to main screen
        context.go(AppConstants.homeRoute);
      } else {
        // User is not logged in, go to login screen
        context.go(AppConstants.loginRoute);
      }
    } catch (e) {
      // Error checking auth, default to login screen
      context.go(AppConstants.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/sylonow_white_logo.png',
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                _version,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 