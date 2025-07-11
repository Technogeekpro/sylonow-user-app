import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import '../models/review_model.dart';
import '../repositories/reviews_repository.dart';

// Reviews Repository Provider
final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ReviewsRepository(supabase);
});

// Service Reviews Provider
final serviceReviewsProvider = FutureProvider.family<List<ReviewModel>, String>((ref, serviceId) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  try {
    return await repository.getServiceReviews(serviceId);
  } catch (e) {
    print('Error getting service reviews: $e');
    return [];
  }
});

// Review Stats Provider
final reviewStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, serviceId) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return await repository.getReviewStats(serviceId);
});

// User Review for Service Provider
final userReviewForServiceProvider = FutureProvider.family<ReviewModel?, String>((ref, serviceId) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return await repository.getUserReviewForService(serviceId);
});

// Add Review Provider
final addReviewProvider = Provider<Future<ReviewModel> Function({
  required String serviceId,
  required String userName,
  required double rating,
  required String comment,
  String? userAvatar,
})>((ref) {
  return ({
    required String serviceId,
    required String userName,
    required double rating,
    required String comment,
    String? userAvatar,
  }) async {
    final repository = ref.read(reviewsRepositoryProvider);
    
    final review = await repository.addReview(
      serviceId: serviceId,
      userName: userName,
      rating: rating,
      comment: comment,
      userAvatar: userAvatar,
    );
    
    // Refresh related providers
    ref.invalidate(serviceReviewsProvider(serviceId));
    ref.invalidate(reviewStatsProvider(serviceId));
    ref.invalidate(userReviewForServiceProvider(serviceId));
    
    return review;
  };
});

// Update Review Provider
final updateReviewProvider = Provider<Future<ReviewModel> Function({
  required String reviewId,
  required String serviceId,
  required double rating,
  required String comment,
})>((ref) {
  return ({
    required String reviewId,
    required String serviceId,
    required double rating,
    required String comment,
  }) async {
    final repository = ref.read(reviewsRepositoryProvider);
    
    final review = await repository.updateReview(
      reviewId: reviewId,
      rating: rating,
      comment: comment,
    );
    
    // Refresh related providers
    ref.invalidate(serviceReviewsProvider(serviceId));
    ref.invalidate(reviewStatsProvider(serviceId));
    ref.invalidate(userReviewForServiceProvider(serviceId));
    
    return review;
  };
});

// Delete Review Provider
final deleteReviewProvider = Provider<Future<void> Function({
  required String reviewId,
  required String serviceId,
})>((ref) {
  return ({
    required String reviewId,
    required String serviceId,
  }) async {
    final repository = ref.read(reviewsRepositoryProvider);
    
    await repository.deleteReview(reviewId);
    
    // Refresh related providers
    ref.invalidate(serviceReviewsProvider(serviceId));
    ref.invalidate(reviewStatsProvider(serviceId));
    ref.invalidate(userReviewForServiceProvider(serviceId));
  };
});