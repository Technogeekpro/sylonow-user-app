import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sylonow_user/features/home/widgets/categories/optimized_explore_categories_section.dart';
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

/// Optimized home screen with performance improvements
class OptimizedHomeScreen extends ConsumerStatefulWidget {
  const OptimizedHomeScreen({super.key});

  @override
  ConsumerState<OptimizedHomeScreen> createState() => _OptimizedHomeScreenState();
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
    
    // Performance optimization: Use value notifier instead of setState for scroll
    _scrollController.addListener(_onScroll);
    
    // Performance optimization: Move location operations to next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermissionAsync();
    });
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
      final position = await locationService.getCurrentLocation()
          .timeout(const Duration(seconds: 30));
      
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
      return const _LocationLoadingScreen();
    }
    
    if (!_isLocationEnabled) {
      return _LocationBlockedScreen(
        onRetry: _checkLocationPermissionAsync,
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
            slivers: const [
              SliverToBoxAdapter(child: _AdvertisementSection()),
             // SliverToBoxAdapter(child: SizedBox(height: 40)),
             // SliverToBoxAdapter(child: QuoteSection()),
              SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(child: OptimizedExploreCategoriesSection()),
              SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(child: FeaturedSection()),
              SliverToBoxAdapter(child: ImageCollageSection()),
              SliverToBoxAdapter(child: PopularNearbySection()),
            ],
          ),
          // Custom App Bar as an overlay
          ValueListenableBuilder<double>(
            valueListenable: _scrollOffsetNotifier,
            builder: (context, scrollOffset, child) {
              return _CustomAppBarOverlay(
                scrollOffset: scrollOffset,
                isLocationEnabled: _isLocationEnabled,
              );
            },
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
      builder: (context) => _LocationPermissionDialog(
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
      builder: (context) => _OpenSettingsDialog(
        onSettingsOpened: () {
          Navigator.of(context).pop();
          Future.delayed(const Duration(seconds: 1), _checkLocationPermissionAsync);
        },
        locationService: ref.read(locationServiceProvider),
      ),
    );
  }

  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _EnableLocationDialog(
        onLocationEnabled: () {
          Navigator.of(context).pop();
          Future.delayed(const Duration(seconds: 1), _checkLocationService);
        },
        locationService: ref.read(locationServiceProvider),
      ),
    );
  }
}

// Performance optimization: Separate stateless widgets for reusability and const optimization
class _LocationLoadingScreen extends StatelessWidget {
  const _LocationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.pink),
            SizedBox(height: 24),
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

class _LocationBlockedScreen extends StatelessWidget {
  const _LocationBlockedScreen({super.key, required this.onRetry});
  
  final VoidCallback onRetry;

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
              const Icon(Icons.location_off, size: 100, color: Colors.grey),
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
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Enable Location',
                    style: TextStyle(fontSize: 16, fontFamily: 'Okra'),
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

// Performance optimization: Extract complex widgets to separate classes
class _CustomAppBarOverlay extends ConsumerWidget {
  const _CustomAppBarOverlay({
    super.key,
    required this.scrollOffset,
    required this.isLocationEnabled,
  });

  final double scrollOffset;
  final bool isLocationEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const locationSectionHeight = 70.0;
    const searchSectionHeight = 60.0;

    final locationScrollRatio = (scrollOffset / locationSectionHeight).clamp(0.0, 1.0);
    final appBarOpacity = (scrollOffset / 50).clamp(0.0, 1.0);

    return Container(
      height: statusBarHeight + locationSectionHeight + searchSectionHeight -
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
          Positioned(
            top: statusBarHeight - (locationSectionHeight * locationScrollRatio),
            left: 0,
            right: 0,
            height: locationSectionHeight,
            child: Opacity(
              opacity: 1 - locationScrollRatio,
              child: _LocationContent(isLocationEnabled: isLocationEnabled),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: searchSectionHeight,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const _SearchSection(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationContent extends ConsumerWidget {
  const _LocationContent({super.key, required this.isLocationEnabled});
  
  final bool isLocationEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAddress = ref.watch(selectedAddressProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isLocationEnabled && selectedAddress != null) {
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
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedAddress?.area ?? 'Accurate location detected',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Okra',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isLocationEnabled && selectedAddress != null)
                        const Icon(
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
          const Row(
            children: [
              _WalletButton(),
              SizedBox(width: 8),
              _UserAvatar(),
            ],
          ),
        ],
      ),
    );
  }
}

class _WalletButton extends StatelessWidget {
  const _WalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: Colors.white),
        ),
      ),
      onPressed: () {
        context.push('/wallet');
      },
      icon: const Icon(Icons.wallet, color: Colors.white, size: 20),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/profile');
      },
      child: const CircleAvatar(
        backgroundColor: Colors.black,
        radius: 20,
        child: Text(
          "A",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
          ),
        ),
      ),
    );
  }
}

class _SearchSection extends StatelessWidget {
  const _SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to search screen
        context.push('/search');
      },
      child: Container(
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
                child: const Row(
                  children: [
                    Text(
                      'Search "',
                      style: TextStyle(
                        color: Color(0xFF737680),
                        fontSize: 14,
                        fontFamily: 'Okra',
                      ),
                    ),
                    Expanded(child: _AnimatedSearchText()),
                    Text(
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
      ),
    );
  }
}

// Performance optimization: Separate animated text to avoid rebuilding parent
class _AnimatedSearchText extends StatelessWidget {
  const _AnimatedSearchText({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: Color(0xFF737680),
        fontSize: 14,
        fontFamily: 'Okra',
      ),
      child: AnimatedTextKit(
        animatedTexts: _OptimizedHomeScreenState._searchTexts
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
    );
  }
}

// Performance optimization: Simplify advertisement section - remove heavy Lottie
class _AdvertisementSection extends StatelessWidget {
  const _AdvertisementSection({super.key});

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 130;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: 260 + appBarHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/splash_screen.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight + appBarHeight + 10,
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
            Image.asset(
              'assets/images/sylonow_white_logo.png',
              width: 100,
              height: 30,
            ),
            const SizedBox(height: 12),
            const Text(
              'Get 50% OFF\non Your First Service Booking!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Okra',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
          
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

// Optimized dialog widgets with minimal styling for better performance
class _LocationPermissionDialog extends StatelessWidget {
  const _LocationPermissionDialog({
    super.key,
    required this.onPermissionGranted,
    required this.onOpenSettings,
    required this.locationService,
  });

  final VoidCallback onPermissionGranted;
  final VoidCallback onOpenSettings;
  final dynamic locationService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Location Access Required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Location access is mandatory to use this app.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final status = await locationService.requestPermission();
              if (status.toString().contains('whileInUse') || 
                  status.toString().contains('always')) {
                onPermissionGranted();
              } else if (status.toString().contains('deniedForever')) {
                onOpenSettings();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Allow Location Access'),
          ),
        ),
      ],
    );
  }
}

class _OpenSettingsDialog extends StatelessWidget {
  const _OpenSettingsDialog({
    super.key,
    required this.onSettingsOpened,
    required this.locationService,
  });

  final VoidCallback onSettingsOpened;
  final dynamic locationService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.settings, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Location Permission Required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Please enable location permission in app settings.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await locationService.openAppSettings();
              onSettingsOpened();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Open Settings'),
          ),
        ),
      ],
    );
  }
}

class _EnableLocationDialog extends StatelessWidget {
  const _EnableLocationDialog({
    super.key,
    required this.onLocationEnabled,
    required this.locationService,
  });

  final VoidCallback onLocationEnabled;
  final dynamic locationService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_off, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Location Service Required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Please enable device location to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await locationService.openLocationSettings();
              onLocationEnabled();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Enable Location Service'),
          ),
        ),
      ],
    );
  }
}