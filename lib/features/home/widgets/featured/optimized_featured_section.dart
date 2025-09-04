import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/home/providers/cached_home_providers.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';

class OptimizedFeaturedSection extends ConsumerStatefulWidget {
  const OptimizedFeaturedSection({super.key});

  @override
  ConsumerState<OptimizedFeaturedSection> createState() => _OptimizedFeaturedSectionState();
}

class _OptimizedFeaturedSectionState extends ConsumerState<OptimizedFeaturedSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Load more when close to end
      final notifier = ref.read(cachedFeaturedServicesProvider.notifier);
      notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsyncValue = ref.watch(cachedFeaturedServicesProvider);
    final notifier = ref.read(cachedFeaturedServicesProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 16),
        servicesAsyncValue.when(
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(),
          data: (services) => _buildServicesList(services, notifier),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Featured Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: Color(0xFF2A3143),
            ),
          ),
          TextButton(
            onPressed: () {
              final notifier = ref.read(cachedFeaturedServicesProvider.notifier);
              notifier.refresh();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Icon(
              Icons.refresh,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.pink),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
      height: 280,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Could not load featured services',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(cachedFeaturedServicesProvider.notifier).refresh();
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontFamily: 'Okra',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(List<ServiceListingModel> services, CachedFeaturedServicesNotifier notifier) {
    if (services.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: Text(
            'No featured services available.',
            style: TextStyle(color: Colors.grey, fontFamily: 'Okra'),
          ),
        ),
      );
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: services.length + (notifier.hasMore ? 1 : 0), // +1 for loading indicator
        itemBuilder: (context, index) {
          if (index == services.length) {
            // Loading more indicator
            return Container(
              width: 80,
              margin: const EdgeInsets.only(right: 16),
              child: Center(
                child: notifier.isLoadingMore
                    ? const CircularProgressIndicator(color: Colors.pink, strokeWidth: 2)
                    : const SizedBox.shrink(),
              ),
            );
          }

          final service = services[index];
          return _buildServiceCard(service, context);
        },
      ),
    );
  }

  Widget _buildServiceCard(ServiceListingModel service, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.only(right: 16, bottom: 8, top: 4),
      child: GestureDetector(
        onTap: () {
          final price = service.offerPrice != null 
              ? '₹${service.offerPrice!.round()}'
              : service.originalPrice != null
                  ? '₹${service.originalPrice!.round()}'
                  : null;

          context.push(
            '/service/${service.id}',
            extra: {
              'serviceName': service.name,
              'price': price,
              'rating': (service.rating ?? 4.9).toStringAsFixed(1),
              'reviewCount': service.reviewsCount ?? 102,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: service.image ?? '',
                          fit: BoxFit.cover,
                          memCacheWidth: 400, // Optimize memory usage
                          memCacheHeight: 240,
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
                              child: Icon(Icons.image_not_supported, 
                                         color: Colors.grey, size: 40),
                            ),
                          ),
                        ),
                      ),
                      
                      // Rating badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                '${service.rating?.toStringAsFixed(1) ?? '4.9'}',
                                style: const TextStyle(
                                  fontSize: 12,
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
              
              // Service Details
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.description ?? 'Professional service with quality guarantee',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Okra',
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPriceDisplay(service),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Book Now',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Okra',
                              ),
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
      ),
    );
  }

  Widget _buildPriceDisplay(ServiceListingModel service) {
    if (service.offerPrice != null && service.originalPrice != null && service.offerPrice! < service.originalPrice!) {
      // Show discounted price
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '₹${_formatNumberWithCommas(service.offerPrice!.round())}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              fontFamily: 'Okra',
            ),
          ),
          Text(
            '₹${_formatNumberWithCommas(service.originalPrice!.round())}',
            style: const TextStyle(
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
              fontFamily: 'Okra',
            ),
          ),
        ],
      );
    } else if (service.originalPrice != null) {
      return Text(
        '₹${_formatNumberWithCommas(service.originalPrice!.round())}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
          fontFamily: 'Okra',
        ),
      );
    } else {
      return Text(
        'Price on request',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryColor,
          fontFamily: 'Okra',
        ),
      );
    }
  }

  String _formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}