import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/core/providers/core_providers.dart' as core;
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import 'package:sylonow_user/features/wallet/models/transaction_model.dart';
import 'package:sylonow_user/features/wallet/models/wallet_model.dart';
import 'package:sylonow_user/features/wallet/repositories/wallet_repository.dart';

// Wallet Repository Provider
final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final supabase = ref.watch(core.supabaseClientProvider);
  return WalletRepository(supabase);
});

// User Wallet Provider
final userWalletProvider = FutureProvider<WalletModel?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  
  final repository = ref.watch(walletRepositoryProvider);
  
  try {
    // Try to get existing wallet
    var wallet = await repository.getUserWallet(user.id);
    
    // If wallet doesn't exist, try to create one
    if (wallet == null) {
      try {
        wallet = await repository.createWallet(user.id);
      } catch (e) {
        // If creation fails (e.g., table doesn't exist), return null
        print('Failed to create wallet: $e');
        return null;
      }
    }
    
    return wallet;
  } catch (e) {
    // Handle any errors gracefully
    print('Error in userWalletProvider: $e');
    return null;
  }
});

// Wallet Balance Provider
final walletBalanceProvider = FutureProvider<double>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return 0.0;
  
  final repository = ref.watch(walletRepositoryProvider);
  return await repository.getWalletBalance(user.id);
});

// Wallet Transactions Provider
final walletTransactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  final repository = ref.watch(walletRepositoryProvider);
  try {
    return await repository.getTransactions(user.id);
  } catch (e) {
    // Handle errors gracefully and return empty list
    print('Error getting transactions: $e');
    return [];
  }
});

// Refund Transaction Provider
final refundTransactionProvider = Provider<Future<TransactionModel> Function({
  required double amount,
  required String description,
  String? orderId,
  String? bookingId,
})>((ref) {
  return ({
    required double amount,
    required String description,
    String? orderId,
    String? bookingId,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) throw Exception('User not authenticated');
    
    final repository = ref.read(walletRepositoryProvider);
    
    final transaction = await repository.addRefundTransaction(
      userId: user.id,
      amount: amount,
      description: description,
      orderId: orderId,
      bookingId: bookingId,
    );
    
    // Refresh wallet data
    ref.invalidate(userWalletProvider);
    ref.invalidate(walletBalanceProvider);
    ref.invalidate(walletTransactionsProvider);
    
    return transaction;
  };
});