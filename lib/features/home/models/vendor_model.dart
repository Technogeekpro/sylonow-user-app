import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_model.freezed.dart';
part 'vendor_model.g.dart';

/// Model representing vendors/partners in the Sylonow app
/// 
/// This model maps to the 'vendors' table in Supabase
@freezed
class VendorModel with _$VendorModel {
  /// Creates a new VendorModel instance
  const factory VendorModel({
    /// Unique identifier for the vendor
    required String id,
    
    /// Email of the vendor (optional - can be null)
    String? email,
    
    /// Phone number of the vendor (optional)
    String? phone,
    
    /// Full name of the vendor (optional)
    @JsonKey(name: 'full_name') String? fullName,
    
    /// Business name
    @JsonKey(name: 'business_name') String? businessName,
    
    /// Type of business
    @JsonKey(name: 'business_type') String? businessType,
    
    /// Years of experience
    @JsonKey(name: 'experience_years') @Default(0) int experienceYears,
    
    /// Location information (coordinates, address, etc.)
    Map<String, dynamic>? location,
    
    /// Profile image URL
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    
    /// Portfolio images
    @JsonKey(name: 'portfolio_images') @Default([]) List<String> portfolioImages,
    
    /// Bio or description
    String? bio,
    
    /// Availability schedule
    @JsonKey(name: 'availability_schedule') Map<String, dynamic>? availabilitySchedule,
    
    /// Average rating (0-5)
    @Default(0.0) double rating,
    
    /// Total number of reviews
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    
    /// Total jobs completed
    @JsonKey(name: 'total_jobs_completed') @Default(0) int totalJobsCompleted,
    
    /// Verification status
    @JsonKey(name: 'verification_status') @Default('pending') String verificationStatus,
    
    /// Whether the vendor is active
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    
    /// Whether the vendor is verified
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    
    /// FCM token for notifications
    @JsonKey(name: 'fcm_token') String? fcmToken,
    
    /// Business hours - start time (HH:mm format)
    @JsonKey(name: 'start_time') String? startTime,
    
    /// Business hours - close time (HH:mm format)
    @JsonKey(name: 'close_time') String? closeTime,
    
    /// Minimum advance booking time in hours
    @JsonKey(name: 'advance_booking_hours') @Default(2) int advanceBookingHours,
    
    /// Whether the vendor is currently online
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    
    /// Timestamp when vendor was last online
    @JsonKey(name: 'last_online_at') DateTime? lastOnlineAt,
    
    /// Timestamp when created
    @JsonKey(name: 'created_at') required DateTime createdAt,
    
    /// Timestamp when last updated
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _VendorModel;

  /// Creates a VendorModel from JSON
  factory VendorModel.fromJson(Map<String, dynamic> json) => _$VendorModelFromJson(json);
} 