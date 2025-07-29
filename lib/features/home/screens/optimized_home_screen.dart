import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sylonow_user/features/home/widgets/categories/optimized_explore_categories_section.dart';
import 'package:sylonow_user/features/home/widgets/featured/featured_section.dart';
import 'package:sylonow_user/features/home/widgets/collage/image_collage_section.dart';
import 'package:sylonow_user/features/home/widgets/popular_nearby/popular_nearby_section.dart';
import 'package:sylonow_user/features/home/widgets/welcome/welcome_overlay.dart';
import 'package:sylonow_user/features/home/widgets/location/location_widgets.dart';
import 'package:sylonow_user/features/home/widgets/app_bar/custom_app_bar.dart';
import 'package:sylonow_user/features/home/widgets/theater/theater_section.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';
import 'package:sylonow_user/features/address/models/address_model.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
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
    });
  }

  Future<void> _checkAndShowWelcomeOverlay() async {
    try {
      debugPrint('🎯 OptimizedHomeScreen checking welcome overlay...');
      // Wait for UI to be fully built
      await Future.delayed(const Duration(milliseconds: 500));
      
      final prefs = await SharedPreferences.getInstance();
      // For testing - always show the overlay (comment out the next line in production)
      final hasShownWelcome = false;
      // final hasShownWelcome = prefs.getBool('has_shown_welcome_overlay') ?? false;
      
      if (!hasShownWelcome && mounted) {
        debugPrint('🎯 Showing welcome overlay...');
        setState(() {
          _showWelcomeOverlay = true;
        });
      }
    } catch (e) {
      debugPrint('Welcome overlay check error: $e');
    }
  }

  Future<void> _markWelcomeCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_shown_welcome_overlay', true);
      setState(() {
        _showWelcomeOverlay = false;
      });
      debugPrint('🎯 Welcome overlay marked as completed');
    } catch (e) {
      debugPrint('Error marking welcome completed: $e');
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

    if (permissionStatus == LocationPermission.denied ||
        permissionStatus == LocationPermission.deniedForever) {
      setState(() {
        _isLocationLoading = false;
        _isLocationEnabled = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLocationPermissionDialog();
      });
    } else if (permissionStatus == LocationPermission.whileInUse ||
        permissionStatus == LocationPermission.always) {
      _checkLocationService();
    } else {
      setState(() {
        _isLocationLoading = false;
        _isLocationEnabled = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLocationPermissionDialog();
      });
    }
  }

  Future<void> _checkLocationService() async {
    final locationService = ref.read(locationServiceProvider);
    final serviceEnabled = await locationService.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        _isLocationLoading = false;
        _isLocationEnabled = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showEnableLocationDialog();
      });
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentLocation().timeout(
        const Duration(seconds: 30),
      );

      if (position != null && mounted) {
        // Performance optimization: Run geocoding on background isolate
        _processLocationData(position);
      } else if (mounted) {
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
        });
      }
    } catch (e) {
      debugPrint('Location error: $e');
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
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

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

        ref.read(selectedAddressProvider.notifier).state = currentAddress;

        setState(() {
          _isLocationEnabled = true;
          _isLocationLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
      if (mounted) {
        setState(() {
          _isLocationEnabled = true;
          _isLocationLoading = false;
        });
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
      return LocationBlockedScreen(onRetry: _checkLocationPermissionAsync);
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
                const SliverToBoxAdapter(child: FeaturedSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: Container(
                    key: theaterKey,
                    child: const TheaterSection(),
                  ),
                ),
                const SliverToBoxAdapter(child: ImageCollageSection()),
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
            // Welcome overlay
            if (_showWelcomeOverlay)
              WelcomeOverlay(
                onSkip: _markWelcomeCompleted,
                onNext: _markWelcomeCompleted,
              ),
          ],
        ),
      
    );
  }

  // Simplified dialogs without heavy styling for better performance
  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LocationPermissionDialog(
        onPermissionGranted: () {
          Navigator.of(context).pop();
          _checkLocationService();
        },
        onOpenSettings: () {
          Navigator.of(context).pop();
          _showOpenSettingsDialog();
        },
        locationService: ref.read(locationServiceProvider),
      ),
    );
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OpenSettingsDialog(
        onSettingsOpened: () {
          Navigator.of(context).pop();
          Future.delayed(
            const Duration(seconds: 1),
            _checkLocationPermissionAsync,
          );
        },
        locationService: ref.read(locationServiceProvider),
      ),
    );
  }

  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EnableLocationDialog(
        onLocationEnabled: () {
          Navigator.of(context).pop();
          Future.delayed(const Duration(seconds: 1), _checkLocationService);
        },
        locationService: ref.read(locationServiceProvider),
      ),
    );
  }
}
