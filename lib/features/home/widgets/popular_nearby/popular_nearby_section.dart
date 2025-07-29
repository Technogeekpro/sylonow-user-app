import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/core/utils/user_location_helper.dart';
import 'package:sylonow_user/core/utils/location_utils.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';

class PopularNearbySection extends ConsumerWidget {
  const PopularNearbySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
          child: Row(
            children: [
              const Text(
                'Near By You',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.push('/nearby-services');
                },
                child: const Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Location-based Popular Nearby Services
        FutureBuilder<Map<String, dynamic>?>(
          future: UserLocationHelper.getLocationParams(ref, radiusKm: 25.0),
          builder: (context, locationSnapshot) {
            print('🔍 PopularNearbySection: FutureBuilder state: ${locationSnapshot.connectionState}');
            
            if (locationSnapshot.connectionState == ConnectionState.waiting) {
              print('🔍 PopularNearbySection: Still waiting for location...');
              return _buildLoadingState();
            }

            final locationParams = locationSnapshot.data;
            print('🔍 PopularNearbySection: Location params received: $locationParams');
            
            if (locationParams == null) {
              print('🔍 PopularNearbySection: No location params, falling back to featured services');
              // Fallback to non-location based services
              return Consumer(
                builder: (context, ref, child) {
                  final featuredServicesState = ref.watch(featuredServicesProvider);
                  print('🔍 PopularNearbySection: Featured services count: ${featuredServicesState.services.length}');
                  return featuredServicesState.services.isEmpty
                      ? _buildLoadingState()
                      : _buildServicesList(featuredServicesState.services, isLocationBased: false);
                },
              );
            }

            print('🔍 PopularNearbySection: Using location-based services with params: $locationParams');
            // Use location-based services
            return Consumer(
              builder: (context, ref, child) {
                final servicesAsync = ref.watch(
                  popularNearbyServicesWithLocationProvider(locationParams)
                );
                return servicesAsync.when(
                  data: (services) {
                    print('🔍 PopularNearbySection: Location-based services loaded: ${services.length}');
                    return services.isEmpty 
                        ? _buildEmptyState() 
                        : _buildServicesList(services, isLocationBased: true);
                  },
                  loading: () {
                    print('🔍 PopularNearbySection: Loading location-based services...');
                    return _buildLoadingState();
                  },
                  error: (error, stack) {
                    print('🔍 PopularNearbySection: Error loading services: $error');
                    return _buildErrorState();
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildServicesList(List<ServiceListingModel> services, {bool isLocationBased = false}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: services.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service, context, isLocationBased: isLocationBased);
      },
    );
  }

  Widget _buildServiceCard(ServiceListingModel service, BuildContext context, {bool isLocationBased = false}) {
    return GestureDetector(
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
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // Image section with gradient overlay
              Stack(
                children: [
                  ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: service.image,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SizedBox(
                              width: 120,
                              height: 120,

                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          // Gradient overlay
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.4),
                                ],
                                stops: const [0.0, 0.93],
                              ),
                            ),
                          ),
                          //Distance badge at bottom
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black],
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.locationArrow,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    isLocationBased && service.distanceKm != null
                                        ? '${service.distanceKm!.toStringAsFixed(1)} km'
                                        : '3.5 km',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
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
                  ),

                  // Distance badge at bottom
                ],
              ),
              // Content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service title
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                          color: Color(0xFF2A3143),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Price with location adjustment
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (service.displayOfferPrice != null) ...[
                                Text(
                                  '₹${service.displayOfferPrice!.round()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Okra',
                                    color: Color(0xFFFF0080),
                                    height: 1.0,
                                  ),
                                ),
                                if (service.displayOriginalPrice != null &&
                                    service.displayOriginalPrice! >
                                        service.displayOfferPrice!) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '₹${service.displayOriginalPrice!.round()}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Okra',
                                      color: Color(0xFF9197A7),
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Color(0xFF9197A7),
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ] else if (service.displayOriginalPrice != null) ...[
                                Text(
                                  '₹${service.displayOriginalPrice!.round()}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Okra',
                                    color: Color(0xFF2A3143),
                                    height: 1.0,
                                  ),
                                ),
                              ] else ...[
                                const Text(
                                  'Price on request',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Okra',
                                    color: Color(0xFF9197A7),
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          // Price adjustment indicator
                          if (isLocationBased && service.isPriceAdjusted == true) ...[
                            const SizedBox(height: 2),
                            Text(
                              '+₹100 (Distance)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Okra',
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                     // Rating section
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
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
                              '${(service.rating ?? 4.9).toStringAsFixed(1)} (${service.reviewsCount ?? 102})',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(Icons.star, color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      // Description with More link
                      Flexible(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text:
                                service.description ??
                                'A floral engagement decoration creates a romantic and elegant ambiance with lush flower arrangements, cascading garlands, and a beautifully adorned stage.',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                              fontFamily: 'Okra',
                              height: 1.2,
                            ),
                            children: const [
                              TextSpan(
                                text: ' More',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFFF0080),
                                  fontWeight: FontWeight.w600,
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
              ),
            ],
          ),
        ),
      );
      
    
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildLoadingCard(context),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      height: 119,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEFEFEF), width: 1.2),
      ),
      child: Row(
        children: [
          // Image placeholder
          Container(
            width: 117,
            height: 117,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
                strokeWidth: 2,
              ),
            ),
          ),
          // Content placeholder
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Price placeholder
                  Container(
                    height: 22,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Rating placeholder
                  Container(
                    height: 13,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  // Description placeholder
                  Column(
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
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
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.location_searching, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No services found nearby',
            style: TextStyle(
              fontSize: 16,
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
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Unable to load popular services',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }
}
