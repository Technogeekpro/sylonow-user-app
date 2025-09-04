// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String? get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String? get customerPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_email')
  String? get customerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_listing_id')
  String? get serviceListingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_title')
  String get serviceTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_description')
  String? get serviceDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_time')
  String? get bookingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'advance_amount')
  double get advanceAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_amount')
  double get remainingAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_requirements')
  String? get specialRequirements => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_id')
  String? get addressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'place_image_url')
  String? get placeImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_image_url')
  String? get serviceImageUrl =>
      throw _privateConstructorUsedError; // Address information from joined addresses table
  @JsonKey(name: 'address_full')
  String? get addressFull => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_area')
  String? get addressArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_nearby')
  String? get addressNearby => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_name')
  String? get addressName => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_floor')
  String? get addressFloor => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'service_listing_id') String? serviceListingId,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'service_description') String? serviceDescription,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'booking_time') String? bookingTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'advance_amount') double advanceAmount,
      @JsonKey(name: 'remaining_amount') double remainingAmount,
      String status,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'address_id') String? addressId,
      @JsonKey(name: 'place_image_url') String? placeImageUrl,
      @JsonKey(name: 'service_image_url') String? serviceImageUrl,
      @JsonKey(name: 'address_full') String? addressFull,
      @JsonKey(name: 'address_area') String? addressArea,
      @JsonKey(name: 'address_nearby') String? addressNearby,
      @JsonKey(name: 'address_name') String? addressName,
      @JsonKey(name: 'address_floor') String? addressFloor,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? vendorId = freezed,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? serviceListingId = freezed,
    Object? serviceTitle = null,
    Object? serviceDescription = freezed,
    Object? bookingDate = null,
    Object? bookingTime = freezed,
    Object? totalAmount = null,
    Object? advanceAmount = null,
    Object? remainingAmount = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? specialRequirements = freezed,
    Object? addressId = freezed,
    Object? placeImageUrl = freezed,
    Object? serviceImageUrl = freezed,
    Object? addressFull = freezed,
    Object? addressArea = freezed,
    Object? addressNearby = freezed,
    Object? addressName = freezed,
    Object? addressFloor = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceListingId: freezed == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      bookingTime: freezed == bookingTime
          ? _value.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      advanceAmount: null == advanceAmount
          ? _value.advanceAmount
          : advanceAmount // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      specialRequirements: freezed == specialRequirements
          ? _value.specialRequirements
          : specialRequirements // ignore: cast_nullable_to_non_nullable
              as String?,
      addressId: freezed == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String?,
      placeImageUrl: freezed == placeImageUrl
          ? _value.placeImageUrl
          : placeImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceImageUrl: freezed == serviceImageUrl
          ? _value.serviceImageUrl
          : serviceImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      addressFull: freezed == addressFull
          ? _value.addressFull
          : addressFull // ignore: cast_nullable_to_non_nullable
              as String?,
      addressArea: freezed == addressArea
          ? _value.addressArea
          : addressArea // ignore: cast_nullable_to_non_nullable
              as String?,
      addressNearby: freezed == addressNearby
          ? _value.addressNearby
          : addressNearby // ignore: cast_nullable_to_non_nullable
              as String?,
      addressName: freezed == addressName
          ? _value.addressName
          : addressName // ignore: cast_nullable_to_non_nullable
              as String?,
      addressFloor: freezed == addressFloor
          ? _value.addressFloor
          : addressFloor // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'service_listing_id') String? serviceListingId,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'service_description') String? serviceDescription,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'booking_time') String? bookingTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'advance_amount') double advanceAmount,
      @JsonKey(name: 'remaining_amount') double remainingAmount,
      String status,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'address_id') String? addressId,
      @JsonKey(name: 'place_image_url') String? placeImageUrl,
      @JsonKey(name: 'service_image_url') String? serviceImageUrl,
      @JsonKey(name: 'address_full') String? addressFull,
      @JsonKey(name: 'address_area') String? addressArea,
      @JsonKey(name: 'address_nearby') String? addressNearby,
      @JsonKey(name: 'address_name') String? addressName,
      @JsonKey(name: 'address_floor') String? addressFloor,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? vendorId = freezed,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? serviceListingId = freezed,
    Object? serviceTitle = null,
    Object? serviceDescription = freezed,
    Object? bookingDate = null,
    Object? bookingTime = freezed,
    Object? totalAmount = null,
    Object? advanceAmount = null,
    Object? remainingAmount = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? specialRequirements = freezed,
    Object? addressId = freezed,
    Object? placeImageUrl = freezed,
    Object? serviceImageUrl = freezed,
    Object? addressFull = freezed,
    Object? addressArea = freezed,
    Object? addressNearby = freezed,
    Object? addressName = freezed,
    Object? addressFloor = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceListingId: freezed == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      bookingTime: freezed == bookingTime
          ? _value.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      advanceAmount: null == advanceAmount
          ? _value.advanceAmount
          : advanceAmount // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      specialRequirements: freezed == specialRequirements
          ? _value.specialRequirements
          : specialRequirements // ignore: cast_nullable_to_non_nullable
              as String?,
      addressId: freezed == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String?,
      placeImageUrl: freezed == placeImageUrl
          ? _value.placeImageUrl
          : placeImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceImageUrl: freezed == serviceImageUrl
          ? _value.serviceImageUrl
          : serviceImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      addressFull: freezed == addressFull
          ? _value.addressFull
          : addressFull // ignore: cast_nullable_to_non_nullable
              as String?,
      addressArea: freezed == addressArea
          ? _value.addressArea
          : addressArea // ignore: cast_nullable_to_non_nullable
              as String?,
      addressNearby: freezed == addressNearby
          ? _value.addressNearby
          : addressNearby // ignore: cast_nullable_to_non_nullable
              as String?,
      addressName: freezed == addressName
          ? _value.addressName
          : addressName // ignore: cast_nullable_to_non_nullable
              as String?,
      addressFloor: freezed == addressFloor
          ? _value.addressFloor
          : addressFloor // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'vendor_id') this.vendorId,
      @JsonKey(name: 'customer_name') required this.customerName,
      @JsonKey(name: 'customer_phone') this.customerPhone,
      @JsonKey(name: 'customer_email') this.customerEmail,
      @JsonKey(name: 'service_listing_id') this.serviceListingId,
      @JsonKey(name: 'service_title') required this.serviceTitle,
      @JsonKey(name: 'service_description') this.serviceDescription,
      @JsonKey(name: 'booking_date') required this.bookingDate,
      @JsonKey(name: 'booking_time') this.bookingTime,
      @JsonKey(name: 'total_amount') this.totalAmount = 0,
      @JsonKey(name: 'advance_amount') this.advanceAmount = 0,
      @JsonKey(name: 'remaining_amount') this.remainingAmount = 0,
      this.status = 'pending',
      @JsonKey(name: 'payment_status') this.paymentStatus = 'pending',
      @JsonKey(name: 'special_requirements') this.specialRequirements,
      @JsonKey(name: 'address_id') this.addressId,
      @JsonKey(name: 'place_image_url') this.placeImageUrl,
      @JsonKey(name: 'service_image_url') this.serviceImageUrl,
      @JsonKey(name: 'address_full') this.addressFull,
      @JsonKey(name: 'address_area') this.addressArea,
      @JsonKey(name: 'address_nearby') this.addressNearby,
      @JsonKey(name: 'address_name') this.addressName,
      @JsonKey(name: 'address_floor') this.addressFloor,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'vendor_id')
  final String? vendorId;
  @override
  @JsonKey(name: 'customer_name')
  final String customerName;
  @override
  @JsonKey(name: 'customer_phone')
  final String? customerPhone;
  @override
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
  @override
  @JsonKey(name: 'service_listing_id')
  final String? serviceListingId;
  @override
  @JsonKey(name: 'service_title')
  final String serviceTitle;
  @override
  @JsonKey(name: 'service_description')
  final String? serviceDescription;
  @override
  @JsonKey(name: 'booking_date')
  final DateTime bookingDate;
  @override
  @JsonKey(name: 'booking_time')
  final String? bookingTime;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'advance_amount')
  final double advanceAmount;
  @override
  @JsonKey(name: 'remaining_amount')
  final double remainingAmount;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @override
  @JsonKey(name: 'special_requirements')
  final String? specialRequirements;
  @override
  @JsonKey(name: 'address_id')
  final String? addressId;
  @override
  @JsonKey(name: 'place_image_url')
  final String? placeImageUrl;
  @override
  @JsonKey(name: 'service_image_url')
  final String? serviceImageUrl;
// Address information from joined addresses table
  @override
  @JsonKey(name: 'address_full')
  final String? addressFull;
  @override
  @JsonKey(name: 'address_area')
  final String? addressArea;
  @override
  @JsonKey(name: 'address_nearby')
  final String? addressNearby;
  @override
  @JsonKey(name: 'address_name')
  final String? addressName;
  @override
  @JsonKey(name: 'address_floor')
  final String? addressFloor;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'OrderModel(id: $id, userId: $userId, vendorId: $vendorId, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, serviceListingId: $serviceListingId, serviceTitle: $serviceTitle, serviceDescription: $serviceDescription, bookingDate: $bookingDate, bookingTime: $bookingTime, totalAmount: $totalAmount, advanceAmount: $advanceAmount, remainingAmount: $remainingAmount, status: $status, paymentStatus: $paymentStatus, specialRequirements: $specialRequirements, addressId: $addressId, placeImageUrl: $placeImageUrl, serviceImageUrl: $serviceImageUrl, addressFull: $addressFull, addressArea: $addressArea, addressNearby: $addressNearby, addressName: $addressName, addressFloor: $addressFloor, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
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
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.advanceAmount, advanceAmount) ||
                other.advanceAmount == advanceAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.specialRequirements, specialRequirements) ||
                other.specialRequirements == specialRequirements) &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId) &&
            (identical(other.placeImageUrl, placeImageUrl) ||
                other.placeImageUrl == placeImageUrl) &&
            (identical(other.serviceImageUrl, serviceImageUrl) ||
                other.serviceImageUrl == serviceImageUrl) &&
            (identical(other.addressFull, addressFull) ||
                other.addressFull == addressFull) &&
            (identical(other.addressArea, addressArea) ||
                other.addressArea == addressArea) &&
            (identical(other.addressNearby, addressNearby) ||
                other.addressNearby == addressNearby) &&
            (identical(other.addressName, addressName) ||
                other.addressName == addressName) &&
            (identical(other.addressFloor, addressFloor) ||
                other.addressFloor == addressFloor) &&
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
        userId,
        vendorId,
        customerName,
        customerPhone,
        customerEmail,
        serviceListingId,
        serviceTitle,
        serviceDescription,
        bookingDate,
        bookingTime,
        totalAmount,
        advanceAmount,
        remainingAmount,
        status,
        paymentStatus,
        specialRequirements,
        addressId,
        placeImageUrl,
        serviceImageUrl,
        addressFull,
        addressArea,
        addressNearby,
        addressName,
        addressFloor,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
      {required final String id,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'vendor_id') final String? vendorId,
      @JsonKey(name: 'customer_name') required final String customerName,
      @JsonKey(name: 'customer_phone') final String? customerPhone,
      @JsonKey(name: 'customer_email') final String? customerEmail,
      @JsonKey(name: 'service_listing_id') final String? serviceListingId,
      @JsonKey(name: 'service_title') required final String serviceTitle,
      @JsonKey(name: 'service_description') final String? serviceDescription,
      @JsonKey(name: 'booking_date') required final DateTime bookingDate,
      @JsonKey(name: 'booking_time') final String? bookingTime,
      @JsonKey(name: 'total_amount') final double totalAmount,
      @JsonKey(name: 'advance_amount') final double advanceAmount,
      @JsonKey(name: 'remaining_amount') final double remainingAmount,
      final String status,
      @JsonKey(name: 'payment_status') final String paymentStatus,
      @JsonKey(name: 'special_requirements') final String? specialRequirements,
      @JsonKey(name: 'address_id') final String? addressId,
      @JsonKey(name: 'place_image_url') final String? placeImageUrl,
      @JsonKey(name: 'service_image_url') final String? serviceImageUrl,
      @JsonKey(name: 'address_full') final String? addressFull,
      @JsonKey(name: 'address_area') final String? addressArea,
      @JsonKey(name: 'address_nearby') final String? addressNearby,
      @JsonKey(name: 'address_name') final String? addressName,
      @JsonKey(name: 'address_floor') final String? addressFloor,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'vendor_id')
  String? get vendorId;
  @override
  @JsonKey(name: 'customer_name')
  String get customerName;
  @override
  @JsonKey(name: 'customer_phone')
  String? get customerPhone;
  @override
  @JsonKey(name: 'customer_email')
  String? get customerEmail;
  @override
  @JsonKey(name: 'service_listing_id')
  String? get serviceListingId;
  @override
  @JsonKey(name: 'service_title')
  String get serviceTitle;
  @override
  @JsonKey(name: 'service_description')
  String? get serviceDescription;
  @override
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate;
  @override
  @JsonKey(name: 'booking_time')
  String? get bookingTime;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'advance_amount')
  double get advanceAmount;
  @override
  @JsonKey(name: 'remaining_amount')
  double get remainingAmount;
  @override
  String get status;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  @JsonKey(name: 'special_requirements')
  String? get specialRequirements;
  @override
  @JsonKey(name: 'address_id')
  String? get addressId;
  @override
  @JsonKey(name: 'place_image_url')
  String? get placeImageUrl;
  @override
  @JsonKey(name: 'service_image_url')
  String? get serviceImageUrl;
  @override // Address information from joined addresses table
  @JsonKey(name: 'address_full')
  String? get addressFull;
  @override
  @JsonKey(name: 'address_area')
  String? get addressArea;
  @override
  @JsonKey(name: 'address_nearby')
  String? get addressNearby;
  @override
  @JsonKey(name: 'address_name')
  String? get addressName;
  @override
  @JsonKey(name: 'address_floor')
  String? get addressFloor;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
