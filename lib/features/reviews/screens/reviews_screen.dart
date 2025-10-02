import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../models/review_model.dart';
import '../providers/reviews_providers.dart';

class ReviewsScreen extends ConsumerWidget {
  static const String routeName = '/reviews';
  
  final String serviceId;
  final String serviceName;
  final double averageRating;
  final int totalReviews;

  const ReviewsScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get reviews from database
    final reviewsAsync = ref.watch(serviceReviewsProvider(serviceId));
    final statsAsync = ref.watch(reviewStatsProvider(serviceId));
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Reviews',
          style: const TextStyle(
            fontFamily: 'Okra',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Reviews Header
          SliverToBoxAdapter(
            child: statsAsync.when(
              data: (stats) => _buildReviewsHeader(stats),
              loading: () => _buildReviewsHeader(null),
              error: (error, _) => _buildReviewsHeader(null),
            ),
          ),
          // Rating Distribution
          SliverToBoxAdapter(
            child: statsAsync.when(
              data: (stats) => _buildRatingDistribution(stats),
              loading: () => _buildLoadingWidget(),
              error: (error, _) => _buildErrorWidget(),
            ),
          ),
          // Reviews List
          reviewsAsync.when(
            data: (reviews) => reviews.isEmpty
                ? const SliverToBoxAdapter(
                    child: _EmptyReviewsWidget(),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final review = reviews[index];
                        return _buildReviewCard(review);
                      },
                      childCount: reviews.length,
                    ),
                  ),
            loading: () => const SliverToBoxAdapter(
              child: _LoadingReviewsWidget(),
            ),
            error: (error, _) => SliverToBoxAdapter(
              child: _ErrorReviewsWidget(error: error.toString()),
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsHeader(Map<String, dynamic>? stats) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            serviceName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      (stats?['averageRating'] ?? averageRating).toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Based on ${stats?['totalReviews'] ?? totalReviews} reviews',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(Map<String, dynamic>? stats) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rating Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            final rating = 5 - index;
            final percentage = _getRatingPercentage(rating, stats);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    '$rating',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Okra',
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${percentage.toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor,
                child: review.userAvatar != null
                    ? ClipOval(
                        child: Image.network(
                          review.userAvatar!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              review.userName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Okra',
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        review.userName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.rating.floor()
                                ? Icons.star
                                : index < review.rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.orange,
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMM dd, yyyy').format(review.createdAt),
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
            ],
          ),
          const SizedBox(height: 16),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  double _getRatingPercentage(int rating, Map<String, dynamic>? stats) {
    if (stats == null || stats['ratingDistribution'] == null) {
      // Fallback sample data
      switch (rating) {
        case 5:
          return 65.0;
        case 4:
          return 25.0;
        case 3:
          return 8.0;
        case 2:
          return 2.0;
        case 1:
          return 0.0;
        default:
          return 0.0;
      }
    }

    final distribution = stats['ratingDistribution'] as Map<int, int>;
    final totalReviews = stats['totalReviews'] as int;
    
    if (totalReviews == 0) return 0.0;
    
    final count = distribution[rating] ?? 0;
    return (count / totalReviews * 100).toDouble();
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Error loading rating distribution',
        style: TextStyle(
          color: Colors.red,
          fontFamily: 'Okra',
        ),
      ),
    );
  }

  List<ReviewModel> _generateSampleReviews() {
    return [
      ReviewModel(
        id: '1',
        userId: 'user1',
        serviceId: serviceId,
        userName: 'Priya Sharma',
        rating: 5.0,
        comment: 'Absolutely wonderful service! The decoration was exactly what I envisioned for my daughter\'s birthday party. The team was professional and completed everything on time. Highly recommended!',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: '2',
        userId: 'user2',
        serviceId: serviceId,
        userName: 'Rajesh Kumar',
        rating: 4.5,
        comment: 'Great experience overall. The decorations were beautiful and the setup was done efficiently. Only minor issue was a slight delay in starting, but the end result was fantastic.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ReviewModel(
        id: '3',
        userId: 'user3',
        serviceId: serviceId,
        userName: 'Anita Patel',
        rating: 5.0,
        comment: 'Exceeded my expectations! The attention to detail was remarkable. The floral arrangements were fresh and beautifully arranged. Will definitely book again for future events.',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      ReviewModel(
        id: '4',
        userId: 'user4',
        serviceId: serviceId,
        userName: 'Mohammed Ali',
        rating: 4.0,
        comment: 'Good service and reasonable pricing. The team was courteous and worked within our budget. The decoration looked elegant and matched our theme perfectly.',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      ReviewModel(
        id: '5',
        userId: 'user5',
        serviceId: serviceId,
        userName: 'Sneha Gupta',
        rating: 5.0,
        comment: 'Amazing work! They transformed our venue completely. The lighting, flowers, and overall ambiance were perfect for our anniversary celebration. Thank you for making our day special!',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }
}

// Empty Reviews Widget
class _EmptyReviewsWidget extends StatelessWidget {
  const _EmptyReviewsWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No reviews yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to review this service',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }
}

// Loading Reviews Widget
class _LoadingReviewsWidget extends StatelessWidget {
  const _LoadingReviewsWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: AppTheme.primaryColor),
            SizedBox(height: 16),
            Text(
              'Loading reviews...',
              style: TextStyle(
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

// Error Reviews Widget
class _ErrorReviewsWidget extends StatelessWidget {
  final String error;
  
  const _ErrorReviewsWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load reviews',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }
}