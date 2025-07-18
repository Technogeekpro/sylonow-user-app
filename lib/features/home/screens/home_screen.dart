import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sylonow_user/features/home/widgets/categories/explore_categories_section.dart';
import 'package:sylonow_user/features/home/widgets/featured/featured_section.dart';
import 'package:sylonow_user/features/home/widgets/collage/image_collage_section.dart';
import 'package:sylonow_user/features/home/widgets/popular_nearby/popular_nearby_section.dart';
import 'package:sylonow_user/features/home/widgets/quote/quote_section.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';
import 'package:sylonow_user/features/address/models/address_model.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/features/address/screens/manage_address_screen.dart';
import 'package:sylonow_user/core/utils/image_cache_manager.dart';
import 'package:sylonow_user/features/wishlist/screens/wishlist_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  late final ScrollController _scrollController;
  late final ValueNotifier<double> _scrollOffsetNotifier;
  bool _isLocationEnabled = false;
  bool _isLocationLoading = true;

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
    _scrollController.addListener(_onScroll);
    
    // Move expensive operations to next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
      AppImageCacheManager.preloadCriticalImages(context);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffsetNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      _scrollOffsetNotifier.value = _scrollController.offset;
    }
  }

  Future<void> _checkLocationPermission() async {
    try {
      print('🔍 Checking location permission...');
      final locationService = ref.read(locationServiceProvider);
      final permissionStatus = await locationService.getPermissionStatus();
      print('📍 Permission status: $permissionStatus');
      
      if (permissionStatus == LocationPermission.denied || 
          permissionStatus == LocationPermission.deniedForever) {
        print('❌ Permission denied, showing dialog');
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
        });
        // Using WidgetsBinding.instance.addPostFrameCallback to show the dialog
        // after the first frame is rendered.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLocationPermissionDialog();
        });
      } else if (permissionStatus == LocationPermission.whileInUse || 
                 permissionStatus == LocationPermission.always) {
        print('✅ Permission granted, checking location service');
        _checkLocationService();
      } else {
        print('⚠️ Unhandled permission status: $permissionStatus');
        // Unhandled permission status, show permission dialog
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLocationPermissionDialog();
        });
      }
    } catch (e) {
      print('💥 Error checking permission: $e');
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
    try {
      print('🛰️ Checking location service...');
      final locationService = ref.read(locationServiceProvider);
      final serviceEnabled = await locationService.isLocationServiceEnabled();
      print('📡 Service enabled: $serviceEnabled');
      
      if (!serviceEnabled) {
        print('❌ Location service disabled, showing dialog');
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showEnableLocationDialog();
        });
      } else {
        print('✅ Location service enabled, getting location');
        _getCurrentLocation();
      }
    } catch (e) {
      print('💥 Error checking location service: $e');
      setState(() {
        _isLocationLoading = false;
        _isLocationEnabled = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showEnableLocationDialog();
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      print('🎯 Getting current location...');
      final locationService = ref.read(locationServiceProvider);
      
      // Add timeout to prevent infinite loading
      print('⏱️ Requesting location with 30s timeout...');
      final position = await locationService.getCurrentLocation()
          .timeout(const Duration(seconds: 30));
      
      if (position != null) {
        print('📍 Position received: ${position.latitude}, ${position.longitude}');
        try {
          print('🔍 Getting address from coordinates...');
          final placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          
          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;
            print('🏠 Address found: ${placemark.street}, ${placemark.locality}');
            
            // Create address even without user (for guest access)
            final currentAddress = Address(
              id: const Uuid().v4(),
              userId: ref.read(currentUserProvider)?.id ?? 'guest',
              addressFor: AddressType.home,
              address: '${placemark.street ?? ''}, ${placemark.locality ?? 'Unknown Location'}',
              area: placemark.subLocality ?? placemark.locality ?? 'Unknown Area',
              name: 'Current Location',
            );
            
            ref.read(selectedAddressProvider.notifier).state = currentAddress;
            
            print('✅ Location enabled successfully!');
            setState(() {
              _isLocationEnabled = true;
              _isLocationLoading = false;
            });
          } else {
            print('⚠️ No placemarks found, using coordinates');
            // No placemarks found, but still enable with basic info
            final basicAddress = Address(
              id: const Uuid().v4(),
              userId: ref.read(currentUserProvider)?.id ?? 'guest',
              addressFor: AddressType.home,
              address: 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
              area: 'Location Found',
              name: 'Current Location',
            );
            
            ref.read(selectedAddressProvider.notifier).state = basicAddress;
            
            print('✅ Location enabled with coordinates!');
            setState(() {
              _isLocationEnabled = true;
              _isLocationLoading = false;
            });
          }
        } catch (e) {
          print('❌ Geocoding failed: $e');
          // Geocoding failed, but we have coordinates
          final basicAddress = Address(
            id: const Uuid().v4(),
            userId: ref.read(currentUserProvider)?.id ?? 'guest',
            addressFor: AddressType.home,
            address: 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
            area: 'Location Found',
            name: 'Current Location',
          );
          
          ref.read(selectedAddressProvider.notifier).state = basicAddress;
          
          print('✅ Location enabled despite geocoding error!');
          setState(() {
            _isLocationEnabled = true;
            _isLocationLoading = false;
          });
        }
      } else {
        print('❌ Position is null');
        setState(() {
          _isLocationLoading = false;
          _isLocationEnabled = false;
        });
      }
    } catch (e) {
      print('💥 Error in _getCurrentLocation: $e');
      // Timeout or other error occurred
      setState(() {
        _isLocationLoading = false;
        _isLocationEnabled = false;
      });
      
      // Show error dialog if needed
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLocationErrorDialog();
        });
      }
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Location Access Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Location access is mandatory to use this app. We need your location to show relevant services and provide accurate delivery.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final locationService = ref.read(locationServiceProvider);
                  final status = await locationService.requestPermission();
                  if (status == LocationPermission.whileInUse || 
                      status == LocationPermission.always) {
                    Navigator.of(context).pop();
                    _checkLocationService();
                  } else if (status == LocationPermission.deniedForever) {
                    // Show app settings dialog
                    Navigator.of(context).pop();
                    _showOpenSettingsDialog();
                  }
                  // If denied, dialog stays open for retry
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Allow Location Access',
                  style: TextStyle(fontFamily: 'Okra'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Location Permission Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Location permission was permanently denied. Please enable it in app settings to continue using the app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final locationService = ref.read(locationServiceProvider);
                  await locationService.openAppSettings();
                  // Recheck permission after returning from settings
                  Future.delayed(const Duration(seconds: 1), () {
                    _checkLocationPermission();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Open Settings',
                  style: TextStyle(fontFamily: 'Okra'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLocationErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Location Error',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Unable to get your current location. Please check your device settings and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _checkLocationPermission(); // Retry the entire flow
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(fontFamily: 'Okra'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Location Service Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Location service is mandatory to use this app. Please enable device location to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final locationService = ref.read(locationServiceProvider);
                  await locationService.openLocationSettings();
                  // Recheck location service after returning from settings
                  Future.delayed(const Duration(seconds: 1), () {
                    _checkLocationService();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Enable Location Service',
                  style: TextStyle(fontFamily: 'Okra'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    if (_isLocationLoading) {
      return _buildLocationLoadingScreen();
    }
    
    if (!_isLocationEnabled) {
      return _buildLocationBlockedScreen();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Main scrollable content
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(child: _buildAdvertisementSection(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
                const SliverToBoxAdapter(child: QuoteSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                const SliverToBoxAdapter(child: ExploreCategoriesSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                const SliverToBoxAdapter(child: FeaturedSection()),
                const SliverToBoxAdapter(child: ImageCollageSection()),
                const SliverToBoxAdapter(child: PopularNearbySection()),
              ],
            ),
            // Custom App Bar as an overlay with performance optimization
            ValueListenableBuilder<double>(
              valueListenable: _scrollOffsetNotifier,
              builder: (context, scrollOffset, child) {
                return _buildCustomAppBarOverlay(scrollOffset);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBarOverlay(double scrollOffset) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const locationSectionHeight = 70.0;
    const searchSectionHeight = 60.0;

    // 0.0 -> 1.0 as user scrolls through the location section height
    final locationScrollRatio = (scrollOffset / locationSectionHeight).clamp(
      0.0,
      1.0,
    );

    // Opacity for the app bar background (becomes fully opaque after scrolling 50px)
    final appBarOpacity = (scrollOffset / 50).clamp(0.0, 1.0);

    return Container(
      // Height shrinks as user scrolls, causing search bar to "stick" at top
      height:
          statusBarHeight +
          locationSectionHeight +
          searchSectionHeight -
          (locationSectionHeight * locationScrollRatio),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(appBarOpacity),
        boxShadow: appBarOpacity > 0.5
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Location Section (slides up and fades out)
          Positioned(
            top:
                statusBarHeight - (locationSectionHeight * locationScrollRatio),
            left: 0,
            right: 0,
            height: locationSectionHeight,
            child: Opacity(
              opacity: 1 - locationScrollRatio,
              child: _buildLocationContent(),
            ),
          ),
          // Search Section (stays at the bottom of the shrinking container)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: searchSectionHeight,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildSearchSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationContent() {
    final selectedAddress = ref.watch(selectedAddressProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_isLocationEnabled && selectedAddress != null) {
                  // Only allow changing address if location is enabled
                  context.go(ManageAddressScreen.routeName);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Transform.rotate(
                        angle: 1,
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedAddress?.area ?? 'Accurate location detected',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold, 
                            fontFamily: 'Okra',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_isLocationEnabled && selectedAddress != null)
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedAddress?.address ?? 'Current Location',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontFamily: 'Okra',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {},
                icon: Icon(Icons.wallet, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  context.go(WishlistScreen.routeName);
                },
                icon: Icon(Icons.favorite, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E2E4), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(5, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Icon(Icons.search, color: Color(0xFFF34E5F), size: 20),
          ),
          Expanded(
            child: Container(
              height: 45,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Text(
                    'Search "',
                    style: TextStyle(
                      color: Color(0xFF737680),
                      fontSize: 14,
                      fontFamily: 'Okra',
                    ),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      color: Color(0xFF737680),
                      fontSize: 14,
                      fontFamily: 'Okra',
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: _searchTexts
                          .map(
                            (text) => TypewriterAnimatedText(
                              text,
                              speed: const Duration(milliseconds: 80),
                              cursor: '',
                            ),
                          )
                          .toList(),
                      repeatForever: true,
                      pause: const Duration(milliseconds: 1000),
                      displayFullTextOnTap: true,
                    ),
                  ),
                  const Text(
                    '"',
                    style: TextStyle(
                      color: Color(0xFF737680),
                      fontSize: 14,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationLoadingScreen() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.pink,
            ),
            const SizedBox(height: 24),
            const Text(
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

  Widget _buildLocationBlockedScreen() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 24),
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
                  onPressed: () {
                    _checkLocationPermission();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Enable Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Okra',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvertisementSection(BuildContext context) {
    const double appBarHeight = 130;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: 400 + appBarHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/splash_screen.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight + appBarHeight + 24,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎉 Special Offer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
                fontFamily: 'Okra',
              ),
            ),
            OptimizedAssetImage(
              assetPath: 'assets/images/sylonow_white_logo.png',
              width: 100,
              height: 56,
            ),
            const SizedBox(height: 12),
            const Text(
              'Get 50% OFF\non Your First\nService Booking!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Okra',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Book any service and enjoy massive savings.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                fontFamily: 'Okra',
                height: 1.4,
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Book Now & Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontFamily: 'Okra',
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.pink, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
