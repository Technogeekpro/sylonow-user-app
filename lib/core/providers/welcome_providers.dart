import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../services/welcome_preferences_service.dart';

/// Provider for the welcome preferences service
final welcomePreferencesServiceProvider = Provider<WelcomePreferencesService>((ref) {
  return WelcomePreferencesService();
});

/// Provider to check if welcome overlay has been shown
final hasShownWelcomeProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(welcomePreferencesServiceProvider);
  return service.hasShownWelcome();
});

/// Provider for celebration date
final celebrationDateProvider = FutureProvider<DateTime?>((ref) async {
  final service = ref.read(welcomePreferencesServiceProvider);
  return service.getCelebrationDate();
});

/// Provider for celebration time
final celebrationTimeProvider = FutureProvider<TimeOfDay?>((ref) async {
  final service = ref.read(welcomePreferencesServiceProvider);
  return service.getCelebrationTime();
});

/// Provider for formatted celebration date
final formattedCelebrationDateProvider = FutureProvider<String?>((ref) async {
  final service = ref.read(welcomePreferencesServiceProvider);
  return service.getFormattedCelebrationDate();
});

/// Provider for formatted celebration time
final formattedCelebrationTimeProvider = FutureProvider<String?>((ref) async {
  final service = ref.read(welcomePreferencesServiceProvider);
  return service.getFormattedCelebrationTime();
});

/// Provider to check if celebration preferences are set
final hasCelebrationPreferencesProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(welcomePreferencesServiceProvider);
  return service.hasCelebrationPreferences();
});

/// Provider for celebration preferences summary
final celebrationPreferencesSummaryProvider = FutureProvider<Map<String, String?>>((ref) async {
  final service = ref.read(welcomePreferencesServiceProvider);
  return service.getCelebrationPreferencesSummary();
});

/// Provider for welcome completion date
final welcomeCompletionDateProvider = FutureProvider<DateTime?>((ref) async {
  final service = ref.read(welcomePreferencesServiceProvider);
  return service.getWelcomeCompletionDate();
});

/// State provider for managing welcome overlay visibility
final showWelcomeOverlayProvider = StateProvider<bool>((ref) => false);