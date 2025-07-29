import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_on_model.freezed.dart';
part 'add_on_model.g.dart';

@freezed
class AddOnModel with _$AddOnModel {
  const factory AddOnModel({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    required String name,
    String? description,
    required double price,
    required String category, // "extra_special", "gifts", "special_services", "cakes"
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AddOnModel;

  factory AddOnModel.fromJson(Map<String, dynamic> json) =>
      _$AddOnModelFromJson(json);
}