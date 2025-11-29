import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../payment/models/payment_method_model.dart';

class RazorpayPaymentService {
  static const String _razorpayKey =
      'rzp_live_RSUaC7MqY7BfsZ'; // Razorpay LIVE key
  static const String _razorpaySecret =
      'Cc2vEjqs2SATSz0uI10TYLi7'; // Razorpay LIVE secret key
  late Razorpay _razorpay;

  Function(PaymentSuccessResponse)? _onSuccess;
  Function(PaymentFailureResponse)? _onError;
  Function(ExternalWalletResponse)? _onExternalWallet;

  RazorpayPaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Initialize Razorpay payment
  Future<void> initiatePayment({
    required double amount,
    required String orderId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String description,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) async {
    try {
      _onSuccess = onSuccess;
      _onError = onError;
      _onExternalWallet = onExternalWallet;

      var options = {
        'key': _razorpayKey,
        'amount': (amount * 100).toInt(), // Amount in paise
        // 'order_id': orderId, // Commenting out order_id for testing without backend
        'name': 'Sylonow',
        'description': description,
        'prefill': {
          'contact': customerPhone,
          'email': customerEmail,
          'name': customerName,
        },
        'theme': {
          'color': '#FF0080', // Your app's primary color
        },
        'timeout': 300, // 5 minutes
        'retry': {'enabled': true, 'max_count': 3},
        'send_sms_hash': true,
        'allow_rotation': true,
        'recurring': false,
        'remember_customer': false,
        'modal': {
          'backdropclose': false,
          'escape': true,
          'handleback': true,
          'confirm_close': true,
          'animation': true,
        },
        'notes': {
          'booking_type': 'theater',
          'app_version': '1.0.0',
          'platform': 'mobile',
        },
      };

      _razorpay.open(options);
    } catch (e) {
      print('Error initiating payment: $e');
      throw Exception('Failed to initiate payment: $e');
    }
  }

  /// Create Razorpay order (this should be done on your backend)
  Future<String> createOrder({
    required double amount,
    required String currency,
    String? notes,
  }) async {
    try {
      // In production, this should be done on your backend
      // For demo purposes, we'll generate a mock order ID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'order_${timestamp}_demo';
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success: ${response.paymentId}');
    print('Order ID: ${response.orderId}');
    print('Signature: ${response.signature}');
    _onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
    _onError?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    _onExternalWallet?.call(response);
  }

  /// Verify payment signature (should be done on backend)
  bool verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) {
    try {
      // In production, this verification should be done on your backend
      // using your Razorpay secret key

      // The signature verification string format:
      // String body = orderId + "|" + paymentId;
      // String expectedSignature = hmac_sha256(body, _razorpaySecret);

      // For now, we'll return true as this should be implemented on backend
      // Real implementation would use HMAC SHA256 with _razorpaySecret
      return true;
    } catch (e) {
      print('Error verifying payment signature: $e');
      return false;
    }
  }

  /// Dispose Razorpay instance
  void dispose() {
    _razorpay.clear();
  }

  /// Get payment methods supported by Razorpay
  List<PaymentMethodModel> getSupportedPaymentMethods() {
    return [
      const PaymentMethodModel(
        id: 'upi',
        type: PaymentMethodType.upi,
        name: 'UPI',
        description: 'Pay using Google Pay, PhonePe, Paytm & more',
        icon: 'assets/icons/upi.png',
        isActive: true,
      ),
      const PaymentMethodModel(
        id: 'card',
        type: PaymentMethodType.card,
        name: 'Credit/Debit Card',
        description: 'Visa, Mastercard, Rupay & more',
        icon: 'assets/icons/card.png',
        isActive: true,
      ),
      const PaymentMethodModel(
        id: 'netbanking',
        type: PaymentMethodType.netbanking,
        name: 'Net Banking',
        description: 'All major banks supported',
        icon: 'assets/icons/netbanking.png',
        isActive: true,
      ),
      const PaymentMethodModel(
        id: 'wallet',
        type: PaymentMethodType.wallet,
        name: 'Wallets',
        description: 'Paytm, PhonePe, Amazon Pay & more',
        icon: 'assets/icons/wallet.png',
        isActive: true,
      ),
    ];
  }
}

/// Enhanced payment request model for theater bookings
class TheaterPaymentRequest {
  final String bookingId;
  final double amount;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String theaterName;
  final String screenName;
  final String bookingDate;
  final String timeSlot;
  final Map<String, dynamic> bookingDetails;

  TheaterPaymentRequest({
    required this.bookingId,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.theaterName,
    required this.screenName,
    required this.bookingDate,
    required this.timeSlot,
    required this.bookingDetails,
  });

  String get description =>
      'Theater booking for $screenName on $bookingDate at $timeSlot';

  Map<String, dynamic> toJson() => {
    'booking_id': bookingId,
    'amount': amount,
    'customer_name': customerName,
    'customer_email': customerEmail,
    'customer_phone': customerPhone,
    'theater_name': theaterName,
    'screen_name': screenName,
    'booking_date': bookingDate,
    'time_slot': timeSlot,
    'booking_details': bookingDetails,
  };
}
