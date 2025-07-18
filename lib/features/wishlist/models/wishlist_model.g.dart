// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistModelImpl _$$WishlistModelImplFromJson(Map<String, dynamic> json) =>
    _$WishlistModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      serviceListing: json['service_listings'] == null
          ? null
          : ServiceListingModel.fromJson(
              json['service_listings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WishlistModelImplToJson(_$WishlistModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'service_id': instance.serviceId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'service_listings': instance.serviceListing,
    };

_$WishlistWithServiceImpl _$$WishlistWithServiceImplFromJson(
        Map<String, dynamic> json) =>
    _$WishlistWithServiceImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      service:
          ServiceListingModel.fromJson(json['service'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WishlistWithServiceImplToJson(
        _$WishlistWithServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'service_id': instance.serviceId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'service': instance.service,
    };
