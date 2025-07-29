import 'package:freezed_annotation/freezed_annotation.dart';

part 'cake_model.freezed.dart';
part 'cake_model.g.dart';

@freezed
class CakeModel with _$CakeModel {
  const factory CakeModel({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    required String name,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    required double price,
    String? size,
    String? flavor,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'preparation_time_minutes') int? preparationTimeMinutes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _CakeModel;

  factory CakeModel.fromJson(Map<String, dynamic> json) =>
      _$CakeModelFromJson(json);
}