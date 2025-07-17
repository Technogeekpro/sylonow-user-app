import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

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

  // Mock data for venues
  final List<Map<String, String>> _venues = [
    {
      'name': 'Powai, Mumbai',
      'rating': '4.6',
      'distance': '38.8 km',
      'openTime': 'Opens at 12 noon',
      'price': '₹1200 for two',
      'offer': 'Flat 10% OFF',
      'image': 'assets/images/category1.jpg',
    },
    {
      'name': 'Santacruz West, Mumbai',
      'rating': '4.5',
      'distance': '40.9 km',
      'openTime': 'Opens at 12 noon',
      'price': '₹2500 for two',
      'offer': 'Flat 10% OFF',
      'image': 'assets/images/category2.jpg',
    },
    {
      'name': 'Worli, Mumbai',
      'rating': '4.6',
      'distance': '43.2 km',
      'openTime': 'Opens at 12 noon',
      'price': '₹3200 for two',
      'offer': 'Flat 10% OFF',
      'image': 'assets/images/category3.jpg',
    },
    {
      'name': 'Bandra West, Mumbai',
      'rating': '4.3',
      'distance': '35.5 km',
      'openTime': 'Opens at 11 AM',
      'price': '₹1800 for two',
      'offer': 'Flat 15% OFF',
      'image': 'assets/images/category4.jpg',
    },
    {
      'name': 'Andheri East, Mumbai',
      'rating': '4.4',
      'distance': '28.3 km',
      'openTime': 'Opens at 10 AM',
      'price': '₹2200 for two',
      'offer': 'Flat 12% OFF',
      'image': 'assets/images/category5.jpg',
    },
    {
      'name': 'Juhu, Mumbai',
      'rating': '4.7',
      'distance': '42.1 km',
      'openTime': 'Opens at 12 noon',
      'price': '₹2800 for two',
      'offer': 'Flat 20% OFF',
      'image': 'assets/images/category1.jpg',
    },
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

                      // Venues List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _venues.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final venue = _venues[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Venue Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      image: DecorationImage(
                                        image: AssetImage(venue['image']!),
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) {
                                          // Fallback for missing images
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Venue Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Venue Name
                                      Text(
                                        venue['name']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2A3143),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      const SizedBox(height: 4),

                                      // Rating
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  venue['rating']!,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 2),
                                                const Icon(
                                                  Icons.star,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      // Distance and Opening Time
                                      Row(
                                        children: [
                                          Text(
                                            venue['distance']!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF757575),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            width: 2,
                                            height: 2,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF757575),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            venue['openTime']!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF757575),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      // Price and Offer
                                      Row(
                                        children: [
                                          Text(
                                            venue['price']!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF2A3143),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            width: 2,
                                            height: 2,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF757575),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            venue['offer']!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
