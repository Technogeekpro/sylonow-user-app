import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';

class ImageCollageSection extends ConsumerWidget {
  const ImageCollageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredState = ref.watch(featuredServicesProvider);
    final services = featuredState.services;

    if (services.isEmpty) {
      return _buildLoadingState(context);
    }
    
    // Use available services and fill remaining slots with loading if needed
    final displayServices = <ServiceListingModel?>[];
    for (int i = 0; i < 4; i++) {
      if (i < services.length) {
        displayServices.add(services[i]);
      } else {
        displayServices.add(null); // null for loading placeholder
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
        children: List.generate(4, (index) {
          final service = displayServices[index];
          if (service == null) {
            // Show loading placeholder for missing services
            return ClipPath(
              clipper: ShapeBorderClipper(
                shape: ContinuousRectangleBorder(
                  borderRadius: _getBorderRadius(index),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
              ),
            );
          }
          return _ImageCard(
            service: service,
            borderRadius: _getBorderRadius(index),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
        children: List.generate(4, (index) {
          return ClipPath(
            clipper: ShapeBorderClipper(
              shape: ContinuousRectangleBorder(
                borderRadius: _getBorderRadius(index),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
            ),
          );
        }),
      ),
    );
  }

  BorderRadius _getBorderRadius(int index) {
    const double smallRadius = 16;
    const double largeRadius = 120;
    switch (index) {
      case 0: // Top-left
        return const BorderRadius.only(
          topLeft: Radius.circular(smallRadius),
          topRight: Radius.circular(largeRadius),
          bottomLeft: Radius.circular(largeRadius),
          bottomRight: Radius.circular(smallRadius),
        );
      case 1: // Top-right
        return const BorderRadius.only(
          topLeft: Radius.circular(largeRadius),
          topRight: Radius.circular(smallRadius),
          bottomLeft: Radius.circular(smallRadius),
          bottomRight: Radius.circular(largeRadius),
        );
      case 2: // Bottom-left
        return const BorderRadius.only(
          topLeft: Radius.circular(largeRadius),
          topRight: Radius.circular(smallRadius),
          bottomLeft: Radius.circular(smallRadius),
          bottomRight: Radius.circular(largeRadius),
        );
      case 3: // Bottom-right
      default:
        return const BorderRadius.only(
          topLeft: Radius.circular(smallRadius),
          topRight: Radius.circular(largeRadius),
          bottomLeft: Radius.circular(largeRadius),
          bottomRight: Radius.circular(smallRadius),
        );
    }
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.service,
    required this.borderRadius,
  });

  final ServiceListingModel service;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/service/${service.id}',
          extra: {
            'serviceName': service.name,
            'price': service.offerPrice?.toString() ?? service.originalPrice?.toString(),
            'rating': service.rating?.toStringAsFixed(1) ?? '4.9',
            'reviewCount': service.reviewsCount ?? 0,
          },
        );
      },
      child: Hero(
        tag: 'collage_service_${service.id}',
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return ClipPath(
                clipper: ShapeBorderClipper(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.lerp(
                      borderRadius,
                      BorderRadius.circular(0),
                      flightDirection == HeroFlightDirection.push 
                          ? animation.value 
                          : 1 - animation.value,
                    )!,
                  ),
                ),
                child: child,
              );
            },
            child: CachedNetworkImage(
              imageUrl: service.image ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[200]),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          );
        },
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: ContinuousRectangleBorder(
              borderRadius: borderRadius,
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: service.image ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[200]),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
} 