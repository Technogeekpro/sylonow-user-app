import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/coupon_model.dart';
import '../repositories/coupon_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return CouponRepository(supabase);
});

/// Provider for getting service-specific coupons
final serviceCouponsProvider = FutureProvider.family<List<CouponModel>, ServiceCouponParams>((ref, params) async {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.getAvailableCouponsForService(
    serviceId: params.serviceId,
    orderAmount: params.orderAmount,
  );
});

/// Provider for validating a coupon
final couponValidationProvider = FutureProvider.family<CouponModel?, CouponValidationParams>((ref, params) async {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.validateCoupon(
    couponCode: params.couponCode,
    serviceId: params.serviceId,
    orderAmount: params.orderAmount,
  );
});

/// Provider for getting all public coupons
final publicCouponsProvider = FutureProvider<List<CouponModel>>((ref) async {
  final repository = ref.watch(couponRepositoryProvider);
  return repository.getPublicCoupons();
});

class ServiceCouponParams {
  final String serviceId;
  final double orderAmount;

  ServiceCouponParams({
    required this.serviceId,
    required this.orderAmount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceCouponParams &&
        other.serviceId == serviceId &&
        other.orderAmount == orderAmount;
  }

  @override
  int get hashCode => serviceId.hashCode ^ orderAmount.hashCode;
}

class CouponValidationParams {
  final String couponCode;
  final String serviceId;
  final double orderAmount;

  CouponValidationParams({
    required this.couponCode,
    required this.serviceId,
    required this.orderAmount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CouponValidationParams &&
        other.couponCode == couponCode &&
        other.serviceId == serviceId &&
        other.orderAmount == orderAmount;
  }

  @override
  int get hashCode => couponCode.hashCode ^ serviceId.hashCode ^ orderAmount.hashCode;
}