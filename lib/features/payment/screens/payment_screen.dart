import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../home/models/service_listing_model.dart';
import '../models/payment_method_model.dart';
import '../providers/payment_providers.dart';
import '../services/payment_service.dart';
import '../../auth/providers/auth_providers.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final ServiceListingModel service;
  final Map<String, dynamic>? customization;
  final String selectedAddressId;
  final double totalAmount;
  final String specialRequirements;

  const PaymentScreen({
    super.key,
    required this.service,
    this.customization,
    required this.selectedAddressId,
    required this.totalAmount,
    required this.specialRequirements,
  });

  static const String routeName = '/payment';

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethodModel? selectedPaymentMethod;
  bool isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    final paymentMethods = ref.watch(paymentMethodsProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              _buildOrderSummary(),
              const SizedBox(height: 16),
              _buildPaymentMethods(paymentMethods),
              const SizedBox(height: 16),
              _buildSecurityInfo(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPaymentButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.secondaryColor,
      elevation: 0.5,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor, size: 24),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'Payment',
        style: TextStyle(
          fontFamily: 'Okra',
          fontWeight: FontWeight.w600,
          color: AppTheme.headingColor,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, color: AppTheme.successColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  '100% SECURE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successColor,
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '₹${_formatPrice(widget.totalAmount)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.service.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Okra',
              color: AppTheme.textPrimaryColor,
            ),
          ),
          if (widget.service.description != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.service.description!,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondaryColor,
                fontFamily: 'Okra',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(AsyncValue<List<PaymentMethodModel>> paymentMethods) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Choose Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          paymentMethods.when(
            data: (methods) => Column(
              children: methods.map((method) => _buildPaymentMethodTile(method)).toList(),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Failed to load payment methods',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Okra',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethodModel method) {
    final isSelected = selectedPaymentMethod?.id == method.id;
    
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.05) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: AppTheme.backgroundColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getPaymentMethodColor(method.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getPaymentMethodIcon(method.type),
                color: _getPaymentMethodColor(method.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Okra',
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            ),
            if (method.type == PaymentMethodType.upi || method.type == PaymentMethodType.card)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'INSTANT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade600,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Your payment is secured',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'We use industry-standard encryption to protect your payment information. Your data is safe with us.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade600,
              fontFamily: 'Okra',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: isProcessingPayment 
              ? 'Processing Payment...' 
              : 'Pay ₹${_formatPrice(widget.totalAmount)}',
          onPressed: selectedPaymentMethod == null || isProcessingPayment
              ? () {}
              : _processPayment,
        ),
      ),
    );
  }

  Color _getPaymentMethodColor(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.upi:
        return Colors.orange;
      case PaymentMethodType.card:
        return Colors.blue;
      case PaymentMethodType.netbanking:
        return Colors.green;
      case PaymentMethodType.wallet:
        return Colors.purple;
      case PaymentMethodType.cod:
        return Colors.brown;
      case PaymentMethodType.emi:
        return Colors.indigo;
    }
  }

  IconData _getPaymentMethodIcon(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.upi:
        return Icons.qr_code;
      case PaymentMethodType.card:
        return Icons.credit_card;
      case PaymentMethodType.netbanking:
        return Icons.account_balance;
      case PaymentMethodType.wallet:
        return Icons.account_balance_wallet;
      case PaymentMethodType.cod:
        return Icons.money;
      case PaymentMethodType.emi:
        return Icons.credit_score;
    }
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!$))'),
      (Match m) => '${m[1]},',
    );
  }

  Future<void> _processPayment() async {
    if (selectedPaymentMethod == null) return;

    setState(() {
      isProcessingPayment = true;
    });

    try {
      final paymentService = ref.read(paymentServiceProvider);
      final user = ref.read(currentUserProvider);

      // Create payment order
      final paymentRequest = await paymentService.createPaymentOrder(
        orderId: 'order_${DateTime.now().millisecondsSinceEpoch}',
        amount: widget.totalAmount,
        customerEmail: user?.email ?? 'guest@example.com',
        customerPhone: user?.phone ?? '9999999999',
        description: 'Payment for ${widget.service.name}',
      );

      // Process payment
      final paymentResponse = await paymentService.processPayment(
        paymentRequest: paymentRequest,
        paymentMethod: selectedPaymentMethod!.type,
      );

      if (paymentResponse.status == PaymentStatus.success) {
        // Payment successful
        if (mounted) {
          context.pushReplacement('/payment-success', extra: {
            'paymentResponse': paymentResponse,
            'service': widget.service,
            'totalAmount': widget.totalAmount,
          });
        }
      } else {
        // Payment failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(paymentResponse.failureReason ?? 'Payment failed'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment processing failed: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessingPayment = false;
        });
      }
    }
  }
}