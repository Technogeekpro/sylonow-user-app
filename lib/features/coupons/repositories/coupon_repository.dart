import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/coupon_model.dart';

class CouponRepository {
  final SupabaseClient _supabase;

  CouponRepository(this._supabase);

  /// Get all public active coupons
  Future<List<CouponModel>> getPublicCoupons() async {
    try {
      final response = await _supabase
          .from('coupons')
          .select()
          .eq('is_active', true)
          .eq('is_public', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((coupon) => CouponModel.fromJson(coupon))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch coupons: $e');
    }
  }

  /// Get coupons linked to a specific service
  Future<List<CouponModel>> getServiceCoupons(String serviceId) async {
    try {
      // First get coupon IDs from service_coupons table
      final serviceCouponsResponse = await _supabase
          .from('service_coupons')
          .select('coupon_id')
          .eq('service_id', serviceId);

      if (serviceCouponsResponse.isEmpty) {
        return [];
      }

      // Extract coupon IDs
      final couponIds = (serviceCouponsResponse as List)
          .map((item) => item['coupon_id'] as String?)
          .where((id) => id != null)
          .cast<String>()
          .toList();

      if (couponIds.isEmpty) {
        return [];
      }

      // Get the actual coupons
      final couponsResponse = await _supabase
          .from('coupons')
          .select()
          .inFilter('id', couponIds)
          .eq('is_active', true);

      return (couponsResponse as List)
          .map((coupon) => CouponModel.fromJson(coupon))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch service coupons: $e');
    }
  }

  /// Validate a coupon code for a specific service and order amount
  Future<CouponModel?> validateCoupon({
    required String couponCode,
    required String serviceId,
    required double orderAmount,
  }) async {
    try {
      final couponCodeUpper = couponCode.toUpperCase();

      // First check if it's a service-specific coupon
      // Get service coupon IDs
      final serviceCouponsResponse = await _supabase
          .from('service_coupons')
          .select('coupon_id')
          .eq('service_id', serviceId);

      if (serviceCouponsResponse.isNotEmpty) {
        final couponIds = (serviceCouponsResponse as List)
            .map((item) => item['coupon_id'] as String?)
            .where((id) => id != null)
            .cast<String>()
            .toList();

        if (couponIds.isNotEmpty) {
          // Check if the coupon code exists in service-specific coupons
          final serviceSpecificResponse = await _supabase
              .from('coupons')
              .select()
              .inFilter('id', couponIds)
              .eq('code', couponCodeUpper)
              .eq('is_active', true)
              .maybeSingle();

          if (serviceSpecificResponse != null) {
            final coupon = CouponModel.fromJson(serviceSpecificResponse);
            if (coupon.isValid && 
                (coupon.minOrderAmount == null || orderAmount >= coupon.minOrderAmount!)) {
              return coupon;
            }
          }
        }
      }

      // If not found as service-specific, check public coupons
      final publicResponse = await _supabase
          .from('coupons')
          .select()
          .eq('code', couponCodeUpper)
          .eq('is_active', true)
          .eq('is_public', true)
          .maybeSingle();

      if (publicResponse != null) {
        final coupon = CouponModel.fromJson(publicResponse);
        if (coupon.isValid && 
            (coupon.minOrderAmount == null || orderAmount >= coupon.minOrderAmount!)) {
          return coupon;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Failed to validate coupon: $e');
    }
  }

  /// Get available coupons for a service (both service-specific and public)
  Future<List<CouponModel>> getAvailableCouponsForService({
    required String serviceId,
    required double orderAmount,
  }) async {
    try {
      final availableCoupons = <CouponModel>[];

      // Get service-specific coupons
      final serviceCoupons = await getServiceCoupons(serviceId);
      availableCoupons.addAll(serviceCoupons.where((coupon) => 
          coupon.isValid && 
          (coupon.minOrderAmount == null || orderAmount >= coupon.minOrderAmount!)
      ));

      // Get public coupons
      final publicCoupons = await getPublicCoupons();
      availableCoupons.addAll(publicCoupons.where((coupon) => 
          coupon.isValid && 
          (coupon.minOrderAmount == null || orderAmount >= coupon.minOrderAmount!) &&
          !availableCoupons.any((existing) => existing.id == coupon.id) // Avoid duplicates
      ));

      // Sort by discount value (highest first)
      availableCoupons.sort((a, b) {
        final discountA = a.calculateDiscount(orderAmount);
        final discountB = b.calculateDiscount(orderAmount);
        return discountB.compareTo(discountA);
      });

      return availableCoupons;
    } catch (e) {
      throw Exception('Failed to fetch available coupons: $e');
    }
  }
}