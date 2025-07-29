// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occasion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OccasionModelImpl _$$OccasionModelImplFromJson(Map<String, dynamic> json) =>
    _$OccasionModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      colorCode: json['color_code'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$OccasionModelImplToJson(_$OccasionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'color_code': instance.colorCode,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
    };
