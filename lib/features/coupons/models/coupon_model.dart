import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_model.freezed.dart';
part 'coupon_model.g.dart';

@freezed
class CouponModel with _$CouponModel {
  const factory CouponModel({
    required String id,
    required String code,
    String? description,
    @JsonKey(name: 'discount_type') required String discountType, // 'percentage' or 'fixed'
    @JsonKey(name: 'discount_value') required double discountValue,
    @JsonKey(name: 'max_discount_amount') double? maxDiscountAmount,
    @JsonKey(name: 'min_order_amount') double? minOrderAmount,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'is_public') required bool isPublic,
    @JsonKey(name: 'usage_limit') int? usageLimit,
    @JsonKey(name: 'used_count') int? usedCount,
    @JsonKey(name: 'valid_from') DateTime? validFrom,
    @JsonKey(name: 'valid_until') DateTime? validUntil,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CouponModel;

  factory CouponModel.fromJson(Map<String, dynamic> json) => 
      _$CouponModelFromJson(json);
}

extension CouponModelExtension on CouponModel {
  bool get isValid {
    if (!isActive) return false;
    
    final now = DateTime.now();
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validUntil != null && now.isAfter(validUntil!)) return false;
    
    if (usageLimit != null && usedCount != null) {
      if (usedCount! >= usageLimit!) return false;
    }
    
    return true;
  }

  String get displayDiscount {
    if (discountType == 'percentage') {
      return '${discountValue.toInt()}% OFF';
    } else {
      return '₹${discountValue.toInt()} OFF';
    }
  }

  String get minOrderText {
    if (minOrderAmount != null && minOrderAmount! > 0) {
      return 'Min order ₹${minOrderAmount!.toInt()}';
    }
    return 'No minimum order';
  }

  String get validityText {
    if (validUntil != null) {
      final now = DateTime.now();
      final difference = validUntil!.difference(now);
      
      if (difference.inDays > 0) {
        return 'Valid for ${difference.inDays} days';
      } else if (difference.inHours > 0) {
        return 'Valid for ${difference.inHours} hours';
      } else {
        return 'Expires soon';
      }
    }
    return 'No expiry';
  }

  double calculateDiscount(double orderAmount) {
    if (!isValid) return 0.0;
    if (minOrderAmount != null && orderAmount < minOrderAmount!) return 0.0;

    double discount = 0.0;
    if (discountType == 'percentage') {
      discount = orderAmount * (discountValue / 100);
      if (maxDiscountAmount != null) {
        discount = discount > maxDiscountAmount! ? maxDiscountAmount! : discount;
      }
    } else {
      discount = discountValue;
    }

    return discount;
  }
}