// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_theater_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrivateTheaterModelImpl _$$PrivateTheaterModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivateTheaterModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      pinCode: json['pin_code'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      capacity: (json['capacity'] as num).toInt(),
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      totalReviews: (json['total_reviews'] as num).toInt(),
      isActive: json['is_active'] as bool,
      ownerId: json['owner_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PrivateTheaterModelImplToJson(
        _$PrivateTheaterModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'pin_code': instance.pinCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'capacity': instance.capacity,
      'amenities': instance.amenities,
      'images': instance.images,
      'hourly_rate': instance.hourlyRate,
      'rating': instance.rating,
      'total_reviews': instance.totalReviews,
      'is_active': instance.isActive,
      'owner_id': instance.ownerId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
