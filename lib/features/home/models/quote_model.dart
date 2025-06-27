import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote_model.freezed.dart';
part 'quote_model.g.dart';

/// Model representing quotes from the Supabase database
@freezed
class QuoteModel with _$QuoteModel {
  /// Creates a new QuoteModel instance
  const factory QuoteModel({
    /// Unique identifier for the quote
    required String id,
    
    /// The quote text
    required String quote,
    
    /// Optional image URL for the quote background
    @JsonKey(name: 'image_url') 
    String? imageUrl,
    
    /// Sex category for the quote (male, female, neutral)
    String? sex,
    
    /// Timestamp when created
    @JsonKey(name: 'created_at') 
    DateTime? createdAt,
    
    /// Timestamp when last updated
    @JsonKey(name: 'updated_at') 
    DateTime? updatedAt,
  }) = _QuoteModel;

  /// Creates a QuoteModel from JSON
  factory QuoteModel.fromJson(Map<String, dynamic> json) => _$QuoteModelFromJson(json);
} 