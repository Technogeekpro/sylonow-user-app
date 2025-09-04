import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data_model.dart';

class OnboardingService {
  static const String _onboardingDataKey = OnboardingConstants.onboardingDataKey;
  static const String _onboardingCompletedKey = OnboardingConstants.onboardingCompletedKey;

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  Future<OnboardingDataModel> getOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_onboardingDataKey);
    
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return OnboardingDataModel.fromJson(jsonMap);
    }
    
    return const OnboardingDataModel();
  }

  Future<void> saveOnboardingData(OnboardingDataModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_onboardingDataKey, jsonString);
  }

  Future<void> updateUserName(String userName) async {
    final currentData = await getOnboardingData();
    final updatedData = currentData.copyWith(userName: userName);
    await saveOnboardingData(updatedData);
  }

  Future<void> updateOccasion(String occasion) async {
    final currentData = await getOnboardingData();
    final updatedData = currentData.copyWith(selectedOccasion: occasion);
    await saveOnboardingData(updatedData);
  }

  Future<void> updateCelebrationDate(String date) async {
    final currentData = await getOnboardingData();
    final updatedData = currentData.copyWith(celebrationDate: date);
    await saveOnboardingData(updatedData);
  }

  Future<void> completeOnboarding() async {
    final currentData = await getOnboardingData();
    final completedData = currentData.copyWith(isCompleted: true);
    await saveOnboardingData(completedData);
    await setOnboardingCompleted(true);
  }

  Future<void> clearOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingDataKey);
    await prefs.remove(_onboardingCompletedKey);
  }
}