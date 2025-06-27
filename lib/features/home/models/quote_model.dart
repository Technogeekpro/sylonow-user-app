import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote_model.freezed.dart';
part 'quote_model.g.dart';

/// Model representing daily motivational quotes
/// 
/// This model maps to the 'app_settings' table in Supabase
/// where quotes are stored with setting_key as 'daily_quote'
@freezed
class QuoteModel with _$QuoteModel {
  /// Creates a new QuoteModel instance
  const factory QuoteModel({
    /// Unique identifier for the quote
    required String id,
    
    /// The quote text content
    required String text,
    
    /// Author of the quote (optional)
    String? author,
    
    /// Category or theme of the quote (optional)
    String? category,
    
    /// Background image URL for the quote (optional)
    String? backgroundUrl,
    
    /// Text color for better contrast (optional)
    String? textColor,
    
    /// Whether this quote is currently active
    @Default(true) bool isActive,
    
    /// Timestamp when the quote was created
    required DateTime createdAt,
    
    /// Timestamp when the quote was last updated
    required DateTime updatedAt,
  }) = _QuoteModel;

  /// Creates a QuoteModel from JSON
  factory QuoteModel.fromJson(Map<String, dynamic> json) => _$QuoteModelFromJson(json);
  
  /// Creates a QuoteModel from app_settings table data
  factory QuoteModel.fromAppSettings(Map<String, dynamic> appSettingsData) {
    final settingValue = appSettingsData['setting_value'] as Map<String, dynamic>;
    
    return QuoteModel(
      id: appSettingsData['id'] as String,
      text: settingValue['text'] as String,
      author: settingValue['author'] as String?,
      category: settingValue['category'] as String?,
      backgroundUrl: settingValue['background_url'] as String?,
      textColor: settingValue['text_color'] as String?,
      isActive: (appSettingsData['is_public'] as bool?) ?? true,
      createdAt: DateTime.parse(appSettingsData['created_at'] as String),
      updatedAt: DateTime.parse(appSettingsData['updated_at'] as String),
    );
  }
} 