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
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'High Rating',
    'Budget Friendly',
    'Premium',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
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
                setState(() {
                  _searchQuery = value;
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
              itemCount: _filterOptions.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filterOptions[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey[200]!,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTheatersGrid() {
    final filterParams = FilterParams(
      searchQuery: _searchQuery,
      selectedFilter: _selectedFilter,
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
