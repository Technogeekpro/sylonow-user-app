// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_listing_id')
  String get serviceListingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_title')
  String get serviceTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_description')
  String? get serviceDescription =>
      throw _privateConstructorUsedError; // Time and Date Information
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_time')
  String get bookingTime =>
      throw _privateConstructorUsedError; // Time slot (e.g., "14:00-16:00")
  @JsonKey(name: 'inquiry_time')
  DateTime get inquiryTime =>
      throw _privateConstructorUsedError; // When service provider was available for inquiry
  @JsonKey(name: 'duration_hours')
  int get durationHours =>
      throw _privateConstructorUsedError; // Customer Information
  @JsonKey(name: 'customer_name')
  String get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String get customerPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_email')
  String? get customerEmail =>
      throw _privateConstructorUsedError; // Address Information
  @JsonKey(name: 'venue_address')
  String get venueAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'venue_coordinates')
  Map<String, dynamic>? get venueCoordinates =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'special_requirements')
  String? get specialRequirements =>
      throw _privateConstructorUsedError; // Pricing Information
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'razorpay_amount')
  double get razorpayAmount =>
      throw _privateConstructorUsedError; // 60% of total
  @JsonKey(name: 'sylonow_qr_amount')
  double get sylonowQrAmount =>
      throw _privateConstructorUsedError; // 40% of total
// Payment Information
  @JsonKey(name: 'razorpay_payment_id')
  String? get razorpayPaymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'razorpay_order_id')
  String? get razorpayOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sylonow_qr_payment_id')
  String? get sylonowQrPaymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus =>
      throw _privateConstructorUsedError; // pending, partial, completed, failed
// Booking Status
  String get status =>
      throw _privateConstructorUsedError; // pending, confirmed, in_progress, completed, cancelled
  @JsonKey(name: 'vendor_confirmation')
  bool get vendorConfirmation => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_sent')
  bool get notificationSent =>
      throw _privateConstructorUsedError; // Additional Information
  @JsonKey(name: 'add_ons')
  List<Map<String, dynamic>>? get addOns => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata =>
      throw _privateConstructorUsedError; // Timestamps
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
          BookingModel value, $Res Function(BookingModel) then) =
      _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'service_listing_id') String serviceListingId,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'service_description') String? serviceDescription,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'booking_time') String bookingTime,
      @JsonKey(name: 'inquiry_time') DateTime inquiryTime,
      @JsonKey(name: 'duration_hours') int durationHours,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String customerPhone,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'venue_address') String venueAddress,
      @JsonKey(name: 'venue_coordinates')
      Map<String, dynamic>? venueCoordinates,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'razorpay_amount') double razorpayAmount,
      @JsonKey(name: 'sylonow_qr_amount') double sylonowQrAmount,
      @JsonKey(name: 'razorpay_payment_id') String? razorpayPaymentId,
      @JsonKey(name: 'razorpay_order_id') String? razorpayOrderId,
      @JsonKey(name: 'sylonow_qr_payment_id') String? sylonowQrPaymentId,
      @JsonKey(name: 'payment_status') String paymentStatus,
      String status,
      @JsonKey(name: 'vendor_confirmation') bool vendorConfirmation,
      @JsonKey(name: 'notification_sent') bool notificationSent,
      @JsonKey(name: 'add_ons') List<Map<String, dynamic>>? addOns,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt});
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? vendorId = null,
    Object? serviceListingId = null,
    Object? serviceTitle = null,
    Object? serviceDescription = freezed,
    Object? bookingDate = null,
    Object? bookingTime = null,
    Object? inquiryTime = null,
    Object? durationHours = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? customerEmail = freezed,
    Object? venueAddress = null,
    Object? venueCoordinates = freezed,
    Object? specialRequirements = freezed,
    Object? totalAmount = null,
    Object? razorpayAmount = null,
    Object? sylonowQrAmount = null,
    Object? razorpayPaymentId = freezed,
    Object? razorpayOrderId = freezed,
    Object? sylonowQrPaymentId = freezed,
    Object? paymentStatus = null,
    Object? status = null,
    Object? vendorConfirmation = null,
    Object? notificationSent = null,
    Object? addOns = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? confirmedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceListingId: null == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceTitle: null == serviceTitle
          ? _value.serviceTitle
          : serviceTitle // ignore: cast_nullable_to_non_nullable
              as String,
      serviceDescription: freezed == serviceDescription
          ? _value.serviceDescription
          : serviceDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingTime: null == bookingTime
          ? _value.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as String,
      inquiryTime: null == inquiryTime
          ? _value.inquiryTime
          : inquiryTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationHours: null == durationHours
          ? _value.durationHours
          : durationHours // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      venueAddress: null == venueAddress
          ? _value.venueAddress
          : venueAddress // ignore: cast_nullable_to_non_nullable
              as String,
      venueCoordinates: freezed == venueCoordinates
          ? _value.venueCoordinates
          : venueCoordinates // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      specialRequirements: freezed == specialRequirements
          ? _value.specialRequirements
          : specialRequirements // ignore: cast_nullable_to_non_nullable
              as String?,
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
      razorpayPaymentId: freezed == razorpayPaymentId
          ? _value.razorpayPaymentId
          : razorpayPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      razorpayOrderId: freezed == razorpayOrderId
          ? _value.razorpayOrderId
          : razorpayOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      sylonowQrPaymentId: freezed == sylonowQrPaymentId
          ? _value.sylonowQrPaymentId
          : sylonowQrPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      vendorConfirmation: null == vendorConfirmation
          ? _value.vendorConfirmation
          : vendorConfirmation // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationSent: null == notificationSent
          ? _value.notificationSent
          : notificationSent // ignore: cast_nullable_to_non_nullable
              as bool,
      addOns: freezed == addOns
          ? _value.addOns
          : addOns // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
          _$BookingModelImpl value, $Res Function(_$BookingModelImpl) then) =
      __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'service_listing_id') String serviceListingId,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'service_description') String? serviceDescription,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'booking_time') String bookingTime,
      @JsonKey(name: 'inquiry_time') DateTime inquiryTime,
      @JsonKey(name: 'duration_hours') int durationHours,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String customerPhone,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'venue_address') String venueAddress,
      @JsonKey(name: 'venue_coordinates')
      Map<String, dynamic>? venueCoordinates,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'razorpay_amount') double razorpayAmount,
      @JsonKey(name: 'sylonow_qr_amount') double sylonowQrAmount,
      @JsonKey(name: 'razorpay_payment_id') String? razorpayPaymentId,
      @JsonKey(name: 'razorpay_order_id') String? razorpayOrderId,
      @JsonKey(name: 'sylonow_qr_payment_id') String? sylonowQrPaymentId,
      @JsonKey(name: 'payment_status') String paymentStatus,
      String status,
      @JsonKey(name: 'vendor_confirmation') bool vendorConfirmation,
      @JsonKey(name: 'notification_sent') bool notificationSent,
      @JsonKey(name: 'add_ons') List<Map<String, dynamic>>? addOns,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt});
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
      _$BookingModelImpl _value, $Res Function(_$BookingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? vendorId = null,
    Object? serviceListingId = null,
    Object? serviceTitle = null,
    Object? serviceDescription = freezed,
    Object? bookingDate = null,
    Object? bookingTime = null,
    Object? inquiryTime = null,
    Object? durationHours = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? customerEmail = freezed,
    Object? venueAddress = null,
    Object? venueCoordinates = freezed,
    Object? specialRequirements = freezed,
    Object? totalAmount = null,
    Object? razorpayAmount = null,
    Object? sylonowQrAmount = null,
    Object? razorpayPaymentId = freezed,
    Object? razorpayOrderId = freezed,
    Object? sylonowQrPaymentId = freezed,
    Object? paymentStatus = null,
    Object? status = null,
    Object? vendorConfirmation = null,
    Object? notificationSent = null,
    Object? addOns = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? confirmedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$BookingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceListingId: null == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceTitle: null == serviceTitle
          ? _value.serviceTitle
          : serviceTitle // ignore: cast_nullable_to_non_nullable
              as String,
      serviceDescription: freezed == serviceDescription
          ? _value.serviceDescription
          : serviceDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingTime: null == bookingTime
          ? _value.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as String,
      inquiryTime: null == inquiryTime
          ? _value.inquiryTime
          : inquiryTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationHours: null == durationHours
          ? _value.durationHours
          : durationHours // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      venueAddress: null == venueAddress
          ? _value.venueAddress
          : venueAddress // ignore: cast_nullable_to_non_nullable
              as String,
      venueCoordinates: freezed == venueCoordinates
          ? _value._venueCoordinates
          : venueCoordinates // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      specialRequirements: freezed == specialRequirements
          ? _value.specialRequirements
          : specialRequirements // ignore: cast_nullable_to_non_nullable
              as String?,
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
      razorpayPaymentId: freezed == razorpayPaymentId
          ? _value.razorpayPaymentId
          : razorpayPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      razorpayOrderId: freezed == razorpayOrderId
          ? _value.razorpayOrderId
          : razorpayOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      sylonowQrPaymentId: freezed == sylonowQrPaymentId
          ? _value.sylonowQrPaymentId
          : sylonowQrPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      vendorConfirmation: null == vendorConfirmation
          ? _value.vendorConfirmation
          : vendorConfirmation // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationSent: null == notificationSent
          ? _value.notificationSent
          : notificationSent // ignore: cast_nullable_to_non_nullable
              as bool,
      addOns: freezed == addOns
          ? _value._addOns
          : addOns // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingModelImpl implements _BookingModel {
  const _$BookingModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'service_listing_id') required this.serviceListingId,
      @JsonKey(name: 'service_title') required this.serviceTitle,
      @JsonKey(name: 'service_description') this.serviceDescription,
      @JsonKey(name: 'booking_date') required this.bookingDate,
      @JsonKey(name: 'booking_time') required this.bookingTime,
      @JsonKey(name: 'inquiry_time') required this.inquiryTime,
      @JsonKey(name: 'duration_hours') required this.durationHours,
      @JsonKey(name: 'customer_name') required this.customerName,
      @JsonKey(name: 'customer_phone') required this.customerPhone,
      @JsonKey(name: 'customer_email') this.customerEmail,
      @JsonKey(name: 'venue_address') required this.venueAddress,
      @JsonKey(name: 'venue_coordinates')
      final Map<String, dynamic>? venueCoordinates,
      @JsonKey(name: 'special_requirements') this.specialRequirements,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'razorpay_amount') required this.razorpayAmount,
      @JsonKey(name: 'sylonow_qr_amount') required this.sylonowQrAmount,
      @JsonKey(name: 'razorpay_payment_id') this.razorpayPaymentId,
      @JsonKey(name: 'razorpay_order_id') this.razorpayOrderId,
      @JsonKey(name: 'sylonow_qr_payment_id') this.sylonowQrPaymentId,
      @JsonKey(name: 'payment_status') this.paymentStatus = 'pending',
      this.status = 'pending',
      @JsonKey(name: 'vendor_confirmation') this.vendorConfirmation = false,
      @JsonKey(name: 'notification_sent') this.notificationSent = false,
      @JsonKey(name: 'add_ons') final List<Map<String, dynamic>>? addOns,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'confirmed_at') this.confirmedAt,
      @JsonKey(name: 'completed_at') this.completedAt})
      : _venueCoordinates = venueCoordinates,
        _addOns = addOns,
        _metadata = metadata;

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  @JsonKey(name: 'service_listing_id')
  final String serviceListingId;
  @override
  @JsonKey(name: 'service_title')
  final String serviceTitle;
  @override
  @JsonKey(name: 'service_description')
  final String? serviceDescription;
// Time and Date Information
  @override
  @JsonKey(name: 'booking_date')
  final DateTime bookingDate;
  @override
  @JsonKey(name: 'booking_time')
  final String bookingTime;
// Time slot (e.g., "14:00-16:00")
  @override
  @JsonKey(name: 'inquiry_time')
  final DateTime inquiryTime;
// When service provider was available for inquiry
  @override
  @JsonKey(name: 'duration_hours')
  final int durationHours;
// Customer Information
  @override
  @JsonKey(name: 'customer_name')
  final String customerName;
  @override
  @JsonKey(name: 'customer_phone')
  final String customerPhone;
  @override
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
// Address Information
  @override
  @JsonKey(name: 'venue_address')
  final String venueAddress;
  final Map<String, dynamic>? _venueCoordinates;
  @override
  @JsonKey(name: 'venue_coordinates')
  Map<String, dynamic>? get venueCoordinates {
    final value = _venueCoordinates;
    if (value == null) return null;
    if (_venueCoordinates is EqualUnmodifiableMapView) return _venueCoordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'special_requirements')
  final String? specialRequirements;
// Pricing Information
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'razorpay_amount')
  final double razorpayAmount;
// 60% of total
  @override
  @JsonKey(name: 'sylonow_qr_amount')
  final double sylonowQrAmount;
// 40% of total
// Payment Information
  @override
  @JsonKey(name: 'razorpay_payment_id')
  final String? razorpayPaymentId;
  @override
  @JsonKey(name: 'razorpay_order_id')
  final String? razorpayOrderId;
  @override
  @JsonKey(name: 'sylonow_qr_payment_id')
  final String? sylonowQrPaymentId;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
// pending, partial, completed, failed
// Booking Status
  @override
  @JsonKey()
  final String status;
// pending, confirmed, in_progress, completed, cancelled
  @override
  @JsonKey(name: 'vendor_confirmation')
  final bool vendorConfirmation;
  @override
  @JsonKey(name: 'notification_sent')
  final bool notificationSent;
// Additional Information
  final List<Map<String, dynamic>>? _addOns;
// Additional Information
  @override
  @JsonKey(name: 'add_ons')
  List<Map<String, dynamic>>? get addOns {
    final value = _addOns;
    if (value == null) return null;
    if (_addOns is EqualUnmodifiableListView) return _addOns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _metadata;
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
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'confirmed_at')
  final DateTime? confirmedAt;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @override
  String toString() {
    return 'BookingModel(id: $id, userId: $userId, vendorId: $vendorId, serviceListingId: $serviceListingId, serviceTitle: $serviceTitle, serviceDescription: $serviceDescription, bookingDate: $bookingDate, bookingTime: $bookingTime, inquiryTime: $inquiryTime, durationHours: $durationHours, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, venueAddress: $venueAddress, venueCoordinates: $venueCoordinates, specialRequirements: $specialRequirements, totalAmount: $totalAmount, razorpayAmount: $razorpayAmount, sylonowQrAmount: $sylonowQrAmount, razorpayPaymentId: $razorpayPaymentId, razorpayOrderId: $razorpayOrderId, sylonowQrPaymentId: $sylonowQrPaymentId, paymentStatus: $paymentStatus, status: $status, vendorConfirmation: $vendorConfirmation, notificationSent: $notificationSent, addOns: $addOns, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, confirmedAt: $confirmedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.serviceListingId, serviceListingId) ||
                other.serviceListingId == serviceListingId) &&
            (identical(other.serviceTitle, serviceTitle) ||
                other.serviceTitle == serviceTitle) &&
            (identical(other.serviceDescription, serviceDescription) ||
                other.serviceDescription == serviceDescription) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.bookingTime, bookingTime) ||
                other.bookingTime == bookingTime) &&
            (identical(other.inquiryTime, inquiryTime) ||
                other.inquiryTime == inquiryTime) &&
            (identical(other.durationHours, durationHours) ||
                other.durationHours == durationHours) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.venueAddress, venueAddress) ||
                other.venueAddress == venueAddress) &&
            const DeepCollectionEquality()
                .equals(other._venueCoordinates, _venueCoordinates) &&
            (identical(other.specialRequirements, specialRequirements) ||
                other.specialRequirements == specialRequirements) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.razorpayAmount, razorpayAmount) ||
                other.razorpayAmount == razorpayAmount) &&
            (identical(other.sylonowQrAmount, sylonowQrAmount) ||
                other.sylonowQrAmount == sylonowQrAmount) &&
            (identical(other.razorpayPaymentId, razorpayPaymentId) ||
                other.razorpayPaymentId == razorpayPaymentId) &&
            (identical(other.razorpayOrderId, razorpayOrderId) ||
                other.razorpayOrderId == razorpayOrderId) &&
            (identical(other.sylonowQrPaymentId, sylonowQrPaymentId) ||
                other.sylonowQrPaymentId == sylonowQrPaymentId) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.vendorConfirmation, vendorConfirmation) ||
                other.vendorConfirmation == vendorConfirmation) &&
            (identical(other.notificationSent, notificationSent) ||
                other.notificationSent == notificationSent) &&
            const DeepCollectionEquality().equals(other._addOns, _addOns) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        vendorId,
        serviceListingId,
        serviceTitle,
        serviceDescription,
        bookingDate,
        bookingTime,
        inquiryTime,
        durationHours,
        customerName,
        customerPhone,
        customerEmail,
        venueAddress,
        const DeepCollectionEquality().hash(_venueCoordinates),
        specialRequirements,
        totalAmount,
        razorpayAmount,
        sylonowQrAmount,
        razorpayPaymentId,
        razorpayOrderId,
        sylonowQrPaymentId,
        paymentStatus,
        status,
        vendorConfirmation,
        notificationSent,
        const DeepCollectionEquality().hash(_addOns),
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt,
        confirmedAt,
        completedAt
      ]);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(
      this,
    );
  }
}

abstract class _BookingModel implements BookingModel {
  const factory _BookingModel(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'vendor_id') required final String vendorId,
      @JsonKey(name: 'service_listing_id')
      required final String serviceListingId,
      @JsonKey(name: 'service_title') required final String serviceTitle,
      @JsonKey(name: 'service_description') final String? serviceDescription,
      @JsonKey(name: 'booking_date') required final DateTime bookingDate,
      @JsonKey(name: 'booking_time') required final String bookingTime,
      @JsonKey(name: 'inquiry_time') required final DateTime inquiryTime,
      @JsonKey(name: 'duration_hours') required final int durationHours,
      @JsonKey(name: 'customer_name') required final String customerName,
      @JsonKey(name: 'customer_phone') required final String customerPhone,
      @JsonKey(name: 'customer_email') final String? customerEmail,
      @JsonKey(name: 'venue_address') required final String venueAddress,
      @JsonKey(name: 'venue_coordinates')
      final Map<String, dynamic>? venueCoordinates,
      @JsonKey(name: 'special_requirements') final String? specialRequirements,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      @JsonKey(name: 'razorpay_amount') required final double razorpayAmount,
      @JsonKey(name: 'sylonow_qr_amount') required final double sylonowQrAmount,
      @JsonKey(name: 'razorpay_payment_id') final String? razorpayPaymentId,
      @JsonKey(name: 'razorpay_order_id') final String? razorpayOrderId,
      @JsonKey(name: 'sylonow_qr_payment_id') final String? sylonowQrPaymentId,
      @JsonKey(name: 'payment_status') final String paymentStatus,
      final String status,
      @JsonKey(name: 'vendor_confirmation') final bool vendorConfirmation,
      @JsonKey(name: 'notification_sent') final bool notificationSent,
      @JsonKey(name: 'add_ons') final List<Map<String, dynamic>>? addOns,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'confirmed_at') final DateTime? confirmedAt,
      @JsonKey(name: 'completed_at')
      final DateTime? completedAt}) = _$BookingModelImpl;

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  @JsonKey(name: 'service_listing_id')
  String get serviceListingId;
  @override
  @JsonKey(name: 'service_title')
  String get serviceTitle;
  @override
  @JsonKey(name: 'service_description')
  String? get serviceDescription; // Time and Date Information
  @override
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate;
  @override
  @JsonKey(name: 'booking_time')
  String get bookingTime; // Time slot (e.g., "14:00-16:00")
  @override
  @JsonKey(name: 'inquiry_time')
  DateTime get inquiryTime; // When service provider was available for inquiry
  @override
  @JsonKey(name: 'duration_hours')
  int get durationHours; // Customer Information
  @override
  @JsonKey(name: 'customer_name')
  String get customerName;
  @override
  @JsonKey(name: 'customer_phone')
  String get customerPhone;
  @override
  @JsonKey(name: 'customer_email')
  String? get customerEmail; // Address Information
  @override
  @JsonKey(name: 'venue_address')
  String get venueAddress;
  @override
  @JsonKey(name: 'venue_coordinates')
  Map<String, dynamic>? get venueCoordinates;
  @override
  @JsonKey(name: 'special_requirements')
  String? get specialRequirements; // Pricing Information
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'razorpay_amount')
  double get razorpayAmount; // 60% of total
  @override
  @JsonKey(name: 'sylonow_qr_amount')
  double get sylonowQrAmount; // 40% of total
// Payment Information
  @override
  @JsonKey(name: 'razorpay_payment_id')
  String? get razorpayPaymentId;
  @override
  @JsonKey(name: 'razorpay_order_id')
  String? get razorpayOrderId;
  @override
  @JsonKey(name: 'sylonow_qr_payment_id')
  String? get sylonowQrPaymentId;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus; // pending, partial, completed, failed
// Booking Status
  @override
  String get status; // pending, confirmed, in_progress, completed, cancelled
  @override
  @JsonKey(name: 'vendor_confirmation')
  bool get vendorConfirmation;
  @override
  @JsonKey(name: 'notification_sent')
  bool get notificationSent; // Additional Information
  @override
  @JsonKey(name: 'add_ons')
  List<Map<String, dynamic>>? get addOns;
  @override
  Map<String, dynamic>? get metadata; // Timestamps
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) {
  return _TimeSlotModel.fromJson(json);
}

/// @nodoc
mixin _$TimeSlotModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_listing_id')
  String get serviceListingId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError; // "14:00"
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError; // "16:00"
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_blocked')
  bool get isBlocked =>
      throw _privateConstructorUsedError; // Manually blocked by vendor
  @JsonKey(name: 'booking_id')
  String? get bookingId =>
      throw _privateConstructorUsedError; // If booked, reference to booking
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TimeSlotModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotModelCopyWith<TimeSlotModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotModelCopyWith<$Res> {
  factory $TimeSlotModelCopyWith(
          TimeSlotModel value, $Res Function(TimeSlotModel) then) =
      _$TimeSlotModelCopyWithImpl<$Res, TimeSlotModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'service_listing_id') String serviceListingId,
      DateTime date,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'is_blocked') bool isBlocked,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$TimeSlotModelCopyWithImpl<$Res, $Val extends TimeSlotModel>
    implements $TimeSlotModelCopyWith<$Res> {
  _$TimeSlotModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? serviceListingId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAvailable = null,
    Object? isBlocked = null,
    Object? bookingId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceListingId: null == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$TimeSlotModelImplCopyWith<$Res>
    implements $TimeSlotModelCopyWith<$Res> {
  factory _$$TimeSlotModelImplCopyWith(
          _$TimeSlotModelImpl value, $Res Function(_$TimeSlotModelImpl) then) =
      __$$TimeSlotModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'service_listing_id') String serviceListingId,
      DateTime date,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'is_blocked') bool isBlocked,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$TimeSlotModelImplCopyWithImpl<$Res>
    extends _$TimeSlotModelCopyWithImpl<$Res, _$TimeSlotModelImpl>
    implements _$$TimeSlotModelImplCopyWith<$Res> {
  __$$TimeSlotModelImplCopyWithImpl(
      _$TimeSlotModelImpl _value, $Res Function(_$TimeSlotModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? serviceListingId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAvailable = null,
    Object? isBlocked = null,
    Object? bookingId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TimeSlotModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceListingId: null == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$TimeSlotModelImpl implements _TimeSlotModel {
  const _$TimeSlotModelImpl(
      {required this.id,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'service_listing_id') required this.serviceListingId,
      required this.date,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(name: 'is_available') this.isAvailable = true,
      @JsonKey(name: 'is_blocked') this.isBlocked = false,
      @JsonKey(name: 'booking_id') this.bookingId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$TimeSlotModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSlotModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  @JsonKey(name: 'service_listing_id')
  final String serviceListingId;
  @override
  final DateTime date;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
// "14:00"
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
// "16:00"
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'is_blocked')
  final bool isBlocked;
// Manually blocked by vendor
  @override
  @JsonKey(name: 'booking_id')
  final String? bookingId;
// If booked, reference to booking
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TimeSlotModel(id: $id, vendorId: $vendorId, serviceListingId: $serviceListingId, date: $date, startTime: $startTime, endTime: $endTime, isAvailable: $isAvailable, isBlocked: $isBlocked, bookingId: $bookingId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.serviceListingId, serviceListingId) ||
                other.serviceListingId == serviceListingId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vendorId,
      serviceListingId,
      date,
      startTime,
      endTime,
      isAvailable,
      isBlocked,
      bookingId,
      createdAt,
      updatedAt);

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotModelImplCopyWith<_$TimeSlotModelImpl> get copyWith =>
      __$$TimeSlotModelImplCopyWithImpl<_$TimeSlotModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSlotModelImplToJson(
      this,
    );
  }
}

abstract class _TimeSlotModel implements TimeSlotModel {
  const factory _TimeSlotModel(
          {required final String id,
          @JsonKey(name: 'vendor_id') required final String vendorId,
          @JsonKey(name: 'service_listing_id')
          required final String serviceListingId,
          required final DateTime date,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') required final String endTime,
          @JsonKey(name: 'is_available') final bool isAvailable,
          @JsonKey(name: 'is_blocked') final bool isBlocked,
          @JsonKey(name: 'booking_id') final String? bookingId,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$TimeSlotModelImpl;

  factory _TimeSlotModel.fromJson(Map<String, dynamic> json) =
      _$TimeSlotModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  @JsonKey(name: 'service_listing_id')
  String get serviceListingId;
  @override
  DateTime get date;
  @override
  @JsonKey(name: 'start_time')
  String get startTime; // "14:00"
  @override
  @JsonKey(name: 'end_time')
  String get endTime; // "16:00"
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'is_blocked')
  bool get isBlocked; // Manually blocked by vendor
  @override
  @JsonKey(name: 'booking_id')
  String? get bookingId; // If booked, reference to booking
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotModelImplCopyWith<_$TimeSlotModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VendorInquiryTimeModel _$VendorInquiryTimeModelFromJson(
    Map<String, dynamic> json) {
  return _VendorInquiryTimeModel.fromJson(json);
}

/// @nodoc
mixin _$VendorInquiryTimeModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'inquiry_start_time')
  DateTime get inquiryStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'inquiry_end_time')
  DateTime? get inquiryEndTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VendorInquiryTimeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorInquiryTimeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorInquiryTimeModelCopyWith<VendorInquiryTimeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorInquiryTimeModelCopyWith<$Res> {
  factory $VendorInquiryTimeModelCopyWith(VendorInquiryTimeModel value,
          $Res Function(VendorInquiryTimeModel) then) =
      _$VendorInquiryTimeModelCopyWithImpl<$Res, VendorInquiryTimeModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'inquiry_start_time') DateTime inquiryStartTime,
      @JsonKey(name: 'inquiry_end_time') DateTime? inquiryEndTime,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$VendorInquiryTimeModelCopyWithImpl<$Res,
        $Val extends VendorInquiryTimeModel>
    implements $VendorInquiryTimeModelCopyWith<$Res> {
  _$VendorInquiryTimeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorInquiryTimeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? inquiryStartTime = null,
    Object? inquiryEndTime = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      inquiryStartTime: null == inquiryStartTime
          ? _value.inquiryStartTime
          : inquiryStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      inquiryEndTime: freezed == inquiryEndTime
          ? _value.inquiryEndTime
          : inquiryEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$VendorInquiryTimeModelImplCopyWith<$Res>
    implements $VendorInquiryTimeModelCopyWith<$Res> {
  factory _$$VendorInquiryTimeModelImplCopyWith(
          _$VendorInquiryTimeModelImpl value,
          $Res Function(_$VendorInquiryTimeModelImpl) then) =
      __$$VendorInquiryTimeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'inquiry_start_time') DateTime inquiryStartTime,
      @JsonKey(name: 'inquiry_end_time') DateTime? inquiryEndTime,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$VendorInquiryTimeModelImplCopyWithImpl<$Res>
    extends _$VendorInquiryTimeModelCopyWithImpl<$Res,
        _$VendorInquiryTimeModelImpl>
    implements _$$VendorInquiryTimeModelImplCopyWith<$Res> {
  __$$VendorInquiryTimeModelImplCopyWithImpl(
      _$VendorInquiryTimeModelImpl _value,
      $Res Function(_$VendorInquiryTimeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VendorInquiryTimeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? inquiryStartTime = null,
    Object? inquiryEndTime = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$VendorInquiryTimeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      inquiryStartTime: null == inquiryStartTime
          ? _value.inquiryStartTime
          : inquiryStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      inquiryEndTime: freezed == inquiryEndTime
          ? _value.inquiryEndTime
          : inquiryEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$VendorInquiryTimeModelImpl implements _VendorInquiryTimeModel {
  const _$VendorInquiryTimeModelImpl(
      {required this.id,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'inquiry_start_time') required this.inquiryStartTime,
      @JsonKey(name: 'inquiry_end_time') this.inquiryEndTime,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$VendorInquiryTimeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorInquiryTimeModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  @JsonKey(name: 'inquiry_start_time')
  final DateTime inquiryStartTime;
  @override
  @JsonKey(name: 'inquiry_end_time')
  final DateTime? inquiryEndTime;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'VendorInquiryTimeModel(id: $id, vendorId: $vendorId, inquiryStartTime: $inquiryStartTime, inquiryEndTime: $inquiryEndTime, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorInquiryTimeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.inquiryStartTime, inquiryStartTime) ||
                other.inquiryStartTime == inquiryStartTime) &&
            (identical(other.inquiryEndTime, inquiryEndTime) ||
                other.inquiryEndTime == inquiryEndTime) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, vendorId, inquiryStartTime,
      inquiryEndTime, isActive, createdAt, updatedAt);

  /// Create a copy of VendorInquiryTimeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorInquiryTimeModelImplCopyWith<_$VendorInquiryTimeModelImpl>
      get copyWith => __$$VendorInquiryTimeModelImplCopyWithImpl<
          _$VendorInquiryTimeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorInquiryTimeModelImplToJson(
      this,
    );
  }
}

abstract class _VendorInquiryTimeModel implements VendorInquiryTimeModel {
  const factory _VendorInquiryTimeModel(
          {required final String id,
          @JsonKey(name: 'vendor_id') required final String vendorId,
          @JsonKey(name: 'inquiry_start_time')
          required final DateTime inquiryStartTime,
          @JsonKey(name: 'inquiry_end_time') final DateTime? inquiryEndTime,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$VendorInquiryTimeModelImpl;

  factory _VendorInquiryTimeModel.fromJson(Map<String, dynamic> json) =
      _$VendorInquiryTimeModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  @JsonKey(name: 'inquiry_start_time')
  DateTime get inquiryStartTime;
  @override
  @JsonKey(name: 'inquiry_end_time')
  DateTime? get inquiryEndTime;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of VendorInquiryTimeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorInquiryTimeModelImplCopyWith<_$VendorInquiryTimeModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
