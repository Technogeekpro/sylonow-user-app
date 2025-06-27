// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_listing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceListingModel _$ServiceListingModelFromJson(Map<String, dynamic> json) {
  return _ServiceListingModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceListingModel {
  /// Unique identifier for the service listing
  String get id => throw _privateConstructorUsedError;

  /// Name of the service listing (maps to 'title' in database)
  @JsonKey(name: 'title')
  String get name => throw _privateConstructorUsedError;

  /// Image URL for the service (maps to 'cover_photo' in database)
  @JsonKey(name: 'cover_photo')
  String get image => throw _privateConstructorUsedError;

  /// Description of the service
  String? get description => throw _privateConstructorUsedError;

  /// Rating of the service
  double? get rating => throw _privateConstructorUsedError;

  /// Number of reviews
  @JsonKey(name: 'reviews_count')
  int? get reviewsCount => throw _privateConstructorUsedError;

  /// Number of offers available
  @JsonKey(name: 'offers_count')
  int? get offersCount => throw _privateConstructorUsedError;

  /// Timestamp when created
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Whether this is a featured service
  @JsonKey(name: 'is_featured')
  bool? get isFeatured => throw _privateConstructorUsedError;

  /// Whether the service is active
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this ServiceListingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceListingModelCopyWith<ServiceListingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceListingModelCopyWith<$Res> {
  factory $ServiceListingModelCopyWith(
          ServiceListingModel value, $Res Function(ServiceListingModel) then) =
      _$ServiceListingModelCopyWithImpl<$Res, ServiceListingModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'title') String name,
      @JsonKey(name: 'cover_photo') String image,
      String? description,
      double? rating,
      @JsonKey(name: 'reviews_count') int? reviewsCount,
      @JsonKey(name: 'offers_count') int? offersCount,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'is_featured') bool? isFeatured,
      @JsonKey(name: 'is_active') bool? isActive});
}

/// @nodoc
class _$ServiceListingModelCopyWithImpl<$Res, $Val extends ServiceListingModel>
    implements $ServiceListingModelCopyWith<$Res> {
  _$ServiceListingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? image = null,
    Object? description = freezed,
    Object? rating = freezed,
    Object? reviewsCount = freezed,
    Object? offersCount = freezed,
    Object? createdAt = freezed,
    Object? isFeatured = freezed,
    Object? isActive = freezed,
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
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewsCount: freezed == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      offersCount: freezed == offersCount
          ? _value.offersCount
          : offersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceListingModelImplCopyWith<$Res>
    implements $ServiceListingModelCopyWith<$Res> {
  factory _$$ServiceListingModelImplCopyWith(_$ServiceListingModelImpl value,
          $Res Function(_$ServiceListingModelImpl) then) =
      __$$ServiceListingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'title') String name,
      @JsonKey(name: 'cover_photo') String image,
      String? description,
      double? rating,
      @JsonKey(name: 'reviews_count') int? reviewsCount,
      @JsonKey(name: 'offers_count') int? offersCount,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'is_featured') bool? isFeatured,
      @JsonKey(name: 'is_active') bool? isActive});
}

/// @nodoc
class __$$ServiceListingModelImplCopyWithImpl<$Res>
    extends _$ServiceListingModelCopyWithImpl<$Res, _$ServiceListingModelImpl>
    implements _$$ServiceListingModelImplCopyWith<$Res> {
  __$$ServiceListingModelImplCopyWithImpl(_$ServiceListingModelImpl _value,
      $Res Function(_$ServiceListingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? image = null,
    Object? description = freezed,
    Object? rating = freezed,
    Object? reviewsCount = freezed,
    Object? offersCount = freezed,
    Object? createdAt = freezed,
    Object? isFeatured = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$ServiceListingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewsCount: freezed == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      offersCount: freezed == offersCount
          ? _value.offersCount
          : offersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceListingModelImpl implements _ServiceListingModel {
  const _$ServiceListingModelImpl(
      {required this.id,
      @JsonKey(name: 'title') required this.name,
      @JsonKey(name: 'cover_photo') required this.image,
      this.description,
      this.rating,
      @JsonKey(name: 'reviews_count') this.reviewsCount,
      @JsonKey(name: 'offers_count') this.offersCount,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'is_featured') this.isFeatured,
      @JsonKey(name: 'is_active') this.isActive});

  factory _$ServiceListingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceListingModelImplFromJson(json);

  /// Unique identifier for the service listing
  @override
  final String id;

  /// Name of the service listing (maps to 'title' in database)
  @override
  @JsonKey(name: 'title')
  final String name;

  /// Image URL for the service (maps to 'cover_photo' in database)
  @override
  @JsonKey(name: 'cover_photo')
  final String image;

  /// Description of the service
  @override
  final String? description;

  /// Rating of the service
  @override
  final double? rating;

  /// Number of reviews
  @override
  @JsonKey(name: 'reviews_count')
  final int? reviewsCount;

  /// Number of offers available
  @override
  @JsonKey(name: 'offers_count')
  final int? offersCount;

  /// Timestamp when created
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Whether this is a featured service
  @override
  @JsonKey(name: 'is_featured')
  final bool? isFeatured;

  /// Whether the service is active
  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;

  @override
  String toString() {
    return 'ServiceListingModel(id: $id, name: $name, image: $image, description: $description, rating: $rating, reviewsCount: $reviewsCount, offersCount: $offersCount, createdAt: $createdAt, isFeatured: $isFeatured, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceListingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.offersCount, offersCount) ||
                other.offersCount == offersCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, image, description,
      rating, reviewsCount, offersCount, createdAt, isFeatured, isActive);

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceListingModelImplCopyWith<_$ServiceListingModelImpl> get copyWith =>
      __$$ServiceListingModelImplCopyWithImpl<_$ServiceListingModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceListingModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceListingModel implements ServiceListingModel {
  const factory _ServiceListingModel(
          {required final String id,
          @JsonKey(name: 'title') required final String name,
          @JsonKey(name: 'cover_photo') required final String image,
          final String? description,
          final double? rating,
          @JsonKey(name: 'reviews_count') final int? reviewsCount,
          @JsonKey(name: 'offers_count') final int? offersCount,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'is_featured') final bool? isFeatured,
          @JsonKey(name: 'is_active') final bool? isActive}) =
      _$ServiceListingModelImpl;

  factory _ServiceListingModel.fromJson(Map<String, dynamic> json) =
      _$ServiceListingModelImpl.fromJson;

  /// Unique identifier for the service listing
  @override
  String get id;

  /// Name of the service listing (maps to 'title' in database)
  @override
  @JsonKey(name: 'title')
  String get name;

  /// Image URL for the service (maps to 'cover_photo' in database)
  @override
  @JsonKey(name: 'cover_photo')
  String get image;

  /// Description of the service
  @override
  String? get description;

  /// Rating of the service
  @override
  double? get rating;

  /// Number of reviews
  @override
  @JsonKey(name: 'reviews_count')
  int? get reviewsCount;

  /// Number of offers available
  @override
  @JsonKey(name: 'offers_count')
  int? get offersCount;

  /// Timestamp when created
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Whether this is a featured service
  @override
  @JsonKey(name: 'is_featured')
  bool? get isFeatured;

  /// Whether the service is active
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceListingModelImplCopyWith<_$ServiceListingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
