import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_shimmer.dart';
import '../../reviews/screens/reviews_screen.dart';
import '../../home/models/service_listing_model.dart';
import '../../home/providers/home_providers.dart';

import '../../booking/screens/checkout_screen.dart';

// Provider to fetch individual service details
final serviceDetailProvider = FutureProvider.family<ServiceListingModel?, String>((ref, serviceId) async {
  try {
    debugPrint('🔄 Fetching service details for ID: $serviceId');
    final repository = ref.watch(homeRepositoryProvider);
    final service = await repository.getServiceById(serviceId);
    
    if (service != null) {
      debugPrint('✅ Service loaded successfully:');
      debugPrint('  - Name: ${service.name}');
      debugPrint('  - Image: ${service.image}');
      debugPrint('  - Photos count: ${service.photos?.length ?? 0}');
      debugPrint('  - Category: ${service.category}');
      debugPrint('  - Original Price: ${service.originalPrice}');
      debugPrint('  - Offer Price: ${service.offerPrice}');
    } else {
      debugPrint('❌ Service not found for ID: $serviceId');
    }
    
    return service;
  } catch (e, stackTrace) {
    debugPrint('❌ Error fetching service details for ID: $serviceId');
    debugPrint('Error: $e');
    debugPrint('StackTrace: $stackTrace');
    rethrow;
  }
});

// Parameters class for related services provider
class RelatedServicesParams {
  final String serviceId;
  final String? category;
  
  const RelatedServicesParams({
    required this.serviceId,
    this.category,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelatedServicesParams &&
          runtimeType == other.runtimeType &&
          serviceId == other.serviceId &&
          category == other.category;
  
  @override
  int get hashCode => serviceId.hashCode ^ category.hashCode;
}

// Provider to fetch related services
final relatedServicesProvider = FutureProvider.family<List<ServiceListingModel>, RelatedServicesParams>((ref, params) async {
  try {
    debugPrint('🔄 Fetching related services for:');
    debugPrint('  - Service ID: ${params.serviceId}');
    debugPrint('  - Category: ${params.category}');
    
    final repository = ref.watch(homeRepositoryProvider);
    final relatedServices = await repository.getRelatedServices(
      currentServiceId: params.serviceId,
      category: params.category,
    );
    
    debugPrint('✅ Related services loaded: ${relatedServices.length} items');
    for (var service in relatedServices.take(3)) {
      debugPrint('  - ${service.name} (${service.id})');
    }
    
    return relatedServices;
  } catch (e, stackTrace) {
    debugPrint('❌ Error fetching related services:');
    debugPrint('  - Service ID: ${params.serviceId}');
    debugPrint('  - Category: ${params.category}');
    debugPrint('  - Error: $e');
    debugPrint('  - StackTrace: $stackTrace');
    rethrow;
  }
});

class ServiceDetailScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final String? serviceName;
  final String? price;
  final String? rating;
  final int? reviewCount;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
    this.serviceName,
    this.price,
    this.rating,
    this.reviewCount,
  });

  @override
  ConsumerState<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  // Placeholder for when no images are available
  final String _placeholderImage = 'https://via.placeholder.com/400x300/f0f0f0/999999?text=No+Image';


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceDetailAsync = ref.watch(serviceDetailProvider(widget.serviceId));
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: serviceDetailAsync.when(
        loading: () => const _LoadingScreen(),
        error: (error, stack) {
          // Enhanced error logging
          debugPrint('ServiceDetailScreen Error: $error');
          debugPrint('ServiceId: ${widget.serviceId}');
          return _ErrorScreen(
            error: error.toString(),
            onRetry: () => ref.refresh(serviceDetailProvider(widget.serviceId)),
          );
        },
        data: (service) {
          if (service == null) {
            debugPrint('❌ Service data is null for ID: ${widget.serviceId}');
            return _ErrorScreen(
              error: 'Service not found',
              onRetry: () => ref.refresh(serviceDetailProvider(widget.serviceId)),
            );
          }
          
          debugPrint('✅ Service detail screen rendering with service: ${service.name}');
          return _buildServiceDetail(service);
        },
      ),
    );
  }

  Widget _buildServiceDetail(ServiceListingModel service) {
    // Log service data usage
    debugPrint('🏗️ Building service detail for: ${service.name}');
    debugPrint('  - Has photos: ${service.photos?.isNotEmpty == true}');
    debugPrint('  - Has image: ${service.image.isNotEmpty}');
    debugPrint('  - Has pricing: original=${service.originalPrice}, offer=${service.offerPrice}');
    
    // Use fetched service data with fallbacks for backward compatibility
    final serviceName = service.name.isNotEmpty ? service.name : (widget.serviceName ?? 'Service');
    final serviceDescription = service.description?.isNotEmpty == true 
        ? service.description! 
        : 'A beautiful service designed to make your celebration special.';
    final serviceRating = service.rating?.toStringAsFixed(1) ?? widget.rating ?? '4.9';
    final reviewCount = service.reviewsCount ?? widget.reviewCount ?? 0;
    final originalPrice = service.originalPrice;
    final offerPrice = service.offerPrice;
    final promotionalTag = service.promotionalTag;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(service, serviceName),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceInfo(service, serviceName, originalPrice, offerPrice, serviceRating, reviewCount, promotionalTag),
                _buildDescription(serviceDescription),
                _buildRelatedServices(service),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBookingBar(service, serviceName),
    );
  }

  Widget _buildSliverAppBar(ServiceListingModel service, String serviceName) {
    // Create image list from service photos array, or fallback to cover photo, or placeholder
    List<String> imageList = [];
    
    if (service.photos != null && service.photos!.isNotEmpty) {
      // Filter out null or empty image URLs from photos array
      imageList = service.photos!
          .where((photo) => photo.isNotEmpty && photo.trim().isNotEmpty)
          .toList();
    } 
    
    // If no valid photos, try cover photo
    if (imageList.isEmpty && service.image.isNotEmpty && service.image.trim().isNotEmpty) {
      imageList = [service.image];
    }
    
    // If still no images, use placeholder
    if (imageList.isEmpty) {
      imageList = [_placeholderImage];
    }
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.black,
            ),
            onPressed: () {
              _shareService(serviceName);
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                final imageUrl = imageList[index];
                final isNetworkImage = imageUrl.startsWith('http');
                
                debugPrint('Loading main image $index: $imageUrl (isNetwork: $isNetworkImage)');
                
                return Hero(
                  tag: 'collage_service_${widget.serviceId}',
                  child: Container(
                    child: isNetworkImage
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.pink),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              debugPrint('Main image load error for $url: $error');
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Image failed to load',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : imageUrl == _placeholderImage
                            ? Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'No image available',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                  ),
                );
              },
            ),
            // Image indicators
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...imageList.take(4).toList().asMap().entries.map((entry) {
                    return Container(
                      width: 60,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _currentImageIndex == entry.key
                              ? Colors.white
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: imageList[entry.key].startsWith('http')
                            ? CachedNetworkImage(
                                imageUrl: imageList[entry.key],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(color: Colors.grey[200]),
                                errorWidget: (context, url, error) {
                                  debugPrint('Thumbnail image error for ${imageList[entry.key]}: $error');
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  );
                                },
                              )
                            : imageList[entry.key] == _placeholderImage
                                ? Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  )
                                : Image.asset(
                                    imageList[entry.key],
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    );
                  }),
                  if (imageList.length > 4)
                    Container(
                      width: 60,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '+${imageList.length - 4}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceInfo(ServiceListingModel service, String serviceName, double? originalPrice, double? offerPrice, String rating, int reviewCount, String? promotionalTag) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Okra',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPriceSection(originalPrice, offerPrice),
                    if (promotionalTag != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          promotionalTag,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isFavorite ? AppTheme.primaryColor : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.white : Colors.grey[600],
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                rating,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '($reviewCount)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _navigateToReviews();
                },
                child: Text(
                  'See reviews',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(double? originalPrice, double? offerPrice) {
    if (offerPrice != null && originalPrice != null && offerPrice < originalPrice) {
      // Show discounted price
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '₹${_formatNumberWithCommas(offerPrice.round())}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontFamily: 'Okra',
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${_formatNumberWithCommas(originalPrice.round())}',
                style: const TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${((originalPrice - offerPrice) / originalPrice * 100).round()}% OFF',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      );
    } else if (originalPrice != null) {
      // Show regular price
      return Text(
        '₹${_formatNumberWithCommas(originalPrice.round())}',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
          fontFamily: 'Okra',
        ),
      );
    } else {
      // Show fallback price
      return Text(
        widget.price != null ? _formatPriceToRupees(widget.price!) : 'Price on request',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
          fontFamily: 'Okra',
        ),
      );
    }
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey[700],
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedServices(ServiceListingModel currentService) {
    return Consumer(
      builder: (context, ref, child) {
        final relatedServicesAsync = ref.watch(relatedServicesProvider(RelatedServicesParams(
          serviceId: widget.serviceId,
          category: currentService.category,
        )));
        
        return relatedServicesAsync.when(
          loading: () => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You might like / More like this',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const RelatedServicesShimmer(),
              ],
            ),
          ),
          error: (error, stack) {
            debugPrint('Related services error: $error');
            debugPrint('Service category: ${currentService.category}');
            debugPrint('Current service ID: ${widget.serviceId}');
            // Show error state instead of hiding
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You might like / More like this',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Unable to load related services',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          data: (relatedServices) {
            debugPrint('Related services loaded: ${relatedServices.length} items');
            if (relatedServices.isEmpty) {
              // Show message instead of hiding section
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You might like / More like this',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Okra',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'No related services found',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You might like / More like this',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedServices.length,
                      itemBuilder: (context, index) {
                        final service = relatedServices[index];
                        final price = service.offerPrice != null 
                            ? '₹${service.offerPrice!.round()}'
                            : service.originalPrice != null
                                ? '₹${service.originalPrice!.round()}'
                                : 'Price on request';
                        
                        return GestureDetector(
                          onTap: () {
                            // Navigate to related service detail
                            context.push(
                              '/service/${service.id}',
                              extra: {
                                'serviceName': service.name,
                                'price': price,
                                'rating': (service.rating ?? 0.0).toStringAsFixed(1),
                                'reviewCount': service.reviewsCount ?? 0,
                              },
                            );
                          },
                          child: Container(
                            width: 280,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: SizedBox(
                                    width: 100,
                                    height: 120,
                                    child: _buildRelatedServiceImage(service),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          service.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Okra',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          price,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryColor,
                                            fontFamily: 'Okra',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.orange,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${(service.rating ?? 0.0).toStringAsFixed(1)} (${service.reviewsCount ?? 0})',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontFamily: 'Okra',
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRelatedServiceImage(ServiceListingModel service) {
    // Get the best available image URL
    String imageUrl = '';
    
    // Try photos array first, then cover photo, then placeholder
    if (service.photos != null && service.photos!.isNotEmpty) {
      final validPhotos = service.photos!.where((photo) => photo.isNotEmpty && photo.trim().isNotEmpty).toList();
      if (validPhotos.isNotEmpty) {
        imageUrl = validPhotos.first;
      }
    }
    
    if (imageUrl.isEmpty && service.image.isNotEmpty && service.image.trim().isNotEmpty) {
      imageUrl = service.image;
    }
    
    if (imageUrl.isEmpty) {
      imageUrl = _placeholderImage;
    }

    debugPrint('Related service image for ${service.name}: $imageUrl');

    if (imageUrl == _placeholderImage) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: Colors.grey,
                size: 24,
              ),
              SizedBox(height: 4),
              Text(
                'No image',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        debugPrint('Related service image error for ${service.name}: $error');
        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 24,
                ),
                SizedBox(height: 4),
                Text(
                  'No image',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBookingBar(ServiceListingModel service, String serviceName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle booking
                _showBookingBottomSheet(service, serviceName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Okra',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingBottomSheet(ServiceListingModel service, String serviceName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) => CustomizationBottomSheet(service: service),
    );
  }

  // Helper method to format price to rupees
  String _formatPriceToRupees(String price) {
    // Convert dollar prices to rupees (assuming $1 = ₹84 approximately)
    if (price.startsWith('\$')) {
      final dollarAmount = double.tryParse(price.substring(1)) ?? 0;
      final rupeeAmount = (dollarAmount * 84).round();
      return '₹${_formatNumberWithCommas(rupeeAmount)}';
    }
    // If already in rupees, return as is
    if (price.startsWith('₹')) {
      return price;
    }
    // Default case
    return '₹$price';
  }

  // Helper method to format numbers with commas
  String _formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // Share service functionality with real service data
  void _shareService(String serviceName) {
    final serviceDetailAsync = ref.read(serviceDetailProvider(widget.serviceId));
    
    serviceDetailAsync.whenData((service) {
      String priceText = 'Price on request';
      
      if (service != null) {
        if (service.offerPrice != null) {
          priceText = '₹${_formatNumberWithCommas(service.offerPrice!.round())}';
          if (service.originalPrice != null && service.originalPrice! > service.offerPrice!) {
            final discountPercent = ((service.originalPrice! - service.offerPrice!) / service.originalPrice! * 100).round();
            priceText += ' ($discountPercent% OFF)';
          }
        } else if (service.originalPrice != null) {
          priceText = '₹${_formatNumberWithCommas(service.originalPrice!.round())}';
        }
      }
      
      final ratingText = service?.rating?.toStringAsFixed(1) ?? widget.rating ?? '4.9';
      final reviewCountText = service?.reviewsCount ?? widget.reviewCount ?? 0;
      final categoryText = service?.category ?? '';
      final promotionalTag = service?.promotionalTag;
      
      final shareText = '''
🎉 Check out this amazing ${categoryText.isNotEmpty ? categoryText.toLowerCase() : 'service'} on Sylonow!

$serviceName
Price: $priceText${promotionalTag != null ? ' • $promotionalTag' : ''}
Rating: $ratingText ⭐ ($reviewCountText reviews)

Book now and make your celebration special!

Download Sylonow app: https://sylonow.com
''';

      Share.share(
        shareText,
        subject: 'Amazing $serviceName service on Sylonow',
      );
    });
  }

  // Navigate to reviews screen
  void _navigateToReviews() {
    final serviceName = widget.serviceName ?? 'Service';
    final rating = widget.rating ?? '4.9';
    final reviewCount = widget.reviewCount ?? 0;
    
    context.push(
      ReviewsScreen.routeName,
      extra: {
        'serviceId': widget.serviceId,
        'serviceName': serviceName,
        'averageRating': double.tryParse(rating) ?? 4.9,
        'totalReviews': reviewCount,
      },
    );
  }
}

// Customization Bottom Sheet Widget
class CustomizationBottomSheet extends ConsumerStatefulWidget {
  final ServiceListingModel service;
  
  const CustomizationBottomSheet({
    super.key,
    required this.service,
  });

  @override
  ConsumerState<CustomizationBottomSheet> createState() => _CustomizationBottomSheetState();
}

class _CustomizationBottomSheetState extends ConsumerState<CustomizationBottomSheet> {
  String selectedVenueType = 'Option';
  String selectedDate = 'Select Date';
  String selectedTime = 'Select Time';
  String selectedEnvironment = 'Option';
  List<String> selectedAddOns = [];
  final TextEditingController commentsController = TextEditingController();

  // Dynamic lists based on service data
  late List<String> venueTypes;
  late List<String> serviceEnvironments;
  late List<Map<String, dynamic>> availableAddOns;
  
  final List<String> timeSlots = [
    '09:00-11:00',
    '11:00-13:00', 
    '13:00-15:00',
    '15:00-17:00',
    '17:00-19:00',
    '19:00-21:00',
    '21:00-23:00',
  ];

  @override
  void initState() {
    super.initState();
    _initializeOptionsFromService();
  }

  void _initializeOptionsFromService() {
    // Initialize venue types from service data or fallback to defaults
    venueTypes = widget.service.venueTypes?.isNotEmpty == true 
        ? widget.service.venueTypes!
        : ['Home', 'Community Hall', 'Restaurant', 'Park'];

    // Initialize service environments
    serviceEnvironments = widget.service.serviceEnvironment?.isNotEmpty == true
        ? widget.service.serviceEnvironment!.map((env) => env.toUpperCase()).toList()
        : ['INDOOR', 'OUTDOOR'];

    // Initialize add-ons from service data
    availableAddOns = widget.service.addOns ?? [];

    debugPrint('🎨 Bottom sheet initialized with:');
    debugPrint('  - Venue types: $venueTypes');
    debugPrint('  - Service environments: $serviceEnvironments');
    debugPrint('  - Available add-ons: ${availableAddOns.length}');
  }

  @override
  void dispose() {
    commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Customise / Requirements',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Service Info Section
                  _buildServiceInfoCard(),
                  const SizedBox(height: 24),

                  // Venue Type Section
                  _buildSectionTitle('Venue type'),
                  const SizedBox(height: 12),
                  ...venueTypes.map((venue) => _buildRadioOption(
                    venue,
                    selectedVenueType,
                    (value) => setState(() => selectedVenueType = value),
                  )),
                  const SizedBox(height: 24),

                  // Service Environment Section (if available)
                  if (serviceEnvironments.isNotEmpty) ...[
                    _buildSectionTitle('Service environment'),
                    const SizedBox(height: 12),
                    ...serviceEnvironments.map((env) => _buildRadioOption(
                      env,
                      selectedEnvironment,
                      (value) => setState(() => selectedEnvironment = value),
                    )),
                    const SizedBox(height: 24),
                  ],

                  // Add-ons Section (if available)
                  if (availableAddOns.isNotEmpty) ...[
                    _buildSectionTitle('Add-ons (optional)'),
                    const SizedBox(height: 12),
                    _buildAddOnsSection(),
                    const SizedBox(height: 24),
                  ],

                  // Time Slot and Date Section
                  _buildSectionTitle('Time slot and Date'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          selectedDate,
                          'Select Date',
                          _getNextSevenDays(),
                          (value) => setState(() => selectedDate = value),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          selectedTime,
                          'Select Time',
                          timeSlots,
                          (value) => setState(() => selectedTime = value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Inclusions Section (if available)
                  if (widget.service.inclusions?.isNotEmpty == true) ...[
                    _buildSectionTitle('What\'s included'),
                    const SizedBox(height: 12),
                    _buildInclusionsSection(),
                    const SizedBox(height: 24),
                  ],

                  // Additional Comments Section
                  _buildSectionTitle('Additional comments'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: commentsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: widget.service.customizationNote?.isNotEmpty == true
                            ? widget.service.customizationNote!
                            : 'Add comment (optional)',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Okra',
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(fontFamily: 'Okra'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Continue Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Service Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          if (widget.service.setupTime?.isNotEmpty == true || 
              widget.service.bookingNotice?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            if (widget.service.setupTime?.isNotEmpty == true)
              _buildInfoRow('Setup Time', widget.service.setupTime!),
            if (widget.service.bookingNotice?.isNotEmpty == true)
              _buildInfoRow('Advance Booking', widget.service.bookingNotice!),
          ],
          if (widget.service.customizationAvailable == true) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Customization available',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green,
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOnsSection() {
    return Column(
      children: availableAddOns.map((addon) {
        final addonName = addon['name']?.toString() ?? 'Add-on';
        final addonPrice = addon['price']?.toString() ?? '';
        final isSelected = selectedAddOns.contains(addonName);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedAddOns.remove(addonName);
              } else {
                selectedAddOns.add(addonName);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    addonName,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Okra',
                      color: isSelected ? AppTheme.primaryColor : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (addonPrice.isNotEmpty)
                  Text(
                    '+₹$addonPrice',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInclusionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.service.inclusions!.map((inclusion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    inclusion,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Okra',
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Okra',
        color: Colors.black87,
      ),
    );
  }

  Widget _buildRadioOption(String option, String selectedValue, Function(String) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(option),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedValue == option ? AppTheme.primaryColor : Colors.grey[400]!,
                  width: 2,
                ),
                color: selectedValue == option ? AppTheme.primaryColor : Colors.transparent,
              ),
              child: selectedValue == option
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              option,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Okra',
                color: selectedValue == option ? AppTheme.primaryColor : Colors.black87,
                fontWeight: selectedValue == option ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String selectedValue, String hint, List<String> items, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedValue == hint ? null : selectedValue,
        hint: Text(
          hint,
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Okra',
          ),
        ),
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontFamily: 'Okra'),
          ),
        )).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }

  List<String> _getNextSevenDays() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index + 1));
      return '${date.day}/${date.month}/${date.year}';
    });
  }

  void _validateAndContinue() {
    // Validate venue type selection
    if (selectedVenueType == 'Option') {
      _showError('Please select a venue type');
      return;
    }
    
    // Validate service environment if available
    if (serviceEnvironments.isNotEmpty && selectedEnvironment == 'Option') {
      _showError('Please select a service environment');
      return;
    }
    
    // Validate date selection
    if (selectedDate == 'Select Date') {
      _showError('Please select a date');
      return;
    }
    
    // Validate time selection
    if (selectedTime == 'Select Time') {
      _showError('Please select a time');
      return;
    }

    // Validate service essential fields
    if (widget.service.id.isEmpty) {
      debugPrint('❌ Service ID is empty');
      _showError('Invalid service. Please try again.');
      return;
    }

    if (widget.service.name.isEmpty) {
      debugPrint('❌ Service name is empty');
      _showError('Service information incomplete. Please try again.');
      return;
    }

    // Check pricing information
    if (widget.service.originalPrice == null && widget.service.offerPrice == null) {
      debugPrint('⚠️ Service has no pricing information');
    }

    // Create comprehensive customization data
    final customizationData = {
      'venueType': selectedVenueType,
      'serviceEnvironment': serviceEnvironments.isNotEmpty ? selectedEnvironment : null,
      'date': selectedDate,
      'time': selectedTime,
      'addOns': selectedAddOns,
      'comments': commentsController.text.trim(),
      'setupTime': widget.service.setupTime,
      'bookingNotice': widget.service.bookingNotice,
    };

    debugPrint('✅ Navigating to checkout with enhanced data:');
    debugPrint('  - Service: ${widget.service.name} (${widget.service.id})');
    debugPrint('  - Venue: $selectedVenueType');
    debugPrint('  - Environment: $selectedEnvironment');
    debugPrint('  - Date & Time: $selectedDate at $selectedTime');
    debugPrint('  - Add-ons: $selectedAddOns');
    debugPrint('  - Comments: ${commentsController.text.isNotEmpty ? "Added" : "None"}');

    try {
      // Close bottom sheet first
      Navigator.of(context).pop();
      
      // Navigate to checkout with enhanced data
      context.push(
        CheckoutScreen.routeName,
        extra: {
          'service': widget.service,
          'customization': customizationData,
        },
      );
    } catch (e) {
      debugPrint('❌ Navigation error: $e');
      _showError('Unable to proceed to checkout. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Related Services Shimmer Widget
class RelatedServicesShimmer extends StatelessWidget {
  const RelatedServicesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Container(
                    width: 100,
                    height: 120,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.pink,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
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
        },
      ),
    );
  }
}

// Loading screen widget with shimmer effect
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Shimmer App Bar
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: ShimmerEffect(
                width: double.infinity,
                height: 300,
                borderRadius: BorderRadius.zero,
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service title shimmer
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerEffect(
                              width: 200,
                              height: 28,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            const SizedBox(height: 12),
                            ShimmerEffect(
                              width: 150,
                              height: 24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        ),
                      ),
                      // Favorite button shimmer
                      ShimmerEffect(
                        width: 48,
                        height: 48,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Rating section shimmer
                  Row(
                    children: [
                      ShimmerEffect(
                        width: 120,
                        height: 20,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(width: 12),
                      ShimmerEffect(
                        width: 80,
                        height: 20,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description shimmer
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerEffect(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 8),
                      ShimmerEffect(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 8),
                      ShimmerEffect(
                        width: 200,
                        height: 16,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Related services section shimmer
                  ShimmerEffect(
                    width: 180,
                    height: 24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 16),
                  const RelatedServicesShimmer(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom bar shimmer
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            ShimmerEffect(
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ShimmerEffect(
                width: double.infinity,
                height: 48,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Error screen widget
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
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
                'Unable to load service',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontFamily: 'Okra',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 