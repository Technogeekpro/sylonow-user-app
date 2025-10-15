import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sylonow_user/features/booking/controllers/booking_controller.dart';
import '../providers/auth_providers.dart';
import '../../profile/providers/profile_providers.dart';
import '../../booking/providers/booking_providers.dart';
import '../../address/providers/address_providers.dart' hide selectedAddressProvider;

class LogoutService {
  static Future<void> clearAllProviders(WidgetRef ref) async {
    try {
      // Clear authentication providers
      ref.invalidate(currentUserProvider);
      ref.invalidate(isAuthenticatedProvider);
      ref.invalidate(authControllerProvider);
      
      // Clear profile providers
      ref.invalidate(currentUserProfileProvider);
      ref.invalidate(profileControllerProvider);
      
      // Clear booking providers
      ref.invalidate(userBookingsProvider);
      ref.invalidate(bookingControllerProvider);
      ref.invalidate(bookingCreationProvider);
      ref.invalidate(razorpayPaymentProvider);
      ref.invalidate(sylonowQrPaymentProvider);
      ref.invalidate(bookingStatusProvider);
      
      // Clear address providers
      ref.invalidate(addressesProvider);
      ref.invalidate(selectedAddressProvider);
      

      
      debugPrint('All providers cleared successfully');
    } catch (e) {
      debugPrint('Error clearing providers: $e');
      // Don't rethrow as this is not critical
    }
  }
  
  static Future<void> performCompleteLogout(WidgetRef ref) async {
    try {
      // First clear all providers
      await clearAllProviders(ref);
      
      // Then perform auth logout
      await ref.read(authControllerProvider.notifier).signOut();
      
      // Final cleanup
      await clearAllProviders(ref);
      
      debugPrint('Complete logout performed successfully');
    } catch (e) {
      debugPrint('Error during complete logout: $e');
      rethrow;
    }
  }
}