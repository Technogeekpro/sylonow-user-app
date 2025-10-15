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
      discountValue: (json['discount_value'] as num).toDouble(),
      discountType: json['discount_type'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      isActive: json['is_active'] as bool,
      isPublic: json['is_public'] as bool,
      userId: json['user_id'] as String?,
      categoryId: json['category_id'] as String?,
      minOrderValue: (json['min_order_value'] as num?)?.toDouble(),
      maxDiscountAmount: (json['max_discount_amount'] as num?)?.toDouble(),
      maxUsagePerUser: (json['max_usage_per_user'] as num?)?.toInt(),
      totalUsageLimit: (json['total_usage_limit'] as num?)?.toInt(),
      currentUsageCount: (json['current_usage_count'] as num?)?.toInt(),
      applicableServices: (json['applicable_services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      excludedServices: (json['excluded_services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      termsAndConditions: json['terms_and_conditions'] as String?,
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
      'discount_value': instance.discountValue,
      'discount_type': instance.discountType,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'is_active': instance.isActive,
      'is_public': instance.isPublic,
      'user_id': instance.userId,
      'category_id': instance.categoryId,
      'min_order_value': instance.minOrderValue,
      'max_discount_amount': instance.maxDiscountAmount,
      'max_usage_per_user': instance.maxUsagePerUser,
      'total_usage_limit': instance.totalUsageLimit,
      'current_usage_count': instance.currentUsageCount,
      'applicable_services': instance.applicableServices,
      'excluded_services': instance.excludedServices,
      'terms_and_conditions': instance.termsAndConditions,
      'metadata': instance.metadata,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
