import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../providers/profile_providers.dart';
import '../models/user_profile_model.dart';

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
              _buildLegalSection(context, ref),
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
                Text(
                  profile?.email ?? currentUser?.email ?? 'No email',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Okra',
                  ),
                ),
                if (profile?.phoneNumber != null) ...[
                  const SizedBox(height: 4),
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
          'subtitle': 'View your past bookings',
          'route': '/profile/bookings',
        },
        {
          'icon': Icons.location_on_outlined,
          'title': 'My Addresses',
          'subtitle': 'Manage delivery addresses',
          'route': '/profile/addresses',
        },
        {
          'icon': Icons.payment_outlined,
          'title': 'Payment Methods',
          'subtitle': 'Manage your payment options',
          'route': '/profile/payments',
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
          'icon': Icons.notifications_outlined,
          'title': 'Notifications',
          'subtitle': 'Manage notification preferences',
          'route': '/profile/notifications',
        },
        {
          'icon': Icons.settings_outlined,
          'title': 'Settings',
          'subtitle': 'App preferences and security',
          'route': '/profile/settings',
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
          'icon': Icons.description_outlined,
          'title': 'Terms of Service',
          'subtitle': 'Read our terms and conditions',
          'route': '/profile/terms',
        },
        {
          'icon': Icons.info_outline,
          'title': 'About',
          'subtitle': 'App version and information',
          'route': '/profile/about',
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
                    onTap: () => context.push(item['route'] as String),
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
            'Are you sure you want to sign out of your account?',
            style: TextStyle(fontFamily: 'Okra'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600], fontFamily: 'Okra'),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Close dialog immediately
                context.pop();
                
                try {
                  // Perform sign out
                  await ref.read(authControllerProvider.notifier).signOut();
                  
                  // Navigate to splash screen to handle auth state
                  if (context.mounted) {
                    context.go('/splash');
                  }
                } catch (e) {
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
}
