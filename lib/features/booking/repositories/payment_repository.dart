import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final SupabaseClient _supabase;

  PaymentRepository(this._supabase);

  /// Create a payment transaction record
  Future<PaymentModel> createPaymentTransaction({
    String? bookingId,
    String? orderId,
    required String userId,
    required String vendorId,
    required String paymentMethod,
    required double amount,
    String currency = 'INR',
    String? razorpayPaymentId,
    String? razorpayOrderId,
    String? razorpaySignature,
    String? qrCodeData,
    String? qrPaymentReference,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Validate that either bookingId or orderId is provided
      if (bookingId == null && orderId == null) {
        throw Exception('Either bookingId or orderId must be provided');
      }
      if (bookingId != null && orderId != null) {
        throw Exception('Cannot provide both bookingId and orderId');
      }

      final paymentData = {
        'user_id': userId,
        'vendor_id': vendorId,
        'payment_method': paymentMethod,
        'amount': amount,
        'currency': currency,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_signature': razorpaySignature,
        'qr_code_data': qrCodeData,
        'qr_payment_reference': qrPaymentReference,
        'status': 'pending',
        'metadata': metadata ?? {},
      };

      // Add either booking_id or order_id
      if (bookingId != null) {
        paymentData['booking_id'] = bookingId;
      }
      if (orderId != null) {
        paymentData['order_id'] = orderId;
      }

      final response = await _supabase
          .from('payment_transactions')
          .insert(paymentData)
          .select()
          .single();

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create payment transaction: $e');
    }
  }

  /// Update payment transaction status
  Future<PaymentModel> updatePaymentStatus({
    required String paymentId,
    required String status,
    String? razorpayPaymentId,
    String? razorpaySignature,
    String? failureReason,
    DateTime? processedAt,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (razorpayPaymentId != null) {
        updateData['razorpay_payment_id'] = razorpayPaymentId;
      }
      if (razorpaySignature != null) {
        updateData['razorpay_signature'] = razorpaySignature;
      }
      if (failureReason != null) {
        updateData['failure_reason'] = failureReason;
      }
      if (processedAt != null) {
        updateData['processed_at'] = processedAt.toIso8601String();
      }

      final response = await _supabase
          .from('payment_transactions')
          .update(updateData)
          .eq('id', paymentId)
          .select()
          .single();

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  /// Get payment transaction by ID
  Future<PaymentModel?> getPaymentById(String paymentId) async {
    try {
      final response = await _supabase
          .from('payment_transactions')
          .select()
          .eq('id', paymentId)
          .maybeSingle();

      if (response == null) return null;

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get payment: $e');
    }
  }

  /// Get payments for a booking
  Future<List<PaymentModel>> getPaymentsByBooking(String bookingId) async {
    try {
      final response = await _supabase
          .from('payment_transactions')
          .select()
          .eq('booking_id', bookingId)
          .order('created_at', ascending: false);

      return response
          .map<PaymentModel>((data) => PaymentModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get payments for booking: $e');
    }
  }

  /// Get payment summary for a booking
  Future<PaymentSummaryModel?> getPaymentSummary(String bookingId) async {
    try {
      final payments = await getPaymentsByBooking(bookingId);

      if (payments.isEmpty) return null;

      PaymentModel? razorpayPayment;
      PaymentModel? sylonowQrPayment;

      for (final payment in payments) {
        if (payment.paymentMethod == 'razorpay') {
          razorpayPayment = payment;
        } else if (payment.paymentMethod == 'sylonow_qr') {
          sylonowQrPayment = payment;
        }
      }

      final totalAmount =
          (razorpayPayment?.amount ?? 0) + (sylonowQrPayment?.amount ?? 0);
      final razorpayAmount = razorpayPayment?.amount ?? 0;
      final sylonowQrAmount = sylonowQrPayment?.amount ?? 0;

      // Determine overall status
      String overallStatus = 'pending';
      final razorpayStatus = razorpayPayment?.status ?? 'pending';
      final sylonowQrStatus = sylonowQrPayment?.status ?? 'pending';

      if (razorpayStatus == 'completed' && sylonowQrStatus == 'completed') {
        overallStatus = 'completed';
      } else if (razorpayStatus == 'completed' ||
          sylonowQrStatus == 'completed') {
        overallStatus = 'partial';
      } else if (razorpayStatus == 'failed' && sylonowQrStatus == 'failed') {
        overallStatus = 'failed';
      }

      return PaymentSummaryModel(
        bookingId: bookingId,
        totalAmount: totalAmount,
        razorpayAmount: razorpayAmount,
        sylonowQrAmount: sylonowQrAmount,
        razorpayStatus: razorpayStatus,
        sylonowQrStatus: sylonowQrStatus,
        overallStatus: overallStatus,
        razorpayPayment: razorpayPayment,
        sylonowQrPayment: sylonowQrPayment,
      );
    } catch (e) {
      throw Exception('Failed to get payment summary: $e');
    }
  }

  /// Get user's payment history
  Future<List<PaymentModel>> getUserPayments(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('payment_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response
          .map<PaymentModel>((data) => PaymentModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user payments: $e');
    }
  }

  /// Get vendor's payment history
  Future<List<PaymentModel>> getVendorPayments(
    String vendorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('payment_transactions')
          .select()
          .eq('vendor_id', vendorId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response
          .map<PaymentModel>((data) => PaymentModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get vendor payments: $e');
    }
  }

  /// Process refund for a payment
  Future<PaymentModel> processRefund({
    required String paymentId,
    required double refundAmount,
    required String refundId,
    String? reason,
  }) async {
    try {
      final updateData = {
        'status': 'refunded',
        'refund_amount': refundAmount,
        'refund_id': refundId,
        'failure_reason': reason,
        'processed_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('payment_transactions')
          .update(updateData)
          .eq('id', paymentId)
          .select()
          .single();

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to process refund: $e');
    }
  }

  /// Get payment statistics for a vendor
  Future<Map<String, dynamic>> getVendorPaymentStats(
    String vendorId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase
          .from('payment_transactions')
          .select('amount, status, created_at')
          .eq('vendor_id', vendorId);

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final response = await query;

      double totalEarnings = 0;
      double completedPayments = 0;
      double pendingPayments = 0;
      double refundedPayments = 0;
      int transactionCount = 0;

      for (final payment in response) {
        final amount = (payment['amount'] as num).toDouble();
        final status = payment['status'] as String;

        transactionCount++;

        switch (status) {
          case 'completed':
            totalEarnings += amount;
            completedPayments += amount;
            break;
          case 'pending':
          case 'processing':
            pendingPayments += amount;
            break;
          case 'refunded':
            refundedPayments += amount;
            break;
        }
      }

      return {
        'total_earnings': totalEarnings,
        'completed_payments': completedPayments,
        'pending_payments': pendingPayments,
        'refunded_payments': refundedPayments,
        'transaction_count': transactionCount,
      };
    } catch (e) {
      throw Exception('Failed to get payment statistics: $e');
    }
  }
}
