import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/decoration_card.dart';
import '../../home/models/filter_model.dart';
import '../../home/models/service_listing_model.dart';
import '../../home/providers/filter_providers.dart';

class InsideScreen extends ConsumerStatefulWidget {
  const InsideScreen({super.key});

  @override
  ConsumerState<InsideScreen> createState() => _InsideScreenState();
}

class _InsideScreenState extends ConsumerState<InsideScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = 'high_to_low'; // high_to_low or low_to_high
  double _minPrice = 0;
  double _maxPrice = 10000;
  double _maxDistance = 60; // in km

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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
                const SliverToBoxAdapter(child: SizedBox(height: 120)),

                // Sticky Filter Bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _FilterBarDelegate(child: _buildFilterBar()),
                ),

                // Services List
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16),
                  sliver: Consumer(
                    builder: (context, ref, child) {
                      final servicesAsync = ref.watch(
                        filteredInsideServicesProvider,
                      );
                      return _buildSliverServicesList(
                        servicesAsync,
                        ref,
                        'inside',
                      );
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

    return Container(
      height: statusBarHeight + 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(insideSearchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Inside Decoration...',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontFamily: 'Okra',
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600], size: 20),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(insideSearchQueryProvider.notifier).state = '';
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5, // 5 filters: High to Low, Low to High, Price, Distance, Categories
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            // Filter 0: High to Low
            if (index == 0) {
              final isSelected = _selectedSort == 'high_to_low';
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSort = 'high_to_low';
                  });
                  ref.read(insideFilterProvider.notifier).update(
                    (state) => state.copyWith(sortBy: SortOption.priceHighToLow),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!,
                    ),
                  ),
                  child: Text(
                    'High to Low',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontFamily: 'Okra',
                    ),
                  ),
                ),
              );
            }

            // Filter 1: Low to High
            if (index == 1) {
              final isSelected = _selectedSort == 'low_to_high';
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSort = 'low_to_high';
                  });
                  ref.read(insideFilterProvider.notifier).update(
                    (state) => state.copyWith(sortBy: SortOption.priceLowToHigh),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!,
                    ),
                  ),
                  child: Text(
                    'Low to High',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontFamily: 'Okra',
                    ),
                  ),
                ),
              );
            }

            // Filter 2: Price
            if (index == 2) {
              final hasPrice = _minPrice > 0 || _maxPrice < 10000;
              return GestureDetector(
                onTap: () => _showPriceSheet(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: hasPrice ? AppTheme.primaryColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: hasPrice ? AppTheme.primaryColor : Colors.grey[200]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        size: 16,
                        color: hasPrice ? Colors.white : Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hasPrice ? '₹${_minPrice.round()}-${_maxPrice.round()}' : 'Price',
                        style: TextStyle(
                          color: hasPrice ? Colors.white : Colors.grey[700],
                          fontSize: 12,
                          fontWeight: hasPrice ? FontWeight.w600 : FontWeight.w500,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Filter 3: Distance
            if (index == 3) {
              final hasDistance = _maxDistance < 60;
              return GestureDetector(
                onTap: () => _showDistanceSheet(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: hasDistance ? AppTheme.primaryColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: hasDistance ? AppTheme.primaryColor : Colors.grey[200]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: hasDistance ? Colors.white : Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hasDistance ? '${_maxDistance.round()}km' : 'Distance',
                        style: TextStyle(
                          color: hasDistance ? Colors.white : Colors.grey[700],
                          fontSize: 12,
                          fontWeight: hasDistance ? FontWeight.w600 : FontWeight.w500,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Filter 4: Categories
            if (index == 4) {
              return Consumer(
                builder: (context, ref, child) {
                  final currentFilter = ref.watch(insideFilterProvider);
                  final hasCategories = currentFilter.categories.isNotEmpty;
                  return GestureDetector(
                    onTap: () => _showCategorySheet(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: hasCategories ? AppTheme.primaryColor : Colors.grey[100],
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: hasCategories ? AppTheme.primaryColor : Colors.grey[200]!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 16,
                            color: hasCategories ? Colors.white : Colors.grey[700],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            hasCategories
                                ? '${currentFilter.categories.length} ${currentFilter.categories.length == 1 ? 'Category' : 'Categories'}'
                                : 'Categories',
                            style: TextStyle(
                              color: hasCategories ? Colors.white : Colors.grey[700],
                              fontSize: 12,
                              fontWeight: hasCategories ? FontWeight.w600 : FontWeight.w500,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showPriceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        double tempMinPrice = _minPrice;
        double tempMaxPrice = _maxPrice;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${tempMinPrice.round()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                        ),
                      ),
                      Text(
                        '₹${tempMaxPrice.round()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RangeSlider(
                    values: RangeValues(tempMinPrice, tempMaxPrice),
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: Colors.grey[300],
                    labels: RangeLabels(
                      '₹${tempMinPrice.round()}',
                      '₹${tempMaxPrice.round()}',
                    ),
                    onChanged: (values) {
                      setModalState(() {
                        tempMinPrice = values.start;
                        tempMaxPrice = values.end;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _minPrice = 0;
                              _maxPrice = 10000;
                            });
                            ref.read(insideFilterProvider.notifier).update(
                              (state) => state.copyWith(minPrice: 0, maxPrice: 10000),
                            );
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Okra',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _minPrice = tempMinPrice;
                              _maxPrice = tempMaxPrice;
                            });
                            ref.read(insideFilterProvider.notifier).update(
                              (state) => state.copyWith(minPrice: tempMinPrice, maxPrice: tempMaxPrice),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Okra',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDistanceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        double tempDistance = _maxDistance;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Maximum Distance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${tempDistance.round()} km',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: tempDistance,
                    min: 1,
                    max: 60,
                    divisions: 59,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: Colors.grey[300],
                    label: '${tempDistance.round()} km',
                    onChanged: (value) {
                      setModalState(() {
                        tempDistance = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _maxDistance = 60;
                            });
                            ref.read(insideFilterProvider.notifier).update(
                              (state) => state.copyWith(maxDistanceKm: 60),
                            );
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Okra',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _maxDistance = tempDistance;
                            });
                            ref.read(insideFilterProvider.notifier).update(
                              (state) => state.copyWith(maxDistanceKm: tempDistance),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Okra',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCategorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final categoriesAsync = ref.watch(availableCategoriesProvider);
          final currentFilter = ref.watch(insideFilterProvider);

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Select Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ),
                      if (currentFilter.categories.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            ref.read(insideFilterProvider.notifier).update(
                              (state) => state.copyWith(categories: []),
                            );
                          },
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Categories List
                categoriesAsync.when(
                  data: (categories) {
                    if (categories.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No categories available',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Okra',
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = currentFilter.categories.contains(category);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () {
                              final updatedCategories = List<String>.from(currentFilter.categories);
                              if (isSelected) {
                                updatedCategories.remove(category);
                              } else {
                                updatedCategories.add(category);
                              }
                              ref.read(insideFilterProvider.notifier).update(
                                (state) => state.copyWith(categories: updatedCategories),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                        color: isSelected ? AppTheme.primaryColor : Colors.black87,
                                        fontFamily: 'Okra',
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppTheme.primaryColor,
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(color: AppTheme.primaryColor),
                    ),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Error loading categories',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
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
                  'No inside decoration services available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
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
          }, childCount: services.length),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
        ),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, height: maxExtent, child: child);
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
