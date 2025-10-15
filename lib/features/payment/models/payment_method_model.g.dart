// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodModelImpl _$$PaymentMethodModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentMethodModelImpl(
      id: json['id'] as String,
      type: $enumDecode(_$PaymentMethodTypeEnumMap, json['type']),
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      isActive: json['isActive'] as bool?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentMethodModelImplToJson(
        _$PaymentMethodModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PaymentMethodTypeEnumMap[instance.type]!,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'isActive': instance.isActive,
      'metadata': instance.metadata,
    };

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.upi: 'upi',
  PaymentMethodType.card: 'card',
  PaymentMethodType.netbanking: 'netbanking',
  PaymentMethodType.wallet: 'wallet',
  PaymentMethodType.cod: 'cod',
  PaymentMethodType.emi: 'emi',
};

_$PaymentRequestModelImpl _$$PaymentRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentRequestModelImpl(
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      customerId: json['customerId'] as String,
      customerEmail: json['customerEmail'] as String,
      customerPhone: json['customerPhone'] as String,
      paymentMethod:
          $enumDecode(_$PaymentMethodTypeEnumMap, json['paymentMethod']),
      metadata: json['metadata'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      callbackUrl: json['callbackUrl'] as String?,
    );

Map<String, dynamic> _$$PaymentRequestModelImplToJson(
        _$PaymentRequestModelImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'amount': instance.amount,
      'currency': instance.currency,
      'customerId': instance.customerId,
      'customerEmail': instance.customerEmail,
      'customerPhone': instance.customerPhone,
      'paymentMethod': _$PaymentMethodTypeEnumMap[instance.paymentMethod]!,
      'metadata': instance.metadata,
      'description': instance.description,
      'callbackUrl': instance.callbackUrl,
    };

_$PaymentResponseModelImpl _$$PaymentResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentResponseModelImpl(
      paymentId: json['paymentId'] as String,
      orderId: json['orderId'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      transactionId: json['transactionId'] as String?,
      gatewayTransactionId: json['gatewayTransactionId'] as String?,
      failureReason: json['failureReason'] as String?,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      gatewayResponse: json['gatewayResponse'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentResponseModelImplToJson(
        _$PaymentResponseModelImpl instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'orderId': instance.orderId,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'transactionId': instance.transactionId,
      'gatewayTransactionId': instance.gatewayTransactionId,
      'failureReason': instance.failureReason,
      'paidAt': instance.paidAt?.toIso8601String(),
      'gatewayResponse': instance.gatewayResponse,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.success: 'success',
  PaymentStatus.failed: 'failed',
  PaymentStatus.cancelled: 'cancelled',
  PaymentStatus.refunded: 'refunded',
};
