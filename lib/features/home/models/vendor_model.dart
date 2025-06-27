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
    
    /// Email of the vendor
    required String email,
    
    /// Phone number of the vendor (optional)
    String? phone,
    
    /// Full name of the vendor (optional)
    String? fullName,
    
    /// Business name
    String? businessName,
    
    /// Type of business
    String? businessType,
    
    /// Years of experience
    @Default(0) int experienceYears,
    
    /// Location information (coordinates, address, etc.)
    Map<String, dynamic>? location,
    
    /// Profile image URL
    String? profileImageUrl,
    
    /// Portfolio images
    @Default([]) List<String> portfolioImages,
    
    /// Bio or description
    String? bio,
    
    /// Availability schedule
    Map<String, dynamic>? availabilitySchedule,
    
    /// Average rating (0-5)
    @Default(0.0) double rating,
    
    /// Total number of reviews
    @Default(0) int totalReviews,
    
    /// Total jobs completed
    @Default(0) int totalJobsCompleted,
    
    /// Verification status
    @Default('pending') String verificationStatus,
    
    /// Whether the vendor is active
    @Default(true) bool isActive,
    
    /// Whether the vendor is verified
    @Default(false) bool isVerified,
    
    /// FCM token for notifications
    String? fcmToken,
    
    /// Timestamp when created
    required DateTime createdAt,
    
    /// Timestamp when last updated
    required DateTime updatedAt,
  }) = _VendorModel;

  /// Creates a VendorModel from JSON
  factory VendorModel.fromJson(Map<String, dynamic> json) => _$VendorModelFromJson(json);
} 