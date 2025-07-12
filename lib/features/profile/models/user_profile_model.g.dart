// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      id: json['id'] as String,
      authUserId: json['auth_user_id'] as String,
      appType: json['app_type'] as String? ?? 'user',
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auth_user_id': instance.authUserId,
      'app_type': instance.appType,
      'full_name': instance.fullName,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'profile_image_url': instance.profileImageUrl,
      'bio': instance.bio,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postal_code': instance.postalCode,
      'emergency_contact_name': instance.emergencyContactName,
      'emergency_contact_phone': instance.emergencyContactPhone,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
