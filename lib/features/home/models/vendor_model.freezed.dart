// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VendorModel _$VendorModelFromJson(Map<String, dynamic> json) {
  return _VendorModel.fromJson(json);
}

/// @nodoc
mixin _$VendorModel {
  /// Unique identifier for the vendor
  String get id => throw _privateConstructorUsedError;

  /// Email of the vendor
  String get email => throw _privateConstructorUsedError;

  /// Phone number of the vendor (optional)
  String? get phone => throw _privateConstructorUsedError;

  /// Full name of the vendor (optional)
  String? get fullName => throw _privateConstructorUsedError;

  /// Business name
  String? get businessName => throw _privateConstructorUsedError;

  /// Type of business
  String? get businessType => throw _privateConstructorUsedError;

  /// Years of experience
  int get experienceYears => throw _privateConstructorUsedError;

  /// Location information (coordinates, address, etc.)
  Map<String, dynamic>? get location => throw _privateConstructorUsedError;

  /// Profile image URL
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// Portfolio images
  List<String> get portfolioImages => throw _privateConstructorUsedError;

  /// Bio or description
  String? get bio => throw _privateConstructorUsedError;

  /// Availability schedule
  Map<String, dynamic>? get availabilitySchedule =>
      throw _privateConstructorUsedError;

  /// Average rating (0-5)
  double get rating => throw _privateConstructorUsedError;

  /// Total number of reviews
  int get totalReviews => throw _privateConstructorUsedError;

  /// Total jobs completed
  int get totalJobsCompleted => throw _privateConstructorUsedError;

  /// Verification status
  String get verificationStatus => throw _privateConstructorUsedError;

  /// Whether the vendor is active
  bool get isActive => throw _privateConstructorUsedError;

  /// Whether the vendor is verified
  bool get isVerified => throw _privateConstructorUsedError;

  /// FCM token for notifications
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Timestamp when created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when last updated
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VendorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorModelCopyWith<VendorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorModelCopyWith<$Res> {
  factory $VendorModelCopyWith(
          VendorModel value, $Res Function(VendorModel) then) =
      _$VendorModelCopyWithImpl<$Res, VendorModel>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? phone,
      String? fullName,
      String? businessName,
      String? businessType,
      int experienceYears,
      Map<String, dynamic>? location,
      String? profileImageUrl,
      List<String> portfolioImages,
      String? bio,
      Map<String, dynamic>? availabilitySchedule,
      double rating,
      int totalReviews,
      int totalJobsCompleted,
      String verificationStatus,
      bool isActive,
      bool isVerified,
      String? fcmToken,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$VendorModelCopyWithImpl<$Res, $Val extends VendorModel>
    implements $VendorModelCopyWith<$Res> {
  _$VendorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? businessName = freezed,
    Object? businessType = freezed,
    Object? experienceYears = null,
    Object? location = freezed,
    Object? profileImageUrl = freezed,
    Object? portfolioImages = null,
    Object? bio = freezed,
    Object? availabilitySchedule = freezed,
    Object? rating = null,
    Object? totalReviews = null,
    Object? totalJobsCompleted = null,
    Object? verificationStatus = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? fcmToken = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioImages: null == portfolioImages
          ? _value.portfolioImages
          : portfolioImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      availabilitySchedule: freezed == availabilitySchedule
          ? _value.availabilitySchedule
          : availabilitySchedule // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalJobsCompleted: null == totalJobsCompleted
          ? _value.totalJobsCompleted
          : totalJobsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$VendorModelImplCopyWith<$Res>
    implements $VendorModelCopyWith<$Res> {
  factory _$$VendorModelImplCopyWith(
          _$VendorModelImpl value, $Res Function(_$VendorModelImpl) then) =
      __$$VendorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? phone,
      String? fullName,
      String? businessName,
      String? businessType,
      int experienceYears,
      Map<String, dynamic>? location,
      String? profileImageUrl,
      List<String> portfolioImages,
      String? bio,
      Map<String, dynamic>? availabilitySchedule,
      double rating,
      int totalReviews,
      int totalJobsCompleted,
      String verificationStatus,
      bool isActive,
      bool isVerified,
      String? fcmToken,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$VendorModelImplCopyWithImpl<$Res>
    extends _$VendorModelCopyWithImpl<$Res, _$VendorModelImpl>
    implements _$$VendorModelImplCopyWith<$Res> {
  __$$VendorModelImplCopyWithImpl(
      _$VendorModelImpl _value, $Res Function(_$VendorModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? businessName = freezed,
    Object? businessType = freezed,
    Object? experienceYears = null,
    Object? location = freezed,
    Object? profileImageUrl = freezed,
    Object? portfolioImages = null,
    Object? bio = freezed,
    Object? availabilitySchedule = freezed,
    Object? rating = null,
    Object? totalReviews = null,
    Object? totalJobsCompleted = null,
    Object? verificationStatus = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? fcmToken = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$VendorModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceYears: null == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int,
      location: freezed == location
          ? _value._location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioImages: null == portfolioImages
          ? _value._portfolioImages
          : portfolioImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      availabilitySchedule: freezed == availabilitySchedule
          ? _value._availabilitySchedule
          : availabilitySchedule // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalJobsCompleted: null == totalJobsCompleted
          ? _value.totalJobsCompleted
          : totalJobsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$VendorModelImpl implements _VendorModel {
  const _$VendorModelImpl(
      {required this.id,
      required this.email,
      this.phone,
      this.fullName,
      this.businessName,
      this.businessType,
      this.experienceYears = 0,
      final Map<String, dynamic>? location,
      this.profileImageUrl,
      final List<String> portfolioImages = const [],
      this.bio,
      final Map<String, dynamic>? availabilitySchedule,
      this.rating = 0.0,
      this.totalReviews = 0,
      this.totalJobsCompleted = 0,
      this.verificationStatus = 'pending',
      this.isActive = true,
      this.isVerified = false,
      this.fcmToken,
      required this.createdAt,
      required this.updatedAt})
      : _location = location,
        _portfolioImages = portfolioImages,
        _availabilitySchedule = availabilitySchedule;

  factory _$VendorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorModelImplFromJson(json);

  /// Unique identifier for the vendor
  @override
  final String id;

  /// Email of the vendor
  @override
  final String email;

  /// Phone number of the vendor (optional)
  @override
  final String? phone;

  /// Full name of the vendor (optional)
  @override
  final String? fullName;

  /// Business name
  @override
  final String? businessName;

  /// Type of business
  @override
  final String? businessType;

  /// Years of experience
  @override
  @JsonKey()
  final int experienceYears;

  /// Location information (coordinates, address, etc.)
  final Map<String, dynamic>? _location;

  /// Location information (coordinates, address, etc.)
  @override
  Map<String, dynamic>? get location {
    final value = _location;
    if (value == null) return null;
    if (_location is EqualUnmodifiableMapView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Profile image URL
  @override
  final String? profileImageUrl;

  /// Portfolio images
  final List<String> _portfolioImages;

  /// Portfolio images
  @override
  @JsonKey()
  List<String> get portfolioImages {
    if (_portfolioImages is EqualUnmodifiableListView) return _portfolioImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_portfolioImages);
  }

  /// Bio or description
  @override
  final String? bio;

  /// Availability schedule
  final Map<String, dynamic>? _availabilitySchedule;

  /// Availability schedule
  @override
  Map<String, dynamic>? get availabilitySchedule {
    final value = _availabilitySchedule;
    if (value == null) return null;
    if (_availabilitySchedule is EqualUnmodifiableMapView)
      return _availabilitySchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Average rating (0-5)
  @override
  @JsonKey()
  final double rating;

  /// Total number of reviews
  @override
  @JsonKey()
  final int totalReviews;

  /// Total jobs completed
  @override
  @JsonKey()
  final int totalJobsCompleted;

  /// Verification status
  @override
  @JsonKey()
  final String verificationStatus;

  /// Whether the vendor is active
  @override
  @JsonKey()
  final bool isActive;

  /// Whether the vendor is verified
  @override
  @JsonKey()
  final bool isVerified;

  /// FCM token for notifications
  @override
  final String? fcmToken;

  /// Timestamp when created
  @override
  final DateTime createdAt;

  /// Timestamp when last updated
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'VendorModel(id: $id, email: $email, phone: $phone, fullName: $fullName, businessName: $businessName, businessType: $businessType, experienceYears: $experienceYears, location: $location, profileImageUrl: $profileImageUrl, portfolioImages: $portfolioImages, bio: $bio, availabilitySchedule: $availabilitySchedule, rating: $rating, totalReviews: $totalReviews, totalJobsCompleted: $totalJobsCompleted, verificationStatus: $verificationStatus, isActive: $isActive, isVerified: $isVerified, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessType, businessType) ||
                other.businessType == businessType) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._portfolioImages, _portfolioImages) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other._availabilitySchedule, _availabilitySchedule) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.totalJobsCompleted, totalJobsCompleted) ||
                other.totalJobsCompleted == totalJobsCompleted) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
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
        email,
        phone,
        fullName,
        businessName,
        businessType,
        experienceYears,
        const DeepCollectionEquality().hash(_location),
        profileImageUrl,
        const DeepCollectionEquality().hash(_portfolioImages),
        bio,
        const DeepCollectionEquality().hash(_availabilitySchedule),
        rating,
        totalReviews,
        totalJobsCompleted,
        verificationStatus,
        isActive,
        isVerified,
        fcmToken,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorModelImplCopyWith<_$VendorModelImpl> get copyWith =>
      __$$VendorModelImplCopyWithImpl<_$VendorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorModelImplToJson(
      this,
    );
  }
}

abstract class _VendorModel implements VendorModel {
  const factory _VendorModel(
      {required final String id,
      required final String email,
      final String? phone,
      final String? fullName,
      final String? businessName,
      final String? businessType,
      final int experienceYears,
      final Map<String, dynamic>? location,
      final String? profileImageUrl,
      final List<String> portfolioImages,
      final String? bio,
      final Map<String, dynamic>? availabilitySchedule,
      final double rating,
      final int totalReviews,
      final int totalJobsCompleted,
      final String verificationStatus,
      final bool isActive,
      final bool isVerified,
      final String? fcmToken,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$VendorModelImpl;

  factory _VendorModel.fromJson(Map<String, dynamic> json) =
      _$VendorModelImpl.fromJson;

  /// Unique identifier for the vendor
  @override
  String get id;

  /// Email of the vendor
  @override
  String get email;

  /// Phone number of the vendor (optional)
  @override
  String? get phone;

  /// Full name of the vendor (optional)
  @override
  String? get fullName;

  /// Business name
  @override
  String? get businessName;

  /// Type of business
  @override
  String? get businessType;

  /// Years of experience
  @override
  int get experienceYears;

  /// Location information (coordinates, address, etc.)
  @override
  Map<String, dynamic>? get location;

  /// Profile image URL
  @override
  String? get profileImageUrl;

  /// Portfolio images
  @override
  List<String> get portfolioImages;

  /// Bio or description
  @override
  String? get bio;

  /// Availability schedule
  @override
  Map<String, dynamic>? get availabilitySchedule;

  /// Average rating (0-5)
  @override
  double get rating;

  /// Total number of reviews
  @override
  int get totalReviews;

  /// Total jobs completed
  @override
  int get totalJobsCompleted;

  /// Verification status
  @override
  String get verificationStatus;

  /// Whether the vendor is active
  @override
  bool get isActive;

  /// Whether the vendor is verified
  @override
  bool get isVerified;

  /// FCM token for notifications
  @override
  String? get fcmToken;

  /// Timestamp when created
  @override
  DateTime get createdAt;

  /// Timestamp when last updated
  @override
  DateTime get updatedAt;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorModelImplCopyWith<_$VendorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
