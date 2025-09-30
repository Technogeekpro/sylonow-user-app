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
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/name_screen.dart';
import '../../features/onboarding/screens/occasion_screen.dart';
import '../../features/onboarding/screens/date_screen.dart';
import '../../features/onboarding/screens/auth_screen.dart';
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
import '../../features/booking/screens/service_booking_screen.dart';
import '../../features/booking/screens/payment_screen.dart';
import '../../features/home/models/service_listing_model.dart';
import '../../features/theater/screens/theater_detail_screen_new.dart';
import '../../features/theater/screens/theater_date_selection_screen.dart';
import '../../features/theater/screens/theater_list_screen.dart';
import '../../features/theater/screens/theater_screens_selection_screen.dart';
import '../../features/theater/screens/theater_decorations_screen.dart';
import '../../features/theater/screens/theater_occasions_screen.dart';
import '../../features/theater/screens/theater_addons_screen.dart';
import '../../features/theater/screens/theater_checkout_screen.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';
import '../../features/offers/screens/offers_screen.dart';
import '../../features/offers/screens/discount_offers_screen.dart';
import '../../features/discounts/screens/discounted_services_screen.dart';
import '../../features/home/screens/nearby_services_screen.dart';
import '../../features/cakes/screens/cakes_screen.dart';
import '../../features/theater/screens/theater_booking_history_screen.dart';
import '../../features/outside/screens/outside_screen.dart';
import '../../features/outside/screens/theater_screen_detail_screen.dart';
import '../../features/outside/models/theater_screen_model.dart';
import '../../features/outside/models/screen_package_model.dart';
import '../../features/outside/models/time_slot_model.dart';
import '../../features/outside/models/addon_model.dart';
import '../../features/outside/screens/outside_occasions_screen.dart';
import '../../features/outside/screens/outside_special_services_screen.dart';
import '../../features/outside/screens/outside_addons_screen.dart';
import '../../features/outside/screens/outside_checkout_screen.dart';
import '../../features/outside/screens/extra_special_screen.dart';
import '../../features/outside/screens/special_services_screen.dart';
import '../../features/outside/screens/checkout_screen.dart' as outside_checkout;

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
      // Onboarding routes
      GoRoute(
        path: WelcomeScreen.routeName,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: NameScreen.routeName,
        builder: (context, state) => const NameScreen(),
      ),
      GoRoute(
        path: OccasionScreen.routeName,
        builder: (context, state) => const OccasionScreen(),
      ),
      GoRoute(
        path: DateScreen.routeName,
        builder: (context, state) => const DateScreen(),
      ),
      GoRoute(
        path: OnboardingAuthScreen.routeName,
        builder: (context, state) => const OnboardingAuthScreen(),
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
          final extra = state.extra;
          if (extra is! Map<String, dynamic> || !extra.containsKey('phoneNumber')) {
            throw Exception('Invalid phone number data in navigation');
          }
          final phoneNumber = extra['phoneNumber'] as String;
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
      // Nearby services route
      GoRoute(
        path: NearbyServicesScreen.routeName,
        builder: (context, state) => const NearbyServicesScreen(),
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
      // Offers route
      GoRoute(
        path: OffersScreen.routeName,
        builder: (context, state) => const OffersScreen(),
      ),
      // Discounted Services route
      GoRoute(
        path: DiscountedServicesScreen.routeName,
        builder: (context, state) => const DiscountedServicesScreen(),
      ),
      // Discount Offers route
      GoRoute(
        path: DiscountOffersScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final minDiscountPercent = extra?['minDiscountPercent'] as int? ?? 50;
          final title = extra?['title'] as String? ?? 'Special Offers';
          return DiscountOffersScreen(
            minDiscountPercent: minDiscountPercent,
            title: title,
          );
        },
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
        path: '/profile/addresses',
        builder: (context, state) => const ManageAddressScreen(),
      ),
      GoRoute(
        path: '/profile/addresses/add',
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
      // Service booking route
      GoRoute(
        path: '/service/:serviceId/booking',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            throw Exception('ServiceBookingScreen requires service data in navigation extra');
          }
          
          // Handle service data - can be ServiceListingModel or Map
          late ServiceListingModel service;
          final serviceData = extra['service'];
          
          if (serviceData is ServiceListingModel) {
            service = serviceData;
          } else if (serviceData is Map<String, dynamic>) {
            // If it's a Map (happens during hot reload/DevTools inspection), 
            // reconstruct the ServiceListingModel
            service = ServiceListingModel.fromJson(serviceData);
          } else {
            // Fallback - shouldn't happen in normal cases
            throw Exception('Invalid service data type: ${serviceData.runtimeType}');
          }
          
          return ServiceBookingScreen(
            service: service,
            addedAddons: extra['addedAddons'] as Map<String, Map<String, dynamic>>? ?? {},
          );
        },
      ),
      // Booking flow routes
      GoRoute(
        path: CheckoutScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          
          // Handle null extra gracefully by providing mock data for development/testing
          late ServiceListingModel service;
          
          if (extra == null || extra['service'] == null) {
            // Create mock service data for widget selection mode or missing data
            service = const ServiceListingModel(
              id: 'mock-service-id',
              vendorId: 'mock-vendor-id',
              name: 'Mock Service for Testing',
              description: 'This is a mock service used for development and testing purposes',
              offerPrice: 4500.0,
              originalPrice: 5000.0,
              isActive: true,
            );
          } else {
            // Safe casting for service - handle both ServiceListingModel and Map cases
            final serviceData = extra['service'];
            
            if (serviceData is ServiceListingModel) {
              service = serviceData;
            } else if (serviceData is Map<String, dynamic>) {
              // If it's a Map (happens during hot reload/DevTools inspection), 
              // reconstruct the ServiceListingModel
              service = ServiceListingModel.fromJson(serviceData);
            } else {
              // Fallback to mock data instead of throwing exception
              service = const ServiceListingModel(
                id: 'fallback-service-id',
                vendorId: 'fallback-vendor-id',
                name: 'Fallback Service',
                description: 'Fallback service for invalid data type',
                offerPrice: 1000.0,
                originalPrice: 1200.0,
                isActive: true,
              );
            }
          }
          
          final selectedAddressId = extra?['selectedAddressId'] as String?;
          final customization = extra?['customization'] as Map<String, dynamic>?;
          final selectedTimeSlot = extra?['selectedTimeSlot'];
          final selectedScreen = extra?['selectedScreen'];
          final selectedDate = extra?['selectedDate'] as String?;
          final selectedAddOns = extra?['selectedAddOns'] as Map<String, Map<String, dynamic>>?;
          
          return CheckoutScreen(
            service: service,
            selectedAddressId: selectedAddressId,
            customization: customization,
            selectedTimeSlot: selectedTimeSlot,
            selectedScreen: selectedScreen,
            selectedDate: selectedDate,
            selectedAddOns: selectedAddOns,
          );
        },
      ),
      GoRoute(
        path: PaymentScreen.routeName,
        builder: (context, state) {
          final bookingData = state.extra as Map<String, dynamic>?;
          if (bookingData == null) {
            throw Exception('PaymentScreen requires booking data in navigation extra');
          }
          return PaymentScreen(bookingData: bookingData);
        },
      ),
      // Booking Success route
      GoRoute(
        path: BookingSuccessScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            throw Exception('BookingSuccessScreen requires data in navigation extra');
          }
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
          final extra = state.extra as Map<String, dynamic>?;
          final decorationType = extra?['decorationType'] as String?;
          final displayName = extra?['displayName'] as String?;

          return CategoryServicesScreen(
            categoryName: categoryName,
            decorationType: decorationType,
            displayName: displayName,
          );
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
      // Theater screens selection route (NEW - after selecting theater)
      GoRoute(
        path: '/theater/:theaterId/screens',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          return TheaterScreensSelectionScreen(
            theaterId: theaterId,
            selectedDate: selectedDate,
          );
        },
      ),
      // Theater decorations selection route (NEW - first step after selecting theater)
      GoRoute(
        path: '/theater/:theaterId/decorations',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          return TheaterDecorationsScreen(
            theaterId: theaterId,
            selectedDate: selectedDate,
          );
        },
      ),
      // Theater detail route (UPDATED - now uses new screen with multi-screen support)
      GoRoute(
        path: '/theater/:theaterId/detail',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          return TheaterDetailScreenNew(
            theaterId: theaterId,
            selectedDate: selectedDate,
            selectionData: extra,
          );
        },
      ),
      // Theater occasions selection route
      GoRoute(
        path: '/theater/:theaterId/occasions',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          final selectionData = extra['selectionData'] as Map<String, dynamic>;
          return TheaterOccasionsScreen(
            theaterId: theaterId,
            selectedDate: selectedDate,
            selectionData: selectionData,
          );
        },
      ),
      // Theater add-ons selection route
      GoRoute(
        path: '/theater/:theaterId/addons',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          final selectionData = extra['selectionData'] as Map<String, dynamic>;
          return TheaterAddonsScreen(
            theaterId: theaterId,
            selectedDate: selectedDate,
            selectionData: selectionData,
          );
        },
      ),
      // Theater checkout route
      GoRoute(
        path: '/theater/:theaterId/checkout',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          final selectionData = extra['selectionData'] as Map<String, dynamic>;
          return TheaterCheckoutScreen(
            theaterId: theaterId,
            selectedDate: selectedDate,
            selectionData: selectionData,
          );
        },
      ),
      // Cakes screen route
      GoRoute(
        path: '/cakes/:theaterId',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          return CakesScreen(theaterId: theaterId);
        },
      ),
      // Theater booking history route
      GoRoute(
        path: '/profile/theater-bookings',
        builder: (context, state) => const TheaterBookingHistoryScreen(),
      ),

      // Outside screen with back button (when navigated from home)
      GoRoute(
        path: '/outside-theaters',
        builder: (context, state) => const OutsideScreen(showBackButton: true),
      ),
      // Theater Screen Detail route
      GoRoute(
        path: TheaterScreenDetailScreen.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null || extra['screen'] == null) {
            throw Exception('TheaterScreenDetailScreen requires screen data in navigation extra');
          }

          final screen = extra['screen'];
          TheaterScreen theaterScreen;

          // Handle both TheaterScreen object and Map<String, dynamic>
          if (screen is TheaterScreen) {
            theaterScreen = screen;
          } else if (screen is Map<String, dynamic>) {
            theaterScreen = TheaterScreen.fromJson(screen);
          } else {
            throw Exception('Invalid screen data type: ${screen.runtimeType}');
          }

          return TheaterScreenDetailScreen(
            screen: theaterScreen,
            selectedDate: extra['selectedDate'] as String?,
          );
        },
      ),
      // Outside booking flow routes
      // Outside occasions selection route
      GoRoute(
        path: '/outside/:screenId/occasions',
        builder: (context, state) {
          final screenId = state.pathParameters['screenId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          final selectionData = extra as Map<String, dynamic>;
          return OutsideOccasionsScreen(
            screenId: screenId,
            selectedDate: selectedDate,
            selectionData: selectionData,
          );
        },
      ),
      // Outside special services selection route (OLD - replaced by new flow)
      GoRoute(
        path: '/outside/:screenId/old-special-services',
        builder: (context, state) {
          final screenId = state.pathParameters['screenId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          final selectionData = extra as Map<String, dynamic>;
          return OutsideSpecialServicesScreen(
            screenId: screenId,
            selectedDate: selectedDate,
            selectionData: selectionData,
          );
        },
      ),
      // Outside addons selection route
      GoRoute(
        path: '/outside/:screenId/addons',
        builder: (context, state) {
          final screenId = state.pathParameters['screenId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          final selectionData = extra as Map<String, dynamic>;
          return OutsideAddonsScreen(
            screenId: screenId,
            selectedDate: selectedDate,
            selectionData: selectionData,
          );
        },
      ),
      // New flow routes for outside theater booking
      // Extra special route
      GoRoute(
        path: '/outside/:screenId/extra-special',
        builder: (context, state) {
          final screenId = state.pathParameters['screenId']!;
          final extra = state.extra as Map<String, dynamic>;

          // Handle serialized data for widget selection mode
          TheaterScreen screen;
          final screenData = extra['screen'];
          if (screenData is TheaterScreen) {
            screen = screenData;
          } else if (screenData is Map<String, dynamic>) {
            screen = TheaterScreen.fromJson(screenData);
          } else {
            throw Exception('Invalid screen data type: ${screenData.runtimeType}');
          }

          ScreenPackageModel? selectedPackage;
          final packageData = extra['selectedPackage'];
          if (packageData is ScreenPackageModel?) {
            selectedPackage = packageData;
          } else if (packageData is Map<String, dynamic>?) {
            selectedPackage = packageData != null ? ScreenPackageModel.fromJson(packageData) : null;
          }

          TimeSlotModel timeSlot;
          final timeSlotData = extra['timeSlot'];
          if (timeSlotData is TimeSlotModel) {
            timeSlot = timeSlotData;
          } else if (timeSlotData is Map<String, dynamic>) {
            timeSlot = TimeSlotModel.fromJson(timeSlotData);
          } else {
            throw Exception('Invalid timeSlot data type: ${timeSlotData.runtimeType}');
          }

          return ExtraSpecialScreen(
            screen: screen,
            selectedPackage: selectedPackage,
            selectedDate: extra['selectedDate'] as String,
            timeSlot: timeSlot,
            screenId: screenId,
            selectedAddons: (extra['selectedAddons'] as List? ?? [])
                .map((e) => e is AddonModel ? e : AddonModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            totalAddonPrice: (extra['totalAddonPrice'] as num?)?.toDouble() ?? 0.0,
          );
        },
      ),
      // Special services route
      GoRoute(
        path: '/outside/:screenId/special-services',
        builder: (context, state) {
          final screenId = state.pathParameters['screenId']!;
          final extra = state.extra as Map<String, dynamic>;

          // Handle serialized data for widget selection mode
          TheaterScreen screen;
          final screenData = extra['screen'];
          if (screenData is TheaterScreen) {
            screen = screenData;
          } else if (screenData is Map<String, dynamic>) {
            screen = TheaterScreen.fromJson(screenData);
          } else {
            throw Exception('Invalid screen data type: ${screenData.runtimeType}');
          }

          ScreenPackageModel? selectedPackage;
          final packageData = extra['selectedPackage'];
          if (packageData is ScreenPackageModel?) {
            selectedPackage = packageData;
          } else if (packageData is Map<String, dynamic>?) {
            selectedPackage = packageData != null ? ScreenPackageModel.fromJson(packageData) : null;
          }

          TimeSlotModel timeSlot;
          final timeSlotData = extra['timeSlot'];
          if (timeSlotData is TimeSlotModel) {
            timeSlot = timeSlotData;
          } else if (timeSlotData is Map<String, dynamic>) {
            timeSlot = TimeSlotModel.fromJson(timeSlotData);
          } else {
            throw Exception('Invalid timeSlot data type: ${timeSlotData.runtimeType}');
          }

          return SpecialServicesScreen(
            screen: screen,
            selectedPackage: selectedPackage,
            selectedDate: extra['selectedDate'] as String,
            timeSlot: timeSlot,
            screenId: screenId,
            selectedAddons: (extra['selectedAddons'] as List? ?? [])
                .map((e) => e is AddonModel ? e : AddonModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            totalAddonPrice: (extra['totalAddonPrice'] as num?)?.toDouble() ?? 0.0,
            selectedExtraSpecials: (extra['selectedExtraSpecials'] as List? ?? [])
                .map((e) => e is AddonModel ? e : AddonModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            totalExtraSpecialPrice: (extra['totalExtraSpecialPrice'] as num?)?.toDouble() ?? 0.0,
          );
        },
      ),
      // New checkout route
      GoRoute(
        path: '/outside/:screenId/checkout',
        builder: (context, state) {
          final screenId = state.pathParameters['screenId']!;
          final extra = state.extra as Map<String, dynamic>;

          // Handle serialized data for widget selection mode
          TheaterScreen screen;
          final screenData = extra['screen'];
          if (screenData is TheaterScreen) {
            screen = screenData;
          } else if (screenData is Map<String, dynamic>) {
            screen = TheaterScreen.fromJson(screenData);
          } else {
            throw Exception('Invalid screen data type: ${screenData.runtimeType}');
          }

          ScreenPackageModel? selectedPackage;
          final packageData = extra['selectedPackage'];
          if (packageData is ScreenPackageModel?) {
            selectedPackage = packageData;
          } else if (packageData is Map<String, dynamic>?) {
            selectedPackage = packageData != null ? ScreenPackageModel.fromJson(packageData) : null;
          }

          TimeSlotModel timeSlot;
          final timeSlotData = extra['timeSlot'];
          if (timeSlotData is TimeSlotModel) {
            timeSlot = timeSlotData;
          } else if (timeSlotData is Map<String, dynamic>) {
            timeSlot = TimeSlotModel.fromJson(timeSlotData);
          } else {
            throw Exception('Invalid timeSlot data type: ${timeSlotData.runtimeType}');
          }

          return outside_checkout.CheckoutScreen(
            screen: screen,
            selectedPackage: selectedPackage,
            selectedDate: extra['selectedDate'] as String,
            timeSlot: timeSlot,
            screenId: screenId,
            selectedAddons: (extra['selectedAddons'] as List? ?? [])
                .map((e) => e is AddonModel ? e : AddonModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            totalAddonPrice: (extra['totalAddonPrice'] as num?)?.toDouble() ?? 0.0,
            selectedExtraSpecials: (extra['selectedExtraSpecials'] as List? ?? [])
                .map((e) => e is AddonModel ? e : AddonModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            totalExtraSpecialPrice: (extra['totalExtraSpecialPrice'] as num?)?.toDouble() ?? 0.0,
            selectedSpecialServices: (extra['selectedSpecialServices'] as List? ?? [])
                .map((e) => e is AddonModel ? e : AddonModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            totalSpecialServicesPrice: (extra['totalSpecialServicesPrice'] as num?)?.toDouble() ?? 0.0,
          );
        },
      ),

      // Old outside checkout route (keeping for compatibility)
      GoRoute(
        path: '/outside/:screenId/old-checkout',
        builder: (context, state) {
          final screenId = state.pathParameters['screenId']!;
          final extra = state.extra as Map<String, dynamic>;
          final selectedDate = extra['selectedDate'] as String;
          final selectionData = extra as Map<String, dynamic>;
          return OutsideCheckoutScreen(
            screenId: screenId,
            selectedDate: selectedDate,
            selectionData: selectionData,
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
