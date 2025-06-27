import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sylonow_user/features/home/widgets/app_bar/home_app_bar.dart';
import 'package:sylonow_user/features/home/widgets/categories/explore_categories_section.dart';
import 'package:sylonow_user/features/home/widgets/featured/featured_section.dart';
import 'package:sylonow_user/features/home/widgets/collage/image_collage_section.dart';
import 'package:sylonow_user/features/home/widgets/popular_nearby/popular_nearby_section.dart';
import 'package:sylonow_user/features/home/widgets/quote/quote_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  
  final List<String> _searchTexts = [
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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                // Advertisement container is now the first item, starting from the top
                SliverToBoxAdapter(child: _buildAdvertisementSection(context)),
                // We add a spacer here so the next content (QuoteSection) isn't hidden
                // behind the search bar initially.
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
                SliverToBoxAdapter(child: QuoteSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(child: ExploreCategoriesSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(child: FeaturedSection()),
                SliverToBoxAdapter(child: ImageCollageSection()),
                SliverToBoxAdapter(child: PopularNearbySection()),
              ],
            ),
            // Custom App Bar as an overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildCustomAppBarOverlay(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBarOverlay() {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final locationSectionHeight = 70.0;
    final searchSectionHeight = 60.0;

    // 0.0 -> 1.0 as user scrolls through the location section height
    final locationScrollRatio = (_scrollOffset / locationSectionHeight).clamp(
      0.0,
      1.0,
    );

    // Opacity for the app bar background (becomes fully opaque after scrolling 50px)
    final appBarOpacity = (_scrollOffset / 50).clamp(0.0, 1.0);

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Column(
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
                  const Text(
                    "Bangalore, Karnataka",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                "Shop no 7, Forest Colony",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          const Spacer(),
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
              const CircleAvatar(
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
        border: Border.all(
          color: const Color(0xFFE1E2E4),
          width: 0.5,
        ),
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
            child: Icon(
              Icons.search,
              color: Color(0xFFF34E5F),
              size: 20,
            ),
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
                      animatedTexts: _searchTexts.map((text) => 
                        TypewriterAnimatedText(
                          text,
                          speed: const Duration(milliseconds: 80),
                          cursor: '',
                        )
                      ).toList(),
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

  Widget _buildAdvertisementSection(BuildContext context) {
    // Add top padding to the ad's content so it doesn't start behind the app bar
    final double appBarHeight = 130;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height:
          400 +
          appBarHeight, // Increase height to account for the space it now occupies

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage('assets/images/splash_screen.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight + appBarHeight + 24, // Push content down
          left: 24,
          right: 24,
          bottom: 24,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Lottie.asset('assets/animations/celebrate.json'),
            ),
            Column(
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
                //Sylonow logo
                Image.asset(
                  'assets/images/sylonow_white_logo.png',
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
                  child: Row(
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
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.pink,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
