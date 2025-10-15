// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) {
  return _CouponModel.fromJson(json);
}

/// @nodoc
mixin _$CouponModel {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_type')
  String get discountType =>
      throw _privateConstructorUsedError; // 'percentage' or 'fixed'
  @JsonKey(name: 'discount_value')
  double get discountValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_discount_amount')
  double? get maxDiscountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_order_amount')
  double? get minOrderAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_limit')
  int? get usageLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'used_count')
  int? get usedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_from')
  DateTime? get validFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_until')
  DateTime? get validUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CouponModelCopyWith<CouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponModelCopyWith<$Res> {
  factory $CouponModelCopyWith(
          CouponModel value, $Res Function(CouponModel) then) =
      _$CouponModelCopyWithImpl<$Res, CouponModel>;
  @useResult
  $Res call(
      {String id,
      String code,
      String? description,
      @JsonKey(name: 'discount_type') String discountType,
      @JsonKey(name: 'discount_value') double discountValue,
      @JsonKey(name: 'max_discount_amount') double? maxDiscountAmount,
      @JsonKey(name: 'min_order_amount') double? minOrderAmount,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'usage_limit') int? usageLimit,
      @JsonKey(name: 'used_count') int? usedCount,
      @JsonKey(name: 'valid_from') DateTime? validFrom,
      @JsonKey(name: 'valid_until') DateTime? validUntil,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$CouponModelCopyWithImpl<$Res, $Val extends CouponModel>
    implements $CouponModelCopyWith<$Res> {
  _$CouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? description = freezed,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxDiscountAmount = freezed,
    Object? minOrderAmount = freezed,
    Object? isActive = null,
    Object? isPublic = null,
    Object? usageLimit = freezed,
    Object? usedCount = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiscountAmount: freezed == maxDiscountAmount
          ? _value.maxDiscountAmount
          : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      minOrderAmount: freezed == minOrderAmount
          ? _value.minOrderAmount
          : minOrderAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      usageLimit: freezed == usageLimit
          ? _value.usageLimit
          : usageLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: freezed == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      validFrom: freezed == validFrom
          ? _value.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      validUntil: freezed == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$CouponModelImplCopyWith<$Res>
    implements $CouponModelCopyWith<$Res> {
  factory _$$CouponModelImplCopyWith(
          _$CouponModelImpl value, $Res Function(_$CouponModelImpl) then) =
      __$$CouponModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String? description,
      @JsonKey(name: 'discount_type') String discountType,
      @JsonKey(name: 'discount_value') double discountValue,
      @JsonKey(name: 'max_discount_amount') double? maxDiscountAmount,
      @JsonKey(name: 'min_order_amount') double? minOrderAmount,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'usage_limit') int? usageLimit,
      @JsonKey(name: 'used_count') int? usedCount,
      @JsonKey(name: 'valid_from') DateTime? validFrom,
      @JsonKey(name: 'valid_until') DateTime? validUntil,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$CouponModelImplCopyWithImpl<$Res>
    extends _$CouponModelCopyWithImpl<$Res, _$CouponModelImpl>
    implements _$$CouponModelImplCopyWith<$Res> {
  __$$CouponModelImplCopyWithImpl(
      _$CouponModelImpl _value, $Res Function(_$CouponModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? description = freezed,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxDiscountAmount = freezed,
    Object? minOrderAmount = freezed,
    Object? isActive = null,
    Object? isPublic = null,
    Object? usageLimit = freezed,
    Object? usedCount = freezed,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CouponModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiscountAmount: freezed == maxDiscountAmount
          ? _value.maxDiscountAmount
          : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      minOrderAmount: freezed == minOrderAmount
          ? _value.minOrderAmount
          : minOrderAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      usageLimit: freezed == usageLimit
          ? _value.usageLimit
          : usageLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: freezed == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      validFrom: freezed == validFrom
          ? _value.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      validUntil: freezed == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$CouponModelImpl implements _CouponModel {
  const _$CouponModelImpl(
      {required this.id,
      required this.code,
      this.description,
      @JsonKey(name: 'discount_type') required this.discountType,
      @JsonKey(name: 'discount_value') required this.discountValue,
      @JsonKey(name: 'max_discount_amount') this.maxDiscountAmount,
      @JsonKey(name: 'min_order_amount') this.minOrderAmount,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'is_public') required this.isPublic,
      @JsonKey(name: 'usage_limit') this.usageLimit,
      @JsonKey(name: 'used_count') this.usedCount,
      @JsonKey(name: 'valid_from') this.validFrom,
      @JsonKey(name: 'valid_until') this.validUntil,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$CouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponModelImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String? description;
  @override
  @JsonKey(name: 'discount_type')
  final String discountType;
// 'percentage' or 'fixed'
  @override
  @JsonKey(name: 'discount_value')
  final double discountValue;
  @override
  @JsonKey(name: 'max_discount_amount')
  final double? maxDiscountAmount;
  @override
  @JsonKey(name: 'min_order_amount')
  final double? minOrderAmount;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  @JsonKey(name: 'usage_limit')
  final int? usageLimit;
  @override
  @JsonKey(name: 'used_count')
  final int? usedCount;
  @override
  @JsonKey(name: 'valid_from')
  final DateTime? validFrom;
  @override
  @JsonKey(name: 'valid_until')
  final DateTime? validUntil;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CouponModel(id: $id, code: $code, description: $description, discountType: $discountType, discountValue: $discountValue, maxDiscountAmount: $maxDiscountAmount, minOrderAmount: $minOrderAmount, isActive: $isActive, isPublic: $isPublic, usageLimit: $usageLimit, usedCount: $usedCount, validFrom: $validFrom, validUntil: $validUntil, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.maxDiscountAmount, maxDiscountAmount) ||
                other.maxDiscountAmount == maxDiscountAmount) &&
            (identical(other.minOrderAmount, minOrderAmount) ||
                other.minOrderAmount == minOrderAmount) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.usageLimit, usageLimit) ||
                other.usageLimit == usageLimit) &&
            (identical(other.usedCount, usedCount) ||
                other.usedCount == usedCount) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
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
      code,
      description,
      discountType,
      discountValue,
      maxDiscountAmount,
      minOrderAmount,
      isActive,
      isPublic,
      usageLimit,
      usedCount,
      validFrom,
      validUntil,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponModelImplCopyWith<_$CouponModelImpl> get copyWith =>
      __$$CouponModelImplCopyWithImpl<_$CouponModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponModelImplToJson(
      this,
    );
  }
}

abstract class _CouponModel implements CouponModel {
  const factory _CouponModel(
          {required final String id,
          required final String code,
          final String? description,
          @JsonKey(name: 'discount_type') required final String discountType,
          @JsonKey(name: 'discount_value') required final double discountValue,
          @JsonKey(name: 'max_discount_amount') final double? maxDiscountAmount,
          @JsonKey(name: 'min_order_amount') final double? minOrderAmount,
          @JsonKey(name: 'is_active') required final bool isActive,
          @JsonKey(name: 'is_public') required final bool isPublic,
          @JsonKey(name: 'usage_limit') final int? usageLimit,
          @JsonKey(name: 'used_count') final int? usedCount,
          @JsonKey(name: 'valid_from') final DateTime? validFrom,
          @JsonKey(name: 'valid_until') final DateTime? validUntil,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$CouponModelImpl;

  factory _CouponModel.fromJson(Map<String, dynamic> json) =
      _$CouponModelImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String? get description;
  @override
  @JsonKey(name: 'discount_type')
  String get discountType;
  @override // 'percentage' or 'fixed'
  @JsonKey(name: 'discount_value')
  double get discountValue;
  @override
  @JsonKey(name: 'max_discount_amount')
  double? get maxDiscountAmount;
  @override
  @JsonKey(name: 'min_order_amount')
  double? get minOrderAmount;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  @JsonKey(name: 'usage_limit')
  int? get usageLimit;
  @override
  @JsonKey(name: 'used_count')
  int? get usedCount;
  @override
  @JsonKey(name: 'valid_from')
  DateTime? get validFrom;
  @override
  @JsonKey(name: 'valid_until')
  DateTime? get validUntil;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$CouponModelImplCopyWith<_$CouponModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
