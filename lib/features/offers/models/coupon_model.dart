import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_model.freezed.dart';
part 'coupon_model.g.dart';

@freezed
class CouponModel with _$CouponModel {
  const factory CouponModel({
    required String id,
    required String code,
    required String title,
    required String description,
    required double discountValue,
    required String discountType, // 'percentage', 'fixed'
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    required bool isPublic, // true for public coupons, false for user-specific
    String? userId, // for user-specific coupons
    String? categoryId,
    double? minOrderValue,
    double? maxDiscountAmount,
    int? maxUsagePerUser,
    int? totalUsageLimit,
    int? currentUsageCount,
    List<String>? applicableServices,
    List<String>? excludedServices,
    String? termsAndConditions,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CouponModel;

  factory CouponModel.fromJson(Map<String, dynamic> json) => _$CouponModelFromJson(json);
}

enum CouponStatus {
  active,
  expired,
  upcoming,
  exhausted,
  disabled,
}

extension CouponModelExtension on CouponModel {
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isUpcoming => DateTime.now().isBefore(startDate);
  bool get isUsageLimitReached => totalUsageLimit != null && (currentUsageCount ?? 0) >= totalUsageLimit!;
  bool get isValid => isActive && !isExpired && !isUpcoming && !isUsageLimitReached;
  
  CouponStatus get status {
    if (!isActive) return CouponStatus.disabled;
    if (isExpired) return CouponStatus.expired;
    if (isUpcoming) return CouponStatus.upcoming;
    if (isUsageLimitReached) return CouponStatus.exhausted;
    return CouponStatus.active;
  }
  
  String get displayDiscount {
    if (discountType == 'percentage') {
      String percentageText = '${discountValue.round()}% OFF';
      if (maxDiscountAmount != null) {
        percentageText += ' (up to ₹${maxDiscountAmount!.round()})';
      }
      return percentageText;
    } else {
      return '₹${discountValue.round()} OFF';
    }
  }
  
  String get validityText {
    switch (status) {
      case CouponStatus.expired:
        return 'Expired on ${endDate.day}/${endDate.month}/${endDate.year}';
      case CouponStatus.upcoming:
        return 'Valid from ${startDate.day}/${startDate.month}/${startDate.year}';
      case CouponStatus.exhausted:
        return 'Usage limit reached';
      case CouponStatus.disabled:
        return 'Currently disabled';
      case CouponStatus.active:
        return 'Valid till ${endDate.day}/${endDate.month}/${endDate.year}';
    }
  }
  
  String get minOrderText {
    if (minOrderValue != null && minOrderValue! > 0) {
      return 'Min order ₹${minOrderValue!.round()}';
    }
    return 'No minimum order';
  }
  
  double calculateDiscount(double orderValue) {
    if (!isValid || orderValue < (minOrderValue ?? 0)) {
      return 0.0;
    }
    
    double discount = 0.0;
    if (discountType == 'percentage') {
      discount = (orderValue * discountValue) / 100;
      if (maxDiscountAmount != null) {
        discount = discount > maxDiscountAmount! ? maxDiscountAmount! : discount;
      }
    } else {
      discount = discountValue;
    }
    
    return discount > orderValue ? orderValue : discount;
  }
}