import 'package:freezed_annotation/freezed_annotation.dart';

part 'occasion_model.freezed.dart';
part 'occasion_model.g.dart';

@freezed
class OccasionModel with _$OccasionModel {
  const factory OccasionModel({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'color_code') String? colorCode,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OccasionModel;

  factory OccasionModel.fromJson(Map<String, dynamic> json) =>
      _$OccasionModelFromJson(json);
}