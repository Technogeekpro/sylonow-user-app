import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/decoration_card.dart';
import '../../home/models/filter_model.dart';
import '../../home/models/service_listing_model.dart';
import '../../home/providers/filter_providers.dart';
import '../../home/widgets/service_filter_sheet.dart';

class InsideScreen extends ConsumerStatefulWidget {
  const InsideScreen({super.key});

  @override
  ConsumerState<InsideScreen> createState() => _InsideScreenState();
}

class _InsideScreenState extends ConsumerState<InsideScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
            const Expanded(
              child: Text(
                'Inside Decoration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.search, color: Colors.grey[600], size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
      child: Row(
        children: [
          // Sort dropdown
          Expanded(flex: 2, child: _buildSortDropdown()),

          // Divider
          Container(
            height: 24,
            width: 0.5,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),

          // Filter button
          Expanded(child: _buildFilterButton()),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Consumer(
      builder: (context, ref, child) {
        final filter = ref.watch(insideFilterProvider);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<SortOption>(
              value: filter.sortBy,
              icon: Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.grey[600]),
              isDense: true,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontFamily: 'Okra',
                fontWeight: FontWeight.w500,
              ),
              items: SortOption.values.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(
                    option.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(insideFilterProvider.notifier)
                      .update((state) => state.copyWith(sortBy: value));
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
        final activeFiltersCount = ref.watch(insideActiveFiltersCountProvider);
        return InkWell(
          onTap: () => _showFilterSheet(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.tune,
                  size: 16,
                  color: activeFiltersCount > 0 ? AppTheme.primaryColor : Colors.grey[700],
                ),
                const SizedBox(width: 4),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 13,
                    color: activeFiltersCount > 0 ? AppTheme.primaryColor : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Okra',
                  ),
                ),
                if (activeFiltersCount > 0) ...[
                  const SizedBox(width: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$activeFiltersCount',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
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
          final currentFilter = ref.read(insideFilterProvider);
          return ServiceFilterSheet(
            initialFilter: currentFilter,
            decorationType: 'inside',
            onApplyFilter: (filter) {
              ref.read(insideFilterProvider.notifier).state = filter;
            },
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
