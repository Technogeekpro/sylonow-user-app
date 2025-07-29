import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/theater/models/decoration_model.dart';
import 'package:sylonow_user/features/theater/providers/theater_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TheaterDecorationsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/theater/decorations';
  
  final String theaterId;
  final String selectedDate;

  const TheaterDecorationsScreen({
    super.key,
    required this.theaterId,
    required this.selectedDate,
  });

  @override
  ConsumerState<TheaterDecorationsScreen> createState() => _TheaterDecorationsScreenState();
}

class _TheaterDecorationsScreenState extends ConsumerState<TheaterDecorationsScreen> {
  DecorationModel? selectedDecoration;

  @override
  Widget build(BuildContext context) {
    final decorationsAsync = ref.watch(theaterDecorationsProvider(widget.theaterId));
    final theaterAsync = ref.watch(theaterProvider(widget.theaterId));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Choose Decorations',
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
          // Theater Info Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: theaterAsync.when(
              data: (theater) => Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: theater?.images.isNotEmpty == true
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: theater!.images.first,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.movie,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.movie,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          theater?.name ?? 'Theater',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Okra',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(DateTime.parse(widget.selectedDate)),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const SizedBox(height: 60),
              error: (error, stackTrace) => const SizedBox(height: 60),
            ),
          ),

          // Decorations List
          Expanded(
            child: decorationsAsync.when(
              data: (decorations) {
                if (decorations.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: decorations.length,
                  itemBuilder: (context, index) {
                    final decoration = decorations[index];
                    final isSelected = selectedDecoration?.id == decoration.id;
                    
                    return _buildDecorationCard(decoration, isSelected);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
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
                onPressed: selectedDecoration != null
                    ? () {
                        context.push(
                          '/theater/${widget.theaterId}/detail',
                          extra: {
                            'selectedDate': widget.selectedDate,
                            'selectedDecoration': selectedDecoration,
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
                  'Continue to Theater Details',
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

  Widget _buildDecorationCard(DecorationModel decoration, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: AppTheme.primaryColor, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedDecoration = decoration;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Decoration Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: decoration.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: decoration.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.celebration,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.celebration,
                        color: Colors.grey,
                        size: 32,
                      ),
              ),
              const SizedBox(width: 16),
              
              // Decoration Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      decoration.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Okra',
                      ),
                    ),
                    if (decoration.description != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        decoration.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Okra',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '₹${decoration.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ],
                ),
              ),
              
              // Selection Indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected 
                      ? AppTheme.primaryColor 
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected 
                        ? AppTheme.primaryColor 
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.celebration_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No decorations available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This theater doesn\'t have decoration options',
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
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
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
            onPressed: () => ref.refresh(theaterDecorationsProvider(widget.theaterId)),
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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}