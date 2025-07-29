import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/user_location_helper.dart';
import '../../../core/utils/location_utils.dart';
import '../../home/providers/home_providers.dart';
import '../../home/models/service_listing_model.dart';

class InsideScreen extends ConsumerStatefulWidget {
  const InsideScreen({super.key});

  @override
  ConsumerState<InsideScreen> createState() => _InsideScreenState();
}

class _InsideScreenState extends ConsumerState<InsideScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  late AnimationController _searchAnimationController;
  late Animation<double> _slideAnimation;

  int _currentSearchIndex = 0;
  final List<String> _searchTexts = [
    'Birthday Decoration',
    'Anniversary Setup',
    'Wedding Decoration',
    'Baby Shower',
    'Corporate Events',
    'Theme Parties',
  ];

  // Mock data for carousel
  final List<Map<String, String>> _carouselItems = [
    {
      'title': 'Flash Sale',
      'subtitle': 'Only This Weekend',
      'discount': 'Up to ₹200 Cashback',
      'code': 'DISCOUNT23',
      'image': 'assets/images/carousel_1.jpg',
    },
    {
      'title': 'Home Decor',
      'subtitle': 'Transform Your Space',
      'discount': 'Up to 50% Off',
      'code': 'HOME50',
      'image': 'assets/images/carousel_2.jpg',
    },
    {
      'title': 'Wedding Special',
      'subtitle': 'Make It Memorable',
      'discount': 'Up to ₹500 Off',
      'code': 'WEDDING500',
      'image': 'assets/images/carousel_3.jpg',
    },
  ];

  // Mock data for categories
  final List<Map<String, String>> _categories = [
    {'title': 'Private Birthday', 'image': 'assets/images/category1.jpg'},
    {'title': 'Anniversary', 'image': 'assets/images/category2.jpg'},
    {'title': 'Theme Birthday', 'image': 'assets/images/category3.jpg'},
    {'title': 'Wedding Decor', 'image': 'assets/images/category4.jpg'},
    {'title': 'Baby Shower', 'image': 'assets/images/category5.jpg'},
    {'title': 'Corporate Events', 'image': 'assets/images/category1.jpg'},
  ];


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize search animation
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation cycle
    _startSearchAnimation();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _pageController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _startSearchAnimation() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        await _searchAnimationController.forward();
        if (mounted) {
          setState(() {
            _currentSearchIndex =
                (_currentSearchIndex + 1) % _searchTexts.length;
          });
          _searchAnimationController.reset();
        }
      }
    }
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

      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Main scrollable content
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // We add a spacer here so the next content isn't hidden behind the search bar initially
                const SliverToBoxAdapter(child: SizedBox(height: 180)),
                // Main Content
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Carousel with custom radius
                      SizedBox(
                        height: 180,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _carouselItems.length,
                          padEnds: false,
                          clipBehavior: Clip.none,
                          itemBuilder: (context, index) {
                            final item = _carouselItems[index];
                            return GestureDetector(
                              onTap: () => _onCarouselTap(item),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: index == 0 ? 16 : 8,
                                  right: index == _carouselItems.length - 1
                                      ? 16
                                      : 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryColor.withOpacity(0.8),
                                      AppTheme.primaryColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Background pattern
                                    Positioned(
                                      right: -20,
                                      top: -20,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                    ),

                                    // Content
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['subtitle']!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['title']!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['discount']!,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      item['code']!,
                                                      style: TextStyle(
                                                        color: AppTheme
                                                            .primaryColor,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Shopping cart icon with decorative elements
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: const Icon(
                                                  Icons.shopping_cart,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Smooth Page Indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: _carouselItems.length,
                            effect: WormEffect(
                              dotColor: Colors.grey.shade300,
                              activeDotColor: AppTheme.primaryColor,
                              dotHeight: 8,
                              dotWidth: 8,
                              spacing: 4,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // What are you looking for section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              'What are you looking for ?',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            //Divider
                            const SizedBox(width: 10),
                            Expanded(
                              child: const Divider(
                                color: Color(0xffE8E9EE),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Categories Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.0, // Square aspect ratio
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return GestureDetector(
                              onTap: () {
                                // Handle category tap
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Selected: ${category['title']}',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 0,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      // Background image
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              category['image']!,
                                            ),
                                            fit: BoxFit.cover,
                                            onError: (exception, stackTrace) {
                                              // Fallback for missing images
                                            },
                                          ),
                                        ),
                                      ),

                                      // Dark overlay for better text readability
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7),
                                            ],
                                            stops: const [0.5, 1.0],
                                          ),
                                        ),
                                      ),

                                      // Title at bottom center
                                      Positioned(
                                        bottom: 12,
                                        left: 8,
                                        right: 8,
                                        child: Text(
                                          category['title']!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(0, 1),
                                                blurRadius: 3,
                                                color: Colors.black54,
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Popular Venues Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              'Popular Venues Near You',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            //Divider
                            const SizedBox(width: 10),
                            Expanded(
                              child: const Divider(
                                color: Color(0xffE8E9EE),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Inside Decoration Services List with Location
                      FutureBuilder<Map<String, dynamic>?>(
                        future: UserLocationHelper.getDecorationTypeLocationParams(ref, 'inside'),
                        builder: (context, locationSnapshot) {
                          if (locationSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            );
                          }

                          final locationParams = locationSnapshot.data;
                          if (locationParams == null) {
                            // Fallback to non-location based services
                            return Consumer(
                              builder: (context, ref, child) {
                                final servicesAsync = ref.watch(
                                  servicesByDecorationTypeProvider('inside')
                                );
                                return _buildServicesList(servicesAsync, ref, 'inside');
                              },
                            );
                          }

                          // Use location-based services
                          return Consumer(
                            builder: (context, ref, child) {
                              final servicesAsync = ref.watch(
                                servicesByDecorationTypeWithLocationProvider(locationParams)
                              );
                              return _buildServicesList(servicesAsync, ref, 'inside', isLocationBased: true);
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
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

  Widget _buildServicesList(
    AsyncValue<List<ServiceListingModel>> servicesAsync,
    WidgetRef ref,
    String decorationType, {
    bool isLocationBased = false,
  }) {
    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'No services available in your area',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildServiceCard(service, isLocationBased);
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        ),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load services',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your connection and try again',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceListingModel service, bool isLocationBased) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 180,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: service.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          
          // Service Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Name and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (service.rating != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              service.rating!.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // Distance and Location Info (if location-based)
                if (isLocationBased && service.distanceKm != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppTheme.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${service.distanceKm!.toStringAsFixed(1)} km away',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (service.isPriceAdjusted == true) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.orange,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            '+₹100 (Distance)',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                ],

                // Pricing
                Row(
                  children: [
                    if (service.displayOriginalPrice != null &&
                        service.displayOfferPrice != null &&
                        service.displayOriginalPrice! > service.displayOfferPrice!) ...[
                      Text(
                        '₹${service.displayOriginalPrice!.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (service.displayOfferPrice != null)
                      Text(
                        '₹${service.displayOfferPrice!.toInt()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    if (service.displayOfferPrice == null && service.displayOriginalPrice != null)
                      Text(
                        '₹${service.displayOriginalPrice!.toInt()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    const Spacer(),
                    if (service.promotionalTag != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          service.promotionalTag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/service-detail/${service.id}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBarOverlay() {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final titleSectionHeight = 70.0;
    final searchSectionHeight = 60.0;

    // 0.0 -> 1.0 as user scrolls through the title section height
    final titleScrollRatio = (_scrollOffset / titleSectionHeight).clamp(
      0.0,
      1.0,
    );

    return Container(
      // Height shrinks as user scrolls, causing search bar to "stick" at top
      height:
          statusBarHeight +
          titleSectionHeight +
          searchSectionHeight -
          (titleSectionHeight * titleScrollRatio),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Title Section (slides up and fades out)
          Positioned(
            top: statusBarHeight - (titleSectionHeight * titleScrollRatio),
            left: 0,
            right: 0,
            height: titleSectionHeight,
            child: Opacity(
              opacity: 1 - titleScrollRatio,
              child: _buildTitleContent(),
            ),
          ),
          // Search Section (stays at the bottom of the shrinking container)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: searchSectionHeight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildSearchSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return Container(child: Text('Carousel'));
  }

  Widget _buildTitleContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Inside Decoration',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
            ),
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
}

class _onCarouselTap extends StatelessWidget {
  Map<String, String> item = {};

  _onCarouselTap(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Carousel'));
  }
}
