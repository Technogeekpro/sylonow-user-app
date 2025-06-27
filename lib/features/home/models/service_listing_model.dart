import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_listing_model.freezed.dart';
part 'service_listing_model.g.dart';

/// Model representing service listings in the Sylonow app
/// 
/// This model maps to the 'service_listings' table in Supabase
@freezed
class ServiceListingModel with _$ServiceListingModel {
  /// Creates a new ServiceListingModel instance
  const factory ServiceListingModel({
    /// Unique identifier for the service listing
    required String id,
    
    /// Name of the service listing (maps to 'title' in database)
    @JsonKey(name: 'title') required String name,
    
    /// Image URL for the service (maps to 'cover_photo' in database)
    @JsonKey(name: 'cover_photo') required String image,
    
    /// Description of the service
    String? description,
    
    /// Rating of the service
    double? rating,

    /// Number of reviews
    @JsonKey(name: 'reviews_count') int? reviewsCount,

    /// Number of offers available
    @JsonKey(name: 'offers_count') int? offersCount,
    
    /// Timestamp when created
    @JsonKey(name: 'created_at') DateTime? createdAt,
    
    /// Whether this is a featured service
    @JsonKey(name: 'is_featured') bool? isFeatured,
    
    /// Whether the service is active
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _ServiceListingModel;

  /// Creates a ServiceListingModel from JSON
  factory ServiceListingModel.fromJson(Map<String, dynamic> json) => _$ServiceListingModelFromJson(json);
  
  /// Creates a ServiceListingModel from service_listings table data
  factory ServiceListingModel.fromServiceListingsTable(Map<String, dynamic> serviceData) {
    return ServiceListingModel(
      id: serviceData['id'] as String,
      name: serviceData['title'] as String,
      image: serviceData['cover_photo'] as String? ?? '',
      description: serviceData['description'] as String?,
      rating: (serviceData['rating'] as num?)?.toDouble(),
      reviewsCount: serviceData['reviews_count'] as int?,
      offersCount: serviceData['offers_count'] as int?,
      createdAt: serviceData['created_at'] != null 
          ? DateTime.parse(serviceData['created_at'] as String)
          : null,
      isFeatured: serviceData['is_featured'] as bool?,
      isActive: serviceData['is_active'] as bool?,
    );
  }
} 