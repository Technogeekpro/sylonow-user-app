import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

class AuthService {
  final SupabaseClient _supabaseClient;
  
  AuthService(this._supabaseClient);
  
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