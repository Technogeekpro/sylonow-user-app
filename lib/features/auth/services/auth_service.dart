import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../../core/constants/app_constants.dart';

class AuthService {
  final SupabaseClient _supabaseClient;
  late final GoogleSignIn _googleSignIn;
  
  AuthService(this._supabaseClient) {
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      // This is the WEB Client ID, which is correct for Supabase integration
      serverClientId: '828054656956-9lb66n0bjgeoo7ta808ank5acj09uno7.apps.googleusercontent.com',
    );
  }
  
  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );
      return response;
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }
  
  // Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.isLoggedInKey, true);
        await prefs.setString(AppConstants.userEmailKey, email);
        await prefs.setString(AppConstants.userIdKey, response.user!.id);
      }
      
      return response;
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Supabase
      await _supabaseClient.auth.signOut();
      
      // Sign out from Google if applicable
      await signOutFromGoogle();
      
      // Clear all local data
      await _clearAllLocalData();
      
      debugPrint('Successfully signed out');
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }
  
  // Clear all local data including SharedPreferences and cache
  Future<void> _clearAllLocalData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear authentication related data
      await prefs.setBool(AppConstants.isLoggedInKey, false);
      await prefs.remove(AppConstants.userEmailKey);
      await prefs.remove(AppConstants.userIdKey);
      await prefs.remove(AppConstants.userPhoneKey);
      
      // Clear all app-specific data
      final keys = prefs.getKeys();
      for (String key in keys) {
        if (key.startsWith('sylonow_') || 
            key.startsWith('user_') || 
            key.startsWith('profile_') ||
            key.startsWith('address_') ||
            key.startsWith('booking_') ||
            key.startsWith('notification_')) {
          await prefs.remove(key);
        }
      }
      
      // Clear cached images
      await _clearImageCache();
      
      debugPrint('All local data cleared');
    } catch (e) {
      debugPrint('Error clearing local data: $e');
      rethrow;
    }
  }
  
  // Clear cached images
  Future<void> _clearImageCache() async {
    try {
      // Clear cached network images
      await CachedNetworkImage.evictFromCache('');
      await DefaultCacheManager().emptyCache();
      debugPrint('Image cache cleared');
    } catch (e) {
      debugPrint('Error clearing image cache: $e');
      // Don't rethrow here as this is not critical
    }
  }
  
  // Send OTP to phone number
  Future<void> sendOtpToPhone(String phoneNumber) async {
    try {
      await _supabaseClient.auth.signInWithOtp(
        phone: phoneNumber,
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userPhoneKey, phoneNumber);
    } catch (e) {
      debugPrint('Send OTP error: $e');
      rethrow;
    }
  }
  
  // Verify phone OTP
  Future<AuthResponse> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _supabaseClient.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );
      
      if (response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.isLoggedInKey, true);
        await prefs.setString(AppConstants.userPhoneKey, phoneNumber);
        await prefs.setString(AppConstants.userIdKey, response.user!.id);
      }
      
      return response;
    } catch (e) {
      debugPrint('Verify OTP error: $e');
      rethrow;
    }
  }
  
  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(AppConstants.isLoggedInKey) ?? false;
    } catch (e) {
      debugPrint('Authentication check error: $e');
      return false;
    }
  }
  
  // Get current user
  User? getCurrentUser() {
    return _supabaseClient.auth.currentUser;
  }
  
  /// Initiates the Google Sign-In process and authenticates with Supabase.
  /// Returns the AuthResponse from Supabase if successful, otherwise null.
  /// Now includes app type to differentiate between vendor and customer apps.
  Future<AuthResponse?> signInWithGoogle({String appType = 'customer'}) async {
    try {
      // 1. Trigger the Google Authentication flow.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // If the user cancelled the sign-in, return null.
      if (googleUser == null) {
        debugPrint('🔵 Google Sign-In was cancelled by the user.');
        return null;
      }

      // 2. Obtain the authentication details from the request.
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Throw an error if the ID token is missing.
      if (googleAuth.idToken == null) {
        throw 'Failed to get ID token from Google.';
      }

      // 3. Use the ID token to sign in to Supabase.
      final authResponse = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      // 🔴 NEW: Create user profile with app type after successful Google sign-in
      if (authResponse.user != null) {
        await _createUserProfile(authResponse.user!.id, appType);
        
        // Update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.isLoggedInKey, true);
        await prefs.setString(AppConstants.userEmailKey, authResponse.user!.email ?? '');
        await prefs.setString(AppConstants.userIdKey, authResponse.user!.id);
      }

      return authResponse;
    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }

  // Sign out from Google
  Future<void> signOutFromGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google sign out error: $e');
    }
  }

  // 🔴 NEW: Helper method to create user profile with app type
  Future<void> _createUserProfile(String userId, String appType) async {
    try {
      await _supabaseClient.rpc('create_user_profile', params: {
        'user_id': userId,
        'app_type': appType,
      });
      
      debugPrint('🟢 User profile created with app type: $appType');
    } catch (e) {
      debugPrint('🔴 Failed to create user profile: $e');
      // Don't throw - this is not critical for auth flow
    }
  }

  // Enhanced phone authentication
  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      await _supabaseClient.auth.signInWithOtp(
        phone: phoneNumber,
        shouldCreateUser: true,
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userPhoneKey, phoneNumber);
    } catch (e) {
      debugPrint('Phone sign in error: $e');
      rethrow;
    }
  }

  // Verify phone OTP and complete authentication
  Future<AuthResponse> verifyPhoneOtpAndSignIn({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _supabaseClient.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );
      
      if (response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.isLoggedInKey, true);
        await prefs.setString(AppConstants.userPhoneKey, phoneNumber);
        await prefs.setString(AppConstants.userIdKey, response.user!.id);
      }
      
      return response;
    } catch (e) {
      debugPrint('Verify phone OTP error: $e');
      rethrow;
    }
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      debugPrint('Reset password error: $e');
      rethrow;
    }
  }
  
  // Check if user profile is complete
  Future<bool> isProfileComplete() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return false;
      
      final response = await _supabaseClient
          .from('user_profiles')
          .select('full_name, gender')
          .eq('auth_user_id', user.id)
          .single();
      
      final fullName = response['full_name'] as String?;
      final gender = response['gender'] as String?;
      
      return fullName != null && fullName.trim().isNotEmpty &&
             gender != null && gender.trim().isNotEmpty;
    } catch (e) {
      debugPrint('Profile check error: $e');
      // If profile doesn't exist or there's an error, assume it's incomplete
      return false;
    }
  }
  
  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;
      
      final response = await _supabaseClient
          .from('user_profiles')
          .select('*')
          .eq('auth_user_id', user.id)
          .single();
      
      return response;
    } catch (e) {
      debugPrint('Get user profile error: $e');
      return null;
    }
  }

  bool get isSignedIn => _supabaseClient.auth.currentUser != null;
  
  User? get currentUser => _supabaseClient.auth.currentUser;
}