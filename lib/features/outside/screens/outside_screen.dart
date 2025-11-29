import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';

import '../providers/theater_providers.dart';
import '../widgets/theater_grid_states.dart';
import '../widgets/theater_screen_card.dart';

class OutsideScreen extends ConsumerStatefulWidget {
  final bool showBackButton;

  const OutsideScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  ConsumerState<OutsideScreen> createState() => _OutsideScreenState();
}

class _OutsideScreenState extends ConsumerState<OutsideScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = 'high_to_low'; // high_to_low or low_to_high
  List<String> _selectedCategories = [];
  double _minPrice = 0;
  double _maxPrice = 10000;
  double _maxDistance = 60; // in km
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: () async {
          // Invalidate the theater screens provider to trigger a refresh
          ref.invalidate(theaterScreensProvider);
          // Wait a bit for the provider to refresh
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          slivers: [
            // Collapsible App Bar
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              floating: true,
              pinned: true,
              snap: true,
              expandedHeight: 120,
              automaticallyImplyLeading: widget.showBackButton,
              leading: widget.showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => context.pop(),
                    )
                  : null,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Theater Screens',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                  ),
                ),
                centerTitle: true,
              ),
            ),
            // Search and Filter
            SliverToBoxAdapter(child: _buildSearchAndFilter()),
            // Theater Screens Grid
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: _buildTheatersGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // Cancel previous timer
                if (_debounce?.isActive ?? false) _debounce!.cancel();

                // Start new timer with 500ms delay
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    _searchQuery = value;
                  });
                });
              },
              decoration: InputDecoration(
                hintText: 'Search screens...',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontFamily: 'Okra',
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              style: const TextStyle(fontSize: 14, fontFamily: 'Okra'),
            ),
          ),
          const SizedBox(height: 16),
          // Filter Chips
          SizedBox(
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
                  final hasCategories = _selectedCategories.isNotEmpty;
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
                                ? '${_selectedCategories.length} ${_selectedCategories.length == 1 ? 'Category' : 'Categories'}'
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
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
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
      builder: (context) {
        final categoriesAsync = ref.watch(screenCategoriesProvider);

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
                        if (_selectedCategories.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategories = [];
                              });
                              setModalState(() {});
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
                          final isSelected = _selectedCategories.contains(category.id);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedCategories.remove(category.id);
                                  } else {
                                    _selectedCategories.add(category.id);
                                  }
                                });
                                setModalState(() {});
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
                                        category.name,
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
        );
      },
    );
  }

  Widget _buildTheatersGrid() {
    final filterParams = FilterParams(
      searchQuery: _searchQuery,
      selectedSort: _selectedSort,
      selectedCategories: _selectedCategories,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      maxDistance: _maxDistance,
    );
    final filteredScreens = ref.watch(
      filteredTheaterScreensProvider(filterParams),
    );
    final screensAsync = ref.watch(theaterScreensProvider);
    final selectedAddress = ref.watch(selectedAddressProvider);

    return screensAsync.when(
      data: (screens) {
        if (screens.isEmpty) {
          return const SliverFillRemaining(child: EmptyState());
        }

        if (filteredScreens.isEmpty) {
          return const SliverFillRemaining(child: NoResultsState());
        }

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 193 / 298, // Width/Height ratio from Figma
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final screen = filteredScreens[index];
            return TheaterScreenCard(
              screen: screen,
              selectedAddress: selectedAddress,
            );
          }, childCount: filteredScreens.length),
        );
      },
      loading: () => const SliverFillRemaining(child: LoadingState()),
      error: (error, stack) => SliverFillRemaining(
        child: ErrorState(errorMessage: error.toString()),
      ),
    );
  }
}
