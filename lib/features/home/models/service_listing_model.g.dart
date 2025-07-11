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
      vendor: json['vendor'] == null
          ? null
          : VendorModel.fromJson(json['vendor'] as Map<String, dynamic>),
      promotionalTag: json['promotional_tag'] as String?,
      inclusions: (json['inclusions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      offerPrice: (json['offer_price'] as num?)?.toDouble(),
      isFeatured: json['is_featured'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      isActive: json['is_active'] as bool?,
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      category: json['category'] as String?,
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
      'vendor': instance.vendor,
      'promotional_tag': instance.promotionalTag,
      'inclusions': instance.inclusions,
      'original_price': instance.originalPrice,
      'offer_price': instance.offerPrice,
      'is_featured': instance.isFeatured,
      'created_at': instance.createdAt?.toIso8601String(),
      'is_active': instance.isActive,
      'photos': instance.photos,
      'category': instance.category,
    };
