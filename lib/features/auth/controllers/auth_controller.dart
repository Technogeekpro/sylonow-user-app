import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;
  
  AuthController(this._authService) : super(const AsyncData(null));

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncLoading();
    
    try {
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
        userData: {'name': name},
      );
      
      if (response.user != null) {
        state = const AsyncData(null);
      } else {
        state = AsyncError('Failed to sign up', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    
    try {
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        state = const AsyncData(null);
      } else {
        state = AsyncError('Failed to sign in', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> sendOtpToPhone(String phoneNumber) async {
    state = const AsyncLoading();
    
    try {
      await _authService.sendOtpToPhone(phoneNumber);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    state = const AsyncLoading();
    
    try {
      final response = await _authService.verifyPhoneOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      
      if (response.user != null) {
        state = const AsyncData(null);
      } else {
        state = AsyncError('Failed to verify OTP', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    
    try {
      await _authService.signOut();
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    
    try {
      await _authService.resetPassword(email);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
} 