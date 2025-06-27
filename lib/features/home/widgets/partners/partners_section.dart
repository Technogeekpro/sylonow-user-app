import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/home/providers/home_providers.dart';
import 'package:sylonow_user/features/home/models/vendor_model.dart';

/// Widget that displays featured partners/vendors
///
/// Features:
/// - Horizontal scrollable list of partners
/// - Partner profile images
/// - Partner information
/// - Rating display
class PartnersSection extends ConsumerWidget {
  /// Creates a new PartnersSection instance
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnersAsyncValue = ref.watch(featuredPartnersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader(),

        const SizedBox(height: 16),

        // Partners List
        SizedBox(
          height: 120,
          child: partnersAsyncValue.when(
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(),
            data: (partners) => _buildPartnersList(partners),
          ),
        ),
      ],
    );
  }

  /// Builds the section header
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Trusted Partners',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
                color: Colors.black87,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Navigate to all partners screen
            },
            child: Text(
              'View All',
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

  /// Builds the loading state
  Widget _buildLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: 90,
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 40,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the error state
  Widget _buildErrorState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.grey, size: 40),
          SizedBox(height: 8),
          Text(
            'Unable to load partners',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'Okra',
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the partners list
  Widget _buildPartnersList(List<VendorModel> partners) {
    if (partners.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text(
              'No partners available',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: partners.length,
      itemBuilder: (context, index) {
        final partner = partners[index];
        return _buildPartnerCard(partner);
      },
    );
  }

  /// Builds an individual partner card
  Widget _buildPartnerCard(VendorModel partner) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          // Partner Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ClipOval(
              child: partner.profileImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: partner.profileImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                      ),
                    )
                  : Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 8),

          // Partner Name
          Text(
            partner.businessName ?? partner.fullName ?? 'Partner',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Partner Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 12),
              const SizedBox(width: 2),
              Text(
                partner.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Okra',
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
