// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_listing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceListingModelImpl _$$ServiceListingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceListingModelImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String?,
      name: json['title'] as String,
      image: json['cover_photo'] as String?,
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
      venueTypes: (json['venue_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      themeTags: (json['theme_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      addOns: (json['add_ons'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      setupTime: json['setup_time'] as String?,
      bookingNotice: json['booking_notice'] as String?,
      customizationAvailable: json['customization_available'] as bool?,
      customizationNote: json['customization_note'] as String?,
      serviceEnvironment: (json['service_environment'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      videoUrl: json['video_url'] as String?,
      decorationType: json['decoration_type'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ServiceListingModelImplToJson(
        _$ServiceListingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
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
      'venue_types': instance.venueTypes,
      'theme_tags': instance.themeTags,
      'add_ons': instance.addOns,
      'setup_time': instance.setupTime,
      'booking_notice': instance.bookingNotice,
      'customization_available': instance.customizationAvailable,
      'customization_note': instance.customizationNote,
      'service_environment': instance.serviceEnvironment,
      'video_url': instance.videoUrl,
      'decoration_type': instance.decorationType,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
