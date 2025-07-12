import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'vendor_id') required String vendorId,
    
    // Payment Details
    @JsonKey(name: 'payment_method') required String paymentMethod, // 'razorpay' or 'sylonow_qr'
    required double amount,
    @JsonKey(name: 'currency') @Default('INR') String currency,
    
    // Razorpay specific fields
    @JsonKey(name: 'razorpay_payment_id') String? razorpayPaymentId,
    @JsonKey(name: 'razorpay_order_id') String? razorpayOrderId,
    @JsonKey(name: 'razorpay_signature') String? razorpaySignature,
    
    // Sylonow QR specific fields
    @JsonKey(name: 'qr_code_data') String? qrCodeData,
    @JsonKey(name: 'qr_payment_reference') String? qrPaymentReference,
    @JsonKey(name: 'qr_verified_by') String? qrVerifiedBy, // Admin/system who verified the QR payment
    
    // Payment Status
    @Default('pending') String status, // pending, processing, completed, failed, refunded
    @JsonKey(name: 'failure_reason') String? failureReason,
    @JsonKey(name: 'refund_amount') double? refundAmount,
    @JsonKey(name: 'refund_id') String? refundId,
    
    // Additional Information
    Map<String, dynamic>? metadata,
    
    // Timestamps
    @JsonKey(name: 'processed_at') DateTime? processedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}

// Payment summary for displaying total payment breakdown
@freezed
class PaymentSummaryModel with _$PaymentSummaryModel {
  const factory PaymentSummaryModel({
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'razorpay_amount') required double razorpayAmount,
    @JsonKey(name: 'sylonow_qr_amount') required double sylonowQrAmount,
    @JsonKey(name: 'razorpay_status') @Default('pending') String razorpayStatus,
    @JsonKey(name: 'sylonow_qr_status') @Default('pending') String sylonowQrStatus,
    @JsonKey(name: 'overall_status') @Default('pending') String overallStatus,
    @JsonKey(name: 'razorpay_payment') PaymentModel? razorpayPayment,
    @JsonKey(name: 'sylonow_qr_payment') PaymentModel? sylonowQrPayment,
  }) = _PaymentSummaryModel;

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryModelFromJson(json);
}

// Enum for payment methods
enum PaymentMethod {
  @JsonValue('razorpay')
  razorpay,
  @JsonValue('sylonow_qr')
  sylonowQr,
}

// Enum for payment status
enum PaymentStatusEnum {
  pending,
  processing,
  completed,
  failed,
  refunded,
  cancelled,
} 