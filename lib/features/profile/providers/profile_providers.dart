import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import '../../../core/providers/core_providers.dart';
import '../models/user_profile_model.dart';
import '../repositories/profile_repository.dart';
import '../services/profile_service.dart';
import '../controllers/profile_controller.dart';

// Profile Repository Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return ProfileRepository(supabaseClient);
});

// Profile Service Provider
final profileServiceProvider = Provider<ProfileService>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ProfileService(profileRepository);
});

// Profile Controller Provider
final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<UserProfileModel?>>((ref) {
  final profileService = ref.watch(profileServiceProvider);
  return ProfileController(profileService);
});

// Current User Profile Provider
final currentUserProfileProvider = FutureProvider<UserProfileModel?>((ref) async {
  final profileService = ref.watch(profileServiceProvider);
  return profileService.getCurrentUserProfile();
});

// Profile Completeness Provider
final profileCompletenessProvider = Provider<double>((ref) {
  final profileAsyncValue = ref.watch(currentUserProfileProvider);
  
  return profileAsyncValue.when(
    data: (profile) {
      if (profile == null) return 0.0;
      final profileService = ref.read(profileServiceProvider);
      return profileService.getProfileCompleteness(profile);
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});