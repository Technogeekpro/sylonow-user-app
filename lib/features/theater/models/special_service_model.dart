import 'package:freezed_annotation/freezed_annotation.dart';

part 'special_service_model.freezed.dart';
part 'special_service_model.g.dart';

@freezed
class SpecialServiceModel with _$SpecialServiceModel {
  const factory SpecialServiceModel({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    required double price,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SpecialServiceModel;

  factory SpecialServiceModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialServiceModelFromJson(json);
}