import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/core/utils/user_location_helper.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';

class NearbyServicesScreen extends ConsumerStatefulWidget {
  const NearbyServicesScreen({super.key});

  static const String routeName = '/nearby-services';

  @override
  ConsumerState<NearbyServicesScreen> createState() =>
      _NearbyServicesScreenState();
}

class _NearbyServicesScreenState extends ConsumerState<NearbyServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Near by',
          style: TextStyle(fontFamily: 'Okra', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: UserLocationHelper.getLocationParams(ref, radiusKm: 25.0),
        builder: (context, locationSnapshot) {
          if (locationSnapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingGrid();
          }

          final locationParams = locationSnapshot.data;

          if (locationParams == null) {
            // Fallback to featured services
            return Consumer(
              builder: (context, ref, child) {
                final featuredServicesState = ref.watch(
                  featuredServicesProvider,
                );
                return featuredServicesState.services.isEmpty
                    ? _buildLoadingGrid()
                    : _buildServicesGrid(
                        featuredServicesState.services,
                        isLocationBased: false,
                      );
              },
            );
          }

          // Use location-based services
          return Consumer(
            builder: (context, ref, child) {
              final servicesAsync = ref.watch(
                popularNearbyServicesWithLocationProvider(locationParams),
              );
              return servicesAsync.when(
                data: (services) {
                  return services.isEmpty
                      ? _buildEmptyState()
                      : _buildServicesGrid(services, isLocationBased: true);
                },
                loading: () => _buildLoadingGrid(),
                error: (error, stack) => _buildErrorState(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildServicesGrid(
    List<ServiceListingModel> services, {
    bool isLocationBased = false,
  }) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.80,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final service = services[index];
              return _buildServiceCard(
                service,
                isLocationBased: isLocationBased,
              );
            }, childCount: services.length),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesContent(Map<String, dynamic>? locationParams) {
    if (locationParams == null) {
      // Fallback to featured services
      final featuredServicesState = ref.watch(featuredServicesProvider);
      return featuredServicesState.services.isEmpty
          ? _buildShimmerGrid()
          : _buildServicesGrid(
              featuredServicesState.services,
              isLocationBased: false,
            );
    }

    // Use location-based services
    final servicesAsync = ref.watch(
      popularNearbyServicesWithLocationProvider(locationParams),
    );

    return servicesAsync.when(
      data: (services) {
        return services.isEmpty
            ? _buildEmptyState()
            : _buildServicesGrid(services, isLocationBased: true);
      },
      loading: () => _buildShimmerGrid(),
      error: (error, stack) {
        print('Error loading nearby services: $error');
        return _buildErrorState();
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.80,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => _buildLoadingCard(),
    );
  }

  Widget _buildServiceCard(
    ServiceListingModel service, {
    bool isLocationBased = false,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          context.push(
            '/service/${service.id}',
            extra: {
              'serviceName': service.name,
              'price': service.displayOfferPrice != null
                  ? '₹${service.displayOfferPrice!.round()}'
                  : service.displayOriginalPrice != null
                  ? '₹${service.displayOriginalPrice!.round()}'
                  : null,
              'rating': (service.rating ?? 4.9).toStringAsFixed(1),
              'reviewCount': service.reviewsCount ?? 102,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1:1 Square Image with 8px radius
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: service.image ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Service name in small font
            Flexible(
              child: Text(
                service.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Okra',
                  color: Color(0xFF333333),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.80,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => _buildLoadingCard(),
    );
  }

  Widget _buildLoadingCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Square image placeholder
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Text placeholder
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          height: 8,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_searching, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No services found nearby',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try expanding your search radius or check back later',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontFamily: 'Okra',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Unable to load services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontFamily: 'Okra',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
