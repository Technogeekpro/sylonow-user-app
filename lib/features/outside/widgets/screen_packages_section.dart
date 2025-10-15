import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';

import '../models/screen_package_model.dart';
import '../providers/theater_screen_detail_providers.dart';

class ScreenPackagesSection extends ConsumerWidget {
  const ScreenPackagesSection({
    super.key,
    required this.screenId,
    this.onPackageSelected,
  });

  final String screenId;
  final Function(ScreenPackageModel package)? onPackageSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(screenPackagesProvider(screenId));

    return packages.when(
      data: (packageList) {
        if (packageList.isEmpty) {
          return const SizedBox(); // Don't show section if no packages
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(packageList.length),
              const SizedBox(height: 12),
              _buildPackagesVerticalList(packageList),
            ],
          ),
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(),
    );
  }

  Widget _buildSectionHeader(int packageCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ready-Made Packages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                  fontFamily: 'Okra',
                ),
              ),
              Text(
                '$packageCount packages available',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'Okra',
                ),
              ),
            ],
          ),
          Icon(
            Icons.local_offer,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesVerticalList(List<ScreenPackageModel> packages) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        return _buildPackageCard(package);
      },
    );
  }

  Widget _buildPackageCard(ScreenPackageModel package) {
    return Container(
      height: 119,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFEFEFEF),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onPackageSelected?.call(package),
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            _buildPackageImage(package),
            Expanded(
              child: _buildPackageContent(package),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageImage(ScreenPackageModel package) {
    return Container(
      width: 95,
      height: double.infinity,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: package.hasImage
            ? CachedNetworkImage(
                imageUrl: package.packageImage!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildImagePlaceholder(),
                errorWidget: (context, url, error) => _buildImagePlaceholder(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[100],
      child: Icon(
        Icons.card_giftcard,
        size: 32,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildPackageContent(ScreenPackageModel package) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top section with package name and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package Name
                Text(
                  package.packageName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                    fontFamily: 'Okra',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Package Description
                Text(
                  package.shortDescription,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF737680),
                    height: 1.3,
                    fontFamily: 'Okra',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Bottom section with pricing and addons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current price and original price row
                    Row(
                      children: [
                        Text(
                          package.formattedPrice,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            fontFamily: 'Okra',
                          ),
                        ),
                        if (package.hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            package.formattedOriginalPrice,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontFamily: 'Okra',
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                    // Discount percentage and add-ons
                    Row(
                      children: [
                        if (package.hasDiscount)
                          Container(
                            margin: const EdgeInsets.only(right: 6, top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${package.discountPercentage}% OFF',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Okra',
                              ),
                            ),
                          ),
                        if (package.addonIds.isNotEmpty)
                          Text(
                            '${package.addonIds.length} add-ons',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green[600],
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Okra',
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Skeumorphic Select button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.9),
                      AppTheme.primaryColor,
                    ],
                  ),
                  boxShadow: [
                    // Outer shadow (drop shadow)
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                      spreadRadius: 0,
                    ),
                    // Subtle highlight shadow
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 1,
                      offset: const Offset(0, -1),
                      spreadRadius: 0,
                    ),
                  ],
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.8),
                    width: 0.5,
                  ),
                ),
                child: const Text(
                  'Select',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 1,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready-Made Packages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                height: 119,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready-Made Packages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 119,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFFEFEFEF),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.grey[400],
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unable to load packages',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}