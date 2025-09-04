import 'package:freezed_annotation/freezed_annotation.dart';

part 'decoration_model.freezed.dart';
part 'decoration_model.g.dart';

@freezed
class DecorationModel with _$DecorationModel {
  const factory DecorationModel({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    @JsonKey(name: 'vendor_id') String? vendorId,
    required String name,
    String? description,
    required double price,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _DecorationModel;

  factory DecorationModel.fromJson(Map<String, dynamic> json) =>
      _$DecorationModelFromJson(json);
}