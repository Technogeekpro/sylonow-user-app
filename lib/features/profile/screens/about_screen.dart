import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'About',
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
            _buildAppInfoSection(),
            const SizedBox(height: 24),
            _buildServicesSection(),
            const SizedBox(height: 24),
            _buildFoundersSection(),
            const SizedBox(height: 24),
            _buildContactSection(),
            const SizedBox(height: 24),
            _buildVersionInfoSection(),
            const SizedBox(height: 24),
            _buildCelebrationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.business,
              size: 48,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sylonow',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your Gateway to Quality Services',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Okra',
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sylonow is India\'s most heartfelt celebration and surprise platform – crafted to turn your emotions into meaningful memories. We help you book thoughtful experiences like event decorations and private theatre spaces, all executed with care, love, and attention to detail.\n\nWe\'re not here to just "deliver" things. We\'re here to create magic, with people who understand celebration.\n\nEvery surprise is carefully planned and brought to life by real people who care about the moment as much as you do. We believe in quality over speed – because real emotion takes time, thoughtfulness, creativity, and heart.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontFamily: 'Okra',
              height: 1.5,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return _buildSection(
      title: '🎯 Currently Available Services',
      children: [
        _buildServiceTile(
          icon: '🎉',
          title: 'Celebrations',
          subtitle: 'Setups, Decorations for birthdays, anniversaries, proposals & more',
        ),
        _buildDivider(),
        _buildServiceTile(
          icon: '🎬',
          title: 'Private Theatre Experiences',
          subtitle: 'For those once-in-a-lifetime surprises',
        ),
        _buildDivider(),
        _buildServiceTile(
          icon: '🎂',
          title: 'Launching Soon',
          subtitle: 'Cakes, venues, gifts, catering, and personalised surprise add-ons',
        ),
      ],
    );
  }

  Widget _buildFoundersSection() {
    return _buildSection(
      title: '👥 Who We Are',
      children: [
        _buildInfoTile(
          icon: Icons.people,
          title: 'Founded by Sangameah K. and Srikanth S.',
          subtitle: 'Sylonow Vision Pvt Ltd. We are bringing depth and meaning back to how we celebrate. We don\'t just send someone to do a job – we bring a feeling to life.',
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return _buildSection(
      title: '📞 Connect With Us',
      children: [
        _buildContactTile(
          icon: Icons.email,
          title: 'Email',
          subtitle: 'info@sylonow.com',
          url: 'mailto:info@sylonow.com',
        ),
        _buildDivider(),
        _buildContactTile(
          icon: Icons.language,
          title: 'Instagram',
          subtitle: 'https://instagram.com/sylonow',
          url: 'https://instagram.com/sylonow',
        ),
        _buildDivider(),
        _buildContactTile(
          icon: Icons.facebook,
          title: 'Facebook',
          subtitle: 'https://facebook.com/sylonow',
          url: 'https://facebook.com/sylonow',
        ),
        _buildDivider(),
        _buildContactTile(
          icon: Icons.business,
          title: 'LinkedIn',
          subtitle: 'https://www.linkedin.com/company/sylonow-main/',
          url: 'https://www.linkedin.com/company/sylonow-main/',
        ),
      ],
    );
  }


  Widget _buildVersionInfoSection() {
    return _buildSection(
      title: 'App Information',
      children: [
        _buildInfoTile(
          icon: Icons.info,
          title: 'Version',
          subtitle: '1.0.0 (Build 1)',
        ),
        _buildDivider(),
        _buildInfoTile(
          icon: Icons.update,
          title: 'Last Updated',
          subtitle: 'January 15, 2025',
        ),
        _buildDivider(),
        _buildInfoTile(
          icon: Icons.devices,
          title: 'Platform',
          subtitle: 'Android & iOS',
        ),
        _buildDivider(),
        _buildInfoTile(
          icon: Icons.code,
          title: 'Built With',
          subtitle: 'Flutter & Supabase',
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

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
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
        ],
      ),
    );
  }


  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[200], indent: 60);
  }

  Widget _buildServiceTile({
    required String icon,
    required String title,
    required String subtitle,
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
            child: Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
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
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchURL(url),
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
                Icons.open_in_new,
                size: 16,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Text(
            '❤️ Let\'s Celebrate – the Sylonow Way.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Not delivered. Not rushed.\nNot just another order.\nRemembered.',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Okra',
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}