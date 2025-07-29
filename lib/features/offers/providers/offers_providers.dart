import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/features/offers/models/offer_model.dart';
import 'package:sylonow_user/features/offers/models/promotion_model.dart';
import 'package:sylonow_user/features/offers/models/coupon_model.dart';
import 'package:sylonow_user/features/offers/repositories/offers_repository.dart';
import 'package:sylonow_user/features/offers/services/offers_service.dart';

// Repository Provider
final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  return OffersRepository();
});

// Service Provider
final offersServiceProvider = Provider<OffersService>((ref) {
  return OffersService(ref.watch(offersRepositoryProvider));
});

// Offers Provider
final offersProvider = FutureProvider<List<OfferModel>>((ref) async {
  final service = ref.watch(offersServiceProvider);
  return service.getActiveOffers();
});

// Promotions Provider
final promotionsProvider = FutureProvider<List<PromotionModel>>((ref) async {
  final service = ref.watch(offersServiceProvider);
  return service.getActivePromotions();
});

// Coupons Provider
final couponsProvider = FutureProvider<List<CouponModel>>((ref) async {
  final service = ref.watch(offersServiceProvider);
  return service.getPublicCoupons();
});

// Featured Promotions Provider
final featuredPromotionsProvider = FutureProvider<List<PromotionModel>>((ref) async {
  final service = ref.watch(offersServiceProvider);
  return service.getFeaturedPromotions();
});

// User Specific Coupons Provider
final userCouponsProvider = FutureProvider.family<List<CouponModel>, String>((ref, userId) async {
  final service = ref.watch(offersServiceProvider);
  return service.getUserCoupons(userId);
});

// Offers by Category Provider
final offersByCategoryProvider = FutureProvider.family<List<OfferModel>, String>((ref, categoryId) async {
  final service = ref.watch(offersServiceProvider);
  return service.getOffersByCategory(categoryId);
});

// Coupon Validation Provider
final couponValidationProvider = FutureProvider.family<bool, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(offersServiceProvider);
  return service.validateCoupon(
    params['code'] as String,
    params['userId'] as String,
    params['orderValue'] as double,
  );
});

// Apply Coupon Provider
final applyCouponProvider = FutureProvider.family<double, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(offersServiceProvider);
  return service.applyCoupon(
    params['code'] as String,
    params['userId'] as String,
    params['orderValue'] as double,
  );
});

// First Time User Offers Provider
final firstTimeOffersProvider = FutureProvider<List<OfferModel>>((ref) async {
  final service = ref.watch(offersServiceProvider);
  return service.getFirstTimeUserOffers();
});

// Seasonal Promotions Provider
final seasonalPromotionsProvider = FutureProvider<List<PromotionModel>>((ref) async {
  final service = ref.watch(offersServiceProvider);
  return service.getSeasonalPromotions();
});

// Offer Detail Provider
final offerDetailProvider = FutureProvider.family<OfferModel?, String>((ref, offerId) async {
  final service = ref.watch(offersServiceProvider);
  return service.getOfferById(offerId);
});

// Promotion Detail Provider
final promotionDetailProvider = FutureProvider.family<PromotionModel?, String>((ref, promotionId) async {
  final service = ref.watch(offersServiceProvider);
  return service.getPromotionById(promotionId);
});

// Coupon Detail Provider
final couponDetailProvider = FutureProvider.family<CouponModel?, String>((ref, couponId) async {
  final service = ref.watch(offersServiceProvider);
  return service.getCouponById(couponId);
});