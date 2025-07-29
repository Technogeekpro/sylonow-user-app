// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cake_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CakeModel _$CakeModelFromJson(Map<String, dynamic> json) {
  return _CakeModel.fromJson(json);
}

/// @nodoc
mixin _$CakeModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;
  String? get flavor => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'preparation_time_minutes')
  int? get preparationTimeMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CakeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CakeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CakeModelCopyWith<CakeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CakeModelCopyWith<$Res> {
  factory $CakeModelCopyWith(CakeModel value, $Res Function(CakeModel) then) =
      _$CakeModelCopyWithImpl<$Res, CakeModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      String name,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      double price,
      String? size,
      String? flavor,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'preparation_time_minutes') int? preparationTimeMinutes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$CakeModelCopyWithImpl<$Res, $Val extends CakeModel>
    implements $CakeModelCopyWith<$Res> {
  _$CakeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CakeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? price = null,
    Object? size = freezed,
    Object? flavor = freezed,
    Object? isAvailable = null,
    Object? preparationTimeMinutes = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      flavor: freezed == flavor
          ? _value.flavor
          : flavor // ignore: cast_nullable_to_non_nullable
              as String?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      preparationTimeMinutes: freezed == preparationTimeMinutes
          ? _value.preparationTimeMinutes
          : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$CakeModelImplCopyWith<$Res>
    implements $CakeModelCopyWith<$Res> {
  factory _$$CakeModelImplCopyWith(
          _$CakeModelImpl value, $Res Function(_$CakeModelImpl) then) =
      __$$CakeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      String name,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      double price,
      String? size,
      String? flavor,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'preparation_time_minutes') int? preparationTimeMinutes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$CakeModelImplCopyWithImpl<$Res>
    extends _$CakeModelCopyWithImpl<$Res, _$CakeModelImpl>
    implements _$$CakeModelImplCopyWith<$Res> {
  __$$CakeModelImplCopyWithImpl(
      _$CakeModelImpl _value, $Res Function(_$CakeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CakeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? price = null,
    Object? size = freezed,
    Object? flavor = freezed,
    Object? isAvailable = null,
    Object? preparationTimeMinutes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CakeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      flavor: freezed == flavor
          ? _value.flavor
          : flavor // ignore: cast_nullable_to_non_nullable
              as String?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      preparationTimeMinutes: freezed == preparationTimeMinutes
          ? _value.preparationTimeMinutes
          : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$CakeModelImpl implements _CakeModel {
  const _$CakeModelImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      required this.name,
      this.description,
      @JsonKey(name: 'image_url') this.imageUrl,
      required this.price,
      this.size,
      this.flavor,
      @JsonKey(name: 'is_available') required this.isAvailable,
      @JsonKey(name: 'preparation_time_minutes') this.preparationTimeMinutes,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$CakeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CakeModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final double price;
  @override
  final String? size;
  @override
  final String? flavor;
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'preparation_time_minutes')
  final int? preparationTimeMinutes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CakeModel(id: $id, theaterId: $theaterId, name: $name, description: $description, imageUrl: $imageUrl, price: $price, size: $size, flavor: $flavor, isAvailable: $isAvailable, preparationTimeMinutes: $preparationTimeMinutes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CakeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.flavor, flavor) || other.flavor == flavor) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.preparationTimeMinutes, preparationTimeMinutes) ||
                other.preparationTimeMinutes == preparationTimeMinutes) &&
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
      theaterId,
      name,
      description,
      imageUrl,
      price,
      size,
      flavor,
      isAvailable,
      preparationTimeMinutes,
      createdAt,
      updatedAt);

  /// Create a copy of CakeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CakeModelImplCopyWith<_$CakeModelImpl> get copyWith =>
      __$$CakeModelImplCopyWithImpl<_$CakeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CakeModelImplToJson(
      this,
    );
  }
}

abstract class _CakeModel implements CakeModel {
  const factory _CakeModel(
          {required final String id,
          @JsonKey(name: 'theater_id') required final String theaterId,
          required final String name,
          final String? description,
          @JsonKey(name: 'image_url') final String? imageUrl,
          required final double price,
          final String? size,
          final String? flavor,
          @JsonKey(name: 'is_available') required final bool isAvailable,
          @JsonKey(name: 'preparation_time_minutes')
          final int? preparationTimeMinutes,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$CakeModelImpl;

  factory _CakeModel.fromJson(Map<String, dynamic> json) =
      _$CakeModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  double get price;
  @override
  String? get size;
  @override
  String? get flavor;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'preparation_time_minutes')
  int? get preparationTimeMinutes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of CakeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CakeModelImplCopyWith<_$CakeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
