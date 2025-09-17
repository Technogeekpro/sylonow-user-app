import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_data_model.freezed.dart';
part 'onboarding_data_model.g.dart';

@freezed
class OnboardingDataModel with _$OnboardingDataModel {
  const factory OnboardingDataModel({
    String? userName,
    String? selectedOccasion,
    String? selectedOccasionId,
    String? celebrationDate,
    String? celebrationTime,
    @Default(false) bool isCompleted,
  }) = _OnboardingDataModel;

  factory OnboardingDataModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingDataModelFromJson(json);
}

@freezed
class OccasionOption with _$OccasionOption {
  const factory OccasionOption({
    required String id,
    required String label,
    required String emoji,
  }) = _OccasionOption;

  factory OccasionOption.fromJson(Map<String, dynamic> json) =>
      _$OccasionOptionFromJson(json);
}