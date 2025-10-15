// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_on_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddOnModelImpl _$$AddOnModelImplFromJson(Map<String, dynamic> json) =>
    _$AddOnModelImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      vendorId: json['vendor_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AddOnModelImplToJson(_$AddOnModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'image_url': instance.imageUrl,
      'is_active': instance.isActive,
      'vendor_id': instance.vendorId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
