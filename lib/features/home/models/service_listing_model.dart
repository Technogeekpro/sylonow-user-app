import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sylonow_user/features/home/models/vendor_model.dart';

part 'service_listing_model.freezed.dart';
part 'service_listing_model.g.dart';

@freezed
class ServiceListingModel with _$ServiceListingModel {
  const factory ServiceListingModel({
    required String id,
    @JsonKey(name: 'vendor_id') required String? vendorId,
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
    List<String>? photos, // Array of service images
    String? category, // Service category for finding related services
    // Enhanced booking fields from database
    @JsonKey(name: 'venue_types') List<String>? venueTypes,
    @JsonKey(name: 'theme_tags') List<String>? themeTags,
    @JsonKey(name: 'add_ons') List<Map<String, dynamic>>? addOns,
    @JsonKey(name: 'setup_time') String? setupTime,
    @JsonKey(name: 'booking_notice') String? bookingNotice,
    @JsonKey(name: 'customization_available') bool? customizationAvailable,
    @JsonKey(name: 'customization_note') String? customizationNote,
    @JsonKey(name: 'service_environment') List<String>? serviceEnvironment,
    @JsonKey(name: 'video_url') String? videoUrl,
  }) = _ServiceListingModel;

  factory ServiceListingModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'vendor' and 'vendors' fields
    if (json.containsKey('vendors') && json['vendors'] != null && !json.containsKey('vendor')) {
      json['vendor'] = json['vendors'];
    }
    return _$ServiceListingModelFromJson(json);
  }
} 