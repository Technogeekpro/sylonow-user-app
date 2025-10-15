// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromotionModelImpl _$$PromotionModelImplFromJson(Map<String, dynamic> json) =>
    _$PromotionModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      bannerImageUrl: json['bannerImageUrl'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      discountType: json['discountType'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      isFeatured: json['isFeatured'] as bool,
      promotionType: json['promotionType'] as String,
      categoryId: json['categoryId'] as String?,
      minOrderValue: (json['minOrderValue'] as num?)?.toDouble(),
      maxUsagePerUser: (json['maxUsagePerUser'] as num?)?.toInt(),
      totalUsageLimit: (json['totalUsageLimit'] as num?)?.toInt(),
      currentUsageCount: (json['currentUsageCount'] as num?)?.toInt(),
      promoCode: json['promoCode'] as String?,
      termsAndConditions: json['termsAndConditions'] as String?,
      targetUserTypes: (json['targetUserTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PromotionModelImplToJson(
        _$PromotionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'bannerImageUrl': instance.bannerImageUrl,
      'discountValue': instance.discountValue,
      'discountType': instance.discountType,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'promotionType': instance.promotionType,
      'categoryId': instance.categoryId,
      'minOrderValue': instance.minOrderValue,
      'maxUsagePerUser': instance.maxUsagePerUser,
      'totalUsageLimit': instance.totalUsageLimit,
      'currentUsageCount': instance.currentUsageCount,
      'promoCode': instance.promoCode,
      'termsAndConditions': instance.termsAndConditions,
      'targetUserTypes': instance.targetUserTypes,
      'metadata': instance.metadata,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
