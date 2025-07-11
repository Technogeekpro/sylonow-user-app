import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../reviews/screens/reviews_screen.dart';
import '../../home/models/service_listing_model.dart';
import '../../home/providers/home_providers.dart';
import '../../home/repositories/home_repository.dart';

// Provider to fetch individual service details
final serviceDetailProvider = FutureProvider.family<ServiceListingModel?, String>((ref, serviceId) async {
  final repository = ref.watch(homeRepositoryProvider);
  return await repository.getServiceById(serviceId);
});

// Provider to fetch related services
final relatedServicesProvider = FutureProvider.family<List<ServiceListingModel>, Map<String, String?>>((ref, params) async {
  final repository = ref.watch(homeRepositoryProvider);
  return await repository.getRelatedServices(
    currentServiceId: params['serviceId']!,
    category: params['category'],
  );
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

  // Default service images when service doesn't have multiple images
  final List<String> _defaultImages = [
    'assets/images/carousel_1.jpg',
    'assets/images/carousel_2.jpg',
    'assets/images/carousel_3.jpg',
    'assets/images/carousel_4.jpg',
    'assets/images/carousel_5.jpg',
  ];


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
        error: (error, stack) => _ErrorScreen(
          error: error.toString(),
          onRetry: () => ref.refresh(serviceDetailProvider(widget.serviceId)),
        ),
        data: (service) => _buildServiceDetail(service),
      ),
    );
  }

  Widget _buildServiceDetail(ServiceListingModel? service) {
    // Use fetched service data or fallback to passed parameters
    final serviceName = service?.name ?? widget.serviceName ?? 'Service';
    final serviceDescription = service?.description ?? 'A beautiful service designed to make your celebration special.';
    final serviceRating = service?.rating?.toStringAsFixed(1) ?? widget.rating ?? '4.9';
    final reviewCount = service?.reviewsCount ?? widget.reviewCount ?? 0;
    final originalPrice = service?.originalPrice;
    final offerPrice = service?.offerPrice;
    final serviceImage = service?.image;
    final promotionalTag = service?.promotionalTag;
    
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
      bottomNavigationBar: _buildBottomBookingBar(serviceName),
    );
  }

  Widget _buildSliverAppBar(ServiceListingModel? service, String serviceName) {
    // Create image list from service photos array, or fallback to cover photo, then default images
    List<String> imageList = [];
    
    if (service?.photos != null && service!.photos!.isNotEmpty) {
      // Use photos array from Supabase
      imageList = service.photos!;
    } else if (service?.image != null) {
      // Use cover photo as single image
      imageList = [service!.image];
    } else {
      // Fallback to default images
      imageList = _defaultImages;
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
                
                return Container(
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
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(_defaultImages[0]),
                                fit: BoxFit.cover,
                              ),
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
                                errorWidget: (context, url, error) => Image.asset(
                                  _defaultImages[0],
                                  fit: BoxFit.cover,
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

  Widget _buildServiceInfo(ServiceListingModel? service, String serviceName, double? originalPrice, double? offerPrice, String rating, int reviewCount, String? promotionalTag) {
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

  Widget _buildRelatedServices(ServiceListingModel? currentService) {
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
          Consumer(
            builder: (context, ref, child) {
              final relatedServicesAsync = ref.watch(relatedServicesProvider({
                'serviceId': widget.serviceId,
                'category': currentService?.category,
              }));
              
              return relatedServicesAsync.when(
                loading: () => const SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.pink),
                  ),
                ),
                error: (error, stack) => const SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      'Unable to load related services',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ),
                data: (relatedServices) {
                  if (relatedServices.isEmpty) {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          'No related services found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return SizedBox(
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
                                  child: Container(
                                    width: 100,
                                    height: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: service.image,
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
                                      errorWidget: (context, url, error) => Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                        ),
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
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBookingBar(String serviceName) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.favorite_border,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle booking
                _showBookingBottomSheet(serviceName);
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

  void _showBookingBottomSheet(String serviceName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Book Service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select your preferred date and time to book this service.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                  // Navigate to booking flow
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue Booking',
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
      ),
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

// Loading screen widget
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.pink),
            SizedBox(height: 16),
            Text(
              'Loading service details...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Okra',
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