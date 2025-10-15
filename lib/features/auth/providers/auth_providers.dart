import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_service.dart';
import '../services/account_deletion_service.dart';

// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Auth State Stream Provider - listens to Supabase auth state changes
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthService(supabase);
});

// Account Deletion Service Provider
final accountDeletionServiceProvider = Provider<AccountDeletionService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AccountDeletionService(supabase);
});

// Auth Controller Provider
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService);
});

// Is Authenticated Provider - now watches auth state stream
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  // Watch the auth state stream to invalidate when auth changes
  ref.watch(authStateStreamProvider);

  final authService = ref.watch(authServiceProvider);
  return authService.isAuthenticated();
});

// Current User Provider - now watches auth state stream
final currentUserProvider = Provider<User?>((ref) {
  // Watch the auth state stream to update when auth changes
  ref.watch(authStateStreamProvider);

  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUser();
});

// Is Onboarding Completed Provider - now watches auth state stream
final isOnboardingCompletedProvider = FutureProvider<bool>((ref) async {
  // Watch the auth state stream to invalidate when auth changes
  ref.watch(authStateStreamProvider);

  final authService = ref.watch(authServiceProvider);
  return authService.isOnboardingCompleted();
}); 