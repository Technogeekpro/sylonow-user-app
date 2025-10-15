import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/payment_model.dart';
import '../repositories/order_repository.dart';
import '../repositories/payment_repository.dart';

class RazorpayService {
  late Razorpay _razorpay;
  final PaymentRepository _paymentRepository;
  final OrderRepository _orderRepository;

  // Razorpay LIVE API credentials
  static const String _keyId = 'rzp_live_RSUaC7MqY7BfsZ';
  static const String _keySecret = 'Cc2vEjqs2SATSz0uI10TYLi7';

  // Callback functions
  Function(PaymentSuccessResponse)? _onPaymentSuccess;
  Function(PaymentFailureResponse)? _onPaymentError;
  Function(ExternalWalletResponse)? _onExternalWallet;

  RazorpayService(this._paymentRepository, this._orderRepository) {
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Create a Razorpay order and initiate payment
  Future<RazorpayPaymentResult> processPayment({
    String? bookingId,
    String? orderId,
    required String userId,
    required String vendorId,
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      // Validate that either bookingId or orderId is provided
      if (bookingId == null && orderId == null) {
        return RazorpayPaymentResult.error(
          'Either bookingId or orderId must be provided',
        );
      }

      // Create payment transaction record first
      final paymentTransaction = await _paymentRepository
          .createPaymentTransaction(
            bookingId: bookingId,
            orderId: orderId,
            userId: userId,
            vendorId: vendorId,
            paymentMethod: 'razorpay',
            amount: amount,
            metadata: metadata,
          );

      // Create Razorpay order
      // Receipt must be max 40 characters
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final receiptId = '${bookingId != null ? 'B' : 'O'}_$timestamp';

      final razorpayOrderId = await _createRazorpayOrder(
        amount: amount,
        currency: 'INR',
        receipt: receiptId,
        notes: {
          if (bookingId != null) 'booking_id': bookingId,
          if (orderId != null) 'order_id': orderId,
          'user_id': userId,
          'vendor_id': vendorId,
          'payment_transaction_id': paymentTransaction.id,
        },
      );

      if (razorpayOrderId == null) {
        await _paymentRepository.updatePaymentStatus(
          paymentId: paymentTransaction.id,
          status: 'failed',
          failureReason: 'Failed to create Razorpay order',
        );
        return RazorpayPaymentResult.error('Failed to create payment order');
      }

      // Update payment transaction with order ID
      await _paymentRepository.updatePaymentStatus(
        paymentId: paymentTransaction.id,
        status: 'processing',
        processedAt: DateTime.now(),
      );

      // Configure payment options
      final options = {
        'key': _keyId,
        'amount': (amount * 100).toInt(), // Amount in paise
        'currency': 'INR',
        'order_id': razorpayOrderId,
        'name': 'Sylonow',
        'description': 'Booking Payment (60%)',
        'timeout': 300, // 5 minutes
        'prefill': {
          'contact': customerPhone,
          'email': customerEmail,
          'name': customerName,
        },
        'theme': {
          'color': '#FF0080', // Sylonow brand color
        },
        'notes': {
          if (bookingId != null) 'booking_id': bookingId,
          if (orderId != null) 'order_id': orderId,
          'payment_type': 'razorpay_60_percent',
          'payment_transaction_id': paymentTransaction.id,
        },
      };

      // Set up callbacks for this specific payment
      _setupPaymentCallbacks(paymentTransaction.id);

      // Open Razorpay checkout
      _razorpay.open(options);

      return RazorpayPaymentResult.processing(
        paymentTransaction.id,
        razorpayOrderId,
      );
    } catch (e) {
      debugPrint('Error processing Razorpay payment: $e');
      return RazorpayPaymentResult.error(
        'Failed to process payment: ${e.toString()}',
      );
    }
  }

  /// Create Razorpay order using Razorpay Orders API
  Future<String?> _createRazorpayOrder({
    required double amount,
    required String currency,
    required String receipt,
    Map<String, dynamic>? notes,
  }) async {
    try {
      // WARNING: In production, this should ALWAYS be done on your backend server
      // Exposing your key_secret in the client app is a security risk
      // This is only for MVP/testing purposes

      final url = Uri.parse('https://api.razorpay.com/v1/orders');
      final basicAuth =
          'Basic ${base64Encode(utf8.encode('$_keyId:$_keySecret'))}';

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode({
          'amount': (amount * 100).toInt(), // Amount in paise
          'currency': currency,
          'receipt': receipt,
          'notes': notes ?? {},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orderId = data['id'] as String;
        debugPrint('✅ Razorpay order created: $orderId');
        return orderId;
      } else {
        debugPrint('❌ Razorpay order creation failed: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error creating Razorpay order: $e');
      return null;
    }
  }

  /// Set up payment callbacks for specific payment transaction
  void _setupPaymentCallbacks(String paymentTransactionId) {
    _onPaymentSuccess = (response) =>
        _handleSpecificPaymentSuccess(response, paymentTransactionId);
    _onPaymentError = (response) =>
        _handleSpecificPaymentError(response, paymentTransactionId);
    _onExternalWallet = (response) =>
        _handleSpecificExternalWallet(response, paymentTransactionId);
  }

  /// Handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_onPaymentSuccess != null) {
      _onPaymentSuccess!(response);
    }
  }

  /// Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    if (_onPaymentError != null) {
      _onPaymentError!(response);
    }
  }

  /// Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    if (_onExternalWallet != null) {
      _onExternalWallet!(response);
    }
  }

  /// Handle specific payment success
  Future<void> _handleSpecificPaymentSuccess(
    PaymentSuccessResponse response,
    String paymentTransactionId,
  ) async {
    try {
      // Verify payment signature
      final isSignatureValid = _verifyPaymentSignature(
        orderId: response.orderId ?? '',
        paymentId: response.paymentId ?? '',
        signature: response.signature ?? '',
      );

      if (!isSignatureValid) {
        await _paymentRepository.updatePaymentStatus(
          paymentId: paymentTransactionId,
          status: 'failed',
          failureReason: 'Invalid payment signature',
        );
        return;
      }

      // Update payment transaction as completed
      final updatedPayment = await _paymentRepository.updatePaymentStatus(
        paymentId: paymentTransactionId,
        status: 'completed',
        razorpayPaymentId: response.paymentId,
        razorpaySignature: response.signature,
        processedAt: DateTime.now(),
      );

      // Update the order with advance payment information
      // Support both bookings and orders tables
      if (updatedPayment.orderId != null) {
        await _orderRepository.updateOrderPayment(
          orderId: updatedPayment.orderId!,
          paymentStatus: 'advance_paid',
        );
      } else if (updatedPayment.bookingId != null) {
        // For theater bookings, update the bookings table
        // TODO: Implement booking payment update if needed
        debugPrint(
          'Theater booking payment completed: ${updatedPayment.bookingId}',
        );
      }

      debugPrint('Razorpay payment successful: ${response.paymentId}');
    } catch (e) {
      debugPrint('Error handling payment success: $e');
      await _paymentRepository.updatePaymentStatus(
        paymentId: paymentTransactionId,
        status: 'failed',
        failureReason: 'Error processing successful payment',
      );
    }
  }

  /// Handle specific payment error
  Future<void> _handleSpecificPaymentError(
    PaymentFailureResponse response,
    String paymentTransactionId,
  ) async {
    try {
      await _paymentRepository.updatePaymentStatus(
        paymentId: paymentTransactionId,
        status: 'failed',
        failureReason: '${response.code}: ${response.message}',
      );

      debugPrint(
        'Razorpay payment failed: ${response.code} - ${response.message}',
      );
    } catch (e) {
      debugPrint('Error handling payment failure: $e');
    }
  }

  /// Handle specific external wallet
  Future<void> _handleSpecificExternalWallet(
    ExternalWalletResponse response,
    String paymentTransactionId,
  ) async {
    try {
      await _paymentRepository.updatePaymentStatus(
        paymentId: paymentTransactionId,
        status: 'processing',
        failureReason:
            'Payment redirected to external wallet: ${response.walletName}',
      );

      debugPrint(
        'Payment redirected to external wallet: ${response.walletName}',
      );
    } catch (e) {
      debugPrint('Error handling external wallet: $e');
    }
  }

  /// Verify Razorpay payment signature
  bool _verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) {
    try {
      final data = '$orderId|$paymentId';
      final key = utf8.encode(_keySecret);
      final bytes = utf8.encode(data);

      final hmacSha256 = Hmac(sha256, key);
      final digest = hmacSha256.convert(bytes);
      final generatedSignature = digest.toString();

      return generatedSignature == signature;
    } catch (e) {
      debugPrint('Error verifying payment signature: $e');
      return false;
    }
  }

  /// Get payment status
  Future<PaymentModel?> getPaymentStatus(String paymentTransactionId) async {
    try {
      return await _paymentRepository.getPaymentById(paymentTransactionId);
    } catch (e) {
      debugPrint('Error getting payment status: $e');
      return null;
    }
  }

  /// Process refund
  Future<RefundResult> processRefund({
    required String paymentId,
    required double amount,
    String? reason,
  }) async {
    try {
      // Note: In production, refund should be processed through your backend
      // This is a simplified implementation

      final refundId = 'rfnd_${DateTime.now().millisecondsSinceEpoch}';

      await _paymentRepository.processRefund(
        paymentId: paymentId,
        refundAmount: amount,
        refundId: refundId,
        reason: reason,
      );

      return RefundResult.success(refundId);
    } catch (e) {
      debugPrint('Error processing refund: $e');
      return RefundResult.error('Failed to process refund: ${e.toString()}');
    }
  }

  /// Dispose Razorpay instance
  void dispose() {
    _razorpay.clear();
  }
}

// Result classes for type-safe returns
class RazorpayPaymentResult {
  final bool isSuccess;
  final String message;
  final String? paymentTransactionId;
  final String? orderId;

  RazorpayPaymentResult._({
    required this.isSuccess,
    required this.message,
    this.paymentTransactionId,
    this.orderId,
  });

  factory RazorpayPaymentResult.processing(
    String paymentTransactionId,
    String orderId,
  ) {
    return RazorpayPaymentResult._(
      isSuccess: true,
      message: 'Payment processing initiated',
      paymentTransactionId: paymentTransactionId,
      orderId: orderId,
    );
  }

  factory RazorpayPaymentResult.error(String message) {
    return RazorpayPaymentResult._(isSuccess: false, message: message);
  }
}

class RefundResult {
  final bool isSuccess;
  final String message;
  final String? refundId;

  RefundResult._({
    required this.isSuccess,
    required this.message,
    this.refundId,
  });

  factory RefundResult.success(String refundId) {
    return RefundResult._(
      isSuccess: true,
      message: 'Refund processed successfully',
      refundId: refundId,
    );
  }

  factory RefundResult.error(String message) {
    return RefundResult._(isSuccess: false, message: message);
  }
}
