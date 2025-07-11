import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';
import 'package:sylonow_user/features/address/screens/manage_address_screen.dart';

/// Custom app bar widget for the home screen
/// 
/// Features:
/// - User profile avatar
/// - Location display with refresh capability
/// - Notification bell
/// - Clean and modern design
class HomeAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  /// Creates a new HomeAppBar instance
  const HomeAppBar({super.key});

  @override
  ConsumerState<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh location when app comes to foreground
      refreshLocation(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              
              // Location Display
              Expanded(
                child: _buildLocationDisplay(context, ref),
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

  /// Builds the location display
  Widget _buildLocationDisplay(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(currentLocationAddressProvider);

    return InkWell(
      onTap: () {
        // Navigate to address management screen
        context.go(ManageAddressScreen.routeName);
      },
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: locationAsyncValue.when(
          data: (address) {
            final addressParts = address.split(',');
            final primaryAddress = addressParts.isNotEmpty ? addressParts[0] : 'N/A';
            final secondaryAddress =
                addressParts.length > 1 ? addressParts.sublist(1).join(',').trim() : '';
            return Row(
              children: [
                Icon(Icons.location_on_outlined, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        primaryAddress,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Okra',
                        ),
                      ),
                      if (secondaryAddress.isNotEmpty)
                        Text(
                          secondaryAddress,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontFamily: 'Okra',
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Icon(Icons.refresh, color: AppTheme.primaryColor, size: 16),
              ],
            );
          },
          loading: () => const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text('Fetching location...'),
            ],
          ),
          error: (err, stack) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text('Error', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
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
} 