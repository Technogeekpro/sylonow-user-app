import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/decoration_card.dart';
import '../../home/models/filter_model.dart';
import '../../home/models/service_listing_model.dart';
import '../../home/providers/filter_providers.dart';

class OutsideDecorationScreen extends ConsumerStatefulWidget {
  const OutsideDecorationScreen({super.key});

  @override
  ConsumerState<OutsideDecorationScreen> createState() => _OutsideDecorationScreenState();
}

class _OutsideDecorationScreenState extends ConsumerState<OutsideDecorationScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final List<Map<String, dynamic>> _filterOptions = [
    {'label': 'All', 'sortBy': SortOption.relevance},
    {'label': 'Price: Low to High', 'sortBy': SortOption.priceLowToHigh},
    {'label': 'Price: High to Low', 'sortBy': SortOption.priceHighToLow},
    {'label': 'High Rating', 'sortBy': SortOption.ratingHighToLow},
    {'label': 'Newest', 'sortBy': SortOption.newest},
  ];

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
                        filteredOutsideServicesProvider,
                      );
                      return _buildSliverServicesList(
                        servicesAsync,
                        ref,
                        'outside',
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
                    ref.read(outsideSearchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Outside Decoration...',
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
                              ref.read(outsideSearchQueryProvider.notifier).state = '';
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
          itemCount: _filterOptions.length + 1, // +1 for Categories button
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
                // Last item is "Categories" button
                if (index == _filterOptions.length) {
                  return Consumer(
                    builder: (context, ref, child) {
                      final currentFilter = ref.watch(outsideFilterProvider);
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

                final filter = _filterOptions[index];
                final isSelected = _selectedFilter == filter['label'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter['label'] as String;
                    });
                    // Update the sort option in the provider
                    ref.read(outsideFilterProvider.notifier).update(
                          (state) => state.copyWith(sortBy: filter['sortBy'] as SortOption),
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
                      filter['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                );
          },
        ),
      ),
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
          final currentFilter = ref.watch(outsideFilterProvider);

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
                            ref.read(outsideFilterProvider.notifier).update(
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
                              ref.read(outsideFilterProvider.notifier).update(
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
                  'No outside decoration services available',
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
