// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'auth_user_id')
  String get authUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_type')
  String get appType => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_of_birth')
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image_url')
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  String? get postalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'emergency_contact_name')
  String? get emergencyContactName => throw _privateConstructorUsedError;
  @JsonKey(name: 'emergency_contact_phone')
  String? get emergencyContactPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
          UserProfileModel value, $Res Function(UserProfileModel) then) =
      _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'auth_user_id') String authUserId,
      @JsonKey(name: 'app_type') String appType,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      String? email,
      @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
      String? gender,
      @JsonKey(name: 'profile_image_url') String? profileImageUrl,
      String? bio,
      String? city,
      String? state,
      String? country,
      @JsonKey(name: 'postal_code') String? postalCode,
      @JsonKey(name: 'emergency_contact_name') String? emergencyContactName,
      @JsonKey(name: 'emergency_contact_phone') String? emergencyContactPhone,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authUserId = null,
    Object? appType = null,
    Object? fullName = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? postalCode = freezed,
    Object? emergencyContactName = freezed,
    Object? emergencyContactPhone = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authUserId: null == authUserId
          ? _value.authUserId
          : authUserId // ignore: cast_nullable_to_non_nullable
              as String,
      appType: null == appType
          ? _value.appType
          : appType // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
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
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(_$UserProfileModelImpl value,
          $Res Function(_$UserProfileModelImpl) then) =
      __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'auth_user_id') String authUserId,
      @JsonKey(name: 'app_type') String appType,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      String? email,
      @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
      String? gender,
      @JsonKey(name: 'profile_image_url') String? profileImageUrl,
      String? bio,
      String? city,
      String? state,
      String? country,
      @JsonKey(name: 'postal_code') String? postalCode,
      @JsonKey(name: 'emergency_contact_name') String? emergencyContactName,
      @JsonKey(name: 'emergency_contact_phone') String? emergencyContactPhone,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(_$UserProfileModelImpl _value,
      $Res Function(_$UserProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authUserId = null,
    Object? appType = null,
    Object? fullName = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? postalCode = freezed,
    Object? emergencyContactName = freezed,
    Object? emergencyContactPhone = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authUserId: null == authUserId
          ? _value.authUserId
          : authUserId // ignore: cast_nullable_to_non_nullable
              as String,
      appType: null == appType
          ? _value.appType
          : appType // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
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
class _$UserProfileModelImpl implements _UserProfileModel {
  const _$UserProfileModelImpl(
      {required this.id,
      @JsonKey(name: 'auth_user_id') required this.authUserId,
      @JsonKey(name: 'app_type') this.appType = 'user',
      @JsonKey(name: 'full_name') this.fullName,
      @JsonKey(name: 'phone_number') this.phoneNumber,
      this.email,
      @JsonKey(name: 'date_of_birth') this.dateOfBirth,
      this.gender,
      @JsonKey(name: 'profile_image_url') this.profileImageUrl,
      this.bio,
      this.city,
      this.state,
      this.country,
      @JsonKey(name: 'postal_code') this.postalCode,
      @JsonKey(name: 'emergency_contact_name') this.emergencyContactName,
      @JsonKey(name: 'emergency_contact_phone') this.emergencyContactPhone,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'auth_user_id')
  final String authUserId;
  @override
  @JsonKey(name: 'app_type')
  final String appType;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @override
  final String? email;
  @override
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;
  @override
  final String? gender;
  @override
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  @override
  final String? bio;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? country;
  @override
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @override
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  @override
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfileModel(id: $id, authUserId: $authUserId, appType: $appType, fullName: $fullName, phoneNumber: $phoneNumber, email: $email, dateOfBirth: $dateOfBirth, gender: $gender, profileImageUrl: $profileImageUrl, bio: $bio, city: $city, state: $state, country: $country, postalCode: $postalCode, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authUserId, authUserId) ||
                other.authUserId == authUserId) &&
            (identical(other.appType, appType) || other.appType == appType) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.emergencyContactName, emergencyContactName) ||
                other.emergencyContactName == emergencyContactName) &&
            (identical(other.emergencyContactPhone, emergencyContactPhone) ||
                other.emergencyContactPhone == emergencyContactPhone) &&
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
      authUserId,
      appType,
      fullName,
      phoneNumber,
      email,
      dateOfBirth,
      gender,
      profileImageUrl,
      bio,
      city,
      state,
      country,
      postalCode,
      emergencyContactName,
      emergencyContactPhone,
      createdAt,
      updatedAt);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(
      this,
    );
  }
}

abstract class _UserProfileModel implements UserProfileModel {
  const factory _UserProfileModel(
          {required final String id,
          @JsonKey(name: 'auth_user_id') required final String authUserId,
          @JsonKey(name: 'app_type') final String appType,
          @JsonKey(name: 'full_name') final String? fullName,
          @JsonKey(name: 'phone_number') final String? phoneNumber,
          final String? email,
          @JsonKey(name: 'date_of_birth') final DateTime? dateOfBirth,
          final String? gender,
          @JsonKey(name: 'profile_image_url') final String? profileImageUrl,
          final String? bio,
          final String? city,
          final String? state,
          final String? country,
          @JsonKey(name: 'postal_code') final String? postalCode,
          @JsonKey(name: 'emergency_contact_name')
          final String? emergencyContactName,
          @JsonKey(name: 'emergency_contact_phone')
          final String? emergencyContactPhone,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'auth_user_id')
  String get authUserId;
  @override
  @JsonKey(name: 'app_type')
  String get appType;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
  @override
  String? get email;
  @override
  @JsonKey(name: 'date_of_birth')
  DateTime? get dateOfBirth;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'profile_image_url')
  String? get profileImageUrl;
  @override
  String? get bio;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get country;
  @override
  @JsonKey(name: 'postal_code')
  String? get postalCode;
  @override
  @JsonKey(name: 'emergency_contact_name')
  String? get emergencyContactName;
  @override
  @JsonKey(name: 'emergency_contact_phone')
  String? get emergencyContactPhone;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
