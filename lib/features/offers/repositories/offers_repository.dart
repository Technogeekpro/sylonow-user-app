import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/features/offers/models/offer_model.dart';
import 'package:sylonow_user/features/offers/models/promotion_model.dart';
import 'package:sylonow_user/features/offers/models/coupon_model.dart';

class OffersRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Offers Methods
  Future<List<OfferModel>> getActiveOffers() async {
    try {
      final response = await _supabase
          .from('offers')
          .select('*')
          .eq('is_active', true)
          .lte('start_date', DateTime.now().toIso8601String())
          .gte('end_date', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => OfferModel.fromJson(json)).toList();
    } catch (e) {
      // Return mock data for development
      return _getMockOffers();
    }
  }

  Future<List<OfferModel>> getOffersByCategory(String categoryId) async {
    try {
      final response = await _supabase
          .from('offers')
          .select('*')
          .eq('is_active', true)
          .eq('category_id', categoryId)
          .lte('start_date', DateTime.now().toIso8601String())
          .gte('end_date', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => OfferModel.fromJson(json)).toList();
    } catch (e) {
      return _getMockOffers().where((offer) => offer.categoryId == categoryId).toList();
    }
  }

  Future<List<OfferModel>> getFirstTimeUserOffers() async {
    try {
      final response = await _supabase
          .from('offers')
          .select('*')
          .eq('is_active', true)
          .eq('offer_type', 'first_time')
          .lte('start_date', DateTime.now().toIso8601String())
          .gte('end_date', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => OfferModel.fromJson(json)).toList();
    } catch (e) {
      return _getMockOffers().where((offer) => offer.offerType == 'first_time').toList();
    }
  }

  Future<OfferModel?> getOfferById(String offerId) async {
    try {
      final response = await _supabase
          .from('offers')
          .select('*')
          .eq('id', offerId)
          .single();

      return OfferModel.fromJson(response);
    } catch (e) {
      return _getMockOffers().firstWhere((offer) => offer.id == offerId);
    }
  }

  // Promotions Methods
  Future<List<PromotionModel>> getActivePromotions() async {
    try {
      final response = await _supabase
          .from('promotions')
          .select('*')
          .eq('is_active', true)
          .lte('start_date', DateTime.now().toIso8601String())
          .gte('end_date', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => PromotionModel.fromJson(json)).toList();
    } catch (e) {
      return _getMockPromotions();
    }
  }

  Future<List<PromotionModel>> getFeaturedPromotions() async {
    try {
      final response = await _supabase
          .from('promotions')
          .select('*')
          .eq('is_active', true)
          .eq('is_featured', true)
          .lte('start_date', DateTime.now().toIso8601String())
          .gte('end_date', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => PromotionModel.fromJson(json)).toList();
    } catch (e) {
      return _getMockPromotions().where((promo) => promo.isFeatured).toList();
    }
  }

  Future<List<PromotionModel>> getSeasonalPromotions() async {
    try {
      final response = await _supabase
          .from('promotions')
          .select('*')
          .eq('is_active', true)
          .eq('promotion_type', 'seasonal')
          .lte('start_date', DateTime.now().toIso8601String())
          .gte('end_date', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => PromotionModel.fromJson(json)).toList();
    } catch (e) {
      return _getMockPromotions().where((promo) => promo.promotionType == 'seasonal').toList();
    }
  }

  Future<PromotionModel?> getPromotionById(String promotionId) async {
    try {
      final response = await _supabase
          .from('promotions')
          .select('*')
          .eq('id', promotionId)
          .single();

      return PromotionModel.fromJson(response);
    } catch (e) {
      return _getMockPromotions().firstWhere((promo) => promo.id == promotionId);
    }
  }

  // Coupons Methods
  Future<List<CouponModel>> getPublicCoupons() async {
    try {
      final response = await _supabase
          .from('coupons')
          .select('*')
          .eq('is_active', true)
          .eq('is_public', true)
          .lte('start_date', DateTime.now().toIso8601String())
          .gte('end_date', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => CouponModel.fromJson(json)).toList();
    } catch (e) {
      return _getMockCoupons();
    }
  }

  Future<List<CouponModel>> getUserCoupons(String userId) async {
    try {
      final response = await _supabase
          .from('coupons')
          .select('*')
          .eq('is_active', true)
          .or('is_public.eq.true,user_id.eq.$userId')
          .lte('start_date', DateTime.now().toIso8601String())
          .gte('end_date', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      return response.map((json) => CouponModel.fromJson(json)).toList();
    } catch (e) {
      return _getMockCoupons();
    }
  }

  Future<CouponModel?> getCouponByCode(String code) async {
    try {
      final response = await _supabase
          .from('coupons')
          .select('*')
          .eq('code', code)
          .eq('is_active', true)
          .single();

      return CouponModel.fromJson(response);
    } catch (e) {
      return _getMockCoupons().firstWhere((coupon) => coupon.code == code);
    }
  }

  Future<CouponModel?> getCouponById(String couponId) async {
    try {
      final response = await _supabase
          .from('coupons')
          .select('*')
          .eq('id', couponId)
          .single();

      return CouponModel.fromJson(response);
    } catch (e) {
      return _getMockCoupons().firstWhere((coupon) => coupon.id == couponId);
    }
  }

  Future<bool> validateCoupon(String code, String userId, double orderValue) async {
    try {
      final coupon = await getCouponByCode(code);
      if (coupon == null) return false;

      return coupon.isValid && 
             orderValue >= (coupon.minOrderValue ?? 0) &&
             (!coupon.isUsageLimitReached);
    } catch (e) {
      return false;
    }
  }

  Future<void> incrementCouponUsage(String couponId) async {
    try {
      await _supabase
          .from('coupons')
          .update({'current_usage_count': 'current_usage_count + 1'})
          .eq('id', couponId);
    } catch (e) {
      // Handle error
    }
  }

  // Mock Data Methods
  List<OfferModel> _getMockOffers() {
    return [
      OfferModel(
        id: '1',
        title: 'First Time User Special',
        description: 'Get 50% off on your first service booking',
        imageUrl: 'https://images.unsplash.com/photo-1558618047-b2c4c3c0b0e5?w=400&q=80',
        discountPercentage: 50.0,
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        offerType: 'percentage',
        minOrderValue: 500.0,
        maxUsageCount: 1000,
        usedCount: 145,
        termsAndConditions: 'Valid for new users only. Minimum order value ₹500.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      OfferModel(
        id: '2',
        title: 'Weekend Special',
        description: 'Extra 30% off on weekend bookings',
        imageUrl: 'https://images.unsplash.com/photo-1567016526105-22da7c13161a?w=400&q=80',
        discountPercentage: 30.0,
        startDate: DateTime.now().subtract(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 10)),
        isActive: true,
        offerType: 'percentage',
        minOrderValue: 300.0,
        maxUsageCount: 500,
        usedCount: 89,
        termsAndConditions: 'Valid on Saturday and Sunday only.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      OfferModel(
        id: '3',
        title: 'Decoration Special',
        description: 'Flat ₹200 off on decoration services',
        imageUrl: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&q=80',
        discountPercentage: 0.0,
        discountAmount: '200',
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 15)),
        isActive: true,
        offerType: 'fixed',
        categoryId: 'decoration',
        minOrderValue: 1000.0,
        maxUsageCount: 200,
        usedCount: 67,
        termsAndConditions: 'Valid for decoration services only. Minimum order ₹1000.',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }

  List<PromotionModel> _getMockPromotions() {
    return [
      PromotionModel(
        id: '1',
        title: 'Grand Opening Sale',
        subtitle: 'Celebrate with us!',
        description: 'Special launch offer for all new customers',
        imageUrl: 'https://images.unsplash.com/photo-1533629806928-cc3e7e85a5c3?w=400&q=80',
        bannerImageUrl: 'https://images.unsplash.com/photo-1533629806928-cc3e7e85a5c3?w=800&q=80',
        discountValue: 40.0,
        discountType: 'percentage',
        startDate: DateTime.now().subtract(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 25)),
        isActive: true,
        isFeatured: true,
        promotionType: 'first_time',
        minOrderValue: 750.0,
        maxUsagePerUser: 1,
        totalUsageLimit: 1000,
        currentUsageCount: 234,
        termsAndConditions: 'Valid for new users only. One time use per user.',
        targetUserTypes: ['new'],
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      PromotionModel(
        id: '2',
        title: 'Summer Festival',
        subtitle: 'Beat the heat with cool offers',
        description: 'Special summer discount on all services',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
        bannerImageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
        discountValue: 25.0,
        discountType: 'percentage',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 20)),
        isActive: true,
        isFeatured: true,
        promotionType: 'seasonal',
        minOrderValue: 500.0,
        maxUsagePerUser: 3,
        totalUsageLimit: 2000,
        currentUsageCount: 456,
        promoCode: 'SUMMER25',
        termsAndConditions: 'Valid during summer season. Maximum 3 uses per user.',
        targetUserTypes: ['new', 'existing'],
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ];
  }

  List<CouponModel> _getMockCoupons() {
    return [
      CouponModel(
        id: '1',
        code: 'WELCOME50',
        title: 'Welcome Bonus',
        description: 'Get 50% off on your first order',
        discountValue: 50.0,
        discountType: 'percentage',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 60)),
        isActive: true,
        isPublic: true,
        minOrderValue: 500.0,
        maxDiscountAmount: 500.0,
        maxUsagePerUser: 1,
        totalUsageLimit: 1000,
        currentUsageCount: 234,
        termsAndConditions: 'Valid for new users only. Maximum discount ₹500.',
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
      ),
      CouponModel(
        id: '2',
        code: 'SAVE200',
        title: 'Flat ₹200 Off',
        description: 'Instant discount of ₹200 on orders above ₹1000',
        discountValue: 200.0,
        discountType: 'fixed',
        startDate: DateTime.now().subtract(const Duration(days: 15)),
        endDate: DateTime.now().add(const Duration(days: 45)),
        isActive: true,
        isPublic: true,
        minOrderValue: 1000.0,
        maxUsagePerUser: 2,
        totalUsageLimit: 500,
        currentUsageCount: 123,
        termsAndConditions: 'Valid on orders above ₹1000. Maximum 2 uses per user.',
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),
      CouponModel(
        id: '3',
        code: 'WEEKEND30',
        title: 'Weekend Special',
        description: '30% off on weekend bookings',
        discountValue: 30.0,
        discountType: 'percentage',
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        isPublic: true,
        minOrderValue: 300.0,
        maxDiscountAmount: 300.0,
        maxUsagePerUser: 4,
        totalUsageLimit: 800,
        currentUsageCount: 89,
        termsAndConditions: 'Valid on Saturday and Sunday only. Maximum discount ₹300.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }
}