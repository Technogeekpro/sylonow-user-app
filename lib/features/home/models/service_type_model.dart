import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_type_model.freezed.dart';
part 'service_type_model.g.dart';

/// Model representing service categories/types in the Sylonow app
/// 
/// This model maps to the 'service_types' table in Supabase
@freezed
class ServiceTypeModel with _$ServiceTypeModel {
  /// Creates a new ServiceTypeModel instance
  const factory ServiceTypeModel({
    /// Unique identifier for the service type
    required String id,
    
    /// Name of the service type
    required String name,
    
    /// Description of the service type
    String? description,
    
    /// Icon URL for the service type
    String? iconUrl,
    
    /// Category this service type belongs to
    String? category,
    
    /// Whether this service type is active
    @Default(true) bool isActive,
    
    /// Timestamp when created
    required DateTime createdAt,
    
    /// Timestamp when last updated
    required DateTime updatedAt,
  }) = _ServiceTypeModel;

  /// Creates a ServiceTypeModel from JSON
  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) => _$ServiceTypeModelFromJson(json);
  
  /// Creates a ServiceTypeModel from service_types table data
  factory ServiceTypeModel.fromServiceTypesTable(Map<String, dynamic> serviceTypeData) {
    return ServiceTypeModel(
      id: serviceTypeData['id'] as String,
      name: serviceTypeData['name'] as String,
      description: serviceTypeData['description'] as String?,
      iconUrl: serviceTypeData['icon_url'] as String?,
      category: serviceTypeData['category'] as String?,
      isActive: (serviceTypeData['is_active'] as bool?) ?? true,
      createdAt: DateTime.parse(serviceTypeData['created_at'] as String),
      updatedAt: DateTime.parse(serviceTypeData['updated_at'] as String),
    );
  }
} 