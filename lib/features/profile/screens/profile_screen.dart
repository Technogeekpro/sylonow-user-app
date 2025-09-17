import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../../auth/services/logout_service.dart';
import '../../auth/services/logout_test_service.dart';
import '../models/user_profile_model.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final profileAsyncValue = ref.watch(currentUserProfileProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              profileAsyncValue.when(
                data: (profile) =>
                    _buildProfileCard(context, currentUser, profile),
                loading: () => _buildLoadingProfileCard(),
                error: (error, stack) => _buildErrorProfileCard(context, ref),
              ),
              const SizedBox(height: 24),
              _buildPersonalSection(context, ref),
              const SizedBox(height: 16),
              _buildUtilitySection(context, ref),
              const SizedBox(height: 16),
              _buildAboutSection(context, ref),
              const SizedBox(height: 24),
              _buildSignOutSection(context, ref),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    dynamic currentUser,
    UserProfileModel? profile,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          _buildProfileAvatar(profile),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  profile?.fullName ??
                      currentUser?.email?.split('@')[0] ??
                      'User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                profile?.email != null
                    ? Text(
                        profile?.email ?? currentUser?.email ?? 'No email',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Okra',
                        ),
                      )
                    : const SizedBox.shrink(),
                if (profile?.phoneNumber != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    profile!.phoneNumber!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.push('/profile/edit');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(UserProfileModel? profile) {
    if (profile?.profileImageUrl != null) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: CachedNetworkImageProvider(profile!.profileImageUrl!),
        backgroundColor: AppTheme.primaryColor,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: profile.profileImageUrl!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const CircularProgressIndicator(strokeWidth: 2),
            errorWidget: (context, url, error) =>
                const Icon(Icons.person, size: 40, color: Colors.white),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 40,
      backgroundColor: AppTheme.primaryColor,
      child: Text(
        profile?.fullName?.isNotEmpty == true
            ? profile!.fullName!.substring(0, 1).toUpperCase()
            : 'U',
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Okra',
        ),
      ),
    );
  }

  Widget _buildLoadingProfileCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorProfileCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
          const SizedBox(height: 8),
          const Text(
            'Failed to load profile',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ref.refresh(currentUserProfileProvider),
            child: const Text(
              'Retry',
              style: TextStyle(fontSize: 14, fontFamily: 'Okra'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalSection(BuildContext context, WidgetRef ref) {
    return _buildSection(
      context: context,
      title: 'Personal',
      items: [
        {
          'icon': Icons.person_outline,
          'title': 'Edit Profile',
          'subtitle': 'Update your personal information',
          'route': '/profile/edit',
        },
        {
          'icon': Icons.history,
          'title': 'Booking History',
          'subtitle': 'View your past service bookings',
          'route': '/profile/bookings',
        },
        {
          'icon': Icons.movie_outlined,
          'title': 'Theater Bookings',
          'subtitle': 'View your theater booking history',
          'route': '/profile/theater-bookings',
        },
        {
          'icon': Icons.location_on_outlined,
          'title': 'My Addresses',
          'subtitle': 'Manage delivery addresses',
          'route': '/manage-address',
        },
      ],
    );
  }

  Widget _buildUtilitySection(BuildContext context, WidgetRef ref) {
    return _buildSection(
      context: context,
      title: 'Utility',
      items: [
        {
          'icon': Icons.wallet_outlined,
          'title': 'Wallet',
          'subtitle': 'View balance and transaction history',
          'route': '/wallet',
        },
        {
          'icon': Icons.notifications_outlined,
          'title': 'Notifications',
          'subtitle': 'Manage notification preferences',
          'route': '/profile/notifications',
        },
        {
          'icon': Icons.help_outline,
          'title': 'Help & Support',
          'subtitle': 'Get help and contact support',
          'route': '/profile/support',
        },
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context, WidgetRef ref) {
    return _buildSection(
      context: context,
      title: 'Legal',
      items: [
        {
          'icon': Icons.privacy_tip_outlined,
          'title': 'Privacy Policy',
          'subtitle': 'Read our privacy policy',
          'route': '/profile/privacy',
        },
        {
          'icon': Icons.cancel_outlined,
          'title': 'Cancellation Policy',
          'subtitle': 'View cancellation and refund policy',
          'onTap': () => _showCancellationPolicyDialog(context),
        },
        {
          'icon': Icons.description_outlined,
          'title': 'Terms of Service',
          'subtitle': 'Read our terms and conditions',
          'route': '/profile/terms',
        },
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontFamily: 'Okra',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildMenuTile(
                    icon: item['icon'] as IconData,
                    title: item['title'] as String,
                    subtitle: item['subtitle'] as String,
                    onTap:
                        item['onTap'] as VoidCallback? ??
                        () => context.push(item['route'] as String),
                  ),
                  if (index < items.length - 1)
                    Divider(height: 1, color: Colors.grey[200], indent: 60),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Okra',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutSection(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showSignOutDialog(context, ref),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Okra'),
          ),
          content: const Text(
            'Are you sure you want to sign out of your account? This will clear all your local data.',
            style: TextStyle(fontFamily: 'Okra'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600], fontFamily: 'Okra'),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Close dialog immediately
                Navigator.pop(dialogContext);

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext loadingContext) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );

                try {
                  // Perform complete logout with all data clearing
                  await LogoutService.performCompleteLogout(ref);

                  // Close loading dialog
                  if (context.mounted) {
                    Navigator.pop(context);
                  }

                  // Test logout state (for debugging)
                  await LogoutTestService.printLogoutState();

                  // Navigate to splash screen to handle auth state
                  if (context.mounted) {
                    context.go('/');
                  }

                  // Show success message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successfully signed out'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  // Close loading dialog
                  if (context.mounted) {
                    Navigator.pop(context);
                  }

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error signing out: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Okra',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutSection(BuildContext context, WidgetRef ref) {
    return _buildSection(
      context: context,
      title: 'About',
      items: [
        {
          'icon': Icons.info_outline,
          'title': 'About Sylonow',
          'subtitle': 'App version and legal information',
          'onTap': () => _showAboutBottomModal(context),
        },
      ],
    );
  }

  void _showAboutBottomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'About Sylonow',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 24),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAboutTile(
                        context: context,
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'Read our privacy policy',
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/profile/privacy');
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildAboutTile(
                        context: context,
                        icon: Icons.cancel_outlined,
                        title: 'Cancellation Policy',
                        subtitle: 'View cancellation and refund policy',
                        onTap: () {
                          Navigator.pop(context);
                          _showCancellationPolicyDialog(context);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildAboutTile(
                        context: context,
                        icon: Icons.description_outlined,
                        title: 'Terms of Service',
                        subtitle: 'Read our terms and conditions',
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/profile/terms');
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.mobile_friendly,
                              size: 48,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Sylonow',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Okra',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Okra',
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Your trusted service marketplace platform connecting you with verified service providers.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Okra',
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAboutTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Okra',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancellationPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Cancellation & Refund Policy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Refunds are subject to the time of cancellation before the scheduled service:',
                  style: TextStyle(
                    fontFamily: 'Okra',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRefundTable(),
                const SizedBox(height: 16),
                const Text(
                  'Additional Wallet Terms:',
                  style: TextStyle(
                    fontFamily: 'Okra',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildWalletTerms(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontFamily: 'Okra',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRefundTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Time Before Service',
                    style: TextStyle(
                      fontFamily: 'Okra',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Bank Refund',
                    style: TextStyle(
                      fontFamily: 'Okra',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Wallet Refund',
                    style: TextStyle(
                      fontFamily: 'Okra',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildTableRow('More than 24 Hours', '50%', '100%'),
          _buildTableRow('24 to 12 Hours', '30%', '100%'),
          _buildTableRow('12 to 6 Hours', '17%', '100%'),
          _buildTableRow('Less than 6 Hours', 'No Refund', '100%'),
        ],
      ),
    );
  }

  Widget _buildTableRow(String time, String bankRefund, String walletRefund) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              time,
              style: const TextStyle(fontFamily: 'Okra', fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              bankRefund,
              style: const TextStyle(fontFamily: 'Okra', fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              walletRefund,
              style: const TextStyle(fontFamily: 'Okra', fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTerms() {
    const terms = [
      '• Bank refunds will be processed within 5-7 working days.',
      '• Wallet refunds are instant and can only be used for future Sylonow bookings.',
      '• Wallet balances do not expire and can be used at any time in the future.',
      '• Wallet balances are non-transferable, non-refundable to bank accounts, and cannot be withdrawn.',
      '• Maximum wallet balance limit: ₹10,000.',
      '• Wallet refund is not available if your wallet balance is ₹10,000 or above.',
      '• Wallet refund becomes available again only when your wallet balance drops below ₹10,000.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: terms
          .map(
            (term) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                term,
                style: const TextStyle(
                  fontFamily: 'Okra',
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
