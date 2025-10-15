// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater_screen_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TheaterScreenModel _$TheaterScreenModelFromJson(Map<String, dynamic> json) {
  return _TheaterScreenModel.fromJson(json);
}

/// @nodoc
mixin _$TheaterScreenModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_name')
  String get screenName => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_number')
  int get screenNumber => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  @JsonKey(name: 'hourly_rate')
  double get hourlyRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_capacity')
  int get totalCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'allowed_capacity')
  int get allowedCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'charges_extra_per_person')
  double get chargesExtraPerPerson => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_hourly_price')
  double get originalHourlyPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'discounted_hourly_price')
  double get discountedHourlyPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterScreenModelCopyWith<TheaterScreenModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterScreenModelCopyWith<$Res> {
  factory $TheaterScreenModelCopyWith(
          TheaterScreenModel value, $Res Function(TheaterScreenModel) then) =
      _$TheaterScreenModelCopyWithImpl<$Res, TheaterScreenModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_name') String screenName,
      @JsonKey(name: 'screen_number') int screenNumber,
      int capacity,
      List<String> amenities,
      @JsonKey(name: 'hourly_rate') double hourlyRate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'total_capacity') int totalCapacity,
      @JsonKey(name: 'allowed_capacity') int allowedCapacity,
      @JsonKey(name: 'charges_extra_per_person') double chargesExtraPerPerson,
      @JsonKey(name: 'video_url') String? videoUrl,
      List<String> images,
      @JsonKey(name: 'original_hourly_price') double originalHourlyPrice,
      @JsonKey(name: 'discounted_hourly_price') double discountedHourlyPrice});
}

/// @nodoc
class _$TheaterScreenModelCopyWithImpl<$Res, $Val extends TheaterScreenModel>
    implements $TheaterScreenModelCopyWith<$Res> {
  _$TheaterScreenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenName = null,
    Object? screenNumber = null,
    Object? capacity = null,
    Object? amenities = null,
    Object? hourlyRate = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? totalCapacity = null,
    Object? allowedCapacity = null,
    Object? chargesExtraPerPerson = null,
    Object? videoUrl = freezed,
    Object? images = null,
    Object? originalHourlyPrice = null,
    Object? discountedHourlyPrice = null,
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
      screenName: null == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String,
      screenNumber: null == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      amenities: null == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hourlyRate: null == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double,
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
      totalCapacity: null == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      allowedCapacity: null == allowedCapacity
          ? _value.allowedCapacity
          : allowedCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      chargesExtraPerPerson: null == chargesExtraPerPerson
          ? _value.chargesExtraPerPerson
          : chargesExtraPerPerson // ignore: cast_nullable_to_non_nullable
              as double,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      originalHourlyPrice: null == originalHourlyPrice
          ? _value.originalHourlyPrice
          : originalHourlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountedHourlyPrice: null == discountedHourlyPrice
          ? _value.discountedHourlyPrice
          : discountedHourlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TheaterScreenModelImplCopyWith<$Res>
    implements $TheaterScreenModelCopyWith<$Res> {
  factory _$$TheaterScreenModelImplCopyWith(_$TheaterScreenModelImpl value,
          $Res Function(_$TheaterScreenModelImpl) then) =
      __$$TheaterScreenModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_name') String screenName,
      @JsonKey(name: 'screen_number') int screenNumber,
      int capacity,
      List<String> amenities,
      @JsonKey(name: 'hourly_rate') double hourlyRate,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'total_capacity') int totalCapacity,
      @JsonKey(name: 'allowed_capacity') int allowedCapacity,
      @JsonKey(name: 'charges_extra_per_person') double chargesExtraPerPerson,
      @JsonKey(name: 'video_url') String? videoUrl,
      List<String> images,
      @JsonKey(name: 'original_hourly_price') double originalHourlyPrice,
      @JsonKey(name: 'discounted_hourly_price') double discountedHourlyPrice});
}

/// @nodoc
class __$$TheaterScreenModelImplCopyWithImpl<$Res>
    extends _$TheaterScreenModelCopyWithImpl<$Res, _$TheaterScreenModelImpl>
    implements _$$TheaterScreenModelImplCopyWith<$Res> {
  __$$TheaterScreenModelImplCopyWithImpl(_$TheaterScreenModelImpl _value,
      $Res Function(_$TheaterScreenModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenName = null,
    Object? screenNumber = null,
    Object? capacity = null,
    Object? amenities = null,
    Object? hourlyRate = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? totalCapacity = null,
    Object? allowedCapacity = null,
    Object? chargesExtraPerPerson = null,
    Object? videoUrl = freezed,
    Object? images = null,
    Object? originalHourlyPrice = null,
    Object? discountedHourlyPrice = null,
  }) {
    return _then(_$TheaterScreenModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      screenName: null == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String,
      screenNumber: null == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      amenities: null == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hourlyRate: null == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double,
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
      totalCapacity: null == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      allowedCapacity: null == allowedCapacity
          ? _value.allowedCapacity
          : allowedCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      chargesExtraPerPerson: null == chargesExtraPerPerson
          ? _value.chargesExtraPerPerson
          : chargesExtraPerPerson // ignore: cast_nullable_to_non_nullable
              as double,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      originalHourlyPrice: null == originalHourlyPrice
          ? _value.originalHourlyPrice
          : originalHourlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountedHourlyPrice: null == discountedHourlyPrice
          ? _value.discountedHourlyPrice
          : discountedHourlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TheaterScreenModelImpl implements _TheaterScreenModel {
  const _$TheaterScreenModelImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      @JsonKey(name: 'screen_name') required this.screenName,
      @JsonKey(name: 'screen_number') required this.screenNumber,
      required this.capacity,
      final List<String> amenities = const [],
      @JsonKey(name: 'hourly_rate') required this.hourlyRate,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'total_capacity') this.totalCapacity = 0,
      @JsonKey(name: 'allowed_capacity') this.allowedCapacity = 0,
      @JsonKey(name: 'charges_extra_per_person')
      this.chargesExtraPerPerson = 0.0,
      @JsonKey(name: 'video_url') this.videoUrl,
      final List<String> images = const [],
      @JsonKey(name: 'original_hourly_price') this.originalHourlyPrice = 0.0,
      @JsonKey(name: 'discounted_hourly_price')
      this.discountedHourlyPrice = 0.0})
      : _amenities = amenities,
        _images = images;

  factory _$TheaterScreenModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TheaterScreenModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  @JsonKey(name: 'screen_name')
  final String screenName;
  @override
  @JsonKey(name: 'screen_number')
  final int screenNumber;
  @override
  final int capacity;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  @override
  @JsonKey(name: 'hourly_rate')
  final double hourlyRate;
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
  @JsonKey(name: 'total_capacity')
  final int totalCapacity;
  @override
  @JsonKey(name: 'allowed_capacity')
  final int allowedCapacity;
  @override
  @JsonKey(name: 'charges_extra_per_person')
  final double chargesExtraPerPerson;
  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'original_hourly_price')
  final double originalHourlyPrice;
  @override
  @JsonKey(name: 'discounted_hourly_price')
  final double discountedHourlyPrice;

  @override
  String toString() {
    return 'TheaterScreenModel(id: $id, theaterId: $theaterId, screenName: $screenName, screenNumber: $screenNumber, capacity: $capacity, amenities: $amenities, hourlyRate: $hourlyRate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, totalCapacity: $totalCapacity, allowedCapacity: $allowedCapacity, chargesExtraPerPerson: $chargesExtraPerPerson, videoUrl: $videoUrl, images: $images, originalHourlyPrice: $originalHourlyPrice, discountedHourlyPrice: $discountedHourlyPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterScreenModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.screenName, screenName) ||
                other.screenName == screenName) &&
            (identical(other.screenNumber, screenNumber) ||
                other.screenNumber == screenNumber) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.totalCapacity, totalCapacity) ||
                other.totalCapacity == totalCapacity) &&
            (identical(other.allowedCapacity, allowedCapacity) ||
                other.allowedCapacity == allowedCapacity) &&
            (identical(other.chargesExtraPerPerson, chargesExtraPerPerson) ||
                other.chargesExtraPerPerson == chargesExtraPerPerson) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.originalHourlyPrice, originalHourlyPrice) ||
                other.originalHourlyPrice == originalHourlyPrice) &&
            (identical(other.discountedHourlyPrice, discountedHourlyPrice) ||
                other.discountedHourlyPrice == discountedHourlyPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      theaterId,
      screenName,
      screenNumber,
      capacity,
      const DeepCollectionEquality().hash(_amenities),
      hourlyRate,
      isActive,
      createdAt,
      updatedAt,
      totalCapacity,
      allowedCapacity,
      chargesExtraPerPerson,
      videoUrl,
      const DeepCollectionEquality().hash(_images),
      originalHourlyPrice,
      discountedHourlyPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterScreenModelImplCopyWith<_$TheaterScreenModelImpl> get copyWith =>
      __$$TheaterScreenModelImplCopyWithImpl<_$TheaterScreenModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterScreenModelImplToJson(
      this,
    );
  }
}

abstract class _TheaterScreenModel implements TheaterScreenModel {
  const factory _TheaterScreenModel(
      {required final String id,
      @JsonKey(name: 'theater_id') required final String theaterId,
      @JsonKey(name: 'screen_name') required final String screenName,
      @JsonKey(name: 'screen_number') required final int screenNumber,
      required final int capacity,
      final List<String> amenities,
      @JsonKey(name: 'hourly_rate') required final double hourlyRate,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'total_capacity') final int totalCapacity,
      @JsonKey(name: 'allowed_capacity') final int allowedCapacity,
      @JsonKey(name: 'charges_extra_per_person')
      final double chargesExtraPerPerson,
      @JsonKey(name: 'video_url') final String? videoUrl,
      final List<String> images,
      @JsonKey(name: 'original_hourly_price') final double originalHourlyPrice,
      @JsonKey(name: 'discounted_hourly_price')
      final double discountedHourlyPrice}) = _$TheaterScreenModelImpl;

  factory _TheaterScreenModel.fromJson(Map<String, dynamic> json) =
      _$TheaterScreenModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'screen_name')
  String get screenName;
  @override
  @JsonKey(name: 'screen_number')
  int get screenNumber;
  @override
  int get capacity;
  @override
  List<String> get amenities;
  @override
  @JsonKey(name: 'hourly_rate')
  double get hourlyRate;
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
  @JsonKey(name: 'total_capacity')
  int get totalCapacity;
  @override
  @JsonKey(name: 'allowed_capacity')
  int get allowedCapacity;
  @override
  @JsonKey(name: 'charges_extra_per_person')
  double get chargesExtraPerPerson;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override
  List<String> get images;
  @override
  @JsonKey(name: 'original_hourly_price')
  double get originalHourlyPrice;
  @override
  @JsonKey(name: 'discounted_hourly_price')
  double get discountedHourlyPrice;
  @override
  @JsonKey(ignore: true)
  _$$TheaterScreenModelImplCopyWith<_$TheaterScreenModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TheaterTimeSlotWithScreenModel _$TheaterTimeSlotWithScreenModelFromJson(
    Map<String, dynamic> json) {
  return _TheaterTimeSlotWithScreenModel.fromJson(json);
}

/// @nodoc
mixin _$TheaterTimeSlotWithScreenModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_id')
  String get screenId => throw _privateConstructorUsedError;
  @JsonKey(name: 'slot_date')
  String get slotDate => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Screen information (joined data)
  @JsonKey(name: 'screen_name')
  String? get screenName => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_number')
  int? get screenNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_capacity')
  int? get screenCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_amenities')
  List<String>? get screenAmenities => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_hourly_rate')
  double? get screenHourlyRate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterTimeSlotWithScreenModelCopyWith<TheaterTimeSlotWithScreenModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterTimeSlotWithScreenModelCopyWith<$Res> {
  factory $TheaterTimeSlotWithScreenModelCopyWith(
          TheaterTimeSlotWithScreenModel value,
          $Res Function(TheaterTimeSlotWithScreenModel) then) =
      _$TheaterTimeSlotWithScreenModelCopyWithImpl<$Res,
          TheaterTimeSlotWithScreenModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_id') String screenId,
      @JsonKey(name: 'slot_date') String slotDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'base_price') double basePrice,
      @JsonKey(name: 'price_per_hour') double pricePerHour,
      @JsonKey(name: 'weekday_multiplier') double weekdayMultiplier,
      @JsonKey(name: 'weekend_multiplier') double weekendMultiplier,
      @JsonKey(name: 'holiday_multiplier') double holidayMultiplier,
      @JsonKey(name: 'max_duration_hours') int maxDurationHours,
      @JsonKey(name: 'min_duration_hours') int minDurationHours,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'screen_name') String? screenName,
      @JsonKey(name: 'screen_number') int? screenNumber,
      @JsonKey(name: 'screen_capacity') int? screenCapacity,
      @JsonKey(name: 'screen_amenities') List<String>? screenAmenities,
      @JsonKey(name: 'screen_hourly_rate') double? screenHourlyRate});
}

/// @nodoc
class _$TheaterTimeSlotWithScreenModelCopyWithImpl<$Res,
        $Val extends TheaterTimeSlotWithScreenModel>
    implements $TheaterTimeSlotWithScreenModelCopyWith<$Res> {
  _$TheaterTimeSlotWithScreenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenId = null,
    Object? slotDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? basePrice = null,
    Object? pricePerHour = null,
    Object? weekdayMultiplier = null,
    Object? weekendMultiplier = null,
    Object? holidayMultiplier = null,
    Object? maxDurationHours = null,
    Object? minDurationHours = null,
    Object? isAvailable = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? screenName = freezed,
    Object? screenNumber = freezed,
    Object? screenCapacity = freezed,
    Object? screenAmenities = freezed,
    Object? screenHourlyRate = freezed,
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
      screenId: null == screenId
          ? _value.screenId
          : screenId // ignore: cast_nullable_to_non_nullable
              as String,
      slotDate: null == slotDate
          ? _value.slotDate
          : slotDate // ignore: cast_nullable_to_non_nullable
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
      screenName: freezed == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenNumber: freezed == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      screenCapacity: freezed == screenCapacity
          ? _value.screenCapacity
          : screenCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      screenAmenities: freezed == screenAmenities
          ? _value.screenAmenities
          : screenAmenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      screenHourlyRate: freezed == screenHourlyRate
          ? _value.screenHourlyRate
          : screenHourlyRate // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TheaterTimeSlotWithScreenModelImplCopyWith<$Res>
    implements $TheaterTimeSlotWithScreenModelCopyWith<$Res> {
  factory _$$TheaterTimeSlotWithScreenModelImplCopyWith(
          _$TheaterTimeSlotWithScreenModelImpl value,
          $Res Function(_$TheaterTimeSlotWithScreenModelImpl) then) =
      __$$TheaterTimeSlotWithScreenModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_id') String screenId,
      @JsonKey(name: 'slot_date') String slotDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'base_price') double basePrice,
      @JsonKey(name: 'price_per_hour') double pricePerHour,
      @JsonKey(name: 'weekday_multiplier') double weekdayMultiplier,
      @JsonKey(name: 'weekend_multiplier') double weekendMultiplier,
      @JsonKey(name: 'holiday_multiplier') double holidayMultiplier,
      @JsonKey(name: 'max_duration_hours') int maxDurationHours,
      @JsonKey(name: 'min_duration_hours') int minDurationHours,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'screen_name') String? screenName,
      @JsonKey(name: 'screen_number') int? screenNumber,
      @JsonKey(name: 'screen_capacity') int? screenCapacity,
      @JsonKey(name: 'screen_amenities') List<String>? screenAmenities,
      @JsonKey(name: 'screen_hourly_rate') double? screenHourlyRate});
}

/// @nodoc
class __$$TheaterTimeSlotWithScreenModelImplCopyWithImpl<$Res>
    extends _$TheaterTimeSlotWithScreenModelCopyWithImpl<$Res,
        _$TheaterTimeSlotWithScreenModelImpl>
    implements _$$TheaterTimeSlotWithScreenModelImplCopyWith<$Res> {
  __$$TheaterTimeSlotWithScreenModelImplCopyWithImpl(
      _$TheaterTimeSlotWithScreenModelImpl _value,
      $Res Function(_$TheaterTimeSlotWithScreenModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenId = null,
    Object? slotDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? basePrice = null,
    Object? pricePerHour = null,
    Object? weekdayMultiplier = null,
    Object? weekendMultiplier = null,
    Object? holidayMultiplier = null,
    Object? maxDurationHours = null,
    Object? minDurationHours = null,
    Object? isAvailable = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? screenName = freezed,
    Object? screenNumber = freezed,
    Object? screenCapacity = freezed,
    Object? screenAmenities = freezed,
    Object? screenHourlyRate = freezed,
  }) {
    return _then(_$TheaterTimeSlotWithScreenModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      screenId: null == screenId
          ? _value.screenId
          : screenId // ignore: cast_nullable_to_non_nullable
              as String,
      slotDate: null == slotDate
          ? _value.slotDate
          : slotDate // ignore: cast_nullable_to_non_nullable
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
      screenName: freezed == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenNumber: freezed == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      screenCapacity: freezed == screenCapacity
          ? _value.screenCapacity
          : screenCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      screenAmenities: freezed == screenAmenities
          ? _value._screenAmenities
          : screenAmenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      screenHourlyRate: freezed == screenHourlyRate
          ? _value.screenHourlyRate
          : screenHourlyRate // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TheaterTimeSlotWithScreenModelImpl
    implements _TheaterTimeSlotWithScreenModel {
  const _$TheaterTimeSlotWithScreenModelImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      @JsonKey(name: 'screen_id') required this.screenId,
      @JsonKey(name: 'slot_date') required this.slotDate,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(name: 'base_price') required this.basePrice,
      @JsonKey(name: 'price_per_hour') required this.pricePerHour,
      @JsonKey(name: 'weekday_multiplier') this.weekdayMultiplier = 1.0,
      @JsonKey(name: 'weekend_multiplier') this.weekendMultiplier = 1.2,
      @JsonKey(name: 'holiday_multiplier') this.holidayMultiplier = 1.5,
      @JsonKey(name: 'max_duration_hours') this.maxDurationHours = 3,
      @JsonKey(name: 'min_duration_hours') this.minDurationHours = 2,
      @JsonKey(name: 'is_available') this.isAvailable = true,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'screen_name') this.screenName,
      @JsonKey(name: 'screen_number') this.screenNumber,
      @JsonKey(name: 'screen_capacity') this.screenCapacity,
      @JsonKey(name: 'screen_amenities') final List<String>? screenAmenities,
      @JsonKey(name: 'screen_hourly_rate') this.screenHourlyRate})
      : _screenAmenities = screenAmenities;

  factory _$TheaterTimeSlotWithScreenModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TheaterTimeSlotWithScreenModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  @JsonKey(name: 'screen_id')
  final String screenId;
  @override
  @JsonKey(name: 'slot_date')
  final String slotDate;
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
// Screen information (joined data)
  @override
  @JsonKey(name: 'screen_name')
  final String? screenName;
  @override
  @JsonKey(name: 'screen_number')
  final int? screenNumber;
  @override
  @JsonKey(name: 'screen_capacity')
  final int? screenCapacity;
  final List<String>? _screenAmenities;
  @override
  @JsonKey(name: 'screen_amenities')
  List<String>? get screenAmenities {
    final value = _screenAmenities;
    if (value == null) return null;
    if (_screenAmenities is EqualUnmodifiableListView) return _screenAmenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'screen_hourly_rate')
  final double? screenHourlyRate;

  @override
  String toString() {
    return 'TheaterTimeSlotWithScreenModel(id: $id, theaterId: $theaterId, screenId: $screenId, slotDate: $slotDate, startTime: $startTime, endTime: $endTime, basePrice: $basePrice, pricePerHour: $pricePerHour, weekdayMultiplier: $weekdayMultiplier, weekendMultiplier: $weekendMultiplier, holidayMultiplier: $holidayMultiplier, maxDurationHours: $maxDurationHours, minDurationHours: $minDurationHours, isAvailable: $isAvailable, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, screenName: $screenName, screenNumber: $screenNumber, screenCapacity: $screenCapacity, screenAmenities: $screenAmenities, screenHourlyRate: $screenHourlyRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterTimeSlotWithScreenModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.screenId, screenId) ||
                other.screenId == screenId) &&
            (identical(other.slotDate, slotDate) ||
                other.slotDate == slotDate) &&
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
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.screenName, screenName) ||
                other.screenName == screenName) &&
            (identical(other.screenNumber, screenNumber) ||
                other.screenNumber == screenNumber) &&
            (identical(other.screenCapacity, screenCapacity) ||
                other.screenCapacity == screenCapacity) &&
            const DeepCollectionEquality()
                .equals(other._screenAmenities, _screenAmenities) &&
            (identical(other.screenHourlyRate, screenHourlyRate) ||
                other.screenHourlyRate == screenHourlyRate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        theaterId,
        screenId,
        slotDate,
        startTime,
        endTime,
        basePrice,
        pricePerHour,
        weekdayMultiplier,
        weekendMultiplier,
        holidayMultiplier,
        maxDurationHours,
        minDurationHours,
        isAvailable,
        isActive,
        createdAt,
        updatedAt,
        screenName,
        screenNumber,
        screenCapacity,
        const DeepCollectionEquality().hash(_screenAmenities),
        screenHourlyRate
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterTimeSlotWithScreenModelImplCopyWith<
          _$TheaterTimeSlotWithScreenModelImpl>
      get copyWith => __$$TheaterTimeSlotWithScreenModelImplCopyWithImpl<
          _$TheaterTimeSlotWithScreenModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterTimeSlotWithScreenModelImplToJson(
      this,
    );
  }
}

abstract class _TheaterTimeSlotWithScreenModel
    implements TheaterTimeSlotWithScreenModel {
  const factory _TheaterTimeSlotWithScreenModel(
      {required final String id,
      @JsonKey(name: 'theater_id') required final String theaterId,
      @JsonKey(name: 'screen_id') required final String screenId,
      @JsonKey(name: 'slot_date') required final String slotDate,
      @JsonKey(name: 'start_time') required final String startTime,
      @JsonKey(name: 'end_time') required final String endTime,
      @JsonKey(name: 'base_price') required final double basePrice,
      @JsonKey(name: 'price_per_hour') required final double pricePerHour,
      @JsonKey(name: 'weekday_multiplier') final double weekdayMultiplier,
      @JsonKey(name: 'weekend_multiplier') final double weekendMultiplier,
      @JsonKey(name: 'holiday_multiplier') final double holidayMultiplier,
      @JsonKey(name: 'max_duration_hours') final int maxDurationHours,
      @JsonKey(name: 'min_duration_hours') final int minDurationHours,
      @JsonKey(name: 'is_available') final bool isAvailable,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'screen_name') final String? screenName,
      @JsonKey(name: 'screen_number') final int? screenNumber,
      @JsonKey(name: 'screen_capacity') final int? screenCapacity,
      @JsonKey(name: 'screen_amenities') final List<String>? screenAmenities,
      @JsonKey(name: 'screen_hourly_rate')
      final double? screenHourlyRate}) = _$TheaterTimeSlotWithScreenModelImpl;

  factory _TheaterTimeSlotWithScreenModel.fromJson(Map<String, dynamic> json) =
      _$TheaterTimeSlotWithScreenModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'screen_id')
  String get screenId;
  @override
  @JsonKey(name: 'slot_date')
  String get slotDate;
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
  @override // Screen information (joined data)
  @JsonKey(name: 'screen_name')
  String? get screenName;
  @override
  @JsonKey(name: 'screen_number')
  int? get screenNumber;
  @override
  @JsonKey(name: 'screen_capacity')
  int? get screenCapacity;
  @override
  @JsonKey(name: 'screen_amenities')
  List<String>? get screenAmenities;
  @override
  @JsonKey(name: 'screen_hourly_rate')
  double? get screenHourlyRate;
  @override
  @JsonKey(ignore: true)
  _$$TheaterTimeSlotWithScreenModelImplCopyWith<
          _$TheaterTimeSlotWithScreenModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TheaterBookingWithScreenModel _$TheaterBookingWithScreenModelFromJson(
    Map<String, dynamic> json) {
  return _TheaterBookingWithScreenModel.fromJson(json);
}

/// @nodoc
mixin _$TheaterBookingWithScreenModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_id')
  String get screenId => throw _privateConstructorUsedError;
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
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Screen details
  @JsonKey(name: 'screen_name')
  String? get screenName => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_number')
  int? get screenNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_capacity')
  int? get screenCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_amenities')
  List<String>? get screenAmenities => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterBookingWithScreenModelCopyWith<TheaterBookingWithScreenModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterBookingWithScreenModelCopyWith<$Res> {
  factory $TheaterBookingWithScreenModelCopyWith(
          TheaterBookingWithScreenModel value,
          $Res Function(TheaterBookingWithScreenModel) then) =
      _$TheaterBookingWithScreenModelCopyWithImpl<$Res,
          TheaterBookingWithScreenModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_id') String screenId,
      @JsonKey(name: 'time_slot_id') String timeSlotId,
      @JsonKey(name: 'booking_date') String bookingDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String status,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'slot_price') double slotPrice,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'screen_name') String? screenName,
      @JsonKey(name: 'screen_number') int? screenNumber,
      @JsonKey(name: 'screen_capacity') int? screenCapacity,
      @JsonKey(name: 'screen_amenities') List<String>? screenAmenities});
}

/// @nodoc
class _$TheaterBookingWithScreenModelCopyWithImpl<$Res,
        $Val extends TheaterBookingWithScreenModel>
    implements $TheaterBookingWithScreenModelCopyWith<$Res> {
  _$TheaterBookingWithScreenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenId = null,
    Object? timeSlotId = null,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? bookingId = freezed,
    Object? slotPrice = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? screenName = freezed,
    Object? screenNumber = freezed,
    Object? screenCapacity = freezed,
    Object? screenAmenities = freezed,
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
      screenId: null == screenId
          ? _value.screenId
          : screenId // ignore: cast_nullable_to_non_nullable
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
      screenName: freezed == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenNumber: freezed == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      screenCapacity: freezed == screenCapacity
          ? _value.screenCapacity
          : screenCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      screenAmenities: freezed == screenAmenities
          ? _value.screenAmenities
          : screenAmenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TheaterBookingWithScreenModelImplCopyWith<$Res>
    implements $TheaterBookingWithScreenModelCopyWith<$Res> {
  factory _$$TheaterBookingWithScreenModelImplCopyWith(
          _$TheaterBookingWithScreenModelImpl value,
          $Res Function(_$TheaterBookingWithScreenModelImpl) then) =
      __$$TheaterBookingWithScreenModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_id') String screenId,
      @JsonKey(name: 'time_slot_id') String timeSlotId,
      @JsonKey(name: 'booking_date') String bookingDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String status,
      @JsonKey(name: 'booking_id') String? bookingId,
      @JsonKey(name: 'slot_price') double slotPrice,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'screen_name') String? screenName,
      @JsonKey(name: 'screen_number') int? screenNumber,
      @JsonKey(name: 'screen_capacity') int? screenCapacity,
      @JsonKey(name: 'screen_amenities') List<String>? screenAmenities});
}

/// @nodoc
class __$$TheaterBookingWithScreenModelImplCopyWithImpl<$Res>
    extends _$TheaterBookingWithScreenModelCopyWithImpl<$Res,
        _$TheaterBookingWithScreenModelImpl>
    implements _$$TheaterBookingWithScreenModelImplCopyWith<$Res> {
  __$$TheaterBookingWithScreenModelImplCopyWithImpl(
      _$TheaterBookingWithScreenModelImpl _value,
      $Res Function(_$TheaterBookingWithScreenModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenId = null,
    Object? timeSlotId = null,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? bookingId = freezed,
    Object? slotPrice = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? screenName = freezed,
    Object? screenNumber = freezed,
    Object? screenCapacity = freezed,
    Object? screenAmenities = freezed,
  }) {
    return _then(_$TheaterBookingWithScreenModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      screenId: null == screenId
          ? _value.screenId
          : screenId // ignore: cast_nullable_to_non_nullable
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
      screenName: freezed == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenNumber: freezed == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      screenCapacity: freezed == screenCapacity
          ? _value.screenCapacity
          : screenCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      screenAmenities: freezed == screenAmenities
          ? _value._screenAmenities
          : screenAmenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TheaterBookingWithScreenModelImpl
    implements _TheaterBookingWithScreenModel {
  const _$TheaterBookingWithScreenModelImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      @JsonKey(name: 'screen_id') required this.screenId,
      @JsonKey(name: 'time_slot_id') required this.timeSlotId,
      @JsonKey(name: 'booking_date') required this.bookingDate,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      required this.status,
      @JsonKey(name: 'booking_id') this.bookingId,
      @JsonKey(name: 'slot_price') required this.slotPrice,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'screen_name') this.screenName,
      @JsonKey(name: 'screen_number') this.screenNumber,
      @JsonKey(name: 'screen_capacity') this.screenCapacity,
      @JsonKey(name: 'screen_amenities') final List<String>? screenAmenities})
      : _screenAmenities = screenAmenities;

  factory _$TheaterBookingWithScreenModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TheaterBookingWithScreenModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  @JsonKey(name: 'screen_id')
  final String screenId;
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
// Screen details
  @override
  @JsonKey(name: 'screen_name')
  final String? screenName;
  @override
  @JsonKey(name: 'screen_number')
  final int? screenNumber;
  @override
  @JsonKey(name: 'screen_capacity')
  final int? screenCapacity;
  final List<String>? _screenAmenities;
  @override
  @JsonKey(name: 'screen_amenities')
  List<String>? get screenAmenities {
    final value = _screenAmenities;
    if (value == null) return null;
    if (_screenAmenities is EqualUnmodifiableListView) return _screenAmenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TheaterBookingWithScreenModel(id: $id, theaterId: $theaterId, screenId: $screenId, timeSlotId: $timeSlotId, bookingDate: $bookingDate, startTime: $startTime, endTime: $endTime, status: $status, bookingId: $bookingId, slotPrice: $slotPrice, createdAt: $createdAt, updatedAt: $updatedAt, screenName: $screenName, screenNumber: $screenNumber, screenCapacity: $screenCapacity, screenAmenities: $screenAmenities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterBookingWithScreenModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.screenId, screenId) ||
                other.screenId == screenId) &&
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
                other.updatedAt == updatedAt) &&
            (identical(other.screenName, screenName) ||
                other.screenName == screenName) &&
            (identical(other.screenNumber, screenNumber) ||
                other.screenNumber == screenNumber) &&
            (identical(other.screenCapacity, screenCapacity) ||
                other.screenCapacity == screenCapacity) &&
            const DeepCollectionEquality()
                .equals(other._screenAmenities, _screenAmenities));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      theaterId,
      screenId,
      timeSlotId,
      bookingDate,
      startTime,
      endTime,
      status,
      bookingId,
      slotPrice,
      createdAt,
      updatedAt,
      screenName,
      screenNumber,
      screenCapacity,
      const DeepCollectionEquality().hash(_screenAmenities));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterBookingWithScreenModelImplCopyWith<
          _$TheaterBookingWithScreenModelImpl>
      get copyWith => __$$TheaterBookingWithScreenModelImplCopyWithImpl<
          _$TheaterBookingWithScreenModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterBookingWithScreenModelImplToJson(
      this,
    );
  }
}

abstract class _TheaterBookingWithScreenModel
    implements TheaterBookingWithScreenModel {
  const factory _TheaterBookingWithScreenModel(
          {required final String id,
          @JsonKey(name: 'theater_id') required final String theaterId,
          @JsonKey(name: 'screen_id') required final String screenId,
          @JsonKey(name: 'time_slot_id') required final String timeSlotId,
          @JsonKey(name: 'booking_date') required final String bookingDate,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') required final String endTime,
          required final String status,
          @JsonKey(name: 'booking_id') final String? bookingId,
          @JsonKey(name: 'slot_price') required final double slotPrice,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'screen_name') final String? screenName,
          @JsonKey(name: 'screen_number') final int? screenNumber,
          @JsonKey(name: 'screen_capacity') final int? screenCapacity,
          @JsonKey(name: 'screen_amenities')
          final List<String>? screenAmenities}) =
      _$TheaterBookingWithScreenModelImpl;

  factory _TheaterBookingWithScreenModel.fromJson(Map<String, dynamic> json) =
      _$TheaterBookingWithScreenModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'screen_id')
  String get screenId;
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
  @override // Screen details
  @JsonKey(name: 'screen_name')
  String? get screenName;
  @override
  @JsonKey(name: 'screen_number')
  int? get screenNumber;
  @override
  @JsonKey(name: 'screen_capacity')
  int? get screenCapacity;
  @override
  @JsonKey(name: 'screen_amenities')
  List<String>? get screenAmenities;
  @override
  @JsonKey(ignore: true)
  _$$TheaterBookingWithScreenModelImplCopyWith<
          _$TheaterBookingWithScreenModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
