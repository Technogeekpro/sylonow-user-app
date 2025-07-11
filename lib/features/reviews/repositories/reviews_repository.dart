import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/review_model.dart';

class ReviewsRepository {
  final SupabaseClient _supabase;

  ReviewsRepository(this._supabase);

  // Get reviews for a specific service
  Future<List<ReviewModel>> getServiceReviews(String serviceId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select()
          .eq('service_id', serviceId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response
          .map((json) => ReviewModel.fromJson(json))
          .toList();
    } catch (e) {
      // Handle case where table doesn't exist
      if (e.toString().contains('relation "public.reviews" does not exist')) {
        print('Reviews table not found. Please run database setup.');
        return [];
      }
      throw Exception('Failed to get reviews: $e');
    }
  }

  // Add a new review
  Future<ReviewModel> addReview({
    required String serviceId,
    required String userName,
    required double rating,
    required String comment,
    String? userAvatar,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('reviews')
          .insert({
            'user_id': user.id,
            'service_id': serviceId,
            'user_name': userName,
            'user_avatar': userAvatar,
            'rating': rating,
            'comment': comment,
          })
          .select()
          .single();

      return ReviewModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  // Update an existing review
  Future<ReviewModel> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('reviews')
          .update({
            'rating': rating,
            'comment': comment,
          })
          .eq('id', reviewId)
          .eq('user_id', user.id) // Ensure user can only update their own reviews
          .select()
          .single();

      return ReviewModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  // Delete a review
  Future<void> deleteReview(String reviewId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('reviews')
          .delete()
          .eq('id', reviewId)
          .eq('user_id', user.id); // Ensure user can only delete their own reviews
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  // Get user's review for a specific service
  Future<ReviewModel?> getUserReviewForService(String serviceId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return null;
      }

      final response = await _supabase
          .from('reviews')
          .select()
          .eq('service_id', serviceId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) return null;

      return ReviewModel.fromJson(response);
    } catch (e) {
      print('Error getting user review: $e');
      return null;
    }
  }

  // Get review statistics for a service
  Future<Map<String, dynamic>> getReviewStats(String serviceId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('rating')
          .eq('service_id', serviceId);

      if (response.isEmpty) {
        return {
          'averageRating': 0.0,
          'totalReviews': 0,
          'ratingDistribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        };
      }

      final ratings = response.map<double>((r) => r['rating'].toDouble()).toList();
      final averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
      
      final ratingDistribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      for (final rating in ratings) {
        final roundedRating = rating.round();
        ratingDistribution[roundedRating] = ratingDistribution[roundedRating]! + 1;
      }

      return {
        'averageRating': double.parse(averageRating.toStringAsFixed(1)),
        'totalReviews': ratings.length,
        'ratingDistribution': ratingDistribution,
      };
    } catch (e) {
      print('Error getting review stats: $e');
      return {
        'averageRating': 0.0,
        'totalReviews': 0,
        'ratingDistribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      };
    }
  }
}