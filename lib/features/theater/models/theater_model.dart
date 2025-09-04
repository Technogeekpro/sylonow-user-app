import 'package:freezed_annotation/freezed_annotation.dart';

part 'theater_model.freezed.dart';
part 'theater_model.g.dart';

@freezed
class TheaterModel with _$TheaterModel {
  const factory TheaterModel({
    String? id,
    String? name,
    String? description,
    String? address,
    String? city,
    String? state,
    @JsonKey(name: 'pin_code') String? pinCode,
    double? latitude,
    double? longitude,
    int? capacity,
    int? screens,
    List<String>? amenities,
    List<String>? images,
    @JsonKey(name: 'hourly_rate') double? hourlyRate,
    double? rating,
    @JsonKey(name: 'total_reviews') int? totalReviews,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'owner_id') String? ownerId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _TheaterModel;

  factory TheaterModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterModelFromJson(json);
}