// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'occasion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OccasionModel _$OccasionModelFromJson(Map<String, dynamic> json) {
  return _OccasionModel.fromJson(json);
}

/// @nodoc
mixin _$OccasionModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'color_code')
  String? get colorCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this OccasionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OccasionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OccasionModelCopyWith<OccasionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OccasionModelCopyWith<$Res> {
  factory $OccasionModelCopyWith(
          OccasionModel value, $Res Function(OccasionModel) then) =
      _$OccasionModelCopyWithImpl<$Res, OccasionModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'color_code') String? colorCode,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$OccasionModelCopyWithImpl<$Res, $Val extends OccasionModel>
    implements $OccasionModelCopyWith<$Res> {
  _$OccasionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OccasionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? colorCode = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
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
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      colorCode: freezed == colorCode
          ? _value.colorCode
          : colorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OccasionModelImplCopyWith<$Res>
    implements $OccasionModelCopyWith<$Res> {
  factory _$$OccasionModelImplCopyWith(
          _$OccasionModelImpl value, $Res Function(_$OccasionModelImpl) then) =
      __$$OccasionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      @JsonKey(name: 'icon_url') String? iconUrl,
      @JsonKey(name: 'color_code') String? colorCode,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$OccasionModelImplCopyWithImpl<$Res>
    extends _$OccasionModelCopyWithImpl<$Res, _$OccasionModelImpl>
    implements _$$OccasionModelImplCopyWith<$Res> {
  __$$OccasionModelImplCopyWithImpl(
      _$OccasionModelImpl _value, $Res Function(_$OccasionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OccasionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? colorCode = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$OccasionModelImpl(
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
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      colorCode: freezed == colorCode
          ? _value.colorCode
          : colorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OccasionModelImpl implements _OccasionModel {
  const _$OccasionModelImpl(
      {required this.id,
      required this.name,
      this.description,
      @JsonKey(name: 'icon_url') this.iconUrl,
      @JsonKey(name: 'color_code') this.colorCode,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$OccasionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OccasionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  @JsonKey(name: 'color_code')
  final String? colorCode;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'OccasionModel(id: $id, name: $name, description: $description, iconUrl: $iconUrl, colorCode: $colorCode, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OccasionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.colorCode, colorCode) ||
                other.colorCode == colorCode) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, iconUrl,
      colorCode, isActive, createdAt);

  /// Create a copy of OccasionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OccasionModelImplCopyWith<_$OccasionModelImpl> get copyWith =>
      __$$OccasionModelImplCopyWithImpl<_$OccasionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OccasionModelImplToJson(
      this,
    );
  }
}

abstract class _OccasionModel implements OccasionModel {
  const factory _OccasionModel(
          {required final String id,
          required final String name,
          final String? description,
          @JsonKey(name: 'icon_url') final String? iconUrl,
          @JsonKey(name: 'color_code') final String? colorCode,
          @JsonKey(name: 'is_active') required final bool isActive,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$OccasionModelImpl;

  factory _OccasionModel.fromJson(Map<String, dynamic> json) =
      _$OccasionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(name: 'color_code')
  String? get colorCode;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of OccasionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OccasionModelImplCopyWith<_$OccasionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
