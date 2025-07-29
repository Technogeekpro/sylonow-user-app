import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/providers/home_providers.dart';
import '../../home/models/category_model.dart';

class AllCategoriesScreen extends ConsumerWidget {
  const AllCategoriesScreen({super.key});

  static const String routeName = '/categories';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'All Categories',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: categoriesAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error.toString()),
        data: (categories) => _buildCategoriesList(context, categories),
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.pink),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context, List<CategoryModel> categories) {
    if (categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No categories available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Check back later for new categories',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    final Color categoryColor = _parseColor(category.colorCode) ?? AppTheme.primaryColor;

    return GestureDetector(
      onTap: () {
        context.push('/category/${category.name}');
      },
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(100),
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
           
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Category Image
              category.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: category.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.pink,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: categoryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.category_outlined,
                          color: categoryColor,
                          size: 48,
                        ),
                      ),
                    )
                  : Container(
                      color: categoryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.category_outlined,
                        color: categoryColor,
                        size: 48,
                      ),
                    ),
              
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(1),
                    ],
                    stops: const [0.1, 1.0],
                  ),
                ),
              ),
              
              // Category Details
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Okra',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        category.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Okra',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Category color indicator
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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