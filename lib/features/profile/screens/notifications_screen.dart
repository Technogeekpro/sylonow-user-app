import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _bookingUpdates = true;
  bool _promotionalOffers = true;
  bool _newServices = false;
  bool _paymentReminders = true;
  bool _reviewRequests = true;
  bool _systemMaintenance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationTypeSection(),
            const SizedBox(height: 24),
            _buildNotificationCategoriesSection(),
            const SizedBox(height: 24),
            _buildQuietHoursSection(),
            const SizedBox(height: 24),
            _buildNotificationHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTypeSection() {
    return _buildSection(
      title: 'Notification Methods',
      children: [
        _buildSwitchTile(
          icon: Icons.notifications_active,
          title: 'Push Notifications',
          subtitle: 'Receive notifications on your device',
          value: _pushNotifications,
          onChanged: (value) {
            setState(() {
              _pushNotifications = value;
            });
          },
        ),
        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.email_outlined,
          title: 'Email Notifications',
          subtitle: 'Receive notifications via email',
          value: _emailNotifications,
          onChanged: (value) {
            setState(() {
              _emailNotifications = value;
            });
          },
        ),
        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.sms_outlined,
          title: 'SMS Notifications',
          subtitle: 'Receive notifications via SMS',
          value: _smsNotifications,
          onChanged: (value) {
            setState(() {
              _smsNotifications = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNotificationCategoriesSection() {
    return _buildSection(
      title: 'Notification Categories',
      children: [
        _buildSwitchTile(
          icon: Icons.calendar_today,
          title: 'Booking Updates',
          subtitle: 'Updates about your bookings and appointments',
          value: _bookingUpdates,
          onChanged: (value) {
            setState(() {
              _bookingUpdates = value;
            });
          },
        ),
        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.payment,
          title: 'Payment Reminders',
          subtitle: 'Reminders about pending payments',
          value: _paymentReminders,
          onChanged: (value) {
            setState(() {
              _paymentReminders = value;
            });
          },
        ),
        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.star_rate,
          title: 'Review Requests',
          subtitle: 'Requests to review completed services',
          value: _reviewRequests,
          onChanged: (value) {
            setState(() {
              _reviewRequests = value;
            });
          },
        ),
        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.local_offer,
          title: 'Promotional Offers',
          subtitle: 'Special offers and discounts',
          value: _promotionalOffers,
          onChanged: (value) {
            setState(() {
              _promotionalOffers = value;
            });
          },
        ),
        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.new_releases,
          title: 'New Services',
          subtitle: 'Notifications about new services in your area',
          value: _newServices,
          onChanged: (value) {
            setState(() {
              _newServices = value;
            });
          },
        ),
        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.build,
          title: 'System Maintenance',
          subtitle: 'Updates about app maintenance and downtime',
          value: _systemMaintenance,
          onChanged: (value) {
            setState(() {
              _systemMaintenance = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildQuietHoursSection() {
    return _buildSection(
      title: 'Quiet Hours',
      children: [
        _buildMenuTile(
          icon: Icons.bedtime,
          title: 'Do Not Disturb',
          subtitle: 'Set quiet hours for notifications',
          onTap: () => _showQuietHoursDialog(),
        ),
        _buildDivider(),
        _buildMenuTile(
          icon: Icons.volume_off,
          title: 'Sound Settings',
          subtitle: 'Customize notification sounds',
          onTap: () => _showSoundSettingsDialog(),
        ),
      ],
    );
  }

  Widget _buildNotificationHistorySection() {
    return _buildSection(
      title: 'Notification History',
      children: [
        _buildMenuTile(
          icon: Icons.history,
          title: 'View All Notifications',
          subtitle: 'See your notification history',
          onTap: () => _showNotificationHistory(),
        ),
        _buildDivider(),
        _buildMenuTile(
          icon: Icons.clear_all,
          title: 'Clear All Notifications',
          subtitle: 'Remove all notifications from history',
          onTap: () => _showClearNotificationsDialog(),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
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
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.primaryColor,
          ),
        ],
      ),
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

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[200], indent: 60);
  }

  void _showQuietHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Quiet Hours',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
          ),
        ),
        content: const Text(
          'Set your quiet hours to avoid notifications during specific times.',
          style: TextStyle(fontFamily: 'Okra'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement quiet hours setting
            },
            child: Text(
              'Set Hours',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSoundSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Sound Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
          ),
        ),
        content: const Text(
          'Customize notification sounds for different types of notifications.',
          style: TextStyle(fontFamily: 'Okra'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sound settings
            },
            child: Text(
              'Customize',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Notification History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Okra',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _buildNotificationHistoryItem(
                    icon: Icons.notifications,
                    title: 'Booking Confirmed',
                    subtitle: 'Your booking for Home Cleaning has been confirmed',
                    time: '2 hours ago',
                    isRead: index % 2 == 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationHistoryItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isRead,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
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
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontFamily: 'Okra',
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }

  void _showClearNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Clear All Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
          ),
        ),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
          style: TextStyle(fontFamily: 'Okra'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications cleared'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ),
        ],
      ),
    );
  }
}