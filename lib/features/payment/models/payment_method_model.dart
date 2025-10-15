import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method_model.freezed.dart';
part 'payment_method_model.g.dart';

@freezed
class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    required String id,
    required PaymentMethodType type,
    required String name,
    required String description,
    String? icon,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);
}

enum PaymentMethodType {
  @JsonValue('upi')
  upi,
  @JsonValue('card')
  card,
  @JsonValue('netbanking')
  netbanking,
  @JsonValue('wallet')
  wallet,
  @JsonValue('cod')
  cod,
  @JsonValue('emi')
  emi,
}

@freezed
class PaymentRequestModel with _$PaymentRequestModel {
  const factory PaymentRequestModel({
    required String orderId,
    required double amount,
    required String currency,
    required String customerId,
    required String customerEmail,
    required String customerPhone,
    required PaymentMethodType paymentMethod,
    Map<String, dynamic>? metadata,
    String? description,
    String? callbackUrl,
  }) = _PaymentRequestModel;

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestModelFromJson(json);
}

@freezed
class PaymentResponseModel with _$PaymentResponseModel {
  const factory PaymentResponseModel({
    required String paymentId,
    required String orderId,
    required PaymentStatus status,
    required double amount,
    required String currency,
    String? transactionId,
    String? gatewayTransactionId,
    String? failureReason,
    DateTime? paidAt,
    Map<String, dynamic>? gatewayResponse,
  }) = _PaymentResponseModel;

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseModelFromJson(json);
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('success')
  success,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('refunded')
  refunded,
}