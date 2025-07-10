import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/constants/app_constants.dart';

class AuthService {
  final SupabaseClient _supabaseClient;
  late final GoogleSignIn _googleSignIn;
  
  AuthService(this._supabaseClient) {
    _googleSignIn = GoogleSignIn(
      // Use your Web client ID from Google Cloud Console
      // This should match the OAuth client configured in Supabase
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
      await _supabaseClient.auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.isLoggedInKey, false);
      await prefs.remove(AppConstants.userEmailKey);
      await prefs.remove(AppConstants.userIdKey);
      await prefs.remove(AppConstants.userPhoneKey);
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
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
  
  // Sign in with Google
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      // Sign in to Supabase with Google credentials
      final response = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.isLoggedInKey, true);
        await prefs.setString(AppConstants.userEmailKey, response.user!.email ?? '');
        await prefs.setString(AppConstants.userIdKey, response.user!.id);
      }

      return response;
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
} 