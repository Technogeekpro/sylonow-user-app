import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:sylonow_user/features/wishlist/models/wishlist_model.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';

part 'wishlist_repository.g.dart';

@riverpod
WishlistRepository wishlistRepository(WishlistRepositoryRef ref) {
  return WishlistRepository(ref.read(supabaseClientProvider));
}

class WishlistRepository {
  final SupabaseClient _supabase;

  WishlistRepository(this._supabase);

  Future<List<WishlistWithService>> getUserWishlist(String userId) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .select('''
            *,
            service_listings!inner(
              id,
              title,
              description,
              price,
              rating,
              reviews_count,
              image_url,
              category_id,
              vendor_id,
              service_type_id,
              created_at,
              updated_at
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map((json) {
        final serviceData = json['service_listings'];
        return WishlistWithService(
          id: json['id'],
          userId: json['user_id'],
          serviceId: json['service_id'],
          createdAt: DateTime.parse(json['created_at']),
          updatedAt: DateTime.parse(json['updated_at']),
          service: ServiceListingModel.fromJson(serviceData),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch wishlist: $e');
    }
  }

  Future<bool> addToWishlist(String userId, String serviceId) async {
    try {
      await _supabase.from('wishlist').insert({
        'user_id': userId,
        'service_id': serviceId,
      });
      return true;
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  Future<bool> removeFromWishlist(String userId, String serviceId) async {
    try {
      await _supabase
          .from('wishlist')
          .delete()
          .eq('user_id', userId)
          .eq('service_id', serviceId);
      return true;
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  Future<bool> isInWishlist(String userId, String serviceId) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .select('id')
          .eq('user_id', userId)
          .eq('service_id', serviceId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      throw Exception('Failed to check wishlist status: $e');
    }
  }

  Future<int> getWishlistCount(String userId) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .select('id', const FetchOptions(count: CountOption.exact))
          .eq('user_id', userId);
      
      return response.length;
    } catch (e) {
      throw Exception('Failed to get wishlist count: $e');
    }
  }
}