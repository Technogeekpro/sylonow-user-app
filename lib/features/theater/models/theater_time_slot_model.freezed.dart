// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater_time_slot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TheaterTimeSlotModel _$TheaterTimeSlotModelFromJson(Map<String, dynamic> json) {
  return _TheaterTimeSlotModel.fromJson(json);
}

/// @nodoc
mixin _$TheaterTimeSlotModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_id')
  String? get screenId => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_price', fromJson: _safeDoubleFromJson)
  double get basePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'discounted_price', fromJson: _safeDoubleFromJson)
  double get discountedPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterTimeSlotModelCopyWith<TheaterTimeSlotModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterTimeSlotModelCopyWith<$Res> {
  factory $TheaterTimeSlotModelCopyWith(TheaterTimeSlotModel value,
          $Res Function(TheaterTimeSlotModel) then) =
      _$TheaterTimeSlotModelCopyWithImpl<$Res, TheaterTimeSlotModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_id') String? screenId,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'base_price', fromJson: _safeDoubleFromJson)
      double basePrice,
      @JsonKey(name: 'discounted_price', fromJson: _safeDoubleFromJson)
      double discountedPrice,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$TheaterTimeSlotModelCopyWithImpl<$Res,
        $Val extends TheaterTimeSlotModel>
    implements $TheaterTimeSlotModelCopyWith<$Res> {
  _$TheaterTimeSlotModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenId = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? basePrice = null,
    Object? discountedPrice = null,
    Object? isAvailable = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      screenId: freezed == screenId
          ? _value.screenId
          : screenId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountedPrice: null == discountedPrice
          ? _value.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$TheaterTimeSlotModelImplCopyWith<$Res>
    implements $TheaterTimeSlotModelCopyWith<$Res> {
  factory _$$TheaterTimeSlotModelImplCopyWith(_$TheaterTimeSlotModelImpl value,
          $Res Function(_$TheaterTimeSlotModelImpl) then) =
      __$$TheaterTimeSlotModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_id') String? screenId,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'base_price', fromJson: _safeDoubleFromJson)
      double basePrice,
      @JsonKey(name: 'discounted_price', fromJson: _safeDoubleFromJson)
      double discountedPrice,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$TheaterTimeSlotModelImplCopyWithImpl<$Res>
    extends _$TheaterTimeSlotModelCopyWithImpl<$Res, _$TheaterTimeSlotModelImpl>
    implements _$$TheaterTimeSlotModelImplCopyWith<$Res> {
  __$$TheaterTimeSlotModelImplCopyWithImpl(_$TheaterTimeSlotModelImpl _value,
      $Res Function(_$TheaterTimeSlotModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenId = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? basePrice = null,
    Object? discountedPrice = null,
    Object? isAvailable = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TheaterTimeSlotModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      screenId: freezed == screenId
          ? _value.screenId
          : screenId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountedPrice: null == discountedPrice
          ? _value.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$TheaterTimeSlotModelImpl implements _TheaterTimeSlotModel {
  const _$TheaterTimeSlotModelImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      @JsonKey(name: 'screen_id') this.screenId,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(name: 'base_price', fromJson: _safeDoubleFromJson)
      this.basePrice = 0.0,
      @JsonKey(name: 'discounted_price', fromJson: _safeDoubleFromJson)
      this.discountedPrice = 0.0,
      @JsonKey(name: 'is_available') this.isAvailable = true,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$TheaterTimeSlotModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TheaterTimeSlotModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  @JsonKey(name: 'screen_id')
  final String? screenId;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  @JsonKey(name: 'base_price', fromJson: _safeDoubleFromJson)
  final double basePrice;
  @override
  @JsonKey(name: 'discounted_price', fromJson: _safeDoubleFromJson)
  final double discountedPrice;
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TheaterTimeSlotModel(id: $id, theaterId: $theaterId, screenId: $screenId, startTime: $startTime, endTime: $endTime, basePrice: $basePrice, discountedPrice: $discountedPrice, isAvailable: $isAvailable, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterTimeSlotModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.screenId, screenId) ||
                other.screenId == screenId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      theaterId,
      screenId,
      startTime,
      endTime,
      basePrice,
      discountedPrice,
      isAvailable,
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterTimeSlotModelImplCopyWith<_$TheaterTimeSlotModelImpl>
      get copyWith =>
          __$$TheaterTimeSlotModelImplCopyWithImpl<_$TheaterTimeSlotModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterTimeSlotModelImplToJson(
      this,
    );
  }
}

abstract class _TheaterTimeSlotModel implements TheaterTimeSlotModel {
  const factory _TheaterTimeSlotModel(
          {required final String id,
          @JsonKey(name: 'theater_id') required final String theaterId,
          @JsonKey(name: 'screen_id') final String? screenId,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') required final String endTime,
          @JsonKey(name: 'base_price', fromJson: _safeDoubleFromJson)
          final double basePrice,
          @JsonKey(name: 'discounted_price', fromJson: _safeDoubleFromJson)
          final double discountedPrice,
          @JsonKey(name: 'is_available') final bool isAvailable,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$TheaterTimeSlotModelImpl;

  factory _TheaterTimeSlotModel.fromJson(Map<String, dynamic> json) =
      _$TheaterTimeSlotModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'screen_id')
  String? get screenId;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  @JsonKey(name: 'base_price', fromJson: _safeDoubleFromJson)
  double get basePrice;
  @override
  @JsonKey(name: 'discounted_price', fromJson: _safeDoubleFromJson)
  double get discountedPrice;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TheaterTimeSlotModelImplCopyWith<_$TheaterTimeSlotModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TheaterSlotBookingModel _$TheaterSlotBookingModelFromJson(
    Map<String, dynamic> json) {
  return _TheaterSlotBookingModel.fromJson(json);
}

/// @nodoc
mixin _$TheaterSlotBookingModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_slot_id')
  String get timeSlotId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_date')
  String get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'available', 'booked', 'blocked', 'maintenance'
  @JsonKey(name: 'booking_id')
  String? get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_price', fromJson: _safeDoubleFromJson)
  double get slotPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterSlotBookingModelCopyWith<TheaterSlotBookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterSlotBookingModelCopyWith<$Res> {
  factory $TheaterSlotBookingModelCopyWith(TheaterSlotBookingModel value,
          $Res Function(TheaterSlotBookingModel) then) =
      _$TheaterSlotBookingModelCopyWithImpl<$Res, TheaterSlotBookingModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'time_slot_id') String timeSlotId,
      @JsonKey(name: 'booking_date') String bookingDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String status,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'slot_price', fromJson: _safeDoubleFromJson)
      double slotPrice,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$TheaterSlotBookingModelCopyWithImpl<$Res,
        $Val extends TheaterSlotBookingModel>
    implements $TheaterSlotBookingModelCopyWith<$Res> {
  _$TheaterSlotBookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? timeSlotId = null,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? bookingId = freezed,
    Object? slotPrice = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      timeSlotId: null == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      slotPrice: null == slotPrice
          ? _value.slotPrice
          : slotPrice // ignore: cast_nullable_to_non_nullable
              as double,
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
abstract class _$$TheaterSlotBookingModelImplCopyWith<$Res>
    implements $TheaterSlotBookingModelCopyWith<$Res> {
  factory _$$TheaterSlotBookingModelImplCopyWith(
          _$TheaterSlotBookingModelImpl value,
          $Res Function(_$TheaterSlotBookingModelImpl) then) =
      __$$TheaterSlotBookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'time_slot_id') String timeSlotId,
      @JsonKey(name: 'booking_date') String bookingDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String status,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'slot_price', fromJson: _safeDoubleFromJson)
      double slotPrice,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$TheaterSlotBookingModelImplCopyWithImpl<$Res>
    extends _$TheaterSlotBookingModelCopyWithImpl<$Res,
        _$TheaterSlotBookingModelImpl>
    implements _$$TheaterSlotBookingModelImplCopyWith<$Res> {
  __$$TheaterSlotBookingModelImplCopyWithImpl(
      _$TheaterSlotBookingModelImpl _value,
      $Res Function(_$TheaterSlotBookingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? timeSlotId = null,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? bookingId = freezed,
    Object? slotPrice = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TheaterSlotBookingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSlotId: null == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String?,
      slotPrice: null == slotPrice
          ? _value.slotPrice
          : slotPrice // ignore: cast_nullable_to_non_nullable
              as double,
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
class _$TheaterSlotBookingModelImpl implements _TheaterSlotBookingModel {
  const _$TheaterSlotBookingModelImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      @JsonKey(name: 'time_slot_id') required this.timeSlotId,
      @JsonKey(name: 'booking_date') required this.bookingDate,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      required this.status,
      @JsonKey(name: 'booking_id') this.bookingId,
      @JsonKey(name: 'slot_price', fromJson: _safeDoubleFromJson)
      this.slotPrice = 0.0,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$TheaterSlotBookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TheaterSlotBookingModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  @JsonKey(name: 'time_slot_id')
  final String timeSlotId;
  @override
  @JsonKey(name: 'booking_date')
  final String bookingDate;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  final String status;
// 'available', 'booked', 'blocked', 'maintenance'
  @override
  @JsonKey(name: 'booking_id')
  final String? bookingId;
  @override
  @JsonKey(name: 'slot_price', fromJson: _safeDoubleFromJson)
  final double slotPrice;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TheaterSlotBookingModel(id: $id, theaterId: $theaterId, timeSlotId: $timeSlotId, bookingDate: $bookingDate, startTime: $startTime, endTime: $endTime, status: $status, bookingId: $bookingId, slotPrice: $slotPrice, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterSlotBookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.timeSlotId, timeSlotId) ||
                other.timeSlotId == timeSlotId) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.slotPrice, slotPrice) ||
                other.slotPrice == slotPrice) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      theaterId,
      timeSlotId,
      bookingDate,
      startTime,
      endTime,
      status,
      bookingId,
      slotPrice,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterSlotBookingModelImplCopyWith<_$TheaterSlotBookingModelImpl>
      get copyWith => __$$TheaterSlotBookingModelImplCopyWithImpl<
          _$TheaterSlotBookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterSlotBookingModelImplToJson(
      this,
    );
  }
}

abstract class _TheaterSlotBookingModel implements TheaterSlotBookingModel {
  const factory _TheaterSlotBookingModel(
          {required final String id,
          @JsonKey(name: 'theater_id') required final String theaterId,
          @JsonKey(name: 'time_slot_id') required final String timeSlotId,
          @JsonKey(name: 'booking_date') required final String bookingDate,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') required final String endTime,
          required final String status,
          @JsonKey(name: 'booking_id') final String? bookingId,
          @JsonKey(name: 'slot_price', fromJson: _safeDoubleFromJson)
          final double slotPrice,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$TheaterSlotBookingModelImpl;

  factory _TheaterSlotBookingModel.fromJson(Map<String, dynamic> json) =
      _$TheaterSlotBookingModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'time_slot_id')
  String get timeSlotId;
  @override
  @JsonKey(name: 'booking_date')
  String get bookingDate;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  String get status;
  @override // 'available', 'booked', 'blocked', 'maintenance'
  @JsonKey(name: 'booking_id')
  String? get bookingId;
  @override
  @JsonKey(name: 'slot_price', fromJson: _safeDoubleFromJson)
  double get slotPrice;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TheaterSlotBookingModelImplCopyWith<_$TheaterSlotBookingModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
