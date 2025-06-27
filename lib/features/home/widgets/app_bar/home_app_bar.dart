import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';

/// Custom app bar widget for the home screen
/// 
/// Features:
/// - User profile avatar
/// - Search functionality  
/// - Notification bell
/// - Clean and modern design
class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  /// Creates a new HomeAppBar instance
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // User Profile Avatar
              _buildUserAvatar(),
              
              const SizedBox(width: 16),
              
              // Search Bar
              Expanded(
                child: _buildSearchBar(context),
              ),
              
              const SizedBox(width: 16),
              
              // Notification Icon
              _buildNotificationIcon(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the user profile avatar
  Widget _buildUserAvatar() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  /// Builds the search bar
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search services...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
            fontFamily: 'Okra',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onTap: () {
          // TODO: Navigate to search screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Search functionality will be implemented'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  /// Builds the notification icon
  Widget _buildNotificationIcon(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.grey[700],
              size: 22,
            ),
          ),
          // Notification badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
} 