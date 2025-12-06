import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/core/widgets/gredient_elevated_button.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';
import 'package:sylonow_user/features/address/screens/manage_address_screen.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';

import 'celebration_date_container.dart';

/// Custom app bar overlay with location and search sections
class CustomAppBarOverlay extends ConsumerWidget {
  const CustomAppBarOverlay({
    super.key,
    required this.scrollOffset,
    required this.isLocationEnabled,
    required this.profileKey,
    required this.locationKey,
    required this.searchKey,
  });

  final double scrollOffset;
  final bool isLocationEnabled;
  final GlobalKey profileKey;
  final GlobalKey locationKey;
  final GlobalKey searchKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const locationSectionHeight = 70.0;
    const searchSectionHeight = 60.0;

    final locationScrollRatio = (scrollOffset / locationSectionHeight).clamp(
      0.0,
      1.0,
    );
    final appBarOpacity = (scrollOffset / 50).clamp(0.0, 1.0);

    return Container(
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
          Positioned(
            top:
                statusBarHeight - (locationSectionHeight * locationScrollRatio),
            left: 0,
            right: 0,
            height: locationSectionHeight,
            child: Opacity(
              opacity: 1 - locationScrollRatio,
              child: LocationContent(
                isLocationEnabled: isLocationEnabled,
                profileKey: profileKey,
                locationKey: locationKey,
              ),
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
              child: SearchSection(searchKey: searchKey),
            ),
          ),
        ],
      ),
    );
  }
}

/// Location content section of the app bar
class LocationContent extends ConsumerWidget {
  const LocationContent({
    super.key,
    required this.isLocationEnabled,
    required this.profileKey,
    required this.locationKey,
  });

  final bool isLocationEnabled;
  final GlobalKey profileKey;
  final GlobalKey locationKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAddress = ref.watch(selectedAddressProvider);

    // Watch nearby services to determine text color
    final nearbyState = ref.watch(popularNearbyServicesProvider);
    final hasServices = nearbyState.maybeWhen(
      data: (services) => services.isNotEmpty,
      orElse: () => true, // Default to true during loading/error (show white)
    );

    // Dynamic colors based on service availability
    final iconColor = hasServices ? Colors.white : Colors.black87;
    final textColor = hasServices ? Colors.white : Colors.black87;
    final subtextColor = hasServices ? Colors.white.withValues(alpha: 0.8) : Colors.black54;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              key: locationKey,
              child: GestureDetector(
                onTap: () {
                  if (isLocationEnabled && selectedAddress != null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      transitionAnimationController: AnimationController(
                        duration: const Duration(milliseconds: 300),
                        vsync: Scaffold.of(context),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.9,
                        minChildSize: 0.5,
                        maxChildSize: 0.95,
                        builder: (context, scrollController) =>
                            const ManageAddressScreen(),
                      ),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: 1,
                          child: Icon(
                            Icons.navigation,
                            color: iconColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            selectedAddress?.area ?? 'Accurate location detected',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Okra',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isLocationEnabled && selectedAddress != null)
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: iconColor,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selectedAddress?.address ?? 'Current Location',
                      style: GoogleFonts.outfit(
                        color: subtextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Row(
            children: [
              CelebrationDateContainer(),
              SizedBox(width: 8),
              WishlistButton(),
            ],
          ),
        ],
      ),
    );
  }
}

/// Wishlist button widget
class WishlistButton extends StatelessWidget {
  const WishlistButton({super.key});

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
        context.push('/wishlist');
      },
      icon: const Icon(Icons.favorite, color: Colors.white, size: 20),
    );
  }
}

/// Search section of the app bar
class SearchSection extends StatelessWidget {
  const SearchSection({super.key, required this.searchKey});

  final GlobalKey searchKey;

  // Memoized search texts
  static const List<String> _searchTexts = [
    'Birthday Decoration',
    'Anniversary Setup',
    'Wedding Decoration',
    'Baby Shower',
    'Corporate Events',
    'Theme Parties',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: searchKey,
      child: GestureDetector(
        onTap: () {
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
                child: Icon(Icons.search, color: Colors.blue, size: 20),
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
                      Expanded(child: AnimatedSearchText()),
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
      ),
    );
  }
}

/// Animated search text widget
class AnimatedSearchText extends StatelessWidget {
  const AnimatedSearchText({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: Color(0xFF737680),
        fontSize: 14,
        fontFamily: 'Okra',
      ),
      child: AnimatedTextKit(
        animatedTexts: SearchSection._searchTexts
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

/// Advertisement section widget
class AdvertisementSection extends StatelessWidget {
  const AdvertisementSection({super.key});

  @override
  Widget build(BuildContext context) {
    double appBarHeight = 130;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () {
        context.push('/discounted-services');
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35 + appBarHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/splash_screen.png'),
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
              Row(
                children: [
                  //Lottie
                  Lottie.asset(
                    'assets/animations/confetti.json',
                    width: 36,
                    height: 36,
                  ),
                  Text(
                    ' Special Offer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/svgs/app_logo_text.svg',
                width: 100,
                height: 30,
              ),
              const SizedBox(height: 12),
              const Text(
                'Get Upto 50% OFF\non Services!',
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
              GradientElevatedButton(
                text: 'Book Now & Save',
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  context.push('/discounted-services');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
