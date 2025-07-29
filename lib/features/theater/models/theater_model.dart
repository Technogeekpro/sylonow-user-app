import 'package:freezed_annotation/freezed_annotation.dart';

part 'theater_model.freezed.dart';
part 'theater_model.g.dart';

@freezed
class TheaterModel with _$TheaterModel {
  const factory TheaterModel({
    required String id,
    required String name,
    String? description,
    required String address,
    required String city,
    required String state,
    @JsonKey(name: 'pin_code') required String pinCode,
    double? latitude,
    double? longitude,
    required int capacity,
    required List<String> amenities,
    required List<String> images,
    @JsonKey(name: 'hourly_rate') required double hourlyRate,
    required double rating,
    @JsonKey(name: 'total_reviews') required int totalReviews,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'owner_id') String? ownerId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _TheaterModel;

  factory TheaterModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterModelFromJson(json);
}