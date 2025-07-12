class UserProfileModel {
  final String id;
  final String authUserId;
  final String appType;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profileImageUrl;
  final String? bio;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfileModel({
    required this.id,
    required this.authUserId,
    this.appType = 'customer',
    this.fullName,
    this.phoneNumber,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.profileImageUrl,
    this.bio,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      authUserId: json['auth_user_id'] as String,
      appType: json['app_type'] as String? ?? 'customer',
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_user_id': authUserId,
      'app_type': appType,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? authUserId,
    String? appType,
    String? fullName,
    String? phoneNumber,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
    String? profileImageUrl,
    String? bio,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? emergencyContactName,
    String? emergencyContactPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      appType: appType ?? this.appType,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserProfileModel &&
            other.id == id &&
            other.authUserId == authUserId &&
            other.appType == appType &&
            other.fullName == fullName &&
            other.phoneNumber == phoneNumber &&
            other.email == email &&
            other.dateOfBirth == dateOfBirth &&
            other.gender == gender &&
            other.profileImageUrl == profileImageUrl &&
            other.bio == bio &&
            other.city == city &&
            other.state == state &&
            other.country == country &&
            other.postalCode == postalCode &&
            other.emergencyContactName == emergencyContactName &&
            other.emergencyContactPhone == emergencyContactPhone &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
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
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfileModel(id: $id, authUserId: $authUserId, appType: $appType, fullName: $fullName, email: $email)';
  }
}