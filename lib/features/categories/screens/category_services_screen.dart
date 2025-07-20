import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/providers/home_providers.dart';
import '../../home/models/service_listing_model.dart';

class CategoryServicesScreen extends ConsumerStatefulWidget {
  final String categoryName;

  const CategoryServicesScreen({
    super.key,
    required this.categoryName,
  });

  static const String routeName = '/category';

  @override
  ConsumerState<CategoryServicesScreen> createState() => _CategoryServicesScreenState();
}

class _CategoryServicesScreenState extends ConsumerState<CategoryServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<String> _filterOptions = [
    'All',
    'Nearby',
    'Within 5 km',
    'Popular',
    'Highest Rated',
    'Price: Low to High',
    'Price: High to Low',
  ];

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesByCategoryProvider(widget.categoryName));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: servicesAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error.toString()),
        data: (services) {
          var filtered = _applyFiltering(services);
          return CustomScrollView(
            slivers: [
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFF34E5F)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE1E2E4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE1E2E4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF34E5F)),
                      ),
                    ),
                  ),
                ),
              ),
              // Filter Header
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterHeaderDelegate(
                  filterOptions: _filterOptions,
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                ),
              ),
              // Services Grid
              filtered.isEmpty
                  ? SliverFillRemaining(
                      child: _buildEmptyState(),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final service = filtered[index];
                            return _buildServiceImage(context, service);
                          },
                          childCount: filtered.length,
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.pink),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ServiceListingModel> _applyFiltering(List<ServiceListingModel> services) {
    var filtered = services;
    
    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    
    // Apply selected filter
    switch (_selectedFilter) {
      case 'Nearby':
        // For now, keep original order (would require location-based sorting)
        break;
      case 'Within 5 km':
        // For now, keep original order (would require location-based filtering)
        break;
      case 'Popular':
        filtered.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));
        break;
      case 'Highest Rated':
        filtered.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));
        break;
      case 'Price: Low to High':
        filtered.sort((a, b) {
          final priceA = a.offerPrice ?? a.originalPrice ?? double.infinity;
          final priceB = b.offerPrice ?? b.originalPrice ?? double.infinity;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) {
          final priceA = a.offerPrice ?? a.originalPrice ?? 0.0;
          final priceB = b.offerPrice ?? b.originalPrice ?? 0.0;
          return priceB.compareTo(priceA);
        });
        break;
      default: // 'All'
        break;
    }
    
    return filtered;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No services found',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceImage(BuildContext context, ServiceListingModel service) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/service/${service.id}',
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(70),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: CachedNetworkImage(
              imageUrl: service.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 116,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.pink,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<String> filterOptions;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  _FilterHeaderDelegate({
    required this.filterOptions,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Filter button with icon
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.05),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // Show filter options or additional filters
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_list, size: 18, color: Colors.black87),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black87),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Filter options
            ...filterOptions.map((filter) {
              final isSelected = filter == selectedFilter;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 13,
                      fontFamily: 'Okra',
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onFilterChanged(filter);
                    }
                  },
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFFF34E5F),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFFF34E5F) : Colors.grey[300]!,
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}