import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_providers.dart';
import '../../onboarding/providers/onboarding_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  String _version = '';
  late AnimationController _animationController;
  bool _animationCompleted = false;
  bool _authCheckCompleted = false;
  String? _nextRoute;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _initPackageInfo();
    _startSplashSequence();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'v${info.version}';
    });
  }

  void _startSplashSequence() {
    // Start both animation and auth check simultaneously
    _checkAuthAndDetermineRoute();
  }

  Future<void> _checkAuthAndDetermineRoute() async {
    if (!mounted) return;
    
    try {
      // First check if onboarding is completed
      final isOnboardingComplete = await ref.read(isOnboardingCompletedProvider.future);
      
      if (!isOnboardingComplete) {
        // User hasn't completed onboarding, go to welcome screen
        _nextRoute = AppConstants.welcomeRoute;
        _authCheckCompleted = true;
        _navigateIfReady();
        return;
      }

      // Check if user is authenticated
      final isAuthenticated = await ref.read(isAuthenticatedProvider.future);
      
      if (isAuthenticated) {
        // Check if profile is complete
        final authService = ref.read(authServiceProvider);
        final isProfileComplete = await authService.isProfileComplete();
        
        if (isProfileComplete) {
          // Profile is complete, go to main screen
          _nextRoute = AppConstants.homeRoute;
        } else {
          // Profile is incomplete, go to profile completion screen
          _nextRoute = '/profile-completion';
        }
      } else {
        // User is not logged in, go to login screen
        _nextRoute = AppConstants.loginRoute;
      }
    } catch (e) {
      // Error checking auth, default to login screen or welcome if onboarding not done
      try {
        final isOnboardingComplete = await ref.read(isOnboardingCompletedProvider.future);
        _nextRoute = isOnboardingComplete ? AppConstants.loginRoute : AppConstants.welcomeRoute;
      } catch (_) {
        _nextRoute = AppConstants.welcomeRoute;
      }
    }
    
    _authCheckCompleted = true;
    _navigateIfReady();
  }

  void _onAnimationComplete() {
    _animationCompleted = true;
    _navigateIfReady();
  }

  void _navigateIfReady() {
    if (_animationCompleted && _authCheckCompleted && _nextRoute != null) {
      if (mounted) {
        context.go(_nextRoute!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Lottie.asset(
                'assets/animations/splash.json',
                controller: _animationController,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
                repeat: false,
                onLoaded: (composition) {
                  _animationController.duration = composition.duration;
                  _animationController.forward().then((_) {
                    _onAnimationComplete();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                _version,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontFamily: 'Okra',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 