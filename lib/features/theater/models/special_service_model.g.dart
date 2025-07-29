// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpecialServiceModelImpl _$$SpecialServiceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SpecialServiceModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SpecialServiceModelImplToJson(
        _$SpecialServiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'price': instance.price,
      'duration_minutes': instance.durationMinutes,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
