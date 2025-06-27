// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteModelImpl _$$QuoteModelImplFromJson(Map<String, dynamic> json) =>
    _$QuoteModelImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String?,
      category: json['category'] as String?,
      backgroundUrl: json['backgroundUrl'] as String?,
      textColor: json['textColor'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$QuoteModelImplToJson(_$QuoteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'author': instance.author,
      'category': instance.category,
      'backgroundUrl': instance.backgroundUrl,
      'textColor': instance.textColor,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
