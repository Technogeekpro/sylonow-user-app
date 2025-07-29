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
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get discountValue => throw _privateConstructorUsedError;
  String get discountType =>
      throw _privateConstructorUsedError; // 'percentage', 'fixed'
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isPublic =>
      throw _privateConstructorUsedError; // true for public coupons, false for user-specific
  String? get userId =>
      throw _privateConstructorUsedError; // for user-specific coupons
  String? get categoryId => throw _privateConstructorUsedError;
  double? get minOrderValue => throw _privateConstructorUsedError;
  double? get maxDiscountAmount => throw _privateConstructorUsedError;
  int? get maxUsagePerUser => throw _privateConstructorUsedError;
  int? get totalUsageLimit => throw _privateConstructorUsedError;
  int? get currentUsageCount => throw _privateConstructorUsedError;
  List<String>? get applicableServices => throw _privateConstructorUsedError;
  List<String>? get excludedServices => throw _privateConstructorUsedError;
  String? get termsAndConditions => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CouponModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      String title,
      String description,
      double discountValue,
      String discountType,
      DateTime startDate,
      DateTime endDate,
      bool isActive,
      bool isPublic,
      String? userId,
      String? categoryId,
      double? minOrderValue,
      double? maxDiscountAmount,
      int? maxUsagePerUser,
      int? totalUsageLimit,
      int? currentUsageCount,
      List<String>? applicableServices,
      List<String>? excludedServices,
      String? termsAndConditions,
      Map<String, dynamic>? metadata,
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

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? title = null,
    Object? description = null,
    Object? discountValue = null,
    Object? discountType = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isActive = null,
    Object? isPublic = null,
    Object? userId = freezed,
    Object? categoryId = freezed,
    Object? minOrderValue = freezed,
    Object? maxDiscountAmount = freezed,
    Object? maxUsagePerUser = freezed,
    Object? totalUsageLimit = freezed,
    Object? currentUsageCount = freezed,
    Object? applicableServices = freezed,
    Object? excludedServices = freezed,
    Object? termsAndConditions = freezed,
    Object? metadata = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      minOrderValue: freezed == minOrderValue
          ? _value.minOrderValue
          : minOrderValue // ignore: cast_nullable_to_non_nullable
              as double?,
      maxDiscountAmount: freezed == maxDiscountAmount
          ? _value.maxDiscountAmount
          : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      maxUsagePerUser: freezed == maxUsagePerUser
          ? _value.maxUsagePerUser
          : maxUsagePerUser // ignore: cast_nullable_to_non_nullable
              as int?,
      totalUsageLimit: freezed == totalUsageLimit
          ? _value.totalUsageLimit
          : totalUsageLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      currentUsageCount: freezed == currentUsageCount
          ? _value.currentUsageCount
          : currentUsageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      applicableServices: freezed == applicableServices
          ? _value.applicableServices
          : applicableServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      excludedServices: freezed == excludedServices
          ? _value.excludedServices
          : excludedServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      String title,
      String description,
      double discountValue,
      String discountType,
      DateTime startDate,
      DateTime endDate,
      bool isActive,
      bool isPublic,
      String? userId,
      String? categoryId,
      double? minOrderValue,
      double? maxDiscountAmount,
      int? maxUsagePerUser,
      int? totalUsageLimit,
      int? currentUsageCount,
      List<String>? applicableServices,
      List<String>? excludedServices,
      String? termsAndConditions,
      Map<String, dynamic>? metadata,
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

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? title = null,
    Object? description = null,
    Object? discountValue = null,
    Object? discountType = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isActive = null,
    Object? isPublic = null,
    Object? userId = freezed,
    Object? categoryId = freezed,
    Object? minOrderValue = freezed,
    Object? maxDiscountAmount = freezed,
    Object? maxUsagePerUser = freezed,
    Object? totalUsageLimit = freezed,
    Object? currentUsageCount = freezed,
    Object? applicableServices = freezed,
    Object? excludedServices = freezed,
    Object? termsAndConditions = freezed,
    Object? metadata = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      minOrderValue: freezed == minOrderValue
          ? _value.minOrderValue
          : minOrderValue // ignore: cast_nullable_to_non_nullable
              as double?,
      maxDiscountAmount: freezed == maxDiscountAmount
          ? _value.maxDiscountAmount
          : maxDiscountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      maxUsagePerUser: freezed == maxUsagePerUser
          ? _value.maxUsagePerUser
          : maxUsagePerUser // ignore: cast_nullable_to_non_nullable
              as int?,
      totalUsageLimit: freezed == totalUsageLimit
          ? _value.totalUsageLimit
          : totalUsageLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      currentUsageCount: freezed == currentUsageCount
          ? _value.currentUsageCount
          : currentUsageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      applicableServices: freezed == applicableServices
          ? _value._applicableServices
          : applicableServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      excludedServices: freezed == excludedServices
          ? _value._excludedServices
          : excludedServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      required this.title,
      required this.description,
      required this.discountValue,
      required this.discountType,
      required this.startDate,
      required this.endDate,
      required this.isActive,
      required this.isPublic,
      this.userId,
      this.categoryId,
      this.minOrderValue,
      this.maxDiscountAmount,
      this.maxUsagePerUser,
      this.totalUsageLimit,
      this.currentUsageCount,
      final List<String>? applicableServices,
      final List<String>? excludedServices,
      this.termsAndConditions,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _applicableServices = applicableServices,
        _excludedServices = excludedServices,
        _metadata = metadata;

  factory _$CouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponModelImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String title;
  @override
  final String description;
  @override
  final double discountValue;
  @override
  final String discountType;
// 'percentage', 'fixed'
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final bool isActive;
  @override
  final bool isPublic;
// true for public coupons, false for user-specific
  @override
  final String? userId;
// for user-specific coupons
  @override
  final String? categoryId;
  @override
  final double? minOrderValue;
  @override
  final double? maxDiscountAmount;
  @override
  final int? maxUsagePerUser;
  @override
  final int? totalUsageLimit;
  @override
  final int? currentUsageCount;
  final List<String>? _applicableServices;
  @override
  List<String>? get applicableServices {
    final value = _applicableServices;
    if (value == null) return null;
    if (_applicableServices is EqualUnmodifiableListView)
      return _applicableServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _excludedServices;
  @override
  List<String>? get excludedServices {
    final value = _excludedServices;
    if (value == null) return null;
    if (_excludedServices is EqualUnmodifiableListView)
      return _excludedServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? termsAndConditions;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CouponModel(id: $id, code: $code, title: $title, description: $description, discountValue: $discountValue, discountType: $discountType, startDate: $startDate, endDate: $endDate, isActive: $isActive, isPublic: $isPublic, userId: $userId, categoryId: $categoryId, minOrderValue: $minOrderValue, maxDiscountAmount: $maxDiscountAmount, maxUsagePerUser: $maxUsagePerUser, totalUsageLimit: $totalUsageLimit, currentUsageCount: $currentUsageCount, applicableServices: $applicableServices, excludedServices: $excludedServices, termsAndConditions: $termsAndConditions, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.minOrderValue, minOrderValue) ||
                other.minOrderValue == minOrderValue) &&
            (identical(other.maxDiscountAmount, maxDiscountAmount) ||
                other.maxDiscountAmount == maxDiscountAmount) &&
            (identical(other.maxUsagePerUser, maxUsagePerUser) ||
                other.maxUsagePerUser == maxUsagePerUser) &&
            (identical(other.totalUsageLimit, totalUsageLimit) ||
                other.totalUsageLimit == totalUsageLimit) &&
            (identical(other.currentUsageCount, currentUsageCount) ||
                other.currentUsageCount == currentUsageCount) &&
            const DeepCollectionEquality()
                .equals(other._applicableServices, _applicableServices) &&
            const DeepCollectionEquality()
                .equals(other._excludedServices, _excludedServices) &&
            (identical(other.termsAndConditions, termsAndConditions) ||
                other.termsAndConditions == termsAndConditions) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
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
        code,
        title,
        description,
        discountValue,
        discountType,
        startDate,
        endDate,
        isActive,
        isPublic,
        userId,
        categoryId,
        minOrderValue,
        maxDiscountAmount,
        maxUsagePerUser,
        totalUsageLimit,
        currentUsageCount,
        const DeepCollectionEquality().hash(_applicableServices),
        const DeepCollectionEquality().hash(_excludedServices),
        termsAndConditions,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
          required final String title,
          required final String description,
          required final double discountValue,
          required final String discountType,
          required final DateTime startDate,
          required final DateTime endDate,
          required final bool isActive,
          required final bool isPublic,
          final String? userId,
          final String? categoryId,
          final double? minOrderValue,
          final double? maxDiscountAmount,
          final int? maxUsagePerUser,
          final int? totalUsageLimit,
          final int? currentUsageCount,
          final List<String>? applicableServices,
          final List<String>? excludedServices,
          final String? termsAndConditions,
          final Map<String, dynamic>? metadata,
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
  String get title;
  @override
  String get description;
  @override
  double get discountValue;
  @override
  String get discountType; // 'percentage', 'fixed'
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  bool get isActive;
  @override
  bool get isPublic; // true for public coupons, false for user-specific
  @override
  String? get userId; // for user-specific coupons
  @override
  String? get categoryId;
  @override
  double? get minOrderValue;
  @override
  double? get maxDiscountAmount;
  @override
  int? get maxUsagePerUser;
  @override
  int? get totalUsageLimit;
  @override
  int? get currentUsageCount;
  @override
  List<String>? get applicableServices;
  @override
  List<String>? get excludedServices;
  @override
  String? get termsAndConditions;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponModelImplCopyWith<_$CouponModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
