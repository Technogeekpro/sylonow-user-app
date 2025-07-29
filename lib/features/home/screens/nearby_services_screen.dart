import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/core/utils/user_location_helper.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';

class NearbyServicesScreen extends ConsumerWidget {
  const NearbyServicesScreen({super.key});

  static const String routeName = '/nearby-services';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Near by',
          style: TextStyle(
            fontFamily: 'Okra',
            fontWeight: FontWeight.bold,
          ),
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
                final featuredServicesState = ref.watch(featuredServicesProvider);
                return featuredServicesState.services.isEmpty
                    ? _buildLoadingGrid()
                    : _buildServicesGrid(featuredServicesState.services, isLocationBased: false);
              },
            );
          }

          // Use location-based services
          return Consumer(
            builder: (context, ref, child) {
              final servicesAsync = ref.watch(
                popularNearbyServicesWithLocationProvider(locationParams)
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

  Widget _buildServicesGrid(List<ServiceListingModel> services, {bool isLocationBased = false}) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service, isLocationBased: isLocationBased);
      },
    );
  }

  Widget _buildServiceCard(ServiceListingModel service, {bool isLocationBased = false}) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          context.push(
            '/service/\${service.id}',
            extra: {
              'serviceName': service.name,
              'price': service.displayOfferPrice != null
                  ? '₹\${service.displayOfferPrice!.round()}'
                  : service.displayOriginalPrice != null
                  ? '₹\${service.displayOriginalPrice!.round()}'
                  : null,
              'rating': (service.rating ?? 4.9).toStringAsFixed(1),
              'reviewCount': service.reviewsCount ?? 102,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: service.image,
                        width: double.infinity,
                        height: double.infinity,
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
                    // Distance badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              FontAwesomeIcons.locationArrow,
                              color: Colors.white,
                              size: 10,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              isLocationBased && service.distanceKm != null
                                  ? '\${service.distanceKm!.toStringAsFixed(1)} km'
                                  : '3.5 km',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Okra',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service title
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                          color: Color(0xFF2A3143),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Price
                      Row(
                        children: [
                          if (service.displayOfferPrice != null) ...[
                            Text(
                              '₹\${service.displayOfferPrice!.round()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Okra',
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            if (service.displayOriginalPrice != null &&
                                service.displayOriginalPrice! >
                                    service.displayOfferPrice!) ...[
                              const SizedBox(width: 4),
                              Text(
                                '₹\${service.displayOriginalPrice!.round()}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Okra',
                                  color: Color(0xFF9197A7),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ] else if (service.displayOriginalPrice != null) ...[
                            Text(
                              '₹\${service.displayOriginalPrice!.round()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Okra',
                                color: Color(0xFF2A3143),
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'Price on request',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Okra',
                                color: Color(0xFF9197A7),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Spacer(),
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\${(service.rating ?? 4.9).toStringAsFixed(1)}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'Okra',
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.star, color: Colors.white, size: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildLoadingCard(),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 16,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 14,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
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