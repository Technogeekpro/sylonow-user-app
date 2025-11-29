import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/home/models/category_model.dart';
import 'package:sylonow_user/features/home/providers/cached_home_providers.dart';

class OptimizedExploreCategoriesSection extends ConsumerWidget {
  const OptimizedExploreCategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(cachedCategoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 16),
        categoriesAsyncValue.when(
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(ref),
          data: (categories) => _buildCategoriesList(context, categories),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Explore Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: Color(0xFF2A3143),
            ),
          ),
          TextButton(
            onPressed: () {
              context.push('/categories');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'See more',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 6, // Show 6 shimmer items
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _ShimmerPlaceholder(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return SizedBox(
      height: 110,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Could not load categories',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Okra',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.invalidate(cachedCategoriesProvider);
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontFamily: 'Okra',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    List<CategoryModel> categories,
  ) {
    if (categories.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'No categories available.',
            style: TextStyle(color: Colors.grey, fontFamily: 'Okra'),
          ),
        ),
      );
    }

    // Show first 8 categories in horizontal list
    final displayCategories = categories.take(8).toList();

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: displayCategories.length,
        itemBuilder: (context, index) {
          final category = displayCategories[index];
          return _buildCategoryCard(context, category);
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    final Color categoryColor =
        _parseColor(category.colorCode) ?? AppTheme.primaryColor;

    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          // Navigate to category services screen with location filtering
          context.push('/category/${Uri.encodeComponent(category.name)}');
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
            ),

            child: Stack(
              fit: StackFit.expand,
              children: [
                // Category Image with optimized caching
                _buildCategoryImage(category, categoryColor),

                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),

                // Category Title
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.2,
                      fontFamily: 'Okra',
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                //   // Category color indicator
                //   Positioned(
                //     top: 8,
                //     right: 8,
                //     child: Container(
                //       width: 8,
                //       height: 8,
                //       decoration: BoxDecoration(
                //         color: categoryColor,
                //         shape: BoxShape.circle,
                //         border: Border.all(color: Colors.white, width: 1),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryImage(CategoryModel category, Color fallbackColor) {
    if (category.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: category.imageUrl!,
        fit: BoxFit.fill,
        memCacheWidth: 320, // Optimize memory usage for small images
        memCacheHeight: 220,
        placeholder: (context, url) => _ShimmerPlaceholder(),
        errorWidget: (context, url, error) =>
            _buildFallbackImage(fallbackColor),
      );
    } else {
      return _buildFallbackImage(fallbackColor);
    }
  }

  Widget _buildFallbackImage(Color color) {
    return Container(
      color: color.withOpacity(0.1),
      child: Icon(Icons.category_outlined, color: color, size: 32),
    );
  }

  Color? _parseColor(String? colorCode) {
    if (colorCode == null || !colorCode.startsWith('#')) return null;
    try {
      return Color(int.parse(colorCode.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return null;
    }
  }
}

// Optimized shimmer placeholder
class _ShimmerPlaceholder extends StatefulWidget {
  @override
  _ShimmerPlaceholderState createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
              colors: [Colors.grey[200]!, Colors.grey[100]!, Colors.grey[200]!],
            ),
          ),
        );
      },
    );
  }
}
