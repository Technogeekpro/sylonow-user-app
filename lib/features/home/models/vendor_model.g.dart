// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorModelImpl _$$VendorModelImplFromJson(Map<String, dynamic> json) =>
    _$VendorModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['fullName'] as String?,
      businessName: json['businessName'] as String?,
      businessType: json['businessType'] as String?,
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
      location: json['location'] as Map<String, dynamic>?,
      profileImageUrl: json['profileImageUrl'] as String?,
      portfolioImages: (json['portfolioImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bio: json['bio'] as String?,
      availabilitySchedule:
          json['availabilitySchedule'] as Map<String, dynamic>?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      totalJobsCompleted: (json['totalJobsCompleted'] as num?)?.toInt() ?? 0,
      verificationStatus: json['verificationStatus'] as String? ?? 'pending',
      isActive: json['isActive'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      fcmToken: json['fcmToken'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VendorModelImplToJson(_$VendorModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'fullName': instance.fullName,
      'businessName': instance.businessName,
      'businessType': instance.businessType,
      'experienceYears': instance.experienceYears,
      'location': instance.location,
      'profileImageUrl': instance.profileImageUrl,
      'portfolioImages': instance.portfolioImages,
      'bio': instance.bio,
      'availabilitySchedule': instance.availabilitySchedule,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
      'totalJobsCompleted': instance.totalJobsCompleted,
      'verificationStatus': instance.verificationStatus,
      'isActive': instance.isActive,
      'isVerified': instance.isVerified,
      'fcmToken': instance.fcmToken,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
