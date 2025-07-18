import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/features/address/screens/add_edit_address_screen.dart';
import 'package:sylonow_user/features/address/screens/manage_address_screen.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/phone_input_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/booking/screens/booking_success_screen.dart';
import '../../features/home/screens/main_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../constants/app_constants.dart';
import '../../features/services/screens/service_detail_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/booking_history_screen.dart';
import '../../features/profile/screens/notifications_screen.dart';
import '../../features/profile/screens/help_support_screen.dart';
import '../../features/profile/screens/privacy_policy_screen.dart';
import '../../features/profile/screens/terms_of_service_screen.dart';
import '../../features/profile/screens/about_screen.dart';
import '../../features/reviews/screens/reviews_screen.dart';
import '../../features/categories/screens/all_categories_screen.dart';
import '../../features/categories/screens/category_services_screen.dart';
import '../../features/booking/screens/checkout_screen.dart';
import '../../features/booking/screens/payment_screen.dart';
import '../../features/home/models/service_listing_model.dart';
import '../../features/theater/screens/theater_detail_screen.dart';
import '../../features/theater/screens/theater_date_selection_screen.dart';
import '../../features/theater/screens/theater_list_screen.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';

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
        path: PhoneInputScreen.routeName,
        builder: (context, state) => const PhoneInputScreen(),
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
      // Search route
      GoRoute(
        path: SearchScreen.routeName,
        builder: (context, state) => const SearchScreen(),
      ),
      // Wallet route
      GoRoute(
        path: WalletScreen.routeName,
        builder: (context, state) => const WalletScreen(),
      ),
      // Wishlist route
      GoRoute(
        path: WishlistScreen.routeName,
        builder: (context, state) => const WishlistScreen(),
      ),
      // Profile route
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
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
        path: ManageAddressScreen.routeName,
        builder: (context, state) => const ManageAddressScreen(),
      ),
      GoRoute(
        path: '/add-edit-address/:addressId',
        builder: (context, state) {
          final addressId = state.pathParameters['addressId'];
          return AddEditAddressScreen(addressId: addressId);
        },
      ),
      GoRoute(
        path: AddEditAddressScreen.routeName,
        builder: (context, state) => const AddEditAddressScreen(),
      ),
      GoRoute(
        path: '/profile/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile/support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/profile/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/profile/terms',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        path: '/profile/about',
        builder: (context, state) => const AboutScreen(),
      ),
      // Service detail route
      GoRoute(
        path: '/service/:serviceId',
        builder: (context, state) {
          final serviceId = state.pathParameters['serviceId']!;
          final extra = state.extra as Map<String, dynamic>?;
          return ServiceDetailScreen(
            serviceId: serviceId,
            serviceName: extra?['serviceName'],
            price: extra?['price'],
            rating: extra?['rating'],
            reviewCount: extra?['reviewCount'],
          );
        },
      ),
      // Booking flow routes
      GoRoute(
        path: CheckoutScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final service = extra['service'] as ServiceListingModel;
          final selectedAddressId = extra['selectedAddressId'] as String?;
          return CheckoutScreen(
            service: service,
            selectedAddressId: selectedAddressId,
          );
        },
      ),
      GoRoute(
        path: PaymentScreen.routeName,
        builder: (context, state) {
          final bookingData = state.extra as Map<String, dynamic>;
          return PaymentScreen(
            bookingData: bookingData,
          );
        },
      ),
      // Booking Success route
      GoRoute(
        path: BookingSuccessScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BookingSuccessScreen(
            bookingData: extra['bookingData'] as Map<String, dynamic>,
            paymentMethod: extra['paymentMethod'] as String,
          );
        },
      ),
      // Reviews route
      GoRoute(
        path: ReviewsScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ReviewsScreen(
            serviceId: extra?['serviceId'] ?? '',
            serviceName: extra?['serviceName'] ?? 'Service',
            averageRating: extra?['averageRating'] ?? 4.9,
            totalReviews: extra?['totalReviews'] ?? 0,
          );
        },
      ),
      // All categories route
      GoRoute(
        path: '/categories',
        builder: (context, state) => const AllCategoriesScreen(),
      ),
      // Category services route
      GoRoute(
        path: '/category/:categoryName',
        builder: (context, state) {
          final categoryName = state.pathParameters['categoryName']!;
          return CategoryServicesScreen(categoryName: categoryName);
        },
      ),
      // Theater date selection route
      GoRoute(
        path: '/theater/date-selection',
        builder: (context, state) => const TheaterDateSelectionScreen(),
      ),
      // Theater list route
      GoRoute(
        path: '/theater/list',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          return TheaterListScreen(selectedDate: selectedDate);
        },
      ),
      // Theater detail route
      GoRoute(
        path: '/theater/:theaterId',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          final extra = state.extra as Map<String, dynamic>?;
          return TheaterDetailScreen(
            theaterId: theaterId,
            selectedDate: extra?['selectedDate'] as String?,
          );
        },
      ),
    ],
    redirect: (context, state) async {
      final isOnSplashPage = state.matchedLocation == AppConstants.splashRoute;
      
      // Always let splash screen handle the authentication check and navigation
      if (isOnSplashPage) {
        return null;
      }
      
      // For all other routes, let them through
      // The splash screen will handle proper navigation based on auth state
      return null;
    },
  );
});

 