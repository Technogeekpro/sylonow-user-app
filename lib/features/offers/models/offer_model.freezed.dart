// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OfferModel _$OfferModelFromJson(Map<String, dynamic> json) {
  return _OfferModel.fromJson(json);
}

/// @nodoc
mixin _$OfferModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  double get discountPercentage => throw _privateConstructorUsedError;
  String? get discountAmount => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get offerType =>
      throw _privateConstructorUsedError; // 'percentage', 'fixed', 'bogo'
  String? get categoryId => throw _privateConstructorUsedError;
  double? get minOrderValue => throw _privateConstructorUsedError;
  int? get maxUsageCount => throw _privateConstructorUsedError;
  int? get usedCount => throw _privateConstructorUsedError;
  String? get termsAndConditions => throw _privateConstructorUsedError;
  List<String>? get applicableServices => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OfferModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OfferModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfferModelCopyWith<OfferModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfferModelCopyWith<$Res> {
  factory $OfferModelCopyWith(
          OfferModel value, $Res Function(OfferModel) then) =
      _$OfferModelCopyWithImpl<$Res, OfferModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String imageUrl,
      double discountPercentage,
      String? discountAmount,
      DateTime startDate,
      DateTime endDate,
      bool isActive,
      String offerType,
      String? categoryId,
      double? minOrderValue,
      int? maxUsageCount,
      int? usedCount,
      String? termsAndConditions,
      List<String>? applicableServices,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$OfferModelCopyWithImpl<$Res, $Val extends OfferModel>
    implements $OfferModelCopyWith<$Res> {
  _$OfferModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfferModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? discountPercentage = null,
    Object? discountAmount = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? isActive = null,
    Object? offerType = null,
    Object? categoryId = freezed,
    Object? minOrderValue = freezed,
    Object? maxUsageCount = freezed,
    Object? usedCount = freezed,
    Object? termsAndConditions = freezed,
    Object? applicableServices = freezed,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as String?,
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
      offerType: null == offerType
          ? _value.offerType
          : offerType // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      minOrderValue: freezed == minOrderValue
          ? _value.minOrderValue
          : minOrderValue // ignore: cast_nullable_to_non_nullable
              as double?,
      maxUsageCount: freezed == maxUsageCount
          ? _value.maxUsageCount
          : maxUsageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: freezed == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      applicableServices: freezed == applicableServices
          ? _value.applicableServices
          : applicableServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
abstract class _$$OfferModelImplCopyWith<$Res>
    implements $OfferModelCopyWith<$Res> {
  factory _$$OfferModelImplCopyWith(
          _$OfferModelImpl value, $Res Function(_$OfferModelImpl) then) =
      __$$OfferModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String imageUrl,
      double discountPercentage,
      String? discountAmount,
      DateTime startDate,
      DateTime endDate,
      bool isActive,
      String offerType,
      String? categoryId,
      double? minOrderValue,
      int? maxUsageCount,
      int? usedCount,
      String? termsAndConditions,
      List<String>? applicableServices,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$OfferModelImplCopyWithImpl<$Res>
    extends _$OfferModelCopyWithImpl<$Res, _$OfferModelImpl>
    implements _$$OfferModelImplCopyWith<$Res> {
  __$$OfferModelImplCopyWithImpl(
      _$OfferModelImpl _value, $Res Function(_$OfferModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OfferModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? discountPercentage = null,
    Object? discountAmount = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? isActive = null,
    Object? offerType = null,
    Object? categoryId = freezed,
    Object? minOrderValue = freezed,
    Object? maxUsageCount = freezed,
    Object? usedCount = freezed,
    Object? termsAndConditions = freezed,
    Object? applicableServices = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$OfferModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as String?,
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
      offerType: null == offerType
          ? _value.offerType
          : offerType // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      minOrderValue: freezed == minOrderValue
          ? _value.minOrderValue
          : minOrderValue // ignore: cast_nullable_to_non_nullable
              as double?,
      maxUsageCount: freezed == maxUsageCount
          ? _value.maxUsageCount
          : maxUsageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: freezed == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      applicableServices: freezed == applicableServices
          ? _value._applicableServices
          : applicableServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
class _$OfferModelImpl implements _OfferModel {
  const _$OfferModelImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.discountPercentage,
      this.discountAmount,
      required this.startDate,
      required this.endDate,
      required this.isActive,
      required this.offerType,
      this.categoryId,
      this.minOrderValue,
      this.maxUsageCount,
      this.usedCount,
      this.termsAndConditions,
      final List<String>? applicableServices,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _applicableServices = applicableServices;

  factory _$OfferModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfferModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String imageUrl;
  @override
  final double discountPercentage;
  @override
  final String? discountAmount;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final bool isActive;
  @override
  final String offerType;
// 'percentage', 'fixed', 'bogo'
  @override
  final String? categoryId;
  @override
  final double? minOrderValue;
  @override
  final int? maxUsageCount;
  @override
  final int? usedCount;
  @override
  final String? termsAndConditions;
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

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'OfferModel(id: $id, title: $title, description: $description, imageUrl: $imageUrl, discountPercentage: $discountPercentage, discountAmount: $discountAmount, startDate: $startDate, endDate: $endDate, isActive: $isActive, offerType: $offerType, categoryId: $categoryId, minOrderValue: $minOrderValue, maxUsageCount: $maxUsageCount, usedCount: $usedCount, termsAndConditions: $termsAndConditions, applicableServices: $applicableServices, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfferModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.offerType, offerType) ||
                other.offerType == offerType) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.minOrderValue, minOrderValue) ||
                other.minOrderValue == minOrderValue) &&
            (identical(other.maxUsageCount, maxUsageCount) ||
                other.maxUsageCount == maxUsageCount) &&
            (identical(other.usedCount, usedCount) ||
                other.usedCount == usedCount) &&
            (identical(other.termsAndConditions, termsAndConditions) ||
                other.termsAndConditions == termsAndConditions) &&
            const DeepCollectionEquality()
                .equals(other._applicableServices, _applicableServices) &&
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
      title,
      description,
      imageUrl,
      discountPercentage,
      discountAmount,
      startDate,
      endDate,
      isActive,
      offerType,
      categoryId,
      minOrderValue,
      maxUsageCount,
      usedCount,
      termsAndConditions,
      const DeepCollectionEquality().hash(_applicableServices),
      createdAt,
      updatedAt);

  /// Create a copy of OfferModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfferModelImplCopyWith<_$OfferModelImpl> get copyWith =>
      __$$OfferModelImplCopyWithImpl<_$OfferModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfferModelImplToJson(
      this,
    );
  }
}

abstract class _OfferModel implements OfferModel {
  const factory _OfferModel(
          {required final String id,
          required final String title,
          required final String description,
          required final String imageUrl,
          required final double discountPercentage,
          final String? discountAmount,
          required final DateTime startDate,
          required final DateTime endDate,
          required final bool isActive,
          required final String offerType,
          final String? categoryId,
          final double? minOrderValue,
          final int? maxUsageCount,
          final int? usedCount,
          final String? termsAndConditions,
          final List<String>? applicableServices,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$OfferModelImpl;

  factory _OfferModel.fromJson(Map<String, dynamic> json) =
      _$OfferModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get imageUrl;
  @override
  double get discountPercentage;
  @override
  String? get discountAmount;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  bool get isActive;
  @override
  String get offerType; // 'percentage', 'fixed', 'bogo'
  @override
  String? get categoryId;
  @override
  double? get minOrderValue;
  @override
  int? get maxUsageCount;
  @override
  int? get usedCount;
  @override
  String? get termsAndConditions;
  @override
  List<String>? get applicableServices;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of OfferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfferModelImplCopyWith<_$OfferModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
