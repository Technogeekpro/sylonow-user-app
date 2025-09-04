// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingDataModelImpl _$$OnboardingDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingDataModelImpl(
      userName: json['userName'] as String?,
      selectedOccasion: json['selectedOccasion'] as String?,
      celebrationDate: json['celebrationDate'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$OnboardingDataModelImplToJson(
        _$OnboardingDataModelImpl instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'selectedOccasion': instance.selectedOccasion,
      'celebrationDate': instance.celebrationDate,
      'isCompleted': instance.isCompleted,
    };

_$OccasionOptionImpl _$$OccasionOptionImplFromJson(Map<String, dynamic> json) =>
    _$OccasionOptionImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      emoji: json['emoji'] as String,
    );

Map<String, dynamic> _$$OccasionOptionImplToJson(
        _$OccasionOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'emoji': instance.emoji,
    };
