import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';

class PopularNearbySection extends ConsumerWidget {
  const PopularNearbySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredServicesState = ref.watch(featuredServicesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 20),
          child: Row(
            children: [
              Text(
                'Near By You',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                  color: Colors.black87,
                ),
              ),
              Spacer(),
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
        featuredServicesState.services.isEmpty
            ? _buildLoadingState()
            : _buildServicesList(featuredServicesState.services),
      ],
    );
  }

  Widget _buildServicesList(List<ServiceListingModel> services) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: services.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service, context);
      },
    );
  }

  Widget _buildServiceCard(ServiceListingModel service, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/service/${service.id}',
          extra: {
            'serviceName': service.name,
            'price': '\$22', // Default price since not in model
            'rating': (service.rating ?? 4.9).toStringAsFixed(1),
            'reviewCount': service.reviewsCount ?? 102,
          },
        );
      },
      child: Container(
      height: 119,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFEFEFEF),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Image section with gradient overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: SizedBox(
                  width: 117,
                  height: 117,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: service.image,
                        width: 117,
                        height: 117,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
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
                        errorWidget: (context, url, error) => Container(
                          width: 117,
                          height: 117,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.image_not_supported, 
                                       color: Colors.grey, size: 32),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        width: 117,
                        height: 117,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
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
                    ],
                  ),
                ),
              ),
              // Distance badge at bottom
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on, 
                                 color: Colors.white, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        '3.5 Km',
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
          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service title
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: Color(0xFF1A1D26),
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Price
                  Text(
                    '₹22',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                      color: Color(0xFFFF0080),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Rating section
                  Row(
                    children: [
                      Icon(Icons.star, color: const Color(0xFFFFD160), size: 16),
                      const SizedBox(width: 3),
                      Text(
                        '${(service.rating ?? 4.9).toStringAsFixed(1)} (${service.reviewsCount ?? 102})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Okra',
                          color: Color(0xFF1A1D26),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Description with More link
                  RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: service.description ?? 'A floral engagement decoration creates a romantic and elegant ambiance with lush flower arrangements, cascading garlands, and a beautifully adorned stage.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontFamily: 'Okra',
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: '...More',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF0080),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Okra',
                          ),
                        ),
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
        border: Border.all(
          color: const Color(0xFFEFEFEF),
          width: 1.2,
        ),
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