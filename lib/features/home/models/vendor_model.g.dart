// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorModelImpl _$$VendorModelImplFromJson(Map<String, dynamic> json) =>
    _$VendorModelImpl(
      id: json['id'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      businessName: json['business_name'] as String?,
      businessType: json['business_type'] as String?,
      experienceYears: (json['experience_years'] as num?)?.toInt() ?? 0,
      location: json['location'] as Map<String, dynamic>?,
      profileImageUrl: json['profile_image_url'] as String?,
      portfolioImages: (json['portfolio_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bio: json['bio'] as String?,
      availabilitySchedule:
          json['availability_schedule'] as Map<String, dynamic>?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      totalJobsCompleted: (json['total_jobs_completed'] as num?)?.toInt() ?? 0,
      verificationStatus: json['verification_status'] as String? ?? 'pending',
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      fcmToken: json['fcm_token'] as String?,
      startTime: json['start_time'] as String?,
      closeTime: json['close_time'] as String?,
      advanceBookingHours:
          (json['advance_booking_hours'] as num?)?.toInt() ?? 2,
      isOnline: json['is_online'] as bool? ?? false,
      lastOnlineAt: json['last_online_at'] == null
          ? null
          : DateTime.parse(json['last_online_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$VendorModelImplToJson(_$VendorModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'full_name': instance.fullName,
      'business_name': instance.businessName,
      'business_type': instance.businessType,
      'experience_years': instance.experienceYears,
      'location': instance.location,
      'profile_image_url': instance.profileImageUrl,
      'portfolio_images': instance.portfolioImages,
      'bio': instance.bio,
      'availability_schedule': instance.availabilitySchedule,
      'rating': instance.rating,
      'total_reviews': instance.totalReviews,
      'total_jobs_completed': instance.totalJobsCompleted,
      'verification_status': instance.verificationStatus,
      'is_active': instance.isActive,
      'is_verified': instance.isVerified,
      'fcm_token': instance.fcmToken,
      'start_time': instance.startTime,
      'close_time': instance.closeTime,
      'advance_booking_hours': instance.advanceBookingHours,
      'is_online': instance.isOnline,
      'last_online_at': instance.lastOnlineAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
