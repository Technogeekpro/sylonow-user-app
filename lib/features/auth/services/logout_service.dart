import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/auth_providers.dart';
import '../../profile/providers/profile_providers.dart';
import '../../booking/providers/booking_providers.dart';
import '../../address/providers/address_providers.dart';
import '../../wishlist/providers/wishlist_providers.dart';
import '../../wallet/providers/wallet_providers.dart';
import '../../home/providers/home_providers.dart';
import '../../home/providers/optimized_home_providers.dart';
import '../../home/providers/cached_home_providers.dart';

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
      
      // Clear wishlist providers
      ref.invalidate(wishlistProvider);
      ref.invalidate(wishlistControllerProvider);
      
      // Clear wallet providers
      ref.invalidate(walletProvider);
      ref.invalidate(transactionHistoryProvider);
      
      // Clear home providers
      ref.invalidate(homeServiceListingsProvider);
      ref.invalidate(homeCategoriesProvider);
      ref.invalidate(homeVendorsProvider);
      ref.invalidate(homeQuotesProvider);
      ref.invalidate(optimizedHomeDataProvider);
      ref.invalidate(cachedHomeDataProvider);
      
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