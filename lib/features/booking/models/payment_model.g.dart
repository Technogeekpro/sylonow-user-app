// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      userId: json['user_id'] as String,
      vendorId: json['vendor_id'] as String,
      paymentMethod: json['payment_method'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      razorpayPaymentId: json['razorpay_payment_id'] as String?,
      razorpayOrderId: json['razorpay_order_id'] as String?,
      razorpaySignature: json['razorpay_signature'] as String?,
      qrCodeData: json['qr_code_data'] as String?,
      qrPaymentReference: json['qr_payment_reference'] as String?,
      qrVerifiedBy: json['qr_verified_by'] as String?,
      status: json['status'] as String? ?? 'pending',
      failureReason: json['failure_reason'] as String?,
      refundAmount: (json['refund_amount'] as num?)?.toDouble(),
      refundId: json['refund_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      processedAt: json['processed_at'] == null
          ? null
          : DateTime.parse(json['processed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'user_id': instance.userId,
      'vendor_id': instance.vendorId,
      'payment_method': instance.paymentMethod,
      'amount': instance.amount,
      'currency': instance.currency,
      'razorpay_payment_id': instance.razorpayPaymentId,
      'razorpay_order_id': instance.razorpayOrderId,
      'razorpay_signature': instance.razorpaySignature,
      'qr_code_data': instance.qrCodeData,
      'qr_payment_reference': instance.qrPaymentReference,
      'qr_verified_by': instance.qrVerifiedBy,
      'status': instance.status,
      'failure_reason': instance.failureReason,
      'refund_amount': instance.refundAmount,
      'refund_id': instance.refundId,
      'metadata': instance.metadata,
      'processed_at': instance.processedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$PaymentSummaryModelImpl _$$PaymentSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentSummaryModelImpl(
      bookingId: json['booking_id'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      razorpayAmount: (json['razorpay_amount'] as num).toDouble(),
      sylonowQrAmount: (json['sylonow_qr_amount'] as num).toDouble(),
      razorpayStatus: json['razorpay_status'] as String? ?? 'pending',
      sylonowQrStatus: json['sylonow_qr_status'] as String? ?? 'pending',
      overallStatus: json['overall_status'] as String? ?? 'pending',
      razorpayPayment: json['razorpay_payment'] == null
          ? null
          : PaymentModel.fromJson(
              json['razorpay_payment'] as Map<String, dynamic>),
      sylonowQrPayment: json['sylonow_qr_payment'] == null
          ? null
          : PaymentModel.fromJson(
              json['sylonow_qr_payment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PaymentSummaryModelImplToJson(
        _$PaymentSummaryModelImpl instance) =>
    <String, dynamic>{
      'booking_id': instance.bookingId,
      'total_amount': instance.totalAmount,
      'razorpay_amount': instance.razorpayAmount,
      'sylonow_qr_amount': instance.sylonowQrAmount,
      'razorpay_status': instance.razorpayStatus,
      'sylonow_qr_status': instance.sylonowQrStatus,
      'overall_status': instance.overallStatus,
      'razorpay_payment': instance.razorpayPayment,
      'sylonow_qr_payment': instance.sylonowQrPayment,
    };
