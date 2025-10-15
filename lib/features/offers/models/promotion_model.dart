import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

@freezed
class PromotionModel with _$PromotionModel {
  const factory PromotionModel({
    required String id,
    required String title,
    required String subtitle,
    required String description,
    required String imageUrl,
    required String bannerImageUrl,
    required double discountValue,
    required String discountType, // 'percentage', 'fixed'
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    required bool isFeatured,
    required String promotionType, // 'first_time', 'seasonal', 'category_specific'
    String? categoryId,
    double? minOrderValue,
    int? maxUsagePerUser,
    int? totalUsageLimit,
    int? currentUsageCount,
    String? promoCode,
    String? termsAndConditions,
    List<String>? targetUserTypes, // 'new', 'existing', 'premium'
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) => _$PromotionModelFromJson(json);
}

enum PromotionType {
  firstTime,
  seasonal,
  categorySpecific,
  flashSale,
  holiday,
  weekendSpecial,
}

extension PromotionModelExtension on PromotionModel {
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isUpcoming => DateTime.now().isBefore(startDate);
  bool get isValid => isActive && !isExpired && !isUpcoming;
  
  String get displayDiscount {
    if (discountType == 'percentage') {
      return '${discountValue.round()}% OFF';
    } else {
      return '₹${discountValue.round()} OFF';
    }
  }
  
  String get validityText {
    if (isExpired) return 'Expired';
    if (isUpcoming) return 'Starting ${startDate.day}/${startDate.month}';
    return 'Valid till ${endDate.day}/${endDate.month}/${endDate.year}';
  }
  
  bool get hasUsageLimit => totalUsageLimit != null && totalUsageLimit! > 0;
  bool get isUsageLimitReached => hasUsageLimit && (currentUsageCount ?? 0) >= totalUsageLimit!;
  
  double get usagePercentage {
    if (!hasUsageLimit) return 0.0;
    return ((currentUsageCount ?? 0) / totalUsageLimit!) * 100;
  }
}