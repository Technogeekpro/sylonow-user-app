// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceTypeModel _$ServiceTypeModelFromJson(Map<String, dynamic> json) {
  return _ServiceTypeModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceTypeModel {
  /// Unique identifier for the service type
  String get id => throw _privateConstructorUsedError;

  /// Name of the service type
  String get name => throw _privateConstructorUsedError;

  /// Description of the service type
  String? get description => throw _privateConstructorUsedError;

  /// Icon URL for the service type
  String? get iconUrl => throw _privateConstructorUsedError;

  /// Category this service type belongs to
  String? get category => throw _privateConstructorUsedError;

  /// Whether this service type is active
  bool get isActive => throw _privateConstructorUsedError;

  /// Timestamp when created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when last updated
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceTypeModelCopyWith<ServiceTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceTypeModelCopyWith<$Res> {
  factory $ServiceTypeModelCopyWith(
          ServiceTypeModel value, $Res Function(ServiceTypeModel) then) =
      _$ServiceTypeModelCopyWithImpl<$Res, ServiceTypeModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? iconUrl,
      String? category,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ServiceTypeModelCopyWithImpl<$Res, $Val extends ServiceTypeModel>
    implements $ServiceTypeModelCopyWith<$Res> {
  _$ServiceTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? category = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$ServiceTypeModelImplCopyWith<$Res>
    implements $ServiceTypeModelCopyWith<$Res> {
  factory _$$ServiceTypeModelImplCopyWith(_$ServiceTypeModelImpl value,
          $Res Function(_$ServiceTypeModelImpl) then) =
      __$$ServiceTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? iconUrl,
      String? category,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ServiceTypeModelImplCopyWithImpl<$Res>
    extends _$ServiceTypeModelCopyWithImpl<$Res, _$ServiceTypeModelImpl>
    implements _$$ServiceTypeModelImplCopyWith<$Res> {
  __$$ServiceTypeModelImplCopyWithImpl(_$ServiceTypeModelImpl _value,
      $Res Function(_$ServiceTypeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? category = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ServiceTypeModelImpl(
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
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$ServiceTypeModelImpl implements _ServiceTypeModel {
  const _$ServiceTypeModelImpl(
      {required this.id,
      required this.name,
      this.description,
      this.iconUrl,
      this.category,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt});

  factory _$ServiceTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceTypeModelImplFromJson(json);

  /// Unique identifier for the service type
  @override
  final String id;

  /// Name of the service type
  @override
  final String name;

  /// Description of the service type
  @override
  final String? description;

  /// Icon URL for the service type
  @override
  final String? iconUrl;

  /// Category this service type belongs to
  @override
  final String? category;

  /// Whether this service type is active
  @override
  @JsonKey()
  final bool isActive;

  /// Timestamp when created
  @override
  final DateTime createdAt;

  /// Timestamp when last updated
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ServiceTypeModel(id: $id, name: $name, description: $description, iconUrl: $iconUrl, category: $category, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, iconUrl,
      category, isActive, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceTypeModelImplCopyWith<_$ServiceTypeModelImpl> get copyWith =>
      __$$ServiceTypeModelImplCopyWithImpl<_$ServiceTypeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceTypeModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceTypeModel implements ServiceTypeModel {
  const factory _ServiceTypeModel(
      {required final String id,
      required final String name,
      final String? description,
      final String? iconUrl,
      final String? category,
      final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ServiceTypeModelImpl;

  factory _ServiceTypeModel.fromJson(Map<String, dynamic> json) =
      _$ServiceTypeModelImpl.fromJson;

  @override

  /// Unique identifier for the service type
  String get id;
  @override

  /// Name of the service type
  String get name;
  @override

  /// Description of the service type
  String? get description;
  @override

  /// Icon URL for the service type
  String? get iconUrl;
  @override

  /// Category this service type belongs to
  String? get category;
  @override

  /// Whether this service type is active
  bool get isActive;
  @override

  /// Timestamp when created
  DateTime get createdAt;
  @override

  /// Timestamp when last updated
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ServiceTypeModelImplCopyWith<_$ServiceTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
