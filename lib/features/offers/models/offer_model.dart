import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer_model.freezed.dart';
part 'offer_model.g.dart';

@freezed
class OfferModel with _$OfferModel {
  const factory OfferModel({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required double discountPercentage,
    String? discountAmount,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    required String offerType, // 'percentage', 'fixed', 'bogo'
    String? categoryId,
    double? minOrderValue,
    int? maxUsageCount,
    int? usedCount,
    String? termsAndConditions,
    List<String>? applicableServices,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OfferModel;

  factory OfferModel.fromJson(Map<String, dynamic> json) => _$OfferModelFromJson(json);
}

enum OfferType {
  percentage,
  fixed,
  bogo, // Buy One Get One
}

extension OfferModelExtension on OfferModel {
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isUpcoming => DateTime.now().isBefore(startDate);
  bool get isValid => isActive && !isExpired && !isUpcoming;
  
  String get displayDiscount {
    if (offerType == 'percentage') {
      return '${discountPercentage.round()}% OFF';
    } else if (offerType == 'fixed' && discountAmount != null) {
      return '₹$discountAmount OFF';
    }
    return 'Special Offer';
  }
  
  String get validityText {
    if (isExpired) return 'Expired';
    if (isUpcoming) return 'Coming Soon';
    return 'Valid till ${endDate.day}/${endDate.month}/${endDate.year}';
  }
}