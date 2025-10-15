// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cake_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CakeModelImpl _$$CakeModelImplFromJson(Map<String, dynamic> json) =>
    _$CakeModelImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      price: (json['price'] as num).toDouble(),
      size: json['size'] as String?,
      flavor: json['flavor'] as String?,
      isAvailable: json['is_available'] as bool,
      preparationTimeMinutes:
          (json['preparation_time_minutes'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CakeModelImplToJson(_$CakeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'price': instance.price,
      'size': instance.size,
      'flavor': instance.flavor,
      'is_available': instance.isAvailable,
      'preparation_time_minutes': instance.preparationTimeMinutes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
