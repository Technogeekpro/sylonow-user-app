import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/features/home/widgets/categories/optimized_explore_categories_section.dart';
import 'package:sylonow_user/features/home/widgets/featured/featured_section.dart';
import 'package:sylonow_user/features/home/widgets/collage/image_collage_section.dart';
import 'package:sylonow_user/features/home/widgets/popular_nearby/popular_nearby_section.dart';
import 'package:sylonow_user/features/home/widgets/welcome/user_celebration_overlay.dart';
import 'package:sylonow_user/features/home/widgets/location/location_widgets.dart';
import 'package:sylonow_user/features/home/widgets/app_bar/custom_app_bar.dart';
import 'package:sylonow_user/features/home/widgets/theater/theater_section.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:sylonow_user/core/providers/welcome_providers.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';
import 'package:sylonow_user/features/address/models/address_model.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import 'package:sylonow_user/features/profile/providers/profile_providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';

/// Optimized home screen with performance improvements
class OptimizedHomeScreen extends ConsumerStatefulWidget {
  const OptimizedHomeScreen({super.key});

  @override
  ConsumerState<OptimizedHomeScreen> createState() =>
      _OptimizedHomeScreenState();
}

class _OptimizedHomeScreenState extends ConsumerState<OptimizedHomeScreen>
    with AutomaticKeepAliveClientMixin {
  // Performance optimization: Keep state alive to prevent rebuilds
  @override
  bool get wantKeepAlive => true;

  late final ScrollController _scrollController;
  late final ValueNotifier<double> _scrollOffsetNotifier;
  bool _isLocationEnabled = false;
  bool _isLocationLoading = true;
  bool _isLocationServiceDisabled = false;

  // Global keys for UI elements
  static final GlobalKey locationKey = GlobalKey();
  static final GlobalKey searchKey = GlobalKey();
  static final GlobalKey profileKey = GlobalKey();
  static final GlobalKey categoriesKey = GlobalKey();
  static final GlobalKey theaterKey = GlobalKey();
  
  // Welcome overlay state
  bool _showWelcomeOverlay = false;

  // Memoized search texts - only create once
  static const List<String> _searchTexts = [
    'Birthday Decoration',
    'Anniversary Setup',
    'Wedding Decoration',
    'Baby Shower',
    'Corporate Events',
    'Theme Parties',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollOffsetNotifier = ValueNotifier(0.0);

    // Tutorial completion will be handled in the tutorial coach mark

    // Performance optimization: Use value notifier instead of setState for scroll
    _scrollController.addListener(_onScroll);

    // Performance optimization: Move location operations to next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermissionAsync();
      _checkAndShowWelcomeOverlay();
      _initializeFCMToken();
    });
  }

  Future<void> _checkAndShowWelcomeOverlay() async {
    try {
      debugPrint('🎯 OptimizedHomeScreen checking welcome overlay...');
      // Wait for UI to be fully built
      await Future.delayed(const Duration(milliseconds: 500));
      
      // FOR TESTING: Always show the overlay
      debugPrint('🎯 [TESTING MODE] Always showing welcome overlay...');
      if (mounted) {
        setState(() {
          _showWelcomeOverlay = true;
        });
      }
      
      // COMMENTED OUT FOR TESTING - Original logic:
      // final welcomeService = ref.read(welcomePreferencesServiceProvider);
      // final hasShownWelcome = await welcomeService.hasShownWelcome();
      // 
      // if (!hasShownWelcome && mounted) {
      //   debugPrint('🎯 Showing welcome overlay for the first time...');
      //   setState(() {
      //     _showWelcomeOverlay = true;
      //   });
      // } else {
      //   debugPrint('🎯 Welcome overlay already shown, skipping...');
      // }
    } catch (e) {
      debugPrint('Welcome overlay check error: $e');
    }
  }

  Future<void> _markWelcomeCompleted() async {
    try {
      final welcomeService = ref.read(welcomePreferencesServiceProvider);
      await welcomeService.markWelcomeCompleted();
      
      setState(() {
        _showWelcomeOverlay = false;
      });
      
      debugPrint('🎯 Welcome overlay marked as completed');
    } catch (e) {
      debugPrint('Error marking welcome completed: $e');
    }
  }

  /// Initialize FCM token and update user profile
  Future<void> _initializeFCMToken() async {
    try {
      debugPrint('🔔 Initializing FCM token...');
      
      // Get current user
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        debugPrint('🔔 No authenticated user found, skipping FCM token initialization');
        return;
      }

      debugPrint('🔔 Current user found: ${currentUser.id}');

      // Request notification permissions
      final messaging = FirebaseMessaging.instance;
      
      // Check current permission status first
      NotificationSettings initialSettings = await messaging.getNotificationSettings();
      debugPrint('🔔 Current notification permission status: ${initialSettings.authorizationStatus}');
      
      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('🔔 Notification permission after request: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('🔔 Notification permission granted, getting FCM token...');

        // Get FCM token with timeout
        final fcmToken = await messaging.getToken().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('🔔 FCM token request timed out');
            return null;
          },
        );

        if (fcmToken != null && fcmToken.isNotEmpty) {
          debugPrint('🔔 FCM token received: ${fcmToken.length > 20 ? fcmToken.substring(0, 20) : fcmToken}...');
          
          // Update user profile with FCM token
          await _updateUserFCMToken(currentUser.id, fcmToken);
        } else {
          debugPrint('🔔 Failed to get valid FCM token');
        }
      } else {
        debugPrint('🔔 Notification permission denied: ${settings.authorizationStatus}');
      }

      // Listen for token refresh (only set up once)
      messaging.onTokenRefresh.listen((newToken) {
        final currentUser = ref.read(currentUserProvider);
        if (currentUser != null && newToken.isNotEmpty) {
          debugPrint('🔔 FCM token refreshed: ${newToken.length > 20 ? newToken.substring(0, 20) : newToken}...');
          _updateUserFCMToken(currentUser.id, newToken);
        }
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('🔔 Foreground message received: ${message.messageId}');
        debugPrint('🔔 Message title: ${message.notification?.title}');
        debugPrint('🔔 Message body: ${message.notification?.body}');
      });

    } catch (e, stackTrace) {
      debugPrint('🔔 Error initializing FCM token: $e');
      debugPrint('🔔 Stack trace: $stackTrace');
    }
  }

  /// Update user FCM token in the database
  Future<void> _updateUserFCMToken(String authUserId, String fcmToken) async {
    try {
      debugPrint('🔔 Updating FCM token in database for user: $authUserId');
      
      final profileRepository = ref.read(profileRepositoryProvider);
      await profileRepository.updateFcmToken(
        authUserId: authUserId,
        fcmToken: fcmToken,
      );
      
      debugPrint('🔔 ✅ FCM token successfully upserted in user_profiles table');
      
      // Verify the update by checking if profile exists
      final updatedProfile = await profileRepository.getUserProfile(authUserId);
      if (updatedProfile?.fcmToken == fcmToken) {
        debugPrint('🔔 ✅ FCM token verification successful');
      } else {
        debugPrint('🔔 ⚠️ FCM token verification failed - token may not have been saved correctly');
      }
      
    } catch (e, stackTrace) {
      debugPrint('🔔 ❌ Error updating FCM token in database: $e');
      debugPrint('🔔 Stack trace: $stackTrace');
      
      // Retry once after a delay
      try {
        await Future.delayed(const Duration(seconds: 2));
        debugPrint('🔔 Retrying FCM token update...');
        
        final profileRepository = ref.read(profileRepositoryProvider);
        await profileRepository.updateFcmToken(
          authUserId: authUserId,
          fcmToken: fcmToken,
        );
        
        debugPrint('🔔 ✅ FCM token updated successfully on retry');
      } catch (retryError) {
        debugPrint('🔔 ❌ Failed to update FCM token on retry: $retryError');
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffsetNotifier.dispose();
    super.dispose();
  }

  // Performance optimization: Use ValueNotifier instead of setState for scroll
  void _onScroll() {
    if (_scrollController.hasClients) {
      _scrollOffsetNotifier.value = _scrollController.offset;
    }
  }

  // Performance optimization: Run location operations asynchronously
  Future<void> _checkLocationPermissionAsync() async {
    try {
      debugPrint('🔍 Location permission check started...');
      setState(() {
        _isLocationLoading = true;
        _isLocationServiceDisabled = false; // Reset the service disabled flag
      });
      await _checkLocationPermission();
    } catch (e) {
      debugPrint('Location check error: $e');
      if (mounted) {
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
        });
      }
    }
  }


  Future<void> _checkLocationPermission() async {
    final locationService = ref.read(locationServiceProvider);
    final permissionStatus = await locationService.getPermissionStatus();
    
    debugPrint('🔍 Current permission status: $permissionStatus');

    if (permissionStatus == LocationPermission.denied) {
      debugPrint('🔍 Permission denied, requesting permission...');
      // Request permission directly using system prompt
      final newStatus = await locationService.requestPermission();
      debugPrint('🔍 New permission status after request: $newStatus');
      
      if (newStatus == LocationPermission.whileInUse ||
          newStatus == LocationPermission.always) {
        debugPrint('🔍 Permission granted, checking location service...');
        _checkLocationService();
      } else {
        debugPrint('🔍 Permission still denied, showing blocked screen');
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
          _isLocationServiceDisabled = false; // This is a permission issue, not service
        });
      }
    } else if (permissionStatus == LocationPermission.whileInUse ||
        permissionStatus == LocationPermission.always) {
      debugPrint('🔍 Permission already granted, checking location service...');
      _checkLocationService();
    } else {
      // Permission denied forever or other states - show blocked screen
      debugPrint('🔍 Permission denied forever or other state, showing blocked screen');
      setState(() {
        _isLocationLoading = false;
        _isLocationEnabled = false;
        _isLocationServiceDisabled = false; // This is a permission issue, not service
      });
    }
  }

  Future<void> _checkLocationService() async {
    final locationService = ref.read(locationServiceProvider);
    debugPrint('🔍 Checking if location service is enabled...');
    final serviceEnabled = await locationService.isLocationServiceEnabled();
    debugPrint('🔍 Location service enabled: $serviceEnabled');

    if (!serviceEnabled) {
      // Location service is disabled - prompt user to enable it
      debugPrint('🔍 Location service disabled, prompting user to enable...');
      try {
        debugPrint('🔍 Opening native location settings dialog...');
        await locationService.openLocationSettings();
        
        // Wait a moment for the user to potentially enable location
        await Future.delayed(const Duration(milliseconds: 1500));
        
        // Check again if location service is now enabled
        debugPrint('🔍 Re-checking location service after settings dialog...');
        final newServiceEnabled = await locationService.isLocationServiceEnabled();
        debugPrint('🔍 Location service enabled after dialog: $newServiceEnabled');
        
        if (newServiceEnabled) {
          debugPrint('🔍 Location service now enabled, getting current location...');
          _getCurrentLocation();
        } else {
          debugPrint('🔍 Location service still disabled, showing blocked screen');
          setState(() {
            _isLocationLoading = false;
            _isLocationEnabled = false;
            _isLocationServiceDisabled = true;
          });
        }
      } catch (e) {
        debugPrint('🔍 Error opening location settings: $e');
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
          _isLocationServiceDisabled = true;
        });
      }
    } else {
      debugPrint('🔍 Location service enabled, getting current location...');
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      debugPrint('🔍 Getting current location...');
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentLocation().timeout(
        const Duration(seconds: 30),
      );
      
      debugPrint('🔍 Location result: ${position != null ? "Success (${position.latitude}, ${position.longitude})" : "Failed - null position"}');

      if (position != null && mounted) {
        debugPrint('🔍 Processing location data...');
        // Performance optimization: Run geocoding on background isolate
        _processLocationData(position);
      } else if (mounted) {
        debugPrint('🔍 Position is null, showing blocked screen');
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
        });
      }
    } catch (e) {
      debugPrint('🔍 Location error: $e');
      if (mounted) {
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
        });
      }
    }
  }

  void _processLocationData(Position position) async {
    try {
      debugPrint('🔍 Processing location data for coordinates: (${position.latitude}, ${position.longitude})');
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      debugPrint('🔍 Geocoding result: ${placemarks.isNotEmpty ? "Success - ${placemarks.length} placemarks found" : "No placemarks found"}');

      if (mounted) {
        final placemark = placemarks.isNotEmpty ? placemarks.first : null;
        final currentAddress = Address(
          id: const Uuid().v4(),
          userId: ref.read(currentUserProvider)?.id ?? 'guest',
          addressFor: AddressType.home,
          address: placemark != null
              ? '${placemark.street ?? ''}, ${placemark.locality ?? 'Unknown Location'}'
              : 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
          area: placemark?.subLocality ?? placemark?.locality ?? 'Unknown Area',
          name: 'Current Location',
        );

        debugPrint('🔍 Setting address: ${currentAddress.address}');
        ref.read(selectedAddressProvider.notifier).state = currentAddress;

        setState(() {
          _isLocationEnabled = true;
          _isLocationLoading = false;
        });
        debugPrint('🔍 ✅ Location setup completed successfully!');
      }
    } catch (e) {
      debugPrint('🔍 Geocoding error: $e');
      if (mounted) {
        setState(() {
          _isLocationEnabled = true;
          _isLocationLoading = false;
        });
        debugPrint('🔍 ✅ Location setup completed with geocoding error (using coordinates)');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    if (_isLocationLoading) {
      return const LocationLoadingScreen();
    }

    if (!_isLocationEnabled) {
      return LocationBlockedScreen(
        onRetry: _checkLocationPermissionAsync,
        isServiceDisabled: _isLocationServiceDisabled,
      );
    }

    return Scaffold(
        backgroundColor: Colors.grey[100],
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Main scrollable content
            CustomScrollView(
              controller: _scrollController,
              // Performance optimization: Use const widgets where possible
              slivers: [
                const SliverToBoxAdapter(child: AdvertisementSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: Container(
                    key: categoriesKey,
                    child: const OptimizedExploreCategoriesSection(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                // Conditionally show featured section
                Consumer(
                  builder: (context, ref, child) {
                    final featuredState = ref.watch(featuredServicesProvider);
                    // Only show if there are services or still loading (hasMore = true)
                    if (featuredState.services.isNotEmpty || featuredState.hasMore) {
                      return const SliverToBoxAdapter(child: FeaturedSection());
                    }
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
                // Conditionally show spacing only if featured section is shown
                Consumer(
                  builder: (context, ref, child) {
                    final featuredState = ref.watch(featuredServicesProvider);
                    if (featuredState.services.isNotEmpty || featuredState.hasMore) {
                      return const SliverToBoxAdapter(child: SizedBox(height: 24));
                    }
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
                SliverToBoxAdapter(
                  child: Container(
                    key: theaterKey,
                    child: const TheaterSection(),
                  ),
                ),
                // Conditionally show image collage section
                Consumer(
                  builder: (context, ref, child) {
                    final featuredState = ref.watch(featuredServicesProvider);
                    // Only show if there are services available
                    if (featuredState.services.isNotEmpty) {
                      return const SliverToBoxAdapter(child: ImageCollageSection());
                    }
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
                const SliverToBoxAdapter(child: PopularNearbySection()),
              ],
            ),
            // Custom App Bar as an overlay
            ValueListenableBuilder<double>(
              valueListenable: _scrollOffsetNotifier,
              builder: (context, scrollOffset, child) {
                return CustomAppBarOverlay(
                  scrollOffset: scrollOffset,
                  isLocationEnabled: _isLocationEnabled,
                  profileKey: profileKey,
                  locationKey: locationKey,
                  searchKey: searchKey,
                );
              },
            ),
            // User celebration overlay
            if (_showWelcomeOverlay)
              UserCelebrationOverlay(
                onContinue: _markWelcomeCompleted,
              ),
          ],
        ),
      
    );
  }

}
