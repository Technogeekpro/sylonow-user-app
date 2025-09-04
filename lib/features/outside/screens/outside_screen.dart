import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/decoration_card.dart';
import '../../home/models/service_listing_model.dart';
import '../../home/models/filter_model.dart';
import '../../home/providers/filter_providers.dart';
import '../../home/widgets/service_filter_sheet.dart';

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



  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initialize search animation
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
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
                
                // Carousel and header content
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
                                right: index == _carouselItems.length - 1 ? 16 : 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.withValues(alpha: 0.8),
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
                                        color: Colors.white.withValues(alpha: 0.1),
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
                                          item['subtitle'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['title'] ?? '',
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
                                                  item['discount'] ?? '',
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
                                                    item['code'] ?? '',
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
                                                color: Colors.white.withValues(alpha: 0.2),
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
                      
                      // Outside Decoration Services Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              'Outside Decoration Services',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            //Divider
                            const SizedBox(width: 10),
                            Expanded(child: const Divider(color: Color(0xffE8E9EE), thickness: 1)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // Sticky Filter Bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _FilterBarDelegate(
                    child: _buildFilterBar(),
                  ),
                ),

                // Services List
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16),
                  sliver: Consumer(
                    builder: (context, ref, child) {
                      final servicesAsync = ref.watch(filteredOutsideServicesProvider);
                      return _buildSliverServicesList(servicesAsync, ref, 'outside');
                    },
                  ),
                ),
                
                // Bottom spacing
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
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
            color: Colors.black.withValues(alpha: 0.05),
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
            color: Colors.black.withValues(alpha: 0.05),
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



  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Sort dropdown
            SizedBox(
              width: 140,
              child: _buildSortDropdown(),
            ),
            const SizedBox(width: 8),
            
            // Filter button
            _buildFilterButton(),
            
            const SizedBox(width: 8),
            
            // Results count
            Consumer(
              builder: (context, ref, child) {
                final servicesAsync = ref.watch(filteredOutsideServicesProvider);
                return servicesAsync.when(
                  data: (services) => Text(
                    '${services.length} results',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Consumer(
      builder: (context, ref, child) {
        final filter = ref.watch(outsideFilterProvider);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300] ?? Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<SortOption>(
              value: filter.sortBy,
              icon: const Icon(Icons.keyboard_arrow_down, size: 16),
              isDense: true,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontFamily: 'Okra',
              ),
              items: SortOption.values.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(
                    option.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(outsideFilterProvider.notifier).update(
                    (state) => state.copyWith(sortBy: value),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton() {
    return Consumer(
      builder: (context, ref, child) {
        final activeFiltersCount = ref.watch(outsideActiveFiltersCountProvider);
        return InkWell(
          onTap: () => _showFilterSheet(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: activeFiltersCount > 0 ? Colors.green : Colors.white,
              border: Border.all(
                color: activeFiltersCount > 0 ? Colors.green : (Colors.grey[300] ?? Colors.grey),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune,
                  size: 18,
                  color: activeFiltersCount > 0 ? Colors.white : Colors.grey[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 14,
                    color: activeFiltersCount > 0 ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Okra',
                  ),
                ),
                if (activeFiltersCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$activeFiltersCount',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentFilter = ref.read(outsideFilterProvider);
          return ServiceFilterSheet(
            initialFilter: currentFilter,
            decorationType: 'outside',
            onApplyFilter: (filter) {
              ref.read(outsideFilterProvider.notifier).state = filter;
            },
          );
        },
      ),
    );
  }

  void _onCarouselTap(Map<String, String> item) {
    // Check if this is a 50% off banner (you might want to check for specific discount banners)
    if (item['discount']?.contains('50%') == true) {
      // Navigate to discount offers screen with 50% minimum discount
      context.push('/discount-offers', extra: {
        'minDiscountPercent': 50,
        'title': 'Up to 50% Off',
      });
    } else {
      // Handle other carousel item taps if needed
      debugPrint('Tapped on carousel item: ${item['title']}');
    }
  }

  Widget _buildSliverServicesList(
    AsyncValue<List<ServiceListingModel>> servicesAsync,
    WidgetRef ref,
    String decorationType,
  ) {
    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'No outside decoration services available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= services.length) {
                return const SizedBox.shrink();
              }
              final service = services[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DecorationCard(
                  service: service,
                  onTap: () {
                    context.push('/service/${service.id}');
                  },
                ),
              );
            },
            childCount: services.length,
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          ),
        ),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Padding(
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
      ),
    );
  }

  Widget _buildServiceCard(ServiceListingModel service) {
    try {
      return DecorationCard(
        service: service,
        onTap: () {
          try {
            context.push('/service/${service.id}');
          } catch (e) {
            // Handle navigation error silently
          }
        },
      );
    } catch (e) {
      return Container(
        height: 119,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text('Error loading service card'),
        ),
      );
    }
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: maxExtent,
      child: child,
    );
  }

  @override
  double get maxExtent => 80.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
} 