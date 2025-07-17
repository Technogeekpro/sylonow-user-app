import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../core/theme/app_theme.dart';

class OutsideScreen extends ConsumerStatefulWidget {
  const OutsideScreen({super.key});

  @override
  ConsumerState<OutsideScreen> createState() => _OutsideScreenState();
}

class _OutsideScreenState extends ConsumerState<OutsideScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  
  late AnimationController _searchAnimationController;
  late Animation<double> _slideAnimation;
  
  int _currentSearchIndex = 0;
  final List<String> _searchTexts = [
    'Garden Decoration',
    'Outdoor Wedding',
    'Pool Party Setup',
    'Terrace Makeover',
    'Lawn Events',
    'Outdoor Lighting',
  ];

  // Mock data for carousel - Outside themed
  final List<Map<String, String>> _carouselItems = [
    {
      'title': 'Garden Special',
      'subtitle': 'Limited Time Offer',
      'discount': 'Up to ₹300 Cashback',
      'code': 'GARDEN30',
      'image': 'assets/images/carousel_1.jpg',
    },
    {
      'title': 'Outdoor Events',
      'subtitle': 'Transform Your Outdoors',
      'discount': 'Up to 60% Off',
      'code': 'OUTDOOR60',
      'image': 'assets/images/carousel_2.jpg',
    },
    {
      'title': 'Lawn Wedding',
      'subtitle': 'Make It Spectacular',
      'discount': 'Up to ₹800 Off',
      'code': 'LAWN800',
      'image': 'assets/images/carousel_3.jpg',
    },
  ];

  // Mock data for categories - Outside themed
  final List<Map<String, String>> _categories = [
    {'title': 'Garden Decoration', 'image': 'assets/images/category1.jpg'},
    {'title': 'Terrace Setup', 'image': 'assets/images/category2.jpg'},
    {'title': 'Pool Party', 'image': 'assets/images/category3.jpg'},
    {'title': 'Outdoor Wedding', 'image': 'assets/images/category4.jpg'},
    {'title': 'Lawn Events', 'image': 'assets/images/category5.jpg'},
    {'title': 'Outdoor Lighting', 'image': 'assets/images/category1.jpg'},
  ];

  // Mock data for venues - Outside themed
  final List<Map<String, String>> _venues = [
    {
      'name': 'Rose Garden, Pune',
      'rating': '4.8',
      'distance': '12.5 km',
      'openTime': 'Opens at 9 AM',
      'price': '₹3500 for event',
      'offer': 'Flat 15% OFF',
      'image': 'assets/images/category1.jpg',
    },
    {
      'name': 'Lotus Terrace, Mumbai',
      'rating': '4.7',
      'distance': '18.2 km',
      'openTime': 'Opens at 10 AM',
      'price': '₹4200 for event',
      'offer': 'Flat 20% OFF',
      'image': 'assets/images/category2.jpg',
    },
    {
      'name': 'Green Valley, Bangalore',
      'rating': '4.9',
      'distance': '25.3 km',
      'openTime': 'Opens at 8 AM',
      'price': '₹5800 for event',
      'offer': 'Flat 25% OFF',
      'image': 'assets/images/category3.jpg',
    },
    {
      'name': 'Sunset Lawn, Delhi',
      'rating': '4.6',
      'distance': '22.1 km',
      'openTime': 'Opens at 9:30 AM',
      'price': '₹3800 for event',
      'offer': 'Flat 18% OFF',
      'image': 'assets/images/category4.jpg',
    },
    {
      'name': 'Ocean View Terrace, Goa',
      'rating': '4.8',
      'distance': '35.7 km',
      'openTime': 'Opens at 11 AM',
      'price': '₹6500 for event',
      'offer': 'Flat 30% OFF',
      'image': 'assets/images/category5.jpg',
    },
    {
      'name': 'Riverside Garden, Kolkata',
      'rating': '4.5',
      'distance': '28.9 km',
      'openTime': 'Opens at 10:30 AM',
      'price': '₹4800 for event',
      'offer': 'Flat 22% OFF',
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
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    ));
    
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
            _currentSearchIndex = (_currentSearchIndex + 1) % _searchTexts.length;
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
                  return Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == _carouselItems.length - 1 ? 16 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.8),
                          Colors.green,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          item['code']!,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Tree/garden icon with decorative elements
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      Icons.park,
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
                    activeDotColor: Colors.green,
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
                    'What outdoor service do you need ?',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  //Divider
                  const SizedBox(width: 10),
                  Expanded(child: const Divider(color: Color(0xffE8E9EE), thickness: 1)),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          content: Text('Selected: ${category['title']}'),
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
                                  image: AssetImage(category['image']!),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {
                                    // Fallback for missing images
                                  },
                                ),
                              ),
                            ),
                            
                            // Green overlay for outdoor theme
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.green.withOpacity(0.7),
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
            
            // Popular Outdoor Venues Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Popular Outdoor Venues Near You',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  //Divider
                  const SizedBox(width: 10),
                  Expanded(child: const Divider(color: Color(0xffE8E9EE), thickness: 1)),
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
              separatorBuilder: (context, index) => const SizedBox(height: 12),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    borderRadius: BorderRadius.circular(4),
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
                                    color: Colors.green,
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
    final titleScrollRatio = (_scrollOffset / titleSectionHeight).clamp(0.0, 1.0);

    return Container(
      // Height shrinks as user scrolls, causing search bar to "stick" at top
      height: statusBarHeight + titleSectionHeight + searchSectionHeight - (titleSectionHeight * titleScrollRatio),
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

  Widget _buildTitleContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
       
          const Text(
            'Outside Decoration',
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
              color: Colors.green,
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
                    'Search \"',
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
                    '\"',
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