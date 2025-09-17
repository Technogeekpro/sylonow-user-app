import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/theater/models/occasion_model.dart';
import 'package:sylonow_user/features/theater/providers/theater_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OutsideOccasionsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/outside/occasions';

  final String screenId;
  final String selectedDate;
  final Map<String, dynamic> selectionData;

  const OutsideOccasionsScreen({
    super.key,
    required this.screenId,
    required this.selectedDate,
    required this.selectionData,
  });

  @override
  ConsumerState<OutsideOccasionsScreen> createState() =>
      _OutsideOccasionsScreenState();
}

class _OutsideOccasionsScreenState extends ConsumerState<OutsideOccasionsScreen> {
  OccasionModel? selectedOccasion;

  @override
  Widget build(BuildContext context) {
    final occasionsAsync = ref.watch(occasionsProvider);

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
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What\'s the occasion?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Okra',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select the occasion to help us customize your experience',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ),

          // Occasions Grid
          Expanded(
            child: occasionsAsync.when(
              data: (occasions) {
                final activeOccasions = occasions.where((o) => o.isActive).toList();
                
                if (activeOccasions.isEmpty) {
                  return const Center(
                    child: Text(
                      'No occasions available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Okra',
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: activeOccasions.length,
                  itemBuilder: (context, index) {
                    final occasion = activeOccasions[index];
                    final isSelected = selectedOccasion?.id == occasion.id;
                    
                    return _buildOccasionCard(occasion, isSelected);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load occasions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please check your connection and try again',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Okra',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Continue Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedOccasion != null ? _continueToSpecialServices : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
    final cardColor = isSelected ? AppTheme.primaryColor : Colors.white;
    final textColor = isSelected ? Colors.white : Colors.black87;
    final iconColor = isSelected ? Colors.white : AppTheme.primaryColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOccasion = occasion;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                ? AppTheme.primaryColor.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Occasion Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(28),
                ),
                child: occasion.iconUrl != null && occasion.iconUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: CachedNetworkImage(
                          imageUrl: occasion.iconUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Icon(
                            Icons.celebration,
                            size: 28,
                            color: iconColor,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.celebration,
                            size: 28,
                            color: iconColor,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.celebration,
                        size: 28,
                        color: iconColor,
                      ),
              ),
              
              const SizedBox(height: 8),
              
              // Occasion Name
              Text(
                occasion.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Okra',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Description (if available)
              if (occasion.description != null && occasion.description!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  occasion.description!,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? Colors.white70 : Colors.grey[600],
                    fontFamily: 'Okra',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              // Selection Indicator
              if (isSelected) ...[
                const SizedBox(height: 8),
                const Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _continueToSpecialServices() {
    if (selectedOccasion == null) return;

    // Navigate to special services screen
    context.push(
      '/outside/${widget.screenId}/special-services',
      extra: {
        ...widget.selectionData,
        'selectedOccasion': selectedOccasion,
        'selectedDate': widget.selectedDate,
        'screenId': widget.screenId,
      },
    );
  }
}