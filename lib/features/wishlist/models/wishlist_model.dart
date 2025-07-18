import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sylonow_user/features/home/models/service_listing_model.dart';

part 'wishlist_model.freezed.dart';
part 'wishlist_model.g.dart';

@freezed
class WishlistModel with _$WishlistModel {
  const factory WishlistModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'service_listings') ServiceListingModel? serviceListing,
  }) = _WishlistModel;

  factory WishlistModel.fromJson(Map<String, dynamic> json) => 
      _$WishlistModelFromJson(json);
}

@freezed
class WishlistWithService with _$WishlistWithService {
  const factory WishlistWithService({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required ServiceListingModel service,
  }) = _WishlistWithService;

  factory WishlistWithService.fromJson(Map<String, dynamic> json) => 
      _$WishlistWithServiceFromJson(json);
}