// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceListingModelImpl _$$ServiceListingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceListingModelImpl(
      id: json['id'] as String,
      name: json['title'] as String,
      image: json['cover_photo'] as String,
      description: json['description'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: (json['reviews_count'] as num?)?.toInt(),
      offersCount: (json['offers_count'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      isFeatured: json['is_featured'] as bool?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$$ServiceListingModelImplToJson(
        _$ServiceListingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.name,
      'cover_photo': instance.image,
      'description': instance.description,
      'rating': instance.rating,
      'reviews_count': instance.reviewsCount,
      'offers_count': instance.offersCount,
      'created_at': instance.createdAt?.toIso8601String(),
      'is_featured': instance.isFeatured,
      'is_active': instance.isActive,
    };
