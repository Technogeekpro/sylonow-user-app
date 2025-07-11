import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sylonow_user/features/home/models/vendor_model.dart';

part 'service_listing_model.freezed.dart';
part 'service_listing_model.g.dart';

@freezed
class ServiceListingModel with _$ServiceListingModel {
  const factory ServiceListingModel({
    required String id,
    @JsonKey(name: 'title') required String name,
    @JsonKey(name: 'cover_photo') required String image,
    String? description,
    double? rating,
    @JsonKey(name: 'reviews_count') int? reviewsCount,
    @JsonKey(name: 'offers_count') int? offersCount,
    VendorModel? vendor,
    @JsonKey(name: 'promotional_tag') String? promotionalTag,
    List<String>? inclusions,
    @JsonKey(name: 'original_price') double? originalPrice,
    @JsonKey(name: 'offer_price') double? offerPrice,
    @JsonKey(name: 'is_featured') bool? isFeatured,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _ServiceListingModel;

  factory ServiceListingModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceListingModelFromJson(json);
} 