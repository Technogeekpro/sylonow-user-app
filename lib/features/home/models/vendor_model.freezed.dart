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

  /// Email of the vendor (optional - can be null)
  String? get email => throw _privateConstructorUsedError;

  /// Phone number of the vendor (optional)
  String? get phone => throw _privateConstructorUsedError;

  /// Full name of the vendor (optional)
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;

  /// Business name
  @JsonKey(name: 'business_name')
  String? get businessName => throw _privateConstructorUsedError;

  /// Type of business
  @JsonKey(name: 'business_type')
  String? get businessType => throw _privateConstructorUsedError;

  /// Years of experience
  @JsonKey(name: 'experience_years')
  int get experienceYears => throw _privateConstructorUsedError;

  /// Location information (coordinates, address, etc.)
  Map<String, dynamic>? get location => throw _privateConstructorUsedError;

  /// Profile image URL
  @JsonKey(name: 'profile_image_url')
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// Portfolio images
  @JsonKey(name: 'portfolio_images')
  List<String> get portfolioImages => throw _privateConstructorUsedError;

  /// Bio or description
  String? get bio => throw _privateConstructorUsedError;

  /// Availability schedule
  @JsonKey(name: 'availability_schedule')
  Map<String, dynamic>? get availabilitySchedule =>
      throw _privateConstructorUsedError;

  /// Average rating (0-5)
  double get rating => throw _privateConstructorUsedError;

  /// Total number of reviews
  @JsonKey(name: 'total_reviews')
  int get totalReviews => throw _privateConstructorUsedError;

  /// Total jobs completed
  @JsonKey(name: 'total_jobs_completed')
  int get totalJobsCompleted => throw _privateConstructorUsedError;

  /// Verification status
  @JsonKey(name: 'verification_status')
  String get verificationStatus => throw _privateConstructorUsedError;

  /// Whether the vendor is active
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Whether the vendor is verified
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;

  /// FCM token for notifications
  @JsonKey(name: 'fcm_token')
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Business hours - start time (HH:mm format)
  @JsonKey(name: 'start_time')
  String? get startTime => throw _privateConstructorUsedError;

  /// Business hours - close time (HH:mm format)
  @JsonKey(name: 'close_time')
  String? get closeTime => throw _privateConstructorUsedError;

  /// Minimum advance booking time in hours
  @JsonKey(name: 'advance_booking_hours')
  int get advanceBookingHours => throw _privateConstructorUsedError;

  /// Whether the vendor is currently online
  @JsonKey(name: 'is_online')
  bool get isOnline => throw _privateConstructorUsedError;

  /// Timestamp when vendor was last online
  @JsonKey(name: 'last_online_at')
  DateTime? get lastOnlineAt => throw _privateConstructorUsedError;

  /// Timestamp when created
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when last updated
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      String? email,
      String? phone,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'business_name') String? businessName,
      @JsonKey(name: 'business_type') String? businessType,
      @JsonKey(name: 'experience_years') int experienceYears,
      Map<String, dynamic>? location,
      @JsonKey(name: 'profile_image_url') String? profileImageUrl,
      @JsonKey(name: 'portfolio_images') List<String> portfolioImages,
      String? bio,
      @JsonKey(name: 'availability_schedule')
      Map<String, dynamic>? availabilitySchedule,
      double rating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'total_jobs_completed') int totalJobsCompleted,
      @JsonKey(name: 'verification_status') String verificationStatus,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'fcm_token') String? fcmToken,
      @JsonKey(name: 'start_time') String? startTime,
      @JsonKey(name: 'close_time') String? closeTime,
      @JsonKey(name: 'advance_booking_hours') int advanceBookingHours,
      @JsonKey(name: 'is_online') bool isOnline,
      @JsonKey(name: 'last_online_at') DateTime? lastOnlineAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$VendorModelCopyWithImpl<$Res, $Val extends VendorModel>
    implements $VendorModelCopyWith<$Res> {
  _$VendorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
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
    Object? startTime = freezed,
    Object? closeTime = freezed,
    Object? advanceBookingHours = null,
    Object? isOnline = null,
    Object? lastOnlineAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
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
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      advanceBookingHours: null == advanceBookingHours
          ? _value.advanceBookingHours
          : advanceBookingHours // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastOnlineAt: freezed == lastOnlineAt
          ? _value.lastOnlineAt
          : lastOnlineAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VendorModelImplCopyWith<$Res>
    implements $VendorModelCopyWith<$Res> {
  factory _$$VendorModelImplCopyWith(
          _$VendorModelImpl value, $Res Function(_$VendorModelImpl) then) =
      __$$VendorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? email,
      String? phone,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'business_name') String? businessName,
      @JsonKey(name: 'business_type') String? businessType,
      @JsonKey(name: 'experience_years') int experienceYears,
      Map<String, dynamic>? location,
      @JsonKey(name: 'profile_image_url') String? profileImageUrl,
      @JsonKey(name: 'portfolio_images') List<String> portfolioImages,
      String? bio,
      @JsonKey(name: 'availability_schedule')
      Map<String, dynamic>? availabilitySchedule,
      double rating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'total_jobs_completed') int totalJobsCompleted,
      @JsonKey(name: 'verification_status') String verificationStatus,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'fcm_token') String? fcmToken,
      @JsonKey(name: 'start_time') String? startTime,
      @JsonKey(name: 'close_time') String? closeTime,
      @JsonKey(name: 'advance_booking_hours') int advanceBookingHours,
      @JsonKey(name: 'is_online') bool isOnline,
      @JsonKey(name: 'last_online_at') DateTime? lastOnlineAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$VendorModelImplCopyWithImpl<$Res>
    extends _$VendorModelCopyWithImpl<$Res, _$VendorModelImpl>
    implements _$$VendorModelImplCopyWith<$Res> {
  __$$VendorModelImplCopyWithImpl(
      _$VendorModelImpl _value, $Res Function(_$VendorModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
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
    Object? startTime = freezed,
    Object? closeTime = freezed,
    Object? advanceBookingHours = null,
    Object? isOnline = null,
    Object? lastOnlineAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VendorModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
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
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      advanceBookingHours: null == advanceBookingHours
          ? _value.advanceBookingHours
          : advanceBookingHours // ignore: cast_nullable_to_non_nullable
              as int,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastOnlineAt: freezed == lastOnlineAt
          ? _value.lastOnlineAt
          : lastOnlineAt // ignore: cast_nullable_to_non_nullable
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
class _$VendorModelImpl implements _VendorModel {
  const _$VendorModelImpl(
      {required this.id,
      this.email,
      this.phone,
      @JsonKey(name: 'full_name') this.fullName,
      @JsonKey(name: 'business_name') this.businessName,
      @JsonKey(name: 'business_type') this.businessType,
      @JsonKey(name: 'experience_years') this.experienceYears = 0,
      final Map<String, dynamic>? location,
      @JsonKey(name: 'profile_image_url') this.profileImageUrl,
      @JsonKey(name: 'portfolio_images')
      final List<String> portfolioImages = const [],
      this.bio,
      @JsonKey(name: 'availability_schedule')
      final Map<String, dynamic>? availabilitySchedule,
      this.rating = 0.0,
      @JsonKey(name: 'total_reviews') this.totalReviews = 0,
      @JsonKey(name: 'total_jobs_completed') this.totalJobsCompleted = 0,
      @JsonKey(name: 'verification_status') this.verificationStatus = 'pending',
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'fcm_token') this.fcmToken,
      @JsonKey(name: 'start_time') this.startTime,
      @JsonKey(name: 'close_time') this.closeTime,
      @JsonKey(name: 'advance_booking_hours') this.advanceBookingHours = 2,
      @JsonKey(name: 'is_online') this.isOnline = false,
      @JsonKey(name: 'last_online_at') this.lastOnlineAt,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _location = location,
        _portfolioImages = portfolioImages,
        _availabilitySchedule = availabilitySchedule;

  factory _$VendorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorModelImplFromJson(json);

  /// Unique identifier for the vendor
  @override
  final String id;

  /// Email of the vendor (optional - can be null)
  @override
  final String? email;

  /// Phone number of the vendor (optional)
  @override
  final String? phone;

  /// Full name of the vendor (optional)
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;

  /// Business name
  @override
  @JsonKey(name: 'business_name')
  final String? businessName;

  /// Type of business
  @override
  @JsonKey(name: 'business_type')
  final String? businessType;

  /// Years of experience
  @override
  @JsonKey(name: 'experience_years')
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
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;

  /// Portfolio images
  final List<String> _portfolioImages;

  /// Portfolio images
  @override
  @JsonKey(name: 'portfolio_images')
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
  @JsonKey(name: 'availability_schedule')
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
  @JsonKey(name: 'total_reviews')
  final int totalReviews;

  /// Total jobs completed
  @override
  @JsonKey(name: 'total_jobs_completed')
  final int totalJobsCompleted;

  /// Verification status
  @override
  @JsonKey(name: 'verification_status')
  final String verificationStatus;

  /// Whether the vendor is active
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Whether the vendor is verified
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  /// FCM token for notifications
  @override
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  /// Business hours - start time (HH:mm format)
  @override
  @JsonKey(name: 'start_time')
  final String? startTime;

  /// Business hours - close time (HH:mm format)
  @override
  @JsonKey(name: 'close_time')
  final String? closeTime;

  /// Minimum advance booking time in hours
  @override
  @JsonKey(name: 'advance_booking_hours')
  final int advanceBookingHours;

  /// Whether the vendor is currently online
  @override
  @JsonKey(name: 'is_online')
  final bool isOnline;

  /// Timestamp when vendor was last online
  @override
  @JsonKey(name: 'last_online_at')
  final DateTime? lastOnlineAt;

  /// Timestamp when created
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// Timestamp when last updated
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VendorModel(id: $id, email: $email, phone: $phone, fullName: $fullName, businessName: $businessName, businessType: $businessType, experienceYears: $experienceYears, location: $location, profileImageUrl: $profileImageUrl, portfolioImages: $portfolioImages, bio: $bio, availabilitySchedule: $availabilitySchedule, rating: $rating, totalReviews: $totalReviews, totalJobsCompleted: $totalJobsCompleted, verificationStatus: $verificationStatus, isActive: $isActive, isVerified: $isVerified, fcmToken: $fcmToken, startTime: $startTime, closeTime: $closeTime, advanceBookingHours: $advanceBookingHours, isOnline: $isOnline, lastOnlineAt: $lastOnlineAt, createdAt: $createdAt, updatedAt: $updatedAt)';
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
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime) &&
            (identical(other.advanceBookingHours, advanceBookingHours) ||
                other.advanceBookingHours == advanceBookingHours) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastOnlineAt, lastOnlineAt) ||
                other.lastOnlineAt == lastOnlineAt) &&
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
        startTime,
        closeTime,
        advanceBookingHours,
        isOnline,
        lastOnlineAt,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
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
          final String? email,
          final String? phone,
          @JsonKey(name: 'full_name') final String? fullName,
          @JsonKey(name: 'business_name') final String? businessName,
          @JsonKey(name: 'business_type') final String? businessType,
          @JsonKey(name: 'experience_years') final int experienceYears,
          final Map<String, dynamic>? location,
          @JsonKey(name: 'profile_image_url') final String? profileImageUrl,
          @JsonKey(name: 'portfolio_images') final List<String> portfolioImages,
          final String? bio,
          @JsonKey(name: 'availability_schedule')
          final Map<String, dynamic>? availabilitySchedule,
          final double rating,
          @JsonKey(name: 'total_reviews') final int totalReviews,
          @JsonKey(name: 'total_jobs_completed') final int totalJobsCompleted,
          @JsonKey(name: 'verification_status') final String verificationStatus,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'is_verified') final bool isVerified,
          @JsonKey(name: 'fcm_token') final String? fcmToken,
          @JsonKey(name: 'start_time') final String? startTime,
          @JsonKey(name: 'close_time') final String? closeTime,
          @JsonKey(name: 'advance_booking_hours') final int advanceBookingHours,
          @JsonKey(name: 'is_online') final bool isOnline,
          @JsonKey(name: 'last_online_at') final DateTime? lastOnlineAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$VendorModelImpl;

  factory _VendorModel.fromJson(Map<String, dynamic> json) =
      _$VendorModelImpl.fromJson;

  @override

  /// Unique identifier for the vendor
  String get id;
  @override

  /// Email of the vendor (optional - can be null)
  String? get email;
  @override

  /// Phone number of the vendor (optional)
  String? get phone;
  @override

  /// Full name of the vendor (optional)
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override

  /// Business name
  @JsonKey(name: 'business_name')
  String? get businessName;
  @override

  /// Type of business
  @JsonKey(name: 'business_type')
  String? get businessType;
  @override

  /// Years of experience
  @JsonKey(name: 'experience_years')
  int get experienceYears;
  @override

  /// Location information (coordinates, address, etc.)
  Map<String, dynamic>? get location;
  @override

  /// Profile image URL
  @JsonKey(name: 'profile_image_url')
  String? get profileImageUrl;
  @override

  /// Portfolio images
  @JsonKey(name: 'portfolio_images')
  List<String> get portfolioImages;
  @override

  /// Bio or description
  String? get bio;
  @override

  /// Availability schedule
  @JsonKey(name: 'availability_schedule')
  Map<String, dynamic>? get availabilitySchedule;
  @override

  /// Average rating (0-5)
  double get rating;
  @override

  /// Total number of reviews
  @JsonKey(name: 'total_reviews')
  int get totalReviews;
  @override

  /// Total jobs completed
  @JsonKey(name: 'total_jobs_completed')
  int get totalJobsCompleted;
  @override

  /// Verification status
  @JsonKey(name: 'verification_status')
  String get verificationStatus;
  @override

  /// Whether the vendor is active
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override

  /// Whether the vendor is verified
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override

  /// FCM token for notifications
  @JsonKey(name: 'fcm_token')
  String? get fcmToken;
  @override

  /// Business hours - start time (HH:mm format)
  @JsonKey(name: 'start_time')
  String? get startTime;
  @override

  /// Business hours - close time (HH:mm format)
  @JsonKey(name: 'close_time')
  String? get closeTime;
  @override

  /// Minimum advance booking time in hours
  @JsonKey(name: 'advance_booking_hours')
  int get advanceBookingHours;
  @override

  /// Whether the vendor is currently online
  @JsonKey(name: 'is_online')
  bool get isOnline;
  @override

  /// Timestamp when vendor was last online
  @JsonKey(name: 'last_online_at')
  DateTime? get lastOnlineAt;
  @override

  /// Timestamp when created
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override

  /// Timestamp when last updated
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$VendorModelImplCopyWith<_$VendorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
