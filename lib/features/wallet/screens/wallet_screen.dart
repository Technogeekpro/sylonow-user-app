import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/features/wallet/providers/wallet_providers.dart';
import 'package:sylonow_user/features/wallet/models/transaction_model.dart';
import 'package:intl/intl.dart';

class WalletScreen extends ConsumerWidget {
  static const String routeName = '/wallet';
  
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(userWalletProvider);
    final transactionsAsync = ref.watch(walletTransactionsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle(
            fontFamily: 'Okra',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userWalletProvider);
          ref.invalidate(walletTransactionsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Wallet Balance Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Color(0xFFE91E63)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Wallet Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Okra',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    walletAsync.when(
                      data: (wallet) => Text(
                        '₹${wallet?.balance.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Okra',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      loading: () => const Text(
                        '₹0.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Okra',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      error: (error, _) => const Text(
                        '₹0.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Okra',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Available for next booking',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ],
                ),
              ),

              // Refund Policy Info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Refunds from cancelled orders are added to your wallet',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showRefundPolicyDialog(context),
                      child: Icon(
                        Icons.help_outline,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Transactions Section
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Okra',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    transactionsAsync.when(
                      data: (transactions) => transactions.isEmpty
                          ? _buildEmptyState()
                          : _buildTransactionsList(transactions),
                      loading: () => _buildLoadingState(),
                      error: (error, _) => _buildErrorState(error.toString()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList(List<TransactionModel> transactions) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionTile(transaction);
      },
    );
  }

  Widget _buildTransactionTile(TransactionModel transaction) {
    IconData icon;
    Color iconColor;
    String prefix;

    switch (transaction.type) {
      case 'refund':
        icon = Icons.refresh;
        iconColor = Colors.green;
        prefix = '+';
        break;
      case 'payment':
        icon = Icons.payment;
        iconColor = Colors.red;
        prefix = '-';
        break;
      case 'cashback':
        icon = Icons.card_giftcard;
        iconColor = Colors.orange;
        prefix = '+';
        break;
      default:
        icon = Icons.account_balance_wallet;
        iconColor = Colors.grey;
        prefix = '';
    }

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(
          fontFamily: 'Okra',
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.createdAt),
        style: TextStyle(
          fontFamily: 'Okra',
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Text(
        '$prefix₹${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontFamily: 'Okra',
          fontWeight: FontWeight.bold,
          color: iconColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Okra',
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your wallet transactions will appear here',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Okra',
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.pink),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.blue[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Database Setup Required',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Okra',
              color: Colors.blue[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please run the database setup script to create wallet tables',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Okra',
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showRefundPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Refund Policy',
          style: TextStyle(
            fontFamily: 'Okra',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Wallet Refunds',
                style: TextStyle(
                  fontFamily: 'Okra',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• Refunds from cancelled orders are automatically added to your wallet',
                style: TextStyle(fontFamily: 'Okra', fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                '• Wallet balance can be used for future bookings',
                style: TextStyle(fontFamily: 'Okra', fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                '• Refunds are processed within 24 hours of cancellation',
                style: TextStyle(fontFamily: 'Okra', fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Cancellation Policy',
                style: TextStyle(
                  fontFamily: 'Okra',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• Free cancellation up to 24 hours before service',
                style: TextStyle(fontFamily: 'Okra', fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                '• 50% refund for cancellations 12-24 hours before service',
                style: TextStyle(fontFamily: 'Okra', fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                '• No refund for cancellations within 12 hours',
                style: TextStyle(fontFamily: 'Okra', fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'Got it',
              style: TextStyle(
                fontFamily: 'Okra',
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}