import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/features/wallet/models/transaction_model.dart';
import 'package:sylonow_user/features/wallet/models/wallet_model.dart';

class WalletRepository {
  final SupabaseClient _supabase;

  WalletRepository(this._supabase);

  // Get user's wallet
  Future<WalletModel?> getUserWallet(String userId) async {
    try {
      final response = await _supabase
          .from('wallets')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return WalletModel.fromJson(response);
    } catch (e) {
      // Handle case where table doesn't exist
      if (e.toString().contains('relation "public.wallets" does not exist')) {
        print('Wallets table not found. Please run database setup.');
        return null;
      }
      throw Exception('Failed to get wallet: $e');
    }
  }

  // Create wallet for user
  Future<WalletModel> createWallet(String userId) async {
    try {
      final response = await _supabase
          .from('wallets')
          .insert({
            'user_id': userId,
            'balance': 0.0,
            'total_refunds': 0.0,
            'total_cashbacks': 0.0,
          })
          .select()
          .single();

      return WalletModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create wallet: $e');
    }
  }

  // Get wallet transactions
  Future<List<TransactionModel>> getTransactions(String userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('user_wallet_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      // Handle case where table doesn't exist
      if (e.toString().contains('relation "public.user_wallet_transactions" does not exist')) {
        print('User wallet transactions table not found. Please run database setup.');
        return [];
      }
      throw Exception('Failed to get transactions: $e');
    }
  }

  // Add refund transaction
  Future<TransactionModel> addRefundTransaction({
    required String userId,
    required double amount,
    required String description,
    String? orderId,
    String? bookingId,
  }) async {
    try {
      final response = await _supabase
          .from('user_wallet_transactions')
          .insert({
            'user_id': userId,
            'transaction_type': 'refund',
            'amount': amount,
            'description': description,
            'status': 'completed',
            'reference_id': orderId ?? bookingId,
            'reference_type': orderId != null ? 'order' : 'booking',
          })
          .select()
          .single();

      // Update wallet balance
      await _updateWalletBalance(userId, amount);

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add refund transaction: $e');
    }
  }

  // Update wallet balance
  Future<void> _updateWalletBalance(String userId, double amount) async {
    try {
      await _supabase.rpc('update_wallet_balance', params: {
        'user_id': userId,
        'amount': amount,
      });
    } catch (e) {
      throw Exception('Failed to update wallet balance: $e');
    }
  }

  // Get wallet balance
  Future<double> getWalletBalance(String userId) async {
    try {
      final wallet = await getUserWallet(userId);
      return wallet?.balance ?? 0.0;
    } catch (e) {
      // Return 0.0 if there's an error (like missing table)
      print('Error getting wallet balance: $e');
      return 0.0;
    }
  }
}