// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater_booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TheaterBookingModel _$TheaterBookingModelFromJson(Map<String, dynamic> json) {
  return _TheaterBookingModel.fromJson(json);
}

/// @nodoc
mixin _$TheaterBookingModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_slot_id')
  String? get timeSlotId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_id')
  String? get paymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_status')
  String get bookingStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_count')
  int get guestCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_requests')
  String? get specialRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_name')
  String get contactName => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_phone')
  String get contactPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_email')
  String? get contactEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'celebration_name')
  String? get celebrationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'number_of_people')
  int get numberOfPeople => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId =>
      throw _privateConstructorUsedError; // Joined data from theater
  @JsonKey(name: 'theater_name')
  String? get theaterName => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_address')
  String? get theaterAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_images')
  List<String>? get theaterImages =>
      throw _privateConstructorUsedError; // Joined data from screen
  @JsonKey(name: 'screen_name')
  String? get screenName => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_number')
  int? get screenNumber =>
      throw _privateConstructorUsedError; // Joined data from add-ons
  @JsonKey(name: 'addons')
  List<TheaterBookingAddonModel>? get addons =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterBookingModelCopyWith<TheaterBookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterBookingModelCopyWith<$Res> {
  factory $TheaterBookingModelCopyWith(
          TheaterBookingModel value, $Res Function(TheaterBookingModel) then) =
      _$TheaterBookingModelCopyWithImpl<$Res, TheaterBookingModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'time_slot_id') String? timeSlotId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'payment_id') String? paymentId,
      @JsonKey(name: 'booking_status') String bookingStatus,
      @JsonKey(name: 'guest_count') int guestCount,
      @JsonKey(name: 'special_requests') String? specialRequests,
      @JsonKey(name: 'contact_name') String contactName,
      @JsonKey(name: 'contact_phone') String contactPhone,
      @JsonKey(name: 'contact_email') String? contactEmail,
      @JsonKey(name: 'celebration_name') String? celebrationName,
      @JsonKey(name: 'number_of_people') int numberOfPeople,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'theater_name') String? theaterName,
      @JsonKey(name: 'theater_address') String? theaterAddress,
      @JsonKey(name: 'theater_images') List<String>? theaterImages,
      @JsonKey(name: 'screen_name') String? screenName,
      @JsonKey(name: 'screen_number') int? screenNumber,
      @JsonKey(name: 'addons') List<TheaterBookingAddonModel>? addons});
}

/// @nodoc
class _$TheaterBookingModelCopyWithImpl<$Res, $Val extends TheaterBookingModel>
    implements $TheaterBookingModelCopyWith<$Res> {
  _$TheaterBookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? timeSlotId = freezed,
    Object? userId = null,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? totalAmount = null,
    Object? paymentStatus = null,
    Object? paymentId = freezed,
    Object? bookingStatus = null,
    Object? guestCount = null,
    Object? specialRequests = freezed,
    Object? contactName = null,
    Object? contactPhone = null,
    Object? contactEmail = freezed,
    Object? celebrationName = freezed,
    Object? numberOfPeople = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? vendorId = null,
    Object? theaterName = freezed,
    Object? theaterAddress = freezed,
    Object? theaterImages = freezed,
    Object? screenName = freezed,
    Object? screenNumber = freezed,
    Object? addons = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSlotId: freezed == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingStatus: null == bookingStatus
          ? _value.bookingStatus
          : bookingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      guestCount: null == guestCount
          ? _value.guestCount
          : guestCount // ignore: cast_nullable_to_non_nullable
              as int,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      celebrationName: freezed == celebrationName
          ? _value.celebrationName
          : celebrationName // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfPeople: null == numberOfPeople
          ? _value.numberOfPeople
          : numberOfPeople // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      theaterName: freezed == theaterName
          ? _value.theaterName
          : theaterName // ignore: cast_nullable_to_non_nullable
              as String?,
      theaterAddress: freezed == theaterAddress
          ? _value.theaterAddress
          : theaterAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      theaterImages: freezed == theaterImages
          ? _value.theaterImages
          : theaterImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      screenName: freezed == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenNumber: freezed == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      addons: freezed == addons
          ? _value.addons
          : addons // ignore: cast_nullable_to_non_nullable
              as List<TheaterBookingAddonModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TheaterBookingModelImplCopyWith<$Res>
    implements $TheaterBookingModelCopyWith<$Res> {
  factory _$$TheaterBookingModelImplCopyWith(_$TheaterBookingModelImpl value,
          $Res Function(_$TheaterBookingModelImpl) then) =
      __$$TheaterBookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'time_slot_id') String? timeSlotId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'payment_id') String? paymentId,
      @JsonKey(name: 'booking_status') String bookingStatus,
      @JsonKey(name: 'guest_count') int guestCount,
      @JsonKey(name: 'special_requests') String? specialRequests,
      @JsonKey(name: 'contact_name') String contactName,
      @JsonKey(name: 'contact_phone') String contactPhone,
      @JsonKey(name: 'contact_email') String? contactEmail,
      @JsonKey(name: 'celebration_name') String? celebrationName,
      @JsonKey(name: 'number_of_people') int numberOfPeople,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'theater_name') String? theaterName,
      @JsonKey(name: 'theater_address') String? theaterAddress,
      @JsonKey(name: 'theater_images') List<String>? theaterImages,
      @JsonKey(name: 'screen_name') String? screenName,
      @JsonKey(name: 'screen_number') int? screenNumber,
      @JsonKey(name: 'addons') List<TheaterBookingAddonModel>? addons});
}

/// @nodoc
class __$$TheaterBookingModelImplCopyWithImpl<$Res>
    extends _$TheaterBookingModelCopyWithImpl<$Res, _$TheaterBookingModelImpl>
    implements _$$TheaterBookingModelImplCopyWith<$Res> {
  __$$TheaterBookingModelImplCopyWithImpl(_$TheaterBookingModelImpl _value,
      $Res Function(_$TheaterBookingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? timeSlotId = freezed,
    Object? userId = null,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? totalAmount = null,
    Object? paymentStatus = null,
    Object? paymentId = freezed,
    Object? bookingStatus = null,
    Object? guestCount = null,
    Object? specialRequests = freezed,
    Object? contactName = null,
    Object? contactPhone = null,
    Object? contactEmail = freezed,
    Object? celebrationName = freezed,
    Object? numberOfPeople = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? vendorId = null,
    Object? theaterName = freezed,
    Object? theaterAddress = freezed,
    Object? theaterImages = freezed,
    Object? screenName = freezed,
    Object? screenNumber = freezed,
    Object? addons = freezed,
  }) {
    return _then(_$TheaterBookingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSlotId: freezed == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingStatus: null == bookingStatus
          ? _value.bookingStatus
          : bookingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      guestCount: null == guestCount
          ? _value.guestCount
          : guestCount // ignore: cast_nullable_to_non_nullable
              as int,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      celebrationName: freezed == celebrationName
          ? _value.celebrationName
          : celebrationName // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfPeople: null == numberOfPeople
          ? _value.numberOfPeople
          : numberOfPeople // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      theaterName: freezed == theaterName
          ? _value.theaterName
          : theaterName // ignore: cast_nullable_to_non_nullable
              as String?,
      theaterAddress: freezed == theaterAddress
          ? _value.theaterAddress
          : theaterAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      theaterImages: freezed == theaterImages
          ? _value._theaterImages
          : theaterImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      screenName: freezed == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenNumber: freezed == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      addons: freezed == addons
          ? _value._addons
          : addons // ignore: cast_nullable_to_non_nullable
              as List<TheaterBookingAddonModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TheaterBookingModelImpl implements _TheaterBookingModel {
  const _$TheaterBookingModelImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      @JsonKey(name: 'time_slot_id') this.timeSlotId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'booking_date') required this.bookingDate,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'payment_status') this.paymentStatus = 'pending',
      @JsonKey(name: 'payment_id') this.paymentId,
      @JsonKey(name: 'booking_status') this.bookingStatus = 'confirmed',
      @JsonKey(name: 'guest_count') this.guestCount = 1,
      @JsonKey(name: 'special_requests') this.specialRequests,
      @JsonKey(name: 'contact_name') required this.contactName,
      @JsonKey(name: 'contact_phone') required this.contactPhone,
      @JsonKey(name: 'contact_email') this.contactEmail,
      @JsonKey(name: 'celebration_name') this.celebrationName,
      @JsonKey(name: 'number_of_people') this.numberOfPeople = 2,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'theater_name') this.theaterName,
      @JsonKey(name: 'theater_address') this.theaterAddress,
      @JsonKey(name: 'theater_images') final List<String>? theaterImages,
      @JsonKey(name: 'screen_name') this.screenName,
      @JsonKey(name: 'screen_number') this.screenNumber,
      @JsonKey(name: 'addons') final List<TheaterBookingAddonModel>? addons})
      : _theaterImages = theaterImages,
        _addons = addons;

  factory _$TheaterBookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TheaterBookingModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  @JsonKey(name: 'time_slot_id')
  final String? timeSlotId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'booking_date')
  final DateTime bookingDate;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @override
  @JsonKey(name: 'payment_id')
  final String? paymentId;
  @override
  @JsonKey(name: 'booking_status')
  final String bookingStatus;
  @override
  @JsonKey(name: 'guest_count')
  final int guestCount;
  @override
  @JsonKey(name: 'special_requests')
  final String? specialRequests;
  @override
  @JsonKey(name: 'contact_name')
  final String contactName;
  @override
  @JsonKey(name: 'contact_phone')
  final String contactPhone;
  @override
  @JsonKey(name: 'contact_email')
  final String? contactEmail;
  @override
  @JsonKey(name: 'celebration_name')
  final String? celebrationName;
  @override
  @JsonKey(name: 'number_of_people')
  final int numberOfPeople;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
// Joined data from theater
  @override
  @JsonKey(name: 'theater_name')
  final String? theaterName;
  @override
  @JsonKey(name: 'theater_address')
  final String? theaterAddress;
  final List<String>? _theaterImages;
  @override
  @JsonKey(name: 'theater_images')
  List<String>? get theaterImages {
    final value = _theaterImages;
    if (value == null) return null;
    if (_theaterImages is EqualUnmodifiableListView) return _theaterImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Joined data from screen
  @override
  @JsonKey(name: 'screen_name')
  final String? screenName;
  @override
  @JsonKey(name: 'screen_number')
  final int? screenNumber;
// Joined data from add-ons
  final List<TheaterBookingAddonModel>? _addons;
// Joined data from add-ons
  @override
  @JsonKey(name: 'addons')
  List<TheaterBookingAddonModel>? get addons {
    final value = _addons;
    if (value == null) return null;
    if (_addons is EqualUnmodifiableListView) return _addons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TheaterBookingModel(id: $id, theaterId: $theaterId, timeSlotId: $timeSlotId, userId: $userId, bookingDate: $bookingDate, startTime: $startTime, endTime: $endTime, totalAmount: $totalAmount, paymentStatus: $paymentStatus, paymentId: $paymentId, bookingStatus: $bookingStatus, guestCount: $guestCount, specialRequests: $specialRequests, contactName: $contactName, contactPhone: $contactPhone, contactEmail: $contactEmail, celebrationName: $celebrationName, numberOfPeople: $numberOfPeople, createdAt: $createdAt, updatedAt: $updatedAt, vendorId: $vendorId, theaterName: $theaterName, theaterAddress: $theaterAddress, theaterImages: $theaterImages, screenName: $screenName, screenNumber: $screenNumber, addons: $addons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterBookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.timeSlotId, timeSlotId) ||
                other.timeSlotId == timeSlotId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.bookingStatus, bookingStatus) ||
                other.bookingStatus == bookingStatus) &&
            (identical(other.guestCount, guestCount) ||
                other.guestCount == guestCount) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.celebrationName, celebrationName) ||
                other.celebrationName == celebrationName) &&
            (identical(other.numberOfPeople, numberOfPeople) ||
                other.numberOfPeople == numberOfPeople) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.theaterName, theaterName) ||
                other.theaterName == theaterName) &&
            (identical(other.theaterAddress, theaterAddress) ||
                other.theaterAddress == theaterAddress) &&
            const DeepCollectionEquality()
                .equals(other._theaterImages, _theaterImages) &&
            (identical(other.screenName, screenName) ||
                other.screenName == screenName) &&
            (identical(other.screenNumber, screenNumber) ||
                other.screenNumber == screenNumber) &&
            const DeepCollectionEquality().equals(other._addons, _addons));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        theaterId,
        timeSlotId,
        userId,
        bookingDate,
        startTime,
        endTime,
        totalAmount,
        paymentStatus,
        paymentId,
        bookingStatus,
        guestCount,
        specialRequests,
        contactName,
        contactPhone,
        contactEmail,
        celebrationName,
        numberOfPeople,
        createdAt,
        updatedAt,
        vendorId,
        theaterName,
        theaterAddress,
        const DeepCollectionEquality().hash(_theaterImages),
        screenName,
        screenNumber,
        const DeepCollectionEquality().hash(_addons)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterBookingModelImplCopyWith<_$TheaterBookingModelImpl> get copyWith =>
      __$$TheaterBookingModelImplCopyWithImpl<_$TheaterBookingModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterBookingModelImplToJson(
      this,
    );
  }
}

abstract class _TheaterBookingModel implements TheaterBookingModel {
  const factory _TheaterBookingModel(
          {required final String id,
          @JsonKey(name: 'theater_id') required final String theaterId,
          @JsonKey(name: 'time_slot_id') final String? timeSlotId,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'booking_date') required final DateTime bookingDate,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') required final String endTime,
          @JsonKey(name: 'total_amount') required final double totalAmount,
          @JsonKey(name: 'payment_status') final String paymentStatus,
          @JsonKey(name: 'payment_id') final String? paymentId,
          @JsonKey(name: 'booking_status') final String bookingStatus,
          @JsonKey(name: 'guest_count') final int guestCount,
          @JsonKey(name: 'special_requests') final String? specialRequests,
          @JsonKey(name: 'contact_name') required final String contactName,
          @JsonKey(name: 'contact_phone') required final String contactPhone,
          @JsonKey(name: 'contact_email') final String? contactEmail,
          @JsonKey(name: 'celebration_name') final String? celebrationName,
          @JsonKey(name: 'number_of_people') final int numberOfPeople,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'vendor_id') required final String vendorId,
          @JsonKey(name: 'theater_name') final String? theaterName,
          @JsonKey(name: 'theater_address') final String? theaterAddress,
          @JsonKey(name: 'theater_images') final List<String>? theaterImages,
          @JsonKey(name: 'screen_name') final String? screenName,
          @JsonKey(name: 'screen_number') final int? screenNumber,
          @JsonKey(name: 'addons')
          final List<TheaterBookingAddonModel>? addons}) =
      _$TheaterBookingModelImpl;

  factory _TheaterBookingModel.fromJson(Map<String, dynamic> json) =
      _$TheaterBookingModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'time_slot_id')
  String? get timeSlotId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  @JsonKey(name: 'payment_id')
  String? get paymentId;
  @override
  @JsonKey(name: 'booking_status')
  String get bookingStatus;
  @override
  @JsonKey(name: 'guest_count')
  int get guestCount;
  @override
  @JsonKey(name: 'special_requests')
  String? get specialRequests;
  @override
  @JsonKey(name: 'contact_name')
  String get contactName;
  @override
  @JsonKey(name: 'contact_phone')
  String get contactPhone;
  @override
  @JsonKey(name: 'contact_email')
  String? get contactEmail;
  @override
  @JsonKey(name: 'celebration_name')
  String? get celebrationName;
  @override
  @JsonKey(name: 'number_of_people')
  int get numberOfPeople;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override // Joined data from theater
  @JsonKey(name: 'theater_name')
  String? get theaterName;
  @override
  @JsonKey(name: 'theater_address')
  String? get theaterAddress;
  @override
  @JsonKey(name: 'theater_images')
  List<String>? get theaterImages;
  @override // Joined data from screen
  @JsonKey(name: 'screen_name')
  String? get screenName;
  @override
  @JsonKey(name: 'screen_number')
  int? get screenNumber;
  @override // Joined data from add-ons
  @JsonKey(name: 'addons')
  List<TheaterBookingAddonModel>? get addons;
  @override
  @JsonKey(ignore: true)
  _$$TheaterBookingModelImplCopyWith<_$TheaterBookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TheaterBookingAddonModel _$TheaterBookingAddonModelFromJson(
    Map<String, dynamic> json) {
  return _TheaterBookingAddonModel.fromJson(json);
}

/// @nodoc
mixin _$TheaterBookingAddonModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  String get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'addon_id')
  String get addonId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  double get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Joined data from add_ons table
  @JsonKey(name: 'addon_name')
  String? get addonName => throw _privateConstructorUsedError;
  @JsonKey(name: 'addon_description')
  String? get addonDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'addon_image_url')
  String? get addonImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'addon_category')
  String? get addonCategory => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterBookingAddonModelCopyWith<TheaterBookingAddonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterBookingAddonModelCopyWith<$Res> {
  factory $TheaterBookingAddonModelCopyWith(TheaterBookingAddonModel value,
          $Res Function(TheaterBookingAddonModel) then) =
      _$TheaterBookingAddonModelCopyWithImpl<$Res, TheaterBookingAddonModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'addon_id') String addonId,
      int quantity,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'total_price') double totalPrice,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'addon_name') String? addonName,
      @JsonKey(name: 'addon_description') String? addonDescription,
      @JsonKey(name: 'addon_image_url') String? addonImageUrl,
      @JsonKey(name: 'addon_category') String? addonCategory});
}

/// @nodoc
class _$TheaterBookingAddonModelCopyWithImpl<$Res,
        $Val extends TheaterBookingAddonModel>
    implements $TheaterBookingAddonModelCopyWith<$Res> {
  _$TheaterBookingAddonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? addonId = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? createdAt = freezed,
    Object? addonName = freezed,
    Object? addonDescription = freezed,
    Object? addonImageUrl = freezed,
    Object? addonCategory = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      addonId: null == addonId
          ? _value.addonId
          : addonId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      addonName: freezed == addonName
          ? _value.addonName
          : addonName // ignore: cast_nullable_to_non_nullable
              as String?,
      addonDescription: freezed == addonDescription
          ? _value.addonDescription
          : addonDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      addonImageUrl: freezed == addonImageUrl
          ? _value.addonImageUrl
          : addonImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      addonCategory: freezed == addonCategory
          ? _value.addonCategory
          : addonCategory // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TheaterBookingAddonModelImplCopyWith<$Res>
    implements $TheaterBookingAddonModelCopyWith<$Res> {
  factory _$$TheaterBookingAddonModelImplCopyWith(
          _$TheaterBookingAddonModelImpl value,
          $Res Function(_$TheaterBookingAddonModelImpl) then) =
      __$$TheaterBookingAddonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'booking_id') String bookingId,
      @JsonKey(name: 'addon_id') String addonId,
      int quantity,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'total_price') double totalPrice,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'addon_name') String? addonName,
      @JsonKey(name: 'addon_description') String? addonDescription,
      @JsonKey(name: 'addon_image_url') String? addonImageUrl,
      @JsonKey(name: 'addon_category') String? addonCategory});
}

/// @nodoc
class __$$TheaterBookingAddonModelImplCopyWithImpl<$Res>
    extends _$TheaterBookingAddonModelCopyWithImpl<$Res,
        _$TheaterBookingAddonModelImpl>
    implements _$$TheaterBookingAddonModelImplCopyWith<$Res> {
  __$$TheaterBookingAddonModelImplCopyWithImpl(
      _$TheaterBookingAddonModelImpl _value,
      $Res Function(_$TheaterBookingAddonModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingId = null,
    Object? addonId = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? createdAt = freezed,
    Object? addonName = freezed,
    Object? addonDescription = freezed,
    Object? addonImageUrl = freezed,
    Object? addonCategory = freezed,
  }) {
    return _then(_$TheaterBookingAddonModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      addonId: null == addonId
          ? _value.addonId
          : addonId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      addonName: freezed == addonName
          ? _value.addonName
          : addonName // ignore: cast_nullable_to_non_nullable
              as String?,
      addonDescription: freezed == addonDescription
          ? _value.addonDescription
          : addonDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      addonImageUrl: freezed == addonImageUrl
          ? _value.addonImageUrl
          : addonImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      addonCategory: freezed == addonCategory
          ? _value.addonCategory
          : addonCategory // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TheaterBookingAddonModelImpl implements _TheaterBookingAddonModel {
  const _$TheaterBookingAddonModelImpl(
      {required this.id,
      @JsonKey(name: 'booking_id') required this.bookingId,
      @JsonKey(name: 'addon_id') required this.addonId,
      required this.quantity,
      @JsonKey(name: 'unit_price') required this.unitPrice,
      @JsonKey(name: 'total_price') required this.totalPrice,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'addon_name') this.addonName,
      @JsonKey(name: 'addon_description') this.addonDescription,
      @JsonKey(name: 'addon_image_url') this.addonImageUrl,
      @JsonKey(name: 'addon_category') this.addonCategory});

  factory _$TheaterBookingAddonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TheaterBookingAddonModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'booking_id')
  final String bookingId;
  @override
  @JsonKey(name: 'addon_id')
  final String addonId;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
// Joined data from add_ons table
  @override
  @JsonKey(name: 'addon_name')
  final String? addonName;
  @override
  @JsonKey(name: 'addon_description')
  final String? addonDescription;
  @override
  @JsonKey(name: 'addon_image_url')
  final String? addonImageUrl;
  @override
  @JsonKey(name: 'addon_category')
  final String? addonCategory;

  @override
  String toString() {
    return 'TheaterBookingAddonModel(id: $id, bookingId: $bookingId, addonId: $addonId, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, createdAt: $createdAt, addonName: $addonName, addonDescription: $addonDescription, addonImageUrl: $addonImageUrl, addonCategory: $addonCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterBookingAddonModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.addonId, addonId) || other.addonId == addonId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.addonName, addonName) ||
                other.addonName == addonName) &&
            (identical(other.addonDescription, addonDescription) ||
                other.addonDescription == addonDescription) &&
            (identical(other.addonImageUrl, addonImageUrl) ||
                other.addonImageUrl == addonImageUrl) &&
            (identical(other.addonCategory, addonCategory) ||
                other.addonCategory == addonCategory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookingId,
      addonId,
      quantity,
      unitPrice,
      totalPrice,
      createdAt,
      addonName,
      addonDescription,
      addonImageUrl,
      addonCategory);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterBookingAddonModelImplCopyWith<_$TheaterBookingAddonModelImpl>
      get copyWith => __$$TheaterBookingAddonModelImplCopyWithImpl<
          _$TheaterBookingAddonModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterBookingAddonModelImplToJson(
      this,
    );
  }
}

abstract class _TheaterBookingAddonModel implements TheaterBookingAddonModel {
  const factory _TheaterBookingAddonModel(
          {required final String id,
          @JsonKey(name: 'booking_id') required final String bookingId,
          @JsonKey(name: 'addon_id') required final String addonId,
          required final int quantity,
          @JsonKey(name: 'unit_price') required final double unitPrice,
          @JsonKey(name: 'total_price') required final double totalPrice,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'addon_name') final String? addonName,
          @JsonKey(name: 'addon_description') final String? addonDescription,
          @JsonKey(name: 'addon_image_url') final String? addonImageUrl,
          @JsonKey(name: 'addon_category') final String? addonCategory}) =
      _$TheaterBookingAddonModelImpl;

  factory _TheaterBookingAddonModel.fromJson(Map<String, dynamic> json) =
      _$TheaterBookingAddonModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'booking_id')
  String get bookingId;
  @override
  @JsonKey(name: 'addon_id')
  String get addonId;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  @JsonKey(name: 'total_price')
  double get totalPrice;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override // Joined data from add_ons table
  @JsonKey(name: 'addon_name')
  String? get addonName;
  @override
  @JsonKey(name: 'addon_description')
  String? get addonDescription;
  @override
  @JsonKey(name: 'addon_image_url')
  String? get addonImageUrl;
  @override
  @JsonKey(name: 'addon_category')
  String? get addonCategory;
  @override
  @JsonKey(ignore: true)
  _$$TheaterBookingAddonModelImplCopyWith<_$TheaterBookingAddonModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
