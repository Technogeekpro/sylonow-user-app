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
  @JsonKey(name: 'slot_name')
  String get slotName => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_price')
  double get basePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_per_hour')
  double get pricePerHour => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekday_multiplier')
  double get weekdayMultiplier => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekend_multiplier')
  double get weekendMultiplier => throw _privateConstructorUsedError;
  @JsonKey(name: 'holiday_multiplier')
  double get holidayMultiplier => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_duration_hours')
  int get maxDurationHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_duration_hours')
  int get minDurationHours => throw _privateConstructorUsedError;
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
      @JsonKey(name: 'slot_name') String slotName,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'base_price') double basePrice,
      @JsonKey(name: 'price_per_hour') double pricePerHour,
      @JsonKey(name: 'weekday_multiplier') double weekdayMultiplier,
      @JsonKey(name: 'weekend_multiplier') double weekendMultiplier,
      @JsonKey(name: 'holiday_multiplier') double holidayMultiplier,
      @JsonKey(name: 'max_duration_hours') int maxDurationHours,
      @JsonKey(name: 'min_duration_hours') int minDurationHours,
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
    Object? slotName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? basePrice = null,
    Object? pricePerHour = null,
    Object? weekdayMultiplier = null,
    Object? weekendMultiplier = null,
    Object? holidayMultiplier = null,
    Object? maxDurationHours = null,
    Object? minDurationHours = null,
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
      slotName: null == slotName
          ? _value.slotName
          : slotName // ignore: cast_nullable_to_non_nullable
              as String,
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
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as double,
      weekdayMultiplier: null == weekdayMultiplier
          ? _value.weekdayMultiplier
          : weekdayMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      weekendMultiplier: null == weekendMultiplier
          ? _value.weekendMultiplier
          : weekendMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      holidayMultiplier: null == holidayMultiplier
          ? _value.holidayMultiplier
          : holidayMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      maxDurationHours: null == maxDurationHours
          ? _value.maxDurationHours
          : maxDurationHours // ignore: cast_nullable_to_non_nullable
              as int,
      minDurationHours: null == minDurationHours
          ? _value.minDurationHours
          : minDurationHours // ignore: cast_nullable_to_non_nullable
              as int,
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
      @JsonKey(name: 'slot_name') String slotName,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'base_price') double basePrice,
      @JsonKey(name: 'price_per_hour') double pricePerHour,
      @JsonKey(name: 'weekday_multiplier') double weekdayMultiplier,
      @JsonKey(name: 'weekend_multiplier') double weekendMultiplier,
      @JsonKey(name: 'holiday_multiplier') double holidayMultiplier,
      @JsonKey(name: 'max_duration_hours') int maxDurationHours,
      @JsonKey(name: 'min_duration_hours') int minDurationHours,
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
    Object? slotName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? basePrice = null,
    Object? pricePerHour = null,
    Object? weekdayMultiplier = null,
    Object? weekendMultiplier = null,
    Object? holidayMultiplier = null,
    Object? maxDurationHours = null,
    Object? minDurationHours = null,
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
      slotName: null == slotName
          ? _value.slotName
          : slotName // ignore: cast_nullable_to_non_nullable
              as String,
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
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as double,
      weekdayMultiplier: null == weekdayMultiplier
          ? _value.weekdayMultiplier
          : weekdayMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      weekendMultiplier: null == weekendMultiplier
          ? _value.weekendMultiplier
          : weekendMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      holidayMultiplier: null == holidayMultiplier
          ? _value.holidayMultiplier
          : holidayMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      maxDurationHours: null == maxDurationHours
          ? _value.maxDurationHours
          : maxDurationHours // ignore: cast_nullable_to_non_nullable
              as int,
      minDurationHours: null == minDurationHours
          ? _value.minDurationHours
          : minDurationHours // ignore: cast_nullable_to_non_nullable
              as int,
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
      @JsonKey(name: 'slot_name') required this.slotName,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(name: 'base_price') required this.basePrice,
      @JsonKey(name: 'price_per_hour') required this.pricePerHour,
      @JsonKey(name: 'weekday_multiplier') required this.weekdayMultiplier,
      @JsonKey(name: 'weekend_multiplier') required this.weekendMultiplier,
      @JsonKey(name: 'holiday_multiplier') required this.holidayMultiplier,
      @JsonKey(name: 'max_duration_hours') required this.maxDurationHours,
      @JsonKey(name: 'min_duration_hours') required this.minDurationHours,
      @JsonKey(name: 'is_active') required this.isActive,
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
  @JsonKey(name: 'slot_name')
  final String slotName;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  @JsonKey(name: 'base_price')
  final double basePrice;
  @override
  @JsonKey(name: 'price_per_hour')
  final double pricePerHour;
  @override
  @JsonKey(name: 'weekday_multiplier')
  final double weekdayMultiplier;
  @override
  @JsonKey(name: 'weekend_multiplier')
  final double weekendMultiplier;
  @override
  @JsonKey(name: 'holiday_multiplier')
  final double holidayMultiplier;
  @override
  @JsonKey(name: 'max_duration_hours')
  final int maxDurationHours;
  @override
  @JsonKey(name: 'min_duration_hours')
  final int minDurationHours;
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
    return 'TheaterTimeSlotModel(id: $id, theaterId: $theaterId, slotName: $slotName, startTime: $startTime, endTime: $endTime, basePrice: $basePrice, pricePerHour: $pricePerHour, weekdayMultiplier: $weekdayMultiplier, weekendMultiplier: $weekendMultiplier, holidayMultiplier: $holidayMultiplier, maxDurationHours: $maxDurationHours, minDurationHours: $minDurationHours, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterTimeSlotModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.slotName, slotName) ||
                other.slotName == slotName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            (identical(other.weekdayMultiplier, weekdayMultiplier) ||
                other.weekdayMultiplier == weekdayMultiplier) &&
            (identical(other.weekendMultiplier, weekendMultiplier) ||
                other.weekendMultiplier == weekendMultiplier) &&
            (identical(other.holidayMultiplier, holidayMultiplier) ||
                other.holidayMultiplier == holidayMultiplier) &&
            (identical(other.maxDurationHours, maxDurationHours) ||
                other.maxDurationHours == maxDurationHours) &&
            (identical(other.minDurationHours, minDurationHours) ||
                other.minDurationHours == minDurationHours) &&
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
      slotName,
      startTime,
      endTime,
      basePrice,
      pricePerHour,
      weekdayMultiplier,
      weekendMultiplier,
      holidayMultiplier,
      maxDurationHours,
      minDurationHours,
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
      @JsonKey(name: 'slot_name') required final String slotName,
      @JsonKey(name: 'start_time') required final String startTime,
      @JsonKey(name: 'end_time') required final String endTime,
      @JsonKey(name: 'base_price') required final double basePrice,
      @JsonKey(name: 'price_per_hour') required final double pricePerHour,
      @JsonKey(name: 'weekday_multiplier')
      required final double weekdayMultiplier,
      @JsonKey(name: 'weekend_multiplier')
      required final double weekendMultiplier,
      @JsonKey(name: 'holiday_multiplier')
      required final double holidayMultiplier,
      @JsonKey(name: 'max_duration_hours') required final int maxDurationHours,
      @JsonKey(name: 'min_duration_hours') required final int minDurationHours,
      @JsonKey(name: 'is_active') required final bool isActive,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$TheaterTimeSlotModelImpl;

  factory _TheaterTimeSlotModel.fromJson(Map<String, dynamic> json) =
      _$TheaterTimeSlotModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'slot_name')
  String get slotName;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  @JsonKey(name: 'base_price')
  double get basePrice;
  @override
  @JsonKey(name: 'price_per_hour')
  double get pricePerHour;
  @override
  @JsonKey(name: 'weekday_multiplier')
  double get weekdayMultiplier;
  @override
  @JsonKey(name: 'weekend_multiplier')
  double get weekendMultiplier;
  @override
  @JsonKey(name: 'holiday_multiplier')
  double get holidayMultiplier;
  @override
  @JsonKey(name: 'max_duration_hours')
  int get maxDurationHours;
  @override
  @JsonKey(name: 'min_duration_hours')
  int get minDurationHours;
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
  @JsonKey(name: 'slot_price')
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
      @JsonKey(name: 'slot_price') double slotPrice,
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
      @JsonKey(name: 'slot_price') double slotPrice,
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
      @JsonKey(name: 'slot_price') required this.slotPrice,
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
  @JsonKey(name: 'slot_price')
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
          @JsonKey(name: 'slot_price') required final double slotPrice,
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
  @JsonKey(name: 'slot_price')
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
