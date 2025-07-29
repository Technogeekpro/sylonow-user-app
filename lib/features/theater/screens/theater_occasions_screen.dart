import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/theater/models/occasion_model.dart';
import 'package:sylonow_user/features/theater/providers/theater_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TheaterOccasionsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/theater/occasions';

  final String theaterId;
  final String selectedDate;
  final Map<String, dynamic> selectionData;

  const TheaterOccasionsScreen({
    super.key,
    required this.theaterId,
    required this.selectedDate,
    required this.selectionData,
  });

  @override
  ConsumerState<TheaterOccasionsScreen> createState() =>
      _TheaterOccasionsScreenState();
}

class _TheaterOccasionsScreenState
    extends ConsumerState<TheaterOccasionsScreen> {
  OccasionModel? selectedOccasion;

  @override
  Widget build(BuildContext context) {
    final occasionsAsync = ref.watch(occasionsProvider);
    final theaterAsync = ref.watch(theaterProvider(widget.theaterId));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Select Occasion',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          iconSize: 20,
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'What\'s the occasion for your celebration?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontFamily: 'Okra',
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Occasions Grid
          Expanded(
            child: occasionsAsync.when(
              data: (occasions) {
                if (occasions.isEmpty) {
                  return _buildEmptyState();
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.90,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: occasions.length,
                  itemBuilder: (context, index) {
                    final occasion = occasions[index];
                    final isSelected = selectedOccasion?.id == occasion.id;

                    return _buildOccasionCard(occasion, isSelected);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
              error: (error, stackTrace) => _buildErrorState(error),
            ),
          ),

          // Continue Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedOccasion != null
                    ? () {
                        final updatedSelectionData = Map<String, dynamic>.from(
                          widget.selectionData,
                        );
                        updatedSelectionData['selectedOccasion'] =
                            selectedOccasion;

                        context.push(
                          '/theater/${widget.theaterId}/addons',
                          extra: {
                            'selectedDate': widget.selectedDate,
                            'selectionData': updatedSelectionData,
                          },
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[600],
                ),
                child: const Text(
                  'Continue to Add-ons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccasionCard(OccasionModel occasion, bool isSelected) {
    // Parse color from hex string, default to pink if invalid
    Color backgroundColor;
    try {
      backgroundColor = Color(
        int.parse('0xFF${occasion.colorCode?.replaceAll('#', '') ?? 'FFC0CB'}'),
      );
    } catch (e) {
      backgroundColor = const Color(0xFFFFC0CB); // Light pink default
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOccasion = occasion;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large Circular Badge
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppTheme.primaryColor, width: 4)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: occasion.iconUrl != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: occasion.iconUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        _getDefaultIconForOccasion(occasion.name),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                : Icon(
                    _getDefaultIconForOccasion(occasion.name),
                    color: Colors.white,
                    size: 40,
                  ),
          ),
          const SizedBox(height: 12),

          // Occasion Name
          Text(
            occasion.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Okra',
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Selection Indicator
          if (isSelected) ...[
            const SizedBox(height: 8),
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getDefaultIconForOccasion(String occasionName) {
    switch (occasionName.toLowerCase()) {
      case 'birthday':
        return Icons.cake;
      case 'anniversary':
        return Icons.favorite;
      case 'romantic date':
        return Icons.favorite_border;
      case 'marriage proposal':
        return Icons.diamond;
      case 'bride to be':
        return Icons.female;
      case 'farewell':
        return Icons.waving_hand;
      case 'congratulation':
        return Icons.celebration;
      case 'baby shower':
        return Icons.child_friendly;
      default:
        return Icons.event;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No occasions available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ), 
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center( 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'Okra',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(occasionsProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
