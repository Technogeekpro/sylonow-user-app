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
            _buildCompanyInfoSection(),
            const SizedBox(height: 24),
            _buildSocialLinksSection(),
            const SizedBox(height: 24),
            _buildLegalSection(),
            const SizedBox(height: 24),
            _buildVersionInfoSection(),
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
            'Sylonow is your trusted platform for discovering and booking quality services from verified providers. From home services to entertainment, we connect you with professionals who deliver excellence.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontFamily: 'Okra',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoSection() {
    return _buildSection(
      title: 'Company Information',
      children: [
        _buildInfoTile(
          icon: Icons.business,
          title: 'Company Name',
          subtitle: 'Sylonow Technologies Pvt. Ltd.',
        ),
        _buildDivider(),
        _buildInfoTile(
          icon: Icons.location_on,
          title: 'Headquarters',
          subtitle: '123 Business District, Tech City, TC 12345',
        ),
        _buildDivider(),
        _buildInfoTile(
          icon: Icons.phone,
          title: 'Phone',
          subtitle: '+91-9876543210',
        ),
        _buildDivider(),
        _buildInfoTile(
          icon: Icons.email,
          title: 'Email',
          subtitle: 'info@sylonow.com',
        ),
        _buildDivider(),
        _buildInfoTile(
          icon: Icons.language,
          title: 'Website',
          subtitle: 'www.sylonow.com',
        ),
      ],
    );
  }

  Widget _buildSocialLinksSection() {
    return _buildSection(
      title: 'Connect With Us',
      children: [
        _buildSocialTile(
          icon: Icons.facebook,
          title: 'Facebook',
          subtitle: '@sylonow',
          url: 'https://facebook.com/sylonow',
        ),
        _buildDivider(),
        _buildSocialTile(
          icon: Icons.alternate_email,
          title: 'Twitter',
          subtitle: '@sylonow',
          url: 'https://twitter.com/sylonow',
        ),
        _buildDivider(),
        _buildSocialTile(
          icon: Icons.camera_alt,
          title: 'Instagram',
          subtitle: '@sylonow',
          url: 'https://instagram.com/sylonow',
        ),
        _buildDivider(),
        _buildSocialTile(
          icon: Icons.business,
          title: 'LinkedIn',
          subtitle: 'Sylonow Technologies',
          url: 'https://linkedin.com/company/sylonow',
        ),
      ],
    );
  }

  Widget _buildLegalSection() {
    return _buildSection(
      title: 'Legal',
      children: [
        _buildInfoTile(
          icon: Icons.copyright,
          title: 'Copyright',
          subtitle: '© 2025 Sylonow Technologies Pvt. Ltd.',
        ),
        _buildDivider(),
        _buildInfoTile(
          icon: Icons.balance,
          title: 'License',
          subtitle: 'All rights reserved under applicable law',
        ),
        _buildDivider(),
        _buildInfoTile(
          icon: Icons.security,
          title: 'Security',
          subtitle: 'Your data is protected with enterprise-grade security',
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

  Widget _buildSocialTile({
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

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[200], indent: 60);
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}