// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'private_theater_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrivateTheaterModel _$PrivateTheaterModelFromJson(Map<String, dynamic> json) {
  return _PrivateTheaterModel.fromJson(json);
}

/// @nodoc
mixin _$PrivateTheaterModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'pin_code')
  String get pinCode => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'hourly_rate')
  double get hourlyRate => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_reviews')
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String? get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PrivateTheaterModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivateTheaterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivateTheaterModelCopyWith<PrivateTheaterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivateTheaterModelCopyWith<$Res> {
  factory $PrivateTheaterModelCopyWith(
          PrivateTheaterModel value, $Res Function(PrivateTheaterModel) then) =
      _$PrivateTheaterModelCopyWithImpl<$Res, PrivateTheaterModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String address,
      String city,
      String state,
      @JsonKey(name: 'pin_code') String pinCode,
      double? latitude,
      double? longitude,
      int capacity,
      List<String> amenities,
      List<String> images,
      @JsonKey(name: 'hourly_rate') double hourlyRate,
      double rating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'owner_id') String? ownerId,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$PrivateTheaterModelCopyWithImpl<$Res, $Val extends PrivateTheaterModel>
    implements $PrivateTheaterModelCopyWith<$Res> {
  _$PrivateTheaterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivateTheaterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? pinCode = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? capacity = null,
    Object? amenities = null,
    Object? images = null,
    Object? hourlyRate = null,
    Object? rating = null,
    Object? totalReviews = null,
    Object? isActive = null,
    Object? ownerId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      pinCode: null == pinCode
          ? _value.pinCode
          : pinCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      amenities: null == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hourlyRate: null == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PrivateTheaterModelImplCopyWith<$Res>
    implements $PrivateTheaterModelCopyWith<$Res> {
  factory _$$PrivateTheaterModelImplCopyWith(_$PrivateTheaterModelImpl value,
          $Res Function(_$PrivateTheaterModelImpl) then) =
      __$$PrivateTheaterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String address,
      String city,
      String state,
      @JsonKey(name: 'pin_code') String pinCode,
      double? latitude,
      double? longitude,
      int capacity,
      List<String> amenities,
      List<String> images,
      @JsonKey(name: 'hourly_rate') double hourlyRate,
      double rating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'owner_id') String? ownerId,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$PrivateTheaterModelImplCopyWithImpl<$Res>
    extends _$PrivateTheaterModelCopyWithImpl<$Res, _$PrivateTheaterModelImpl>
    implements _$$PrivateTheaterModelImplCopyWith<$Res> {
  __$$PrivateTheaterModelImplCopyWithImpl(_$PrivateTheaterModelImpl _value,
      $Res Function(_$PrivateTheaterModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrivateTheaterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? pinCode = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? capacity = null,
    Object? amenities = null,
    Object? images = null,
    Object? hourlyRate = null,
    Object? rating = null,
    Object? totalReviews = null,
    Object? isActive = null,
    Object? ownerId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PrivateTheaterModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      pinCode: null == pinCode
          ? _value.pinCode
          : pinCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      amenities: null == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hourlyRate: null == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
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
class _$PrivateTheaterModelImpl implements _PrivateTheaterModel {
  const _$PrivateTheaterModelImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.address,
      required this.city,
      required this.state,
      @JsonKey(name: 'pin_code') required this.pinCode,
      this.latitude,
      this.longitude,
      required this.capacity,
      required final List<String> amenities,
      required final List<String> images,
      @JsonKey(name: 'hourly_rate') required this.hourlyRate,
      required this.rating,
      @JsonKey(name: 'total_reviews') required this.totalReviews,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'owner_id') this.ownerId,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _amenities = amenities,
        _images = images;

  factory _$PrivateTheaterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivateTheaterModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String address;
  @override
  final String city;
  @override
  final String state;
  @override
  @JsonKey(name: 'pin_code')
  final String pinCode;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final int capacity;
  final List<String> _amenities;
  @override
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'hourly_rate')
  final double hourlyRate;
  @override
  final double rating;
  @override
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'owner_id')
  final String? ownerId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PrivateTheaterModel(id: $id, name: $name, description: $description, address: $address, city: $city, state: $state, pinCode: $pinCode, latitude: $latitude, longitude: $longitude, capacity: $capacity, amenities: $amenities, images: $images, hourlyRate: $hourlyRate, rating: $rating, totalReviews: $totalReviews, isActive: $isActive, ownerId: $ownerId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivateTheaterModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.pinCode, pinCode) || other.pinCode == pinCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        address,
        city,
        state,
        pinCode,
        latitude,
        longitude,
        capacity,
        const DeepCollectionEquality().hash(_amenities),
        const DeepCollectionEquality().hash(_images),
        hourlyRate,
        rating,
        totalReviews,
        isActive,
        ownerId,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of PrivateTheaterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivateTheaterModelImplCopyWith<_$PrivateTheaterModelImpl> get copyWith =>
      __$$PrivateTheaterModelImplCopyWithImpl<_$PrivateTheaterModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivateTheaterModelImplToJson(
      this,
    );
  }
}

abstract class _PrivateTheaterModel implements PrivateTheaterModel {
  const factory _PrivateTheaterModel(
          {required final String id,
          required final String name,
          final String? description,
          required final String address,
          required final String city,
          required final String state,
          @JsonKey(name: 'pin_code') required final String pinCode,
          final double? latitude,
          final double? longitude,
          required final int capacity,
          required final List<String> amenities,
          required final List<String> images,
          @JsonKey(name: 'hourly_rate') required final double hourlyRate,
          required final double rating,
          @JsonKey(name: 'total_reviews') required final int totalReviews,
          @JsonKey(name: 'is_active') required final bool isActive,
          @JsonKey(name: 'owner_id') final String? ownerId,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$PrivateTheaterModelImpl;

  factory _PrivateTheaterModel.fromJson(Map<String, dynamic> json) =
      _$PrivateTheaterModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get address;
  @override
  String get city;
  @override
  String get state;
  @override
  @JsonKey(name: 'pin_code')
  String get pinCode;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  int get capacity;
  @override
  List<String> get amenities;
  @override
  List<String> get images;
  @override
  @JsonKey(name: 'hourly_rate')
  double get hourlyRate;
  @override
  double get rating;
  @override
  @JsonKey(name: 'total_reviews')
  int get totalReviews;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'owner_id')
  String? get ownerId;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of PrivateTheaterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivateTheaterModelImplCopyWith<_$PrivateTheaterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
