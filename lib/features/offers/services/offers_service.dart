import 'package:sylonow_user/features/offers/models/offer_model.dart';
import 'package:sylonow_user/features/offers/models/promotion_model.dart';
import 'package:sylonow_user/features/offers/models/coupon_model.dart';
import 'package:sylonow_user/features/offers/repositories/offers_repository.dart';

class OffersService {
  final OffersRepository _repository;

  OffersService(this._repository);

  // Offers Methods
  Future<List<OfferModel>> getActiveOffers() async {
    final offers = await _repository.getActiveOffers();
    return offers.where((offer) => offer.isValid).toList();
  }

  Future<List<OfferModel>> getOffersByCategory(String categoryId) async {
    final offers = await _repository.getOffersByCategory(categoryId);
    return offers.where((offer) => offer.isValid).toList();
  }

  Future<List<OfferModel>> getFirstTimeUserOffers() async {
    final offers = await _repository.getFirstTimeUserOffers();
    return offers.where((offer) => offer.isValid).toList();
  }

  Future<OfferModel?> getOfferById(String offerId) async {
    return await _repository.getOfferById(offerId);
  }

  // Promotions Methods
  Future<List<PromotionModel>> getActivePromotions() async {
    final promotions = await _repository.getActivePromotions();
    return promotions.where((promo) => promo.isValid).toList();
  }

  Future<List<PromotionModel>> getFeaturedPromotions() async {
    final promotions = await _repository.getFeaturedPromotions();
    return promotions.where((promo) => promo.isValid).toList();
  }

  Future<List<PromotionModel>> getSeasonalPromotions() async {
    final promotions = await _repository.getSeasonalPromotions();
    return promotions.where((promo) => promo.isValid).toList();
  }

  Future<PromotionModel?> getPromotionById(String promotionId) async {
    return await _repository.getPromotionById(promotionId);
  }

  // Coupons Methods
  Future<List<CouponModel>> getPublicCoupons() async {
    final coupons = await _repository.getPublicCoupons();
    return coupons.where((coupon) => coupon.isValid).toList();
  }

  Future<List<CouponModel>> getUserCoupons(String userId) async {
    final coupons = await _repository.getUserCoupons(userId);
    return coupons.where((coupon) => coupon.isValid).toList();
  }

  Future<CouponModel?> getCouponByCode(String code) async {
    return await _repository.getCouponByCode(code);
  }

  Future<CouponModel?> getCouponById(String couponId) async {
    return await _repository.getCouponById(couponId);
  }

  // Validation and Application Methods
  Future<bool> validateCoupon(String code, String userId, double orderValue) async {
    return await _repository.validateCoupon(code, userId, orderValue);
  }

  Future<double> applyCoupon(String code, String userId, double orderValue) async {
    final coupon = await _repository.getCouponByCode(code);
    if (coupon == null || !coupon.isValid) {
      throw Exception('Invalid coupon code');
    }

    if (orderValue < (coupon.minOrderValue ?? 0)) {
      throw Exception('Minimum order value not met');
    }

    if (coupon.isUsageLimitReached) {
      throw Exception('Coupon usage limit reached');
    }

    final discount = coupon.calculateDiscount(orderValue);
    
    // Increment usage count
    await _repository.incrementCouponUsage(coupon.id);
    
    return discount;
  }

  // Offer Application Methods
  Future<double> applyOffer(String offerId, double orderValue) async {
    final offer = await _repository.getOfferById(offerId);
    if (offer == null || !offer.isValid) {
      throw Exception('Invalid offer');
    }

    if (orderValue < (offer.minOrderValue ?? 0)) {
      throw Exception('Minimum order value not met');
    }

    double discount = 0.0;
    if (offer.offerType == 'percentage') {
      discount = (orderValue * offer.discountPercentage) / 100;
    } else if (offer.offerType == 'fixed' && offer.discountAmount != null) {
      discount = double.parse(offer.discountAmount!);
    }

    return discount > orderValue ? orderValue : discount;
  }

  // Get best applicable offer for user
  Future<OfferModel?> getBestOfferForOrder(double orderValue, String? categoryId, bool isFirstTime) async {
    List<OfferModel> applicableOffers = [];

    // Get all active offers
    final allOffers = await getActiveOffers();
    
    // Get category-specific offers if category is provided
    if (categoryId != null) {
      final categoryOffers = await getOffersByCategory(categoryId);
      applicableOffers.addAll(categoryOffers);
    }

    // Get first-time user offers if applicable
    if (isFirstTime) {
      final firstTimeOffers = await getFirstTimeUserOffers();
      applicableOffers.addAll(firstTimeOffers);
    }

    // Add general offers
    applicableOffers.addAll(allOffers);

    // Remove duplicates
    applicableOffers = applicableOffers.toSet().toList();

    // Filter by minimum order value
    applicableOffers = applicableOffers.where((offer) => 
      orderValue >= (offer.minOrderValue ?? 0)
    ).toList();

    if (applicableOffers.isEmpty) return null;

    // Find the offer with maximum discount
    OfferModel? bestOffer;
    double maxDiscount = 0.0;

    for (final offer in applicableOffers) {
      double discount = 0.0;
      if (offer.offerType == 'percentage') {
        discount = (orderValue * offer.discountPercentage) / 100;
      } else if (offer.offerType == 'fixed' && offer.discountAmount != null) {
        discount = double.parse(offer.discountAmount!);
      }

      if (discount > maxDiscount) {
        maxDiscount = discount;
        bestOffer = offer;
      }
    }

    return bestOffer;
  }

  // Get best applicable coupon for user
  Future<CouponModel?> getBestCouponForOrder(double orderValue, String userId) async {
    final userCoupons = await getUserCoupons(userId);
    
    // Filter by minimum order value
    final applicableCoupons = userCoupons.where((coupon) => 
      orderValue >= (coupon.minOrderValue ?? 0)
    ).toList();

    if (applicableCoupons.isEmpty) return null;

    // Find the coupon with maximum discount
    CouponModel? bestCoupon;
    double maxDiscount = 0.0;

    for (final coupon in applicableCoupons) {
      final discount = coupon.calculateDiscount(orderValue);
      if (discount > maxDiscount) {
        maxDiscount = discount;
        bestCoupon = coupon;
      }
    }

    return bestCoupon;
  }

  // Analytics Methods
  Future<Map<String, dynamic>> getOffersAnalytics() async {
    final offers = await _repository.getActiveOffers();
    final promotions = await _repository.getActivePromotions();
    final coupons = await _repository.getPublicCoupons();

    return {
      'total_offers': offers.length,
      'total_promotions': promotions.length,
      'total_coupons': coupons.length,
      'featured_promotions': promotions.where((p) => p.isFeatured).length,
      'expiring_soon': offers.where((o) => 
        o.endDate.difference(DateTime.now()).inDays <= 3
      ).length,
    };
  }
}