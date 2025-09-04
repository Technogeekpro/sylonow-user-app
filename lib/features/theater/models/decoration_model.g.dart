// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decoration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DecorationModelImpl _$$DecorationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DecorationModelImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      vendorId: json['vendor_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      isAvailable: json['is_available'] as bool,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$DecorationModelImplToJson(
        _$DecorationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'vendor_id': instance.vendorId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image_url': instance.imageUrl,
      'is_available': instance.isAvailable,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
