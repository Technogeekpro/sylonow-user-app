// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cake_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CakeModelImpl _$$CakeModelImplFromJson(Map<String, dynamic> json) =>
    _$CakeModelImpl(
      id: json['id'] as String,
      theaterId: json['theaterId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num).toDouble(),
      size: json['size'] as String?,
      flavor: json['flavor'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      preparationTimeMinutes:
          (json['preparationTimeMinutes'] as num?)?.toInt() ?? 60,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CakeModelImplToJson(_$CakeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theaterId': instance.theaterId,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'size': instance.size,
      'flavor': instance.flavor,
      'isAvailable': instance.isAvailable,
      'preparationTimeMinutes': instance.preparationTimeMinutes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
