// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  String? get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError; // Payment Details
  @JsonKey(name: 'payment_method')
  String get paymentMethod =>
      throw _privateConstructorUsedError; // 'razorpay' or 'sylonow_qr'
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String get currency =>
      throw _privateConstructorUsedError; // Razorpay specific fields
  @JsonKey(name: 'razorpay_payment_id')
  String? get razorpayPaymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'razorpay_order_id')
  String? get razorpayOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'razorpay_signature')
  String? get razorpaySignature =>
      throw _privateConstructorUsedError; // Sylonow QR specific fields
  @JsonKey(name: 'qr_code_data')
  String? get qrCodeData => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_payment_reference')
  String? get qrPaymentReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_verified_by')
  String? get qrVerifiedBy =>
      throw _privateConstructorUsedError; // Admin/system who verified the QR payment
// Payment Status
  String get status =>
      throw _privateConstructorUsedError; // pending, processing, completed, failed, refunded
  @JsonKey(name: 'failure_reason')
  String? get failureReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'refund_amount')
  double? get refundAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'refund_id')
  String? get refundId =>
      throw _privateConstructorUsedError; // Additional Information
  Map<String, dynamic>? get metadata =>
      throw _privateConstructorUsedError; // Timestamps
  @JsonKey(name: 'processed_at')
  DateTime? get processedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
          PaymentModel value, $Res Function(PaymentModel) then) =
      _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'order_id') String? orderId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'payment_method') String paymentMethod,
      double amount,
      @JsonKey(name: 'currency') String currency,
      @JsonKey(name: 'razorpay_payment_id') String? razorpayPaymentId,
      @JsonKey(name: 'razorpay_order_id') String? razorpayOrderId,
      @JsonKey(name: 'razorpay_signature') String? razorpaySignature,
      @JsonKey(name: 'qr_code_data') String? qrCodeData,
      @JsonKey(name: 'qr_payment_reference') String? qrPaymentReference,
      @JsonKey(name: 'qr_verified_by') String? qrVerifiedBy,
      String status,
      @JsonKey(name: 'failure_reason') String? failureReason,
      @JsonKey(name: 'refund_amount') double? refundAmount,
      @JsonKey(name: 'refund_id') String? refundId,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'processed_at') DateTime? processedAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = freezed,
    Object? orderId = freezed,
    Object? userId = null,
    Object? vendorId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? currency = null,
    Object? razorpayPaymentId = freezed,
    Object? razorpayOrderId = freezed,
    Object? razorpaySignature = freezed,
    Object? qrCodeData = freezed,
    Object? qrPaymentReference = freezed,
    Object? qrVerifiedBy = freezed,
    Object? status = null,
    Object? failureReason = freezed,
    Object? refundAmount = freezed,
    Object? refundId = freezed,
    Object? metadata = freezed,
    Object? processedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      razorpayPaymentId: freezed == razorpayPaymentId
          ? _value.razorpayPaymentId
          : razorpayPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      razorpayOrderId: freezed == razorpayOrderId
          ? _value.razorpayOrderId
          : razorpayOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      razorpaySignature: freezed == razorpaySignature
          ? _value.razorpaySignature
          : razorpaySignature // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      qrPaymentReference: freezed == qrPaymentReference
          ? _value.qrPaymentReference
          : qrPaymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
      qrVerifiedBy: freezed == qrVerifiedBy
          ? _value.qrVerifiedBy
          : qrVerifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      refundId: freezed == refundId
          ? _value.refundId
          : refundId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
          _$PaymentModelImpl value, $Res Function(_$PaymentModelImpl) then) =
      __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'order_id') String? orderId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'payment_method') String paymentMethod,
      double amount,
      @JsonKey(name: 'currency') String currency,
      @JsonKey(name: 'razorpay_payment_id') String? razorpayPaymentId,
      @JsonKey(name: 'razorpay_order_id') String? razorpayOrderId,
      @JsonKey(name: 'razorpay_signature') String? razorpaySignature,
      @JsonKey(name: 'qr_code_data') String? qrCodeData,
      @JsonKey(name: 'qr_payment_reference') String? qrPaymentReference,
      @JsonKey(name: 'qr_verified_by') String? qrVerifiedBy,
      String status,
      @JsonKey(name: 'failure_reason') String? failureReason,
      @JsonKey(name: 'refund_amount') double? refundAmount,
      @JsonKey(name: 'refund_id') String? refundId,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'processed_at') DateTime? processedAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
      _$PaymentModelImpl _value, $Res Function(_$PaymentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = freezed,
    Object? orderId = freezed,
    Object? userId = null,
    Object? vendorId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? currency = null,
    Object? razorpayPaymentId = freezed,
    Object? razorpayOrderId = freezed,
    Object? razorpaySignature = freezed,
    Object? qrCodeData = freezed,
    Object? qrPaymentReference = freezed,
    Object? qrVerifiedBy = freezed,
    Object? status = null,
    Object? failureReason = freezed,
    Object? refundAmount = freezed,
    Object? refundId = freezed,
    Object? metadata = freezed,
    Object? processedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PaymentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      razorpayPaymentId: freezed == razorpayPaymentId
          ? _value.razorpayPaymentId
          : razorpayPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      razorpayOrderId: freezed == razorpayOrderId
          ? _value.razorpayOrderId
          : razorpayOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      razorpaySignature: freezed == razorpaySignature
          ? _value.razorpaySignature
          : razorpaySignature // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeData: freezed == qrCodeData
          ? _value.qrCodeData
          : qrCodeData // ignore: cast_nullable_to_non_nullable
              as String?,
      qrPaymentReference: freezed == qrPaymentReference
          ? _value.qrPaymentReference
          : qrPaymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
      qrVerifiedBy: freezed == qrVerifiedBy
          ? _value.qrVerifiedBy
          : qrVerifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      refundId: freezed == refundId
          ? _value.refundId
          : refundId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentModelImpl implements _PaymentModel {
  const _$PaymentModelImpl(
      {required this.id,
      @JsonKey(name: 'booking_id') this.bookingId,
      @JsonKey(name: 'order_id') this.orderId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'payment_method') required this.paymentMethod,
      required this.amount,
      @JsonKey(name: 'currency') this.currency = 'INR',
      @JsonKey(name: 'razorpay_payment_id') this.razorpayPaymentId,
      @JsonKey(name: 'razorpay_order_id') this.razorpayOrderId,
      @JsonKey(name: 'razorpay_signature') this.razorpaySignature,
      @JsonKey(name: 'qr_code_data') this.qrCodeData,
      @JsonKey(name: 'qr_payment_reference') this.qrPaymentReference,
      @JsonKey(name: 'qr_verified_by') this.qrVerifiedBy,
      this.status = 'pending',
      @JsonKey(name: 'failure_reason') this.failureReason,
      @JsonKey(name: 'refund_amount') this.refundAmount,
      @JsonKey(name: 'refund_id') this.refundId,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'processed_at') this.processedAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _metadata = metadata;

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'booking_id')
  final String? bookingId;
  @override
  @JsonKey(name: 'order_id')
  final String? orderId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
// Payment Details
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
// 'razorpay' or 'sylonow_qr'
  @override
  final double amount;
  @override
  @JsonKey(name: 'currency')
  final String currency;
// Razorpay specific fields
  @override
  @JsonKey(name: 'razorpay_payment_id')
  final String? razorpayPaymentId;
  @override
  @JsonKey(name: 'razorpay_order_id')
  final String? razorpayOrderId;
  @override
  @JsonKey(name: 'razorpay_signature')
  final String? razorpaySignature;
// Sylonow QR specific fields
  @override
  @JsonKey(name: 'qr_code_data')
  final String? qrCodeData;
  @override
  @JsonKey(name: 'qr_payment_reference')
  final String? qrPaymentReference;
  @override
  @JsonKey(name: 'qr_verified_by')
  final String? qrVerifiedBy;
// Admin/system who verified the QR payment
// Payment Status
  @override
  @JsonKey()
  final String status;
// pending, processing, completed, failed, refunded
  @override
  @JsonKey(name: 'failure_reason')
  final String? failureReason;
  @override
  @JsonKey(name: 'refund_amount')
  final double? refundAmount;
  @override
  @JsonKey(name: 'refund_id')
  final String? refundId;
// Additional Information
  final Map<String, dynamic>? _metadata;
// Additional Information
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Timestamps
  @override
  @JsonKey(name: 'processed_at')
  final DateTime? processedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PaymentModel(id: $id, bookingId: $bookingId, orderId: $orderId, userId: $userId, vendorId: $vendorId, paymentMethod: $paymentMethod, amount: $amount, currency: $currency, razorpayPaymentId: $razorpayPaymentId, razorpayOrderId: $razorpayOrderId, razorpaySignature: $razorpaySignature, qrCodeData: $qrCodeData, qrPaymentReference: $qrPaymentReference, qrVerifiedBy: $qrVerifiedBy, status: $status, failureReason: $failureReason, refundAmount: $refundAmount, refundId: $refundId, metadata: $metadata, processedAt: $processedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.razorpayPaymentId, razorpayPaymentId) ||
                other.razorpayPaymentId == razorpayPaymentId) &&
            (identical(other.razorpayOrderId, razorpayOrderId) ||
                other.razorpayOrderId == razorpayOrderId) &&
            (identical(other.razorpaySignature, razorpaySignature) ||
                other.razorpaySignature == razorpaySignature) &&
            (identical(other.qrCodeData, qrCodeData) ||
                other.qrCodeData == qrCodeData) &&
            (identical(other.qrPaymentReference, qrPaymentReference) ||
                other.qrPaymentReference == qrPaymentReference) &&
            (identical(other.qrVerifiedBy, qrVerifiedBy) ||
                other.qrVerifiedBy == qrVerifiedBy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.failureReason, failureReason) ||
                other.failureReason == failureReason) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount) &&
            (identical(other.refundId, refundId) ||
                other.refundId == refundId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        bookingId,
        orderId,
        userId,
        vendorId,
        paymentMethod,
        amount,
        currency,
        razorpayPaymentId,
        razorpayOrderId,
        razorpaySignature,
        qrCodeData,
        qrPaymentReference,
        qrVerifiedBy,
        status,
        failureReason,
        refundAmount,
        refundId,
        const DeepCollectionEquality().hash(_metadata),
        processedAt,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentModel implements PaymentModel {
  const factory _PaymentModel(
      {required final String id,
      @JsonKey(name: 'booking_id') final String? bookingId,
      @JsonKey(name: 'order_id') final String? orderId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'vendor_id') required final String vendorId,
      @JsonKey(name: 'payment_method') required final String paymentMethod,
      required final double amount,
      @JsonKey(name: 'currency') final String currency,
      @JsonKey(name: 'razorpay_payment_id') final String? razorpayPaymentId,
      @JsonKey(name: 'razorpay_order_id') final String? razorpayOrderId,
      @JsonKey(name: 'razorpay_signature') final String? razorpaySignature,
      @JsonKey(name: 'qr_code_data') final String? qrCodeData,
      @JsonKey(name: 'qr_payment_reference') final String? qrPaymentReference,
      @JsonKey(name: 'qr_verified_by') final String? qrVerifiedBy,
      final String status,
      @JsonKey(name: 'failure_reason') final String? failureReason,
      @JsonKey(name: 'refund_amount') final double? refundAmount,
      @JsonKey(name: 'refund_id') final String? refundId,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'processed_at') final DateTime? processedAt,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$PaymentModelImpl;

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'booking_id')
  String? get bookingId;
  @override
  @JsonKey(name: 'order_id')
  String? get orderId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override // Payment Details
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override // 'razorpay' or 'sylonow_qr'
  double get amount;
  @override
  @JsonKey(name: 'currency')
  String get currency;
  @override // Razorpay specific fields
  @JsonKey(name: 'razorpay_payment_id')
  String? get razorpayPaymentId;
  @override
  @JsonKey(name: 'razorpay_order_id')
  String? get razorpayOrderId;
  @override
  @JsonKey(name: 'razorpay_signature')
  String? get razorpaySignature;
  @override // Sylonow QR specific fields
  @JsonKey(name: 'qr_code_data')
  String? get qrCodeData;
  @override
  @JsonKey(name: 'qr_payment_reference')
  String? get qrPaymentReference;
  @override
  @JsonKey(name: 'qr_verified_by')
  String? get qrVerifiedBy;
  @override // Admin/system who verified the QR payment
// Payment Status
  String get status;
  @override // pending, processing, completed, failed, refunded
  @JsonKey(name: 'failure_reason')
  String? get failureReason;
  @override
  @JsonKey(name: 'refund_amount')
  double? get refundAmount;
  @override
  @JsonKey(name: 'refund_id')
  String? get refundId;
  @override // Additional Information
  Map<String, dynamic>? get metadata;
  @override // Timestamps
  @JsonKey(name: 'processed_at')
  DateTime? get processedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentSummaryModel _$PaymentSummaryModelFromJson(Map<String, dynamic> json) {
  return _PaymentSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentSummaryModel {
  @JsonKey(name: 'booking_id')
  String get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'razorpay_amount')
  double get razorpayAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'sylonow_qr_amount')
  double get sylonowQrAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'razorpay_status')
  String get razorpayStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'sylonow_qr_status')
  String get sylonowQrStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'overall_status')
  String get overallStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'razorpay_payment')
  PaymentModel? get razorpayPayment => throw _privateConstructorUsedError;
  @JsonKey(name: 'sylonow_qr_payment')
  PaymentModel? get sylonowQrPayment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentSummaryModelCopyWith<PaymentSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentSummaryModelCopyWith<$Res> {
  factory $PaymentSummaryModelCopyWith(
          PaymentSummaryModel value, $Res Function(PaymentSummaryModel) then) =
      _$PaymentSummaryModelCopyWithImpl<$Res, PaymentSummaryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'razorpay_amount') double razorpayAmount,
      @JsonKey(name: 'sylonow_qr_amount') double sylonowQrAmount,
      @JsonKey(name: 'razorpay_status') String razorpayStatus,
      @JsonKey(name: 'sylonow_qr_status') String sylonowQrStatus,
      @JsonKey(name: 'overall_status') String overallStatus,
      @JsonKey(name: 'razorpay_payment') PaymentModel? razorpayPayment,
      @JsonKey(name: 'sylonow_qr_payment') PaymentModel? sylonowQrPayment});

  $PaymentModelCopyWith<$Res>? get razorpayPayment;
  $PaymentModelCopyWith<$Res>? get sylonowQrPayment;
}

/// @nodoc
class _$PaymentSummaryModelCopyWithImpl<$Res, $Val extends PaymentSummaryModel>
    implements $PaymentSummaryModelCopyWith<$Res> {
  _$PaymentSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? totalAmount = null,
    Object? razorpayAmount = null,
    Object? sylonowQrAmount = null,
    Object? razorpayStatus = null,
    Object? sylonowQrStatus = null,
    Object? overallStatus = null,
    Object? razorpayPayment = freezed,
    Object? sylonowQrPayment = freezed,
  }) {
    return _then(_value.copyWith(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      razorpayAmount: null == razorpayAmount
          ? _value.razorpayAmount
          : razorpayAmount // ignore: cast_nullable_to_non_nullable
              as double,
      sylonowQrAmount: null == sylonowQrAmount
          ? _value.sylonowQrAmount
          : sylonowQrAmount // ignore: cast_nullable_to_non_nullable
              as double,
      razorpayStatus: null == razorpayStatus
          ? _value.razorpayStatus
          : razorpayStatus // ignore: cast_nullable_to_non_nullable
              as String,
      sylonowQrStatus: null == sylonowQrStatus
          ? _value.sylonowQrStatus
          : sylonowQrStatus // ignore: cast_nullable_to_non_nullable
              as String,
      overallStatus: null == overallStatus
          ? _value.overallStatus
          : overallStatus // ignore: cast_nullable_to_non_nullable
              as String,
      razorpayPayment: freezed == razorpayPayment
          ? _value.razorpayPayment
          : razorpayPayment // ignore: cast_nullable_to_non_nullable
              as PaymentModel?,
      sylonowQrPayment: freezed == sylonowQrPayment
          ? _value.sylonowQrPayment
          : sylonowQrPayment // ignore: cast_nullable_to_non_nullable
              as PaymentModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaymentModelCopyWith<$Res>? get razorpayPayment {
    if (_value.razorpayPayment == null) {
      return null;
    }

    return $PaymentModelCopyWith<$Res>(_value.razorpayPayment!, (value) {
      return _then(_value.copyWith(razorpayPayment: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PaymentModelCopyWith<$Res>? get sylonowQrPayment {
    if (_value.sylonowQrPayment == null) {
      return null;
    }

    return $PaymentModelCopyWith<$Res>(_value.sylonowQrPayment!, (value) {
      return _then(_value.copyWith(sylonowQrPayment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentSummaryModelImplCopyWith<$Res>
    implements $PaymentSummaryModelCopyWith<$Res> {
  factory _$$PaymentSummaryModelImplCopyWith(_$PaymentSummaryModelImpl value,
          $Res Function(_$PaymentSummaryModelImpl) then) =
      __$$PaymentSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'razorpay_amount') double razorpayAmount,
      @JsonKey(name: 'sylonow_qr_amount') double sylonowQrAmount,
      @JsonKey(name: 'razorpay_status') String razorpayStatus,
      @JsonKey(name: 'sylonow_qr_status') String sylonowQrStatus,
      @JsonKey(name: 'overall_status') String overallStatus,
      @JsonKey(name: 'razorpay_payment') PaymentModel? razorpayPayment,
      @JsonKey(name: 'sylonow_qr_payment') PaymentModel? sylonowQrPayment});

  @override
  $PaymentModelCopyWith<$Res>? get razorpayPayment;
  @override
  $PaymentModelCopyWith<$Res>? get sylonowQrPayment;
}

/// @nodoc
class __$$PaymentSummaryModelImplCopyWithImpl<$Res>
    extends _$PaymentSummaryModelCopyWithImpl<$Res, _$PaymentSummaryModelImpl>
    implements _$$PaymentSummaryModelImplCopyWith<$Res> {
  __$$PaymentSummaryModelImplCopyWithImpl(_$PaymentSummaryModelImpl _value,
      $Res Function(_$PaymentSummaryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? totalAmount = null,
    Object? razorpayAmount = null,
    Object? sylonowQrAmount = null,
    Object? razorpayStatus = null,
    Object? sylonowQrStatus = null,
    Object? overallStatus = null,
    Object? razorpayPayment = freezed,
    Object? sylonowQrPayment = freezed,
  }) {
    return _then(_$PaymentSummaryModelImpl(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      razorpayAmount: null == razorpayAmount
          ? _value.razorpayAmount
          : razorpayAmount // ignore: cast_nullable_to_non_nullable
              as double,
      sylonowQrAmount: null == sylonowQrAmount
          ? _value.sylonowQrAmount
          : sylonowQrAmount // ignore: cast_nullable_to_non_nullable
              as double,
      razorpayStatus: null == razorpayStatus
          ? _value.razorpayStatus
          : razorpayStatus // ignore: cast_nullable_to_non_nullable
              as String,
      sylonowQrStatus: null == sylonowQrStatus
          ? _value.sylonowQrStatus
          : sylonowQrStatus // ignore: cast_nullable_to_non_nullable
              as String,
      overallStatus: null == overallStatus
          ? _value.overallStatus
          : overallStatus // ignore: cast_nullable_to_non_nullable
              as String,
      razorpayPayment: freezed == razorpayPayment
          ? _value.razorpayPayment
          : razorpayPayment // ignore: cast_nullable_to_non_nullable
              as PaymentModel?,
      sylonowQrPayment: freezed == sylonowQrPayment
          ? _value.sylonowQrPayment
          : sylonowQrPayment // ignore: cast_nullable_to_non_nullable
              as PaymentModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentSummaryModelImpl implements _PaymentSummaryModel {
  const _$PaymentSummaryModelImpl(
      {@JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'razorpay_amount') required this.razorpayAmount,
      @JsonKey(name: 'sylonow_qr_amount') required this.sylonowQrAmount,
      @JsonKey(name: 'razorpay_status') this.razorpayStatus = 'pending',
      @JsonKey(name: 'sylonow_qr_status') this.sylonowQrStatus = 'pending',
      @JsonKey(name: 'overall_status') this.overallStatus = 'pending',
      @JsonKey(name: 'razorpay_payment') this.razorpayPayment,
      @JsonKey(name: 'sylonow_qr_payment') this.sylonowQrPayment});

  factory _$PaymentSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentSummaryModelImplFromJson(json);

  @override
  @JsonKey(name: 'booking_id')
  final String bookingId;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'razorpay_amount')
  final double razorpayAmount;
  @override
  @JsonKey(name: 'sylonow_qr_amount')
  final double sylonowQrAmount;
  @override
  @JsonKey(name: 'razorpay_status')
  final String razorpayStatus;
  @override
  @JsonKey(name: 'sylonow_qr_status')
  final String sylonowQrStatus;
  @override
  @JsonKey(name: 'overall_status')
  final String overallStatus;
  @override
  @JsonKey(name: 'razorpay_payment')
  final PaymentModel? razorpayPayment;
  @override
  @JsonKey(name: 'sylonow_qr_payment')
  final PaymentModel? sylonowQrPayment;

  @override
  String toString() {
    return 'PaymentSummaryModel(bookingId: $bookingId, totalAmount: $totalAmount, razorpayAmount: $razorpayAmount, sylonowQrAmount: $sylonowQrAmount, razorpayStatus: $razorpayStatus, sylonowQrStatus: $sylonowQrStatus, overallStatus: $overallStatus, razorpayPayment: $razorpayPayment, sylonowQrPayment: $sylonowQrPayment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentSummaryModelImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.razorpayAmount, razorpayAmount) ||
                other.razorpayAmount == razorpayAmount) &&
            (identical(other.sylonowQrAmount, sylonowQrAmount) ||
                other.sylonowQrAmount == sylonowQrAmount) &&
            (identical(other.razorpayStatus, razorpayStatus) ||
                other.razorpayStatus == razorpayStatus) &&
            (identical(other.sylonowQrStatus, sylonowQrStatus) ||
                other.sylonowQrStatus == sylonowQrStatus) &&
            (identical(other.overallStatus, overallStatus) ||
                other.overallStatus == overallStatus) &&
            (identical(other.razorpayPayment, razorpayPayment) ||
                other.razorpayPayment == razorpayPayment) &&
            (identical(other.sylonowQrPayment, sylonowQrPayment) ||
                other.sylonowQrPayment == sylonowQrPayment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bookingId,
      totalAmount,
      razorpayAmount,
      sylonowQrAmount,
      razorpayStatus,
      sylonowQrStatus,
      overallStatus,
      razorpayPayment,
      sylonowQrPayment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentSummaryModelImplCopyWith<_$PaymentSummaryModelImpl> get copyWith =>
      __$$PaymentSummaryModelImplCopyWithImpl<_$PaymentSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentSummaryModel implements PaymentSummaryModel {
  const factory _PaymentSummaryModel(
      {@JsonKey(name: 'booking_id') required final String bookingId,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      @JsonKey(name: 'razorpay_amount') required final double razorpayAmount,
      @JsonKey(name: 'sylonow_qr_amount') required final double sylonowQrAmount,
      @JsonKey(name: 'razorpay_status') final String razorpayStatus,
      @JsonKey(name: 'sylonow_qr_status') final String sylonowQrStatus,
      @JsonKey(name: 'overall_status') final String overallStatus,
      @JsonKey(name: 'razorpay_payment') final PaymentModel? razorpayPayment,
      @JsonKey(name: 'sylonow_qr_payment')
      final PaymentModel? sylonowQrPayment}) = _$PaymentSummaryModelImpl;

  factory _PaymentSummaryModel.fromJson(Map<String, dynamic> json) =
      _$PaymentSummaryModelImpl.fromJson;

  @override
  @JsonKey(name: 'booking_id')
  String get bookingId;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'razorpay_amount')
  double get razorpayAmount;
  @override
  @JsonKey(name: 'sylonow_qr_amount')
  double get sylonowQrAmount;
  @override
  @JsonKey(name: 'razorpay_status')
  String get razorpayStatus;
  @override
  @JsonKey(name: 'sylonow_qr_status')
  String get sylonowQrStatus;
  @override
  @JsonKey(name: 'overall_status')
  String get overallStatus;
  @override
  @JsonKey(name: 'razorpay_payment')
  PaymentModel? get razorpayPayment;
  @override
  @JsonKey(name: 'sylonow_qr_payment')
  PaymentModel? get sylonowQrPayment;
  @override
  @JsonKey(ignore: true)
  _$$PaymentSummaryModelImplCopyWith<_$PaymentSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
