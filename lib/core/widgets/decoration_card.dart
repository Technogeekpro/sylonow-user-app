import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../../features/home/models/service_listing_model.dart';

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
    try {
      print('🐛 DecorationCard build() - Line 18: Starting build for service ${service.id}');
      print('🐛 Service details: name=${service.name}, rating=${service.rating}, offerPrice=${service.offerPrice}, originalPrice=${service.originalPrice}');
      print('🐛 Service image: ${service.image}, displayOfferPrice=${service.displayOfferPrice}, displayOriginalPrice=${service.displayOriginalPrice}');
      
      return Hero(
        tag: 'service-${service.id}',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap ?? () {
              try {
                print('🐛 DecorationCard onTap - Line 25: Navigating to service ${service.id}');
                context.push('/service/${service.id}');
              } catch (e, stackTrace) {
                print('🐛 CRITICAL ERROR at Line 25 - DecorationCard onTap: $e');
                print('🐛 Stack trace: $stackTrace');
              }
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: 119,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFEFEFEF),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Image section
                  _buildImageSection(),
                
                // Content section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Rating row
                        Row(
                          children: [
                            // Title
                            Expanded(
                              child: Text(
                                service.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1D26),
                                  fontFamily: 'Okra',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            
                            // Rating
                            if (service.rating != null) _buildRating(),
                          ],
                        ),
                        
                        const SizedBox(height: 1),
                        
                        // Price
                        _buildPrice(),
                        
                        const Spacer(),
                        
                        // Description
                        Text(
                          service.description ?? 'Professional decoration service',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8A6175),
                            fontFamily: 'Okra',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    } catch (e, stackTrace) {
      print('🐛 CRITICAL ERROR at Line 18 - DecorationCard build(): $e');
      print('🐛 Stack trace: $stackTrace');
      print('🐛 Service data: ${service.toString()}');
      return Container(
        height: 119,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: const Center(
          child: Text(
            'Error loading service card',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Widget _buildImageSection() {
    try {
      print('🐛 DecorationCard _buildImageSection() - Line 142: Building image section for ${service.id}');
      print('🐛 Image URL: ${service.image}');
      
      return Container(
        width: 117,
        height: 117,
        margin: const EdgeInsets.all(1),
        child: Stack(
          children: [
            // Main image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: 117,
                height: 117,
                child: CachedNetworkImage(
                  imageUrl: service.image ?? '',
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
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          
          // Gradient overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 117,
              height: 117,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.7, 1.0],
                ),
              ),
            ),
          ),
          
          // Distance indicator at bottom
      
        ],
      ), 
    );
    } catch (e, stackTrace) {
      print('🐛 CRITICAL ERROR at Line 142 - _buildImageSection(): $e');
      print('🐛 Stack trace: $stackTrace');
      return Container(
        width: 117,
        height: 117,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Icon(Icons.error, color: Colors.red),
        ),
      );
    }
  } 

  Widget _buildRating() {
    try {
      print('🐛 DecorationCard _buildRating() - Line 226: Building rating for ${service.id}');
      print('🐛 Rating value: ${service.rating}');
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: Color(0xFFFED05F),
              size: 16,
            ), 
            const SizedBox(width: 3),
            Text(
              (service.rating ?? 0.0).toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D26),
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      print('🐛 CRITICAL ERROR at Line 226 - _buildRating(): $e');
      print('🐛 Stack trace: $stackTrace');
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: const Text('Error', style: TextStyle(color: Colors.red)),
      );
    }
  }

  Widget _buildPrice() {
    try {
      print('🐛 DecorationCard _buildPrice() - Line 264: Building price for ${service.id}');
      print('🐛 displayOfferPrice: ${service.displayOfferPrice}');
      print('🐛 displayOriginalPrice: ${service.displayOriginalPrice}');
      print('🐛 offerPrice: ${service.offerPrice}');
      print('🐛 originalPrice: ${service.originalPrice}');
      print('🐛 adjustedOfferPrice: ${service.adjustedOfferPrice}');
      print('🐛 adjustedOriginalPrice: ${service.adjustedOriginalPrice}');
      
      return Row(
        children: [
          // Offer price
          if (service.displayOfferPrice != null)
            Text(
              '₹${(service.displayOfferPrice ?? 0.0).toInt()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontFamily: 'Okra',
              ),
            ),
          
          // Original price (crossed out)
          if (service.displayOriginalPrice != null &&
              service.displayOfferPrice != null &&
              (service.displayOriginalPrice ?? 0.0) > (service.displayOfferPrice ?? 0.0)) ...[
            const SizedBox(width: 6),
            Text(
              '₹${(service.displayOriginalPrice ?? 0.0).toInt()}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                fontFamily: 'Okra',
              ),
            ),
          ],
          
          // Show only original price if no offer price
          if (service.displayOfferPrice == null && service.displayOriginalPrice != null)
            Text(
              '₹${(service.displayOriginalPrice ?? 0.0).toInt()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontFamily: 'Okra',
              ),
            ),
        ],
      );
    } catch (e, stackTrace) {
      print('🐛 CRITICAL ERROR at Line 264 - _buildPrice(): $e');
      print('🐛 Stack trace: $stackTrace');
      return const Text(
        'Price Error',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    }
  }
}