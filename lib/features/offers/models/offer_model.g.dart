// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferModelImpl _$$OfferModelImplFromJson(Map<String, dynamic> json) =>
    _$OfferModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      discountAmount: json['discountAmount'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      offerType: json['offerType'] as String,
      categoryId: json['categoryId'] as String?,
      minOrderValue: (json['minOrderValue'] as num?)?.toDouble(),
      maxUsageCount: (json['maxUsageCount'] as num?)?.toInt(),
      usedCount: (json['usedCount'] as num?)?.toInt(),
      termsAndConditions: json['termsAndConditions'] as String?,
      applicableServices: (json['applicableServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$OfferModelImplToJson(_$OfferModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'discountPercentage': instance.discountPercentage,
      'discountAmount': instance.discountAmount,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isActive': instance.isActive,
      'offerType': instance.offerType,
      'categoryId': instance.categoryId,
      'minOrderValue': instance.minOrderValue,
      'maxUsageCount': instance.maxUsageCount,
      'usedCount': instance.usedCount,
      'termsAndConditions': instance.termsAndConditions,
      'applicableServices': instance.applicableServices,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
