import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';
import 'package:sylonow_user/features/home/models/quote_model.dart';

/// Widget that displays daily motivational quotes
///
/// Features:
/// - Beautiful gradient background
/// - Quote text with author attribution
/// - Loading and error states
/// - Smooth animations
class QuoteSection extends ConsumerWidget {
  /// Creates a new QuoteSection instance
  const QuoteSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsyncValue = ref.watch(dailyQuoteProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: quoteAsyncValue.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(),
        data: (quote) => _buildQuoteCard(quote),
      ),
    );
  }

  /// Builds the loading state
  Widget _buildLoadingState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[200]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  /// Builds the error state
  Widget _buildErrorState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.grey[400]!, Colors.grey[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.format_quote, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text(
              'Quote of the day',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
            Text(
              'Stay motivated!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the quote card
  Widget _buildQuoteCard(QuoteModel? quote) {
    if (quote == null) {
      return _buildDefaultQuote();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
         borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote icon
          Icon(
            Icons.format_quote,
            color: Colors.white.withOpacity(0.8),
            size: 28,
          ),

          const SizedBox(height: 8),

          // Quote text
          Text(
            quote.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Okra',
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          if (quote.author != null) ...[
            const SizedBox(height: 12),
            // Author attribution
            Row(
              children: [
                Container(
                  width: 30,
                  height: 1,
                  color: Colors.white.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  quote.author!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Builds a default quote when no quote is available
  Widget _buildDefaultQuote() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote icon
          Icon(
            Icons.format_quote,
            color: Colors.white.withOpacity(0.8),
            size: 28,
          ),

          const SizedBox(height: 8),

          // Default quote text
          const Text(
            'Transform your space, transform your life. Quality service at your doorstep.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Okra',
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          // Default attribution
          Row(
            children: [
              Container(
                width: 30,
                height: 1,
                color: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Text(
                'Sylonow Team',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
