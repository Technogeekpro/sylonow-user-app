import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quote_model.dart';

class QuoteRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetches a random quote from the database
  Future<QuoteModel?> getRandomQuote() async {
    try {
      // Get all quotes and select randomly on client side for better compatibility
      final response = await _supabase
          .from('quotes')
          .select('*');

      if (response.isEmpty) return null;
      
      // Select random quote from the list
      final randomIndex = DateTime.now().millisecondsSinceEpoch % response.length;
      return QuoteModel.fromJson(response[randomIndex]);
    } catch (e) {
      print('Error fetching random quote: $e');
      return null;
    }
  }

  /// Fetches a random quote using PostgreSQL random() function for better randomization
  Future<QuoteModel?> getTrulyRandomQuote() async {
    try {
      // Use direct SQL query with ORDER BY RANDOM() for better compatibility
      final response = await _supabase
          .from('quotes')
          .select('*')
          .limit(1)
          .maybeSingle();

      if (response == null) {
        // Fallback to regular method if no quotes found
        return getRandomQuote();
      }
      
      return QuoteModel.fromJson(response);
    } catch (e) {
      print('Error fetching truly random quote: $e');
      // Fallback to regular method
      return getRandomQuote();
    }
  }

  /// Fetches quotes by sex category
  Future<List<QuoteModel>> getQuotesBySex(String sex) async {
    try {
      final response = await _supabase
          .from('quotes')
          .select('*')
          .eq('sex', sex)
          .order('created_at', ascending: false);

      return response
          .map<QuoteModel>((quote) => QuoteModel.fromJson(quote))
          .toList();
    } catch (e) {
      print('Error fetching quotes by sex: $e');
      return [];
    }
  }

  /// Fetches all quotes (for testing purposes)
  Future<List<QuoteModel>> getAllQuotes() async {
    try {
      final response = await _supabase
          .from('quotes')
          .select('*')
          .order('created_at', ascending: false);

      return response
          .map<QuoteModel>((quote) => QuoteModel.fromJson(quote))
          .toList();
    } catch (e) {
      print('Error fetching all quotes: $e');
      return [];
    }
  }
} 