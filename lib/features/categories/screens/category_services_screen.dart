import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shimmer_widget.dart';
import '../../../core/utils/user_location_helper.dart';
import '../../home/providers/home_providers.dart';
import '../../home/models/service_listing_model.dart';

class CategoryServicesScreen extends ConsumerStatefulWidget {
  final String categoryName;
  final String? decorationType;
  final String? displayName;

  const CategoryServicesScreen({
    super.key, 
    required this.categoryName,
    this.decorationType,
    this.displayName,
  });

  static const String routeName = '/category';

  @override
  ConsumerState<CategoryServicesScreen> createState() =>
      _CategoryServicesScreenState();
}

class _CategoryServicesScreenState
    extends ConsumerState<CategoryServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

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

  Future<void> _onRefresh() async {
    // Invalidate providers to trigger refresh
    if (widget.decorationType != null) {
      ref.invalidate(servicesByCategoryAndDecorationTypeProvider);
    } else {
      ref.invalidate(servicesByCategoryProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 CategoryServicesScreen: Building with categoryName: ${widget.categoryName}, decorationType: ${widget.decorationType}, displayName: ${widget.displayName}');
    
    // Determine theme colors based on decoration type
    final isInsideDecoration = widget.decorationType == 'inside';
    final primaryColor = isInsideDecoration ? AppTheme.primaryColor : Colors.green;
    final displayTitle = widget.displayName ?? widget.categoryName;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          displayTitle,
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
      body: FutureBuilder<Map<String, dynamic>?>(
        future: UserLocationHelper.getLocationParams(ref, radiusKm: 25.0),
        builder: (context, locationSnapshot) {
          if (locationSnapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerGrid(primaryColor);
          }

          final locationParams = locationSnapshot.data;
          
          return RefreshIndicator(
            key: _refreshKey,
            onRefresh: _onRefresh,
            color: primaryColor,
            child: _buildServicesContent(locationParams, primaryColor),
          );
        },
      ),
    );
  }

  Widget _buildServicesContent(Map<String, dynamic>? locationParams, Color primaryColor) {
    print('🔍 CategoryServicesScreen: _buildServicesContent called with locationParams: $locationParams, decorationType: ${widget.decorationType}');
    
    // Use location-enhanced provider if location is available
    if (locationParams != null && widget.decorationType != null) {
      final providerParams = {
        'category': widget.categoryName,
        'decorationType': widget.decorationType!,
        'userLat': locationParams['userLat'],
        'userLon': locationParams['userLon'],
        'radiusKm': locationParams['radiusKm'],
      };
      print('🔍 CategoryServicesScreen: Using location provider with params: $providerParams');
      
      final servicesAsync = ref.watch(
        servicesByCategoryAndDecorationTypeWithLocationProvider(providerParams),
      );
      return _buildServicesView(servicesAsync, primaryColor, isLocationBased: true);
    }
    
    // Fallback to basic provider
    if (widget.decorationType != null) {
      final providerParams = {
        'category': widget.categoryName,
        'decorationType': widget.decorationType!,
      };
      print('🔍 CategoryServicesScreen: Using basic combined provider with params: $providerParams');
      
      final servicesAsync = ref.watch(
        servicesByCategoryAndDecorationTypeProvider(providerParams),
      );
      return _buildServicesView(servicesAsync, primaryColor, isLocationBased: false);
    } else {
      print('🔍 CategoryServicesScreen: Using category-only provider with category: ${widget.categoryName}');
      
      final servicesAsync = ref.watch(
        servicesByCategoryProvider(widget.categoryName),
      );
      return _buildServicesView(servicesAsync, primaryColor, isLocationBased: false);
    }
  }

  Widget _buildServicesView(
    AsyncValue<List<ServiceListingModel>> servicesAsync, 
    Color primaryColor, 
    {bool isLocationBased = false}
  ) {
    print('🔍 CategoryServicesScreen: _buildServicesView called with AsyncValue state: ${servicesAsync.runtimeType}');
    
    return servicesAsync.when(
      loading: () {
        print('🔍 CategoryServicesScreen: AsyncValue is in loading state, showing shimmer');
        return _buildShimmerGrid(primaryColor);
      },
      error: (error, stack) {
        print('🔍 CategoryServicesScreen: AsyncValue error: $error');
        print('🔍 CategoryServicesScreen: Stack trace: $stack');
        return _buildErrorState(primaryColor);
      },
      data: (services) {
        print('🔍 CategoryServicesScreen: AsyncValue data received with ${services.length} services');
        var filtered = _applyFiltering(services);
        print('🔍 CategoryServicesScreen: After filtering: ${filtered.length} services');
        return _buildServicesGrid(filtered, primaryColor, isLocationBased);
      },
    );
  }

  Widget _buildServicesGrid(
    List<ServiceListingModel> services, 
    Color primaryColor, 
    bool isLocationBased
  ) {
    if (services.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(child: _buildEmptyState()),
        ],
      );
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
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
                prefixIcon: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
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
                  borderSide: BorderSide(color: primaryColor),
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
            primaryColor: primaryColor,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
        ),
        // Services Grid
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final service = services[index];
                return _buildServiceCard(context, service, isLocationBased);
              },
              childCount: services.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerGrid(Color primaryColor) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ShimmerWidgets.categoryServiceCard();
      },
    );
  }

  Widget _buildErrorState(Color primaryColor) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
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
                    'Pull down to refresh',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _refreshKey.currentState?.show(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<ServiceListingModel> _applyFiltering(
    List<ServiceListingModel> services,
  ) {
    var filtered = services;

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
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
          final priceA = a.displayOfferPrice ?? a.displayOriginalPrice ?? double.infinity;
          final priceB = b.displayOfferPrice ?? b.displayOriginalPrice ?? double.infinity;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) {
          final priceA = a.displayOfferPrice ?? a.displayOriginalPrice ?? 0.0;
          final priceB = b.displayOfferPrice ?? b.displayOriginalPrice ?? 0.0;
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
            const Icon(Icons.category_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No services found',
              style: TextStyle(
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

  Widget _buildServiceCard(BuildContext context, ServiceListingModel service, bool isLocationBased) {
    return GestureDetector(
      onTap: () {
        context.push('/service/${service.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.9,
              offset: const Offset(2, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              child: CachedNetworkImage(
                imageUrl: service.image ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 136,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      color: widget.decorationType == 'inside' ? AppTheme.primaryColor : Colors.green,
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

            // Content Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location with distance if available
                  Text(
                    isLocationBased && service.distanceKm != null
                        ? '${service.distanceKm!.toStringAsFixed(1)} km away'
                        : 'At Your Location',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Service Name
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price Section
                      Expanded(
                        child: Row(
                          children: [
                            if (service.displayOfferPrice != null) ...[
                              Text(
                                '₹${service.displayOfferPrice!.toInt()}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.66),
                                  fontFamily: 'Okra',
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (service.displayOriginalPrice != null &&
                                  service.displayOriginalPrice! > service.displayOfferPrice!)
                                Text(
                                  '₹${service.displayOriginalPrice!.toInt()}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.45),
                                    decoration: TextDecoration.lineThrough,
                                    fontFamily: 'Okra',
                                  ),
                                ),
                            ] else if (service.displayOriginalPrice != null) ...[
                              Text(
                                '₹${service.displayOriginalPrice!.toInt()}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.66),
                                  fontFamily: 'Okra',
                                ),
                              ),
                            ] else ...[
                              const Text(
                                'Price on request',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Okra',
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Rating Section
                      if (service.rating != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Color(0xFFFFD060),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              service.rating!.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Okra',
                              ),
                            ),
                          ],
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
  final Color primaryColor;
  final ValueChanged<String> onFilterChanged;

  _FilterHeaderDelegate({
    required this.filterOptions,
    required this.selectedFilter,
    required this.primaryColor,
    required this.onFilterChanged,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(46)),
      ),
      child: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
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
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        onFilterChanged(filter);
                      }
                    },
                    backgroundColor: Colors.white,
                    selectedColor: primaryColor,
                    side: BorderSide(
                      color: isSelected
                          ? primaryColor
                          : Colors.grey[300]!,
                    ),
                    showCheckmark: false,
                  ),
                );
              }),
            ],
          ),
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
