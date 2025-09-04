import '../models/onboarding_data_model.dart';

class OnboardingConstants {
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String onboardingDataKey = 'onboarding_data';
  
  static const List<OccasionOption> occasionOptions = [
    OccasionOption(
      id: 'birthday',
      label: 'Birthday',
      emoji: '🎂',
    ),
    OccasionOption(
      id: 'anniversary',
      label: 'Anniversary',
      emoji: '💕',
    ),
    OccasionOption(
      id: 'surprise',
      label: 'Surprise',
      emoji: '🎁',
    ),
    OccasionOption(
      id: 'other',
      label: 'Other',
      emoji: '✨',
    ),
  ];
}