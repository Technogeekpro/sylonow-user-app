// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) {
  return _PromotionModel.fromJson(json);
}

/// @nodoc
mixin _$PromotionModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get bannerImageUrl => throw _privateConstructorUsedError;
  double get discountValue => throw _privateConstructorUsedError;
  String get discountType =>
      throw _privateConstructorUsedError; // 'percentage', 'fixed'
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  String get promotionType =>
      throw _privateConstructorUsedError; // 'first_time', 'seasonal', 'category_specific'
  String? get categoryId => throw _privateConstructorUsedError;
  double? get minOrderValue => throw _privateConstructorUsedError;
  int? get maxUsagePerUser => throw _privateConstructorUsedError;
  int? get totalUsageLimit => throw _privateConstructorUsedError;
  int? get currentUsageCount => throw _privateConstructorUsedError;
  String? get promoCode => throw _privateConstructorUsedError;
  String? get termsAndConditions => throw _privateConstructorUsedError;
  List<String>? get targetUserTypes =>
      throw _privateConstructorUsedError; // 'new', 'existing', 'premium'
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromotionModelCopyWith<PromotionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromotionModelCopyWith<$Res> {
  factory $PromotionModelCopyWith(
          PromotionModel value, $Res Function(PromotionModel) then) =
      _$PromotionModelCopyWithImpl<$Res, PromotionModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String subtitle,
      String description,
      String imageUrl,
      String bannerImageUrl,
      double discountValue,
      String discountType,
      DateTime startDate,
      DateTime endDate,
      bool isActive,
      bool isFeatured,
      String promotionType,
      String? categoryId,
      double? minOrderValue,
      int? maxUsagePerUser,
      int? totalUsageLimit,
      int? currentUsageCount,
      String? promoCode,
      String? termsAndConditions,
      List<String>? targetUserTypes,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$PromotionModelCopyWithImpl<$Res, $Val extends PromotionModel>
    implements $PromotionModelCopyWith<$Res> {
  _$PromotionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? bannerImageUrl = null,
    Object? discountValue = null,
    Object? discountType = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? promotionType = null,
    Object? categoryId = freezed,
    Object? minOrderValue = freezed,
    Object? maxUsagePerUser = freezed,
    Object? totalUsageLimit = freezed,
    Object? currentUsageCount = freezed,
    Object? promoCode = freezed,
    Object? termsAndConditions = freezed,
    Object? targetUserTypes = freezed,
    Object? metadata = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      bannerImageUrl: null == bannerImageUrl
          ? _value.bannerImageUrl
          : bannerImageUrl // ignore: cast_nullable_to_non_nullable
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
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      promotionType: null == promotionType
          ? _value.promotionType
          : promotionType // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      minOrderValue: freezed == minOrderValue
          ? _value.minOrderValue
          : minOrderValue // ignore: cast_nullable_to_non_nullable
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
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      targetUserTypes: freezed == targetUserTypes
          ? _value.targetUserTypes
          : targetUserTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
abstract class _$$PromotionModelImplCopyWith<$Res>
    implements $PromotionModelCopyWith<$Res> {
  factory _$$PromotionModelImplCopyWith(_$PromotionModelImpl value,
          $Res Function(_$PromotionModelImpl) then) =
      __$$PromotionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String subtitle,
      String description,
      String imageUrl,
      String bannerImageUrl,
      double discountValue,
      String discountType,
      DateTime startDate,
      DateTime endDate,
      bool isActive,
      bool isFeatured,
      String promotionType,
      String? categoryId,
      double? minOrderValue,
      int? maxUsagePerUser,
      int? totalUsageLimit,
      int? currentUsageCount,
      String? promoCode,
      String? termsAndConditions,
      List<String>? targetUserTypes,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$PromotionModelImplCopyWithImpl<$Res>
    extends _$PromotionModelCopyWithImpl<$Res, _$PromotionModelImpl>
    implements _$$PromotionModelImplCopyWith<$Res> {
  __$$PromotionModelImplCopyWithImpl(
      _$PromotionModelImpl _value, $Res Function(_$PromotionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? bannerImageUrl = null,
    Object? discountValue = null,
    Object? discountType = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? promotionType = null,
    Object? categoryId = freezed,
    Object? minOrderValue = freezed,
    Object? maxUsagePerUser = freezed,
    Object? totalUsageLimit = freezed,
    Object? currentUsageCount = freezed,
    Object? promoCode = freezed,
    Object? termsAndConditions = freezed,
    Object? targetUserTypes = freezed,
    Object? metadata = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PromotionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      bannerImageUrl: null == bannerImageUrl
          ? _value.bannerImageUrl
          : bannerImageUrl // ignore: cast_nullable_to_non_nullable
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
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      promotionType: null == promotionType
          ? _value.promotionType
          : promotionType // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      minOrderValue: freezed == minOrderValue
          ? _value.minOrderValue
          : minOrderValue // ignore: cast_nullable_to_non_nullable
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
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      targetUserTypes: freezed == targetUserTypes
          ? _value._targetUserTypes
          : targetUserTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
class _$PromotionModelImpl implements _PromotionModel {
  const _$PromotionModelImpl(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.description,
      required this.imageUrl,
      required this.bannerImageUrl,
      required this.discountValue,
      required this.discountType,
      required this.startDate,
      required this.endDate,
      required this.isActive,
      required this.isFeatured,
      required this.promotionType,
      this.categoryId,
      this.minOrderValue,
      this.maxUsagePerUser,
      this.totalUsageLimit,
      this.currentUsageCount,
      this.promoCode,
      this.termsAndConditions,
      final List<String>? targetUserTypes,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _targetUserTypes = targetUserTypes,
        _metadata = metadata;

  factory _$PromotionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromotionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String description;
  @override
  final String imageUrl;
  @override
  final String bannerImageUrl;
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
  final bool isFeatured;
  @override
  final String promotionType;
// 'first_time', 'seasonal', 'category_specific'
  @override
  final String? categoryId;
  @override
  final double? minOrderValue;
  @override
  final int? maxUsagePerUser;
  @override
  final int? totalUsageLimit;
  @override
  final int? currentUsageCount;
  @override
  final String? promoCode;
  @override
  final String? termsAndConditions;
  final List<String>? _targetUserTypes;
  @override
  List<String>? get targetUserTypes {
    final value = _targetUserTypes;
    if (value == null) return null;
    if (_targetUserTypes is EqualUnmodifiableListView) return _targetUserTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// 'new', 'existing', 'premium'
  final Map<String, dynamic>? _metadata;
// 'new', 'existing', 'premium'
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
    return 'PromotionModel(id: $id, title: $title, subtitle: $subtitle, description: $description, imageUrl: $imageUrl, bannerImageUrl: $bannerImageUrl, discountValue: $discountValue, discountType: $discountType, startDate: $startDate, endDate: $endDate, isActive: $isActive, isFeatured: $isFeatured, promotionType: $promotionType, categoryId: $categoryId, minOrderValue: $minOrderValue, maxUsagePerUser: $maxUsagePerUser, totalUsageLimit: $totalUsageLimit, currentUsageCount: $currentUsageCount, promoCode: $promoCode, termsAndConditions: $termsAndConditions, targetUserTypes: $targetUserTypes, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromotionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.bannerImageUrl, bannerImageUrl) ||
                other.bannerImageUrl == bannerImageUrl) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.promotionType, promotionType) ||
                other.promotionType == promotionType) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.minOrderValue, minOrderValue) ||
                other.minOrderValue == minOrderValue) &&
            (identical(other.maxUsagePerUser, maxUsagePerUser) ||
                other.maxUsagePerUser == maxUsagePerUser) &&
            (identical(other.totalUsageLimit, totalUsageLimit) ||
                other.totalUsageLimit == totalUsageLimit) &&
            (identical(other.currentUsageCount, currentUsageCount) ||
                other.currentUsageCount == currentUsageCount) &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            (identical(other.termsAndConditions, termsAndConditions) ||
                other.termsAndConditions == termsAndConditions) &&
            const DeepCollectionEquality()
                .equals(other._targetUserTypes, _targetUserTypes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        subtitle,
        description,
        imageUrl,
        bannerImageUrl,
        discountValue,
        discountType,
        startDate,
        endDate,
        isActive,
        isFeatured,
        promotionType,
        categoryId,
        minOrderValue,
        maxUsagePerUser,
        totalUsageLimit,
        currentUsageCount,
        promoCode,
        termsAndConditions,
        const DeepCollectionEquality().hash(_targetUserTypes),
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromotionModelImplCopyWith<_$PromotionModelImpl> get copyWith =>
      __$$PromotionModelImplCopyWithImpl<_$PromotionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromotionModelImplToJson(
      this,
    );
  }
}

abstract class _PromotionModel implements PromotionModel {
  const factory _PromotionModel(
          {required final String id,
          required final String title,
          required final String subtitle,
          required final String description,
          required final String imageUrl,
          required final String bannerImageUrl,
          required final double discountValue,
          required final String discountType,
          required final DateTime startDate,
          required final DateTime endDate,
          required final bool isActive,
          required final bool isFeatured,
          required final String promotionType,
          final String? categoryId,
          final double? minOrderValue,
          final int? maxUsagePerUser,
          final int? totalUsageLimit,
          final int? currentUsageCount,
          final String? promoCode,
          final String? termsAndConditions,
          final List<String>? targetUserTypes,
          final Map<String, dynamic>? metadata,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$PromotionModelImpl;

  factory _PromotionModel.fromJson(Map<String, dynamic> json) =
      _$PromotionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  String get description;
  @override
  String get imageUrl;
  @override
  String get bannerImageUrl;
  @override
  double get discountValue;
  @override
  String get discountType;
  @override // 'percentage', 'fixed'
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  bool get isActive;
  @override
  bool get isFeatured;
  @override
  String get promotionType;
  @override // 'first_time', 'seasonal', 'category_specific'
  String? get categoryId;
  @override
  double? get minOrderValue;
  @override
  int? get maxUsagePerUser;
  @override
  int? get totalUsageLimit;
  @override
  int? get currentUsageCount;
  @override
  String? get promoCode;
  @override
  String? get termsAndConditions;
  @override
  List<String>? get targetUserTypes;
  @override // 'new', 'existing', 'premium'
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PromotionModelImplCopyWith<_$PromotionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
