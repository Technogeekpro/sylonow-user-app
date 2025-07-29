// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CouponModelImpl _$$CouponModelImplFromJson(Map<String, dynamic> json) =>
    _$CouponModelImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      discountType: json['discountType'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      isPublic: json['isPublic'] as bool,
      userId: json['userId'] as String?,
      categoryId: json['categoryId'] as String?,
      minOrderValue: (json['minOrderValue'] as num?)?.toDouble(),
      maxDiscountAmount: (json['maxDiscountAmount'] as num?)?.toDouble(),
      maxUsagePerUser: (json['maxUsagePerUser'] as num?)?.toInt(),
      totalUsageLimit: (json['totalUsageLimit'] as num?)?.toInt(),
      currentUsageCount: (json['currentUsageCount'] as num?)?.toInt(),
      applicableServices: (json['applicableServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      excludedServices: (json['excludedServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      termsAndConditions: json['termsAndConditions'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CouponModelImplToJson(_$CouponModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'title': instance.title,
      'description': instance.description,
      'discountValue': instance.discountValue,
      'discountType': instance.discountType,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isActive': instance.isActive,
      'isPublic': instance.isPublic,
      'userId': instance.userId,
      'categoryId': instance.categoryId,
      'minOrderValue': instance.minOrderValue,
      'maxDiscountAmount': instance.maxDiscountAmount,
      'maxUsagePerUser': instance.maxUsagePerUser,
      'totalUsageLimit': instance.totalUsageLimit,
      'currentUsageCount': instance.currentUsageCount,
      'applicableServices': instance.applicableServices,
      'excludedServices': instance.excludedServices,
      'termsAndConditions': instance.termsAndConditions,
      'metadata': instance.metadata,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
