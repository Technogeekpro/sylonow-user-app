import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/home/screens/main_screen.dart';
import '../constants/app_constants.dart';
import '../../features/services/screens/service_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConstants.splashRoute,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.otpVerificationRoute,
        builder: (context, state) {
          final phoneNumber = (state.extra as Map<String, dynamic>)['phoneNumber'] as String;
          return OtpVerificationScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: AppConstants.homeRoute,
        builder: (context, state) => const MainScreen(),
      ),
      // Profile related routes
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/bookings',
        builder: (context, state) => const BookingHistoryScreen(),
      ),
      GoRoute(
        path: '/profile/addresses',
        builder: (context, state) => const AddressesScreen(),
      ),
      GoRoute(
        path: '/profile/payments',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/profile/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile/support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/profile/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // Service detail route
      GoRoute(
        path: '/service/:serviceId',
        builder: (context, state) {
          final serviceId = state.pathParameters['serviceId']!;
          final extra = state.extra as Map<String, dynamic>?;
          return ServiceDetailScreen(
            serviceId: serviceId,
            serviceName: extra?['serviceName'] ?? 'Service Name',
            price: extra?['price'] ?? '\$22',
            rating: extra?['rating'] ?? '4.9',
            reviewCount: extra?['reviewCount'] ?? 102,
          );
        },
      ),
    ],
    redirect: (context, state) async {
      final isAuthenticated = await ref.read(isAuthenticatedProvider.future);
      
      final isOnLoginPage = state.matchedLocation == AppConstants.loginRoute;
      final isOnRegisterPage = state.matchedLocation == AppConstants.registerRoute;
      final isOnSplashPage = state.matchedLocation == AppConstants.splashRoute;
      final isOnOtpPage = state.matchedLocation == AppConstants.otpVerificationRoute;
      
      // If the user is on the splash screen, let the splash screen handle the redirection
      if (isOnSplashPage) {
        return null;
      }
      
      // If the user is not authenticated and not on an auth page, redirect to login
      if (!isAuthenticated && 
          !isOnLoginPage && 
          !isOnRegisterPage && 
          !isOnOtpPage) {
        return AppConstants.homeRoute;
      }
      
      // If the user is authenticated and on an auth page, redirect to home
      if (isAuthenticated && 
          (isOnLoginPage || isOnRegisterPage)) {
        return AppConstants.homeRoute;
      }
      
      return null;
    },
  );
});

// Placeholder screens for profile navigation
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Edit Profile Screen\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Booking History Screen\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Addresses Screen\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Payment Methods Screen\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Notifications Screen\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Support Screen\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Settings Screen\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
} 