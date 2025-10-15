import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/theater/models/add_on_model.dart';
import 'package:sylonow_user/features/theater/models/selected_add_on_model.dart';
import 'package:sylonow_user/features/theater/providers/theater_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TheaterAddonsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/theater/addons';

  final String theaterId;
  final String selectedDate;
  final Map<String, dynamic> selectionData;

  const TheaterAddonsScreen({
    super.key,
    required this.theaterId,
    required this.selectedDate,
    required this.selectionData,
  });

  @override
  ConsumerState<TheaterAddonsScreen> createState() =>
      _TheaterAddonsScreenState();
}

class _TheaterAddonsScreenState extends ConsumerState<TheaterAddonsScreen> {
  int _currentStep = 0;
  final List<SelectedAddOnModel> _selectedGiftsAndDecorations = [];
  final List<SelectedAddOnModel> _selectedSpecialServices = [];

  // Pagination
  final Map<String, int> _visibleCounts = {
    'cake': 4,
    'cakes': 4,
    'decorations': 4,
    'special_services': 4,
    'extra_special': 4,
  };

  @override
  void initState() {
    super.initState();
  }

  List<SelectedAddOnModel> get _allSelectedAddOns => [
    ..._selectedGiftsAndDecorations,
    ..._selectedSpecialServices,
  ];

  double get _totalAddOnsPrice {
    return _allSelectedAddOns.fold(0.0, (sum, addon) => sum + addon.totalPrice);
  }

  int get _totalSelectedCount => _allSelectedAddOns.fold(0, (sum, addon) => sum + addon.quantity);

  String get _currentStepTitle {
    switch (_currentStep) {
      case 0:
        return 'Gifts & Decorations';
      case 1:
        return 'Special Services';
      default:
        return 'Add-ons';
    }
  }

  List<String> get _currentStepCategories {
    switch (_currentStep) {
      case 0:
        return ['cake', 'cakes', 'decorations']; // Updated to match actual database categories
      case 1:
        return ['special_services', 'extra_special', 'special service', 'extra-special-service']; // Include all service variants
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final addOnsAsync = ref.watch(theaterAddOnsProvider(widget.theaterId));
    final theaterAsync = ref.watch(theaterProvider(widget.theaterId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentStepTitle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Okra',
              ),
            ),
            if (_totalSelectedCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_totalSelectedCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              context.pop();
            }
          },
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
                    child: theater?.images?.isNotEmpty == true
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: theater!.images!.first,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.movie, color: Colors.grey),
                            ),
                          )
                        : const Icon(Icons.movie, color: Colors.grey),
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
                  // Step Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'Step ${_currentStep + 1} of 2',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ],
              ),
              loading: () => const SizedBox(height: 60),
              error: (error, stackTrace) => const SizedBox(height: 60),
            ),
          ),

          // Content
          Expanded(
            child: addOnsAsync.when(
              data: (addOns) {
                if (addOns.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildStepContent(addOns);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
              error: (error, stackTrace) => _buildErrorState(error),
            ),
          ),

          // Next Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleNextStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentStep == 1 ? 'Continue to Checkout' : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(List<AddOnModel> allAddOns) {
    // Filter add-ons for current step
    final stepAddOns = allAddOns
        .where((addon) => _currentStepCategories.contains(addon.category))
        .toList();

    if (stepAddOns.isEmpty) {
      return _buildEmptyStepState();
    }

    // Group by category
    final Map<String, List<AddOnModel>> categorizedAddOns = {};
    for (final addOn in stepAddOns) {
      final category = addOn.category;
      if (!categorizedAddOns.containsKey(category)) {
        categorizedAddOns[category] = [];
      }
      categorizedAddOns[category]!.add(addOn);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build sections for each category
          ...categorizedAddOns.entries.map((entry) {
            final categoryName = entry.key;
            final categoryAddOns = entry.value;
            final visibleCount = _visibleCounts[categoryName] ?? 4;
            final visibleAddOns = categoryAddOns.take(visibleCount).toList();
            final hasMore = categoryAddOns.length > visibleCount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(categoryName),
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getCategoryDisplayName(categoryName),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Okra',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${categoryAddOns.length} items',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2x2 Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75, // Make cards taller
                  ),
                  itemCount: visibleAddOns.length,
                  itemBuilder: (context, index) {
                    final addOn = visibleAddOns[index];
                    final selectedAddOn = _getSelectedAddOn(addOn);
                    return _buildFigmaStyleCard(addOn, selectedAddOn);
                  },
                ),

                // Load More Button
                if (hasMore) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _visibleCounts[categoryName] =
                              (_visibleCounts[categoryName] ?? 4) + 4;
                        });
                      },
                      icon: Icon(
                        Icons.expand_more,
                        color: AppTheme.primaryColor,
                      ),
                      label: Text(
                        'Load More ${_getCategoryDisplayName(categoryName)}',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFigmaStyleCard(AddOnModel addOn, SelectedAddOnModel? selectedAddOn) {
    final isSelected = selectedAddOn != null;
    final quantity = selectedAddOn?.quantity ?? 0;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: InkWell(
        onTap: () => _addAddOn(addOn),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section with Selection Badge
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: Colors.grey[100],
                    ),
                    child: addOn.imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: addOn.imageUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(
                                  _getCategoryIcon(addOn.category),
                                  color: Colors.grey[400],
                                  size: 32,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              _getCategoryIcon(addOn.category),
                              color: Colors.grey[400],
                              size: 32,
                            ),
                          ),
                  ),
                  
                  // Selection Badge
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Info Section
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppTheme.primaryColor.withOpacity(0.1)
                      : const Color(0xffF0EBFE),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name and Price
                    Column(
                      children: [
                        Text(
                          addOn.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppTheme.primaryColor : Colors.black,
                            fontFamily: 'Okra',
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${addOn.price.round()}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                            fontFamily: 'Okra',
                          ),
                        ),
                      ],
                    ),
                    
                    // Quantity Controls
                    if (isSelected)
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => _decreaseQuantity(addOn),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.remove,
                                  size: 14,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                  fontFamily: 'Okra',
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: quantity < 5 ? () => _increaseQuantity(addOn) : null,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.add,
                                  size: 14,
                                  color: quantity < 5 
                                      ? AppTheme.primaryColor 
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      // Add Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SelectedAddOnModel? _getSelectedAddOn(AddOnModel addOn) {
    try {
      return _allSelectedAddOns.firstWhere((selected) => selected.id == addOn.id);
    } catch (e) {
      return null;
    }
  }

  void _addAddOn(AddOnModel addOn) {
    setState(() {
      final currentStepSelection = _currentStep == 0
          ? _selectedGiftsAndDecorations
          : _selectedSpecialServices;

      final existingIndex = currentStepSelection.indexWhere((item) => item.id == addOn.id);
      
      if (existingIndex >= 0) {
        // Already selected, increase quantity if under limit
        final current = currentStepSelection[existingIndex];
        if (current.quantity < 5) {
          currentStepSelection[existingIndex] = current.copyWith(quantity: current.quantity + 1);
        }
      } else {
        // Not selected, add with quantity 1
        currentStepSelection.add(SelectedAddOnModel(addOn: addOn, quantity: 1));
      }
    });
  }

  void _increaseQuantity(AddOnModel addOn) {
    setState(() {
      final currentStepSelection = _currentStep == 0
          ? _selectedGiftsAndDecorations
          : _selectedSpecialServices;

      final index = currentStepSelection.indexWhere((item) => item.id == addOn.id);
      if (index >= 0) {
        final current = currentStepSelection[index];
        if (current.quantity < 5) {
          currentStepSelection[index] = current.copyWith(quantity: current.quantity + 1);
        }
      }
    });
  }

  void _decreaseQuantity(AddOnModel addOn) {
    setState(() {
      final currentStepSelection = _currentStep == 0
          ? _selectedGiftsAndDecorations
          : _selectedSpecialServices;

      final index = currentStepSelection.indexWhere((item) => item.id == addOn.id);
      if (index >= 0) {
        final current = currentStepSelection[index];
        if (current.quantity > 1) {
          currentStepSelection[index] = current.copyWith(quantity: current.quantity - 1);
        } else {
          // Remove if quantity becomes 0
          currentStepSelection.removeAt(index);
        }
      }
    });
  }

  void _handleNextStep() {
    if (_currentStep == 0) {
      // Go to special services step
      setState(() {
        _currentStep = 1;
      });
    } else {
      // Go to checkout with selected items
      final updatedSelectionData = Map<String, dynamic>.from(
        widget.selectionData,
      );
      updatedSelectionData['selectedAddOns'] = _allSelectedAddOns;
      updatedSelectionData['totalAddOnsPrice'] = _totalAddOnsPrice;

      context.push(
        '/theater/${widget.theaterId}/checkout',
        extra: {
          'selectedDate': widget.selectedDate,
          'selectionData': updatedSelectionData,
        },
      );
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No add-ons available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontFamily: 'Okra',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This theater doesn\'t offer any add-ons or services',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Okra',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStepState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(_currentStepCategories.first),
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No ${_currentStepTitle.toLowerCase()} available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This theater doesn\'t offer ${_currentStepTitle.toLowerCase()}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'Okra',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'gifts':
        return 'Gifts';
      case 'cake':
        return 'Gifts & Treats'; // Treat cake category as gifts
      case 'special_services':
        return 'Special Services';
      case 'cakes':
        return 'Cakes';
      case 'extra_special':
        return 'Extra Special';
      case 'extra-special-service':
        return 'Extra Special';
      case 'special service':
        return 'Special Services';
      case 'decorations':
        return 'Decorations';
      case 'video_shoot':
        return 'Video Shoot';
      case 'photography':
        return 'Photography';
      default:
        return category
            .replaceAll('_', ' ')
            .replaceAll('-', ' ')
            .split(' ')
            .map(
              (word) => word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : word,
            )
            .join(' ');
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'gifts':
        return Icons.card_giftcard;
      case 'cake':
        return Icons.card_giftcard; // Use gift icon for cake category
      case 'special_services':
        return Icons.room_service;
      case 'special service':
        return Icons.room_service;
      case 'extra-special-service':
        return Icons.star;
      case 'cakes':
        return Icons.cake;
      case 'extra_special':
        return Icons.star;
      case 'decorations':
        return Icons.celebration;
      case 'video_shoot':
        return Icons.videocam;
      case 'photography':
        return Icons.photo_camera;
      case 'candle_heart':
        return Icons.favorite;
      case 'balloon_setup':
        return Icons.sports_basketball;
      case 'rose_petals':
        return Icons.local_florist;
      default:
        return Icons.add_box;
    }
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
            onPressed: () =>
                ref.refresh(theaterAddOnsProvider(widget.theaterId)),
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
