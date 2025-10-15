// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_on_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddOnModel _$AddOnModelFromJson(Map<String, dynamic> json) {
  return _AddOnModel.fromJson(json);
}

/// @nodoc
mixin _$AddOnModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String? get theaterId =>
      throw _privateConstructorUsedError; // Made nullable to match database
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // "extra_special", "gifts", "special_services", "cakes"
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive =>
      throw _privateConstructorUsedError; // Fixed: use is_active
  @JsonKey(name: 'vendor_id')
  String? get vendorId =>
      throw _privateConstructorUsedError; // Added vendor_id field
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddOnModelCopyWith<AddOnModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddOnModelCopyWith<$Res> {
  factory $AddOnModelCopyWith(
          AddOnModel value, $Res Function(AddOnModel) then) =
      _$AddOnModelCopyWithImpl<$Res, AddOnModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String? theaterId,
      String name,
      String? description,
      double price,
      String category,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$AddOnModelCopyWithImpl<$Res, $Val extends AddOnModel>
    implements $AddOnModelCopyWith<$Res> {
  _$AddOnModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? category = null,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? vendorId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: freezed == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AddOnModelImplCopyWith<$Res>
    implements $AddOnModelCopyWith<$Res> {
  factory _$$AddOnModelImplCopyWith(
          _$AddOnModelImpl value, $Res Function(_$AddOnModelImpl) then) =
      __$$AddOnModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String? theaterId,
      String name,
      String? description,
      double price,
      String category,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$AddOnModelImplCopyWithImpl<$Res>
    extends _$AddOnModelCopyWithImpl<$Res, _$AddOnModelImpl>
    implements _$$AddOnModelImplCopyWith<$Res> {
  __$$AddOnModelImplCopyWithImpl(
      _$AddOnModelImpl _value, $Res Function(_$AddOnModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? category = null,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? vendorId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AddOnModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: freezed == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
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
class _$AddOnModelImpl implements _AddOnModel {
  const _$AddOnModelImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') this.theaterId,
      required this.name,
      this.description,
      required this.price,
      required this.category,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'vendor_id') this.vendorId,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$AddOnModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddOnModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String? theaterId;
// Made nullable to match database
  @override
  final String name;
  @override
  final String? description;
  @override
  final double price;
  @override
  final String category;
// "extra_special", "gifts", "special_services", "cakes"
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
// Fixed: use is_active
  @override
  @JsonKey(name: 'vendor_id')
  final String? vendorId;
// Added vendor_id field
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AddOnModel(id: $id, theaterId: $theaterId, name: $name, description: $description, price: $price, category: $category, imageUrl: $imageUrl, isActive: $isActive, vendorId: $vendorId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddOnModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, theaterId, name, description,
      price, category, imageUrl, isActive, vendorId, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddOnModelImplCopyWith<_$AddOnModelImpl> get copyWith =>
      __$$AddOnModelImplCopyWithImpl<_$AddOnModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddOnModelImplToJson(
      this,
    );
  }
}

abstract class _AddOnModel implements AddOnModel {
  const factory _AddOnModel(
          {required final String id,
          @JsonKey(name: 'theater_id') final String? theaterId,
          required final String name,
          final String? description,
          required final double price,
          required final String category,
          @JsonKey(name: 'image_url') final String? imageUrl,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'vendor_id') final String? vendorId,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$AddOnModelImpl;

  factory _AddOnModel.fromJson(Map<String, dynamic> json) =
      _$AddOnModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String? get theaterId;
  @override // Made nullable to match database
  String get name;
  @override
  String? get description;
  @override
  double get price;
  @override
  String get category;
  @override // "extra_special", "gifts", "special_services", "cakes"
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override // Fixed: use is_active
  @JsonKey(name: 'vendor_id')
  String? get vendorId;
  @override // Added vendor_id field
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AddOnModelImplCopyWith<_$AddOnModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
