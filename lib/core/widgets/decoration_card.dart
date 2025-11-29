import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../../features/home/models/service_listing_model.dart';
import '../utils/price_calculator.dart';

class DecorationCard extends StatelessWidget {
  final ServiceListingModel service;
  final VoidCallback? onTap;

  const DecorationCard({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate discount percentage
    int? discountPercentage;
    if (service.displayOriginalPrice != null && service.displayOfferPrice != null) {
      final discount = ((service.displayOriginalPrice! - service.displayOfferPrice!) /
                        service.displayOriginalPrice! * 100);
      discountPercentage = discount.round();
    }

    return GestureDetector(
      onTap: onTap ?? () {
        context.push(
          '/service/${service.id}',
          extra: {
            'serviceName': service.name,
            'price': service.displayOfferPrice != null
                ? PriceCalculator.formatPriceAsInt(
                    PriceCalculator.calculateTotalPriceWithTaxes(
                      service.displayOfferPrice!,
                    ),
                  )
                : service.displayOriginalPrice != null
                ? PriceCalculator.formatPriceAsInt(
                    PriceCalculator.calculateTotalPriceWithTaxes(
                      service.displayOriginalPrice!,
                    ),
                  )
                : null,
            'rating': (service.rating ?? 4.9).toStringAsFixed(1),
            'reviewCount': service.reviewsCount ?? 102,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image with discount badge
            Expanded(
              flex: 3,
              child: _buildImageSection(discountPercentage),
            ),
            // Service Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Name
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Service Description
                    if (service.description != null && service.description!.isNotEmpty)
                      Text(
                        service.description!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Okra',
                          color: Colors.grey[600],
                        ),
                      ),
                    const Spacer(),
                    // Price section
                    _buildPrice(),
                    const SizedBox(height: 4),
                    // Rating
                    _buildRating(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(int? discountPercentage) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: CachedNetworkImage(
            imageUrl: service.image ?? '',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: const Center(
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
        // Discount badge
        if (discountPercentage != null && discountPercentage > 0)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                    size: 10,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '$discountPercentage%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Wishlist icon
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price section
        if (service.displayOfferPrice != null) ...[
          Row(
            children: [
              // Offer Price with taxes
              Text(
                PriceCalculator.formatPriceAsInt(
                  PriceCalculator.calculateTotalPriceWithTaxes(
                    service.displayOfferPrice!,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              // Original Price (struck through) with taxes
              if (service.displayOriginalPrice != null)
                Text(
                  PriceCalculator.formatPriceAsInt(
                    PriceCalculator.calculateTotalPriceWithTaxes(
                      service.displayOriginalPrice!,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Okra',
                    color: Colors.grey[600],
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ] else if (service.displayOriginalPrice != null) ...[
          Text(
            PriceCalculator.formatPriceAsInt(
              PriceCalculator.calculateTotalPriceWithTaxes(
                service.displayOriginalPrice!,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (service.rating ?? 4.9).toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.star,
                color: Colors.white,
                size: 11,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
