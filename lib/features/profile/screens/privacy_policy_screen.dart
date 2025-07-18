import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
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
            _buildHeader(),
            const SizedBox(height: 24),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.privacy_tip,
            size: 48,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: January 15, 2025',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Okra',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This Privacy Policy describes how Sylonow collects, uses, and protects your personal information when you use our service marketplace platform.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontFamily: 'Okra',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: '1. Information We Collect',
            content: [
              _buildSubSection(
                subtitle: 'Personal Information',
                text: 'We collect information you provide directly to us, such as when you create an account, make a booking, or contact us for support. This includes your name, email address, phone number, and address.',
              ),
              _buildSubSection(
                subtitle: 'Usage Information',
                text: 'We collect information about how you use our services, including the pages you visit, the services you book, and the actions you take.',
              ),
              _buildSubSection(
                subtitle: 'Device Information',
                text: 'We collect information about the device you use to access our services, including device type, operating system, and unique device identifiers.',
              ),
              _buildSubSection(
                subtitle: 'Location Information',
                text: 'With your permission, we collect location information to provide location-based services and improve our offerings.',
              ),
            ],
          ),
          _buildSection(
            title: '2. How We Use Your Information',
            content: [
              _buildBulletPoint('Provide and maintain our services'),
              _buildBulletPoint('Process bookings and payments'),
              _buildBulletPoint('Send you important service notifications'),
              _buildBulletPoint('Improve our services and user experience'),
              _buildBulletPoint('Prevent fraud and ensure security'),
              _buildBulletPoint('Comply with legal obligations'),
            ],
          ),
          _buildSection(
            title: '3. Information Sharing',
            content: [
              _buildSubSection(
                subtitle: 'Service Providers',
                text: 'We share your information with service providers who help us operate our platform, process payments, and deliver services to you.',
              ),
              _buildSubSection(
                subtitle: 'Business Partners',
                text: 'We may share information with trusted business partners who provide services on our platform, but only as necessary to fulfill your bookings.',
              ),
              _buildSubSection(
                subtitle: 'Legal Requirements',
                text: 'We may disclose your information if required by law, regulation, or legal process, or if we believe disclosure is necessary to protect our rights or safety.',
              ),
            ],
          ),
          _buildSection(
            title: '4. Data Security',
            content: [
              _buildSubSection(
                subtitle: 'Security Measures',
                text: 'We implement appropriate technical and organizational security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
              ),
              _buildSubSection(
                subtitle: 'Encryption',
                text: 'All sensitive information is encrypted both in transit and at rest using industry-standard encryption protocols.',
              ),
              _buildSubSection(
                subtitle: 'Access Controls',
                text: 'We limit access to your personal information to employees and contractors who need it to perform their job functions.',
              ),
            ],
          ),
          _buildSection(
            title: '5. Your Rights',
            content: [
              _buildBulletPoint('Access and review your personal information'),
              _buildBulletPoint('Correct or update inaccurate information'),
              _buildBulletPoint('Delete your account and personal information'),
              _buildBulletPoint('Opt-out of marketing communications'),
              _buildBulletPoint('Request data portability'),
              _buildBulletPoint('Withdraw consent for data processing'),
            ],
          ),
          _buildSection(
            title: '6. Data Retention',
            content: [
              _buildSubSection(
                subtitle: 'Retention Period',
                text: 'We retain your personal information for as long as necessary to provide our services, comply with legal obligations, resolve disputes, and enforce our agreements.',
              ),
              _buildSubSection(
                subtitle: 'Deletion',
                text: 'When you delete your account, we will delete or anonymize your personal information, except where we are required to retain it by law.',
              ),
            ],
          ),
          _buildSection(
            title: '7. Cookies and Tracking',
            content: [
              _buildSubSection(
                subtitle: 'Cookies',
                text: 'We use cookies and similar tracking technologies to improve our services, analyze usage patterns, and personalize your experience.',
              ),
              _buildSubSection(
                subtitle: 'Analytics',
                text: 'We may use third-party analytics services to help us understand how our services are used and improve user experience.',
              ),
            ],
          ),
          _buildSection(
            title: '8. Third-Party Services',
            content: [
              _buildSubSection(
                subtitle: 'Integration',
                text: 'Our services may integrate with third-party services such as payment processors, mapping services, and social media platforms.',
              ),
              _buildSubSection(
                subtitle: 'Privacy Policies',
                text: 'These third-party services have their own privacy policies, and we encourage you to review them before using these services.',
              ),
            ],
          ),
          _buildSection(
            title: '9. Changes to This Policy',
            content: [
              _buildSubSection(
                subtitle: 'Updates',
                text: 'We may update this Privacy Policy from time to time. We will notify you of any material changes by posting the new policy on our app and updating the "last updated" date.',
              ),
              _buildSubSection(
                subtitle: 'Continued Use',
                text: 'Your continued use of our services after any changes constitutes acceptance of the new Privacy Policy.',
              ),
            ],
          ),
          _buildSection(
            title: '10. Contact Us',
            content: [
              _buildSubSection(
                subtitle: 'Questions',
                text: 'If you have any questions about this Privacy Policy or our privacy practices, please contact us:',
              ),
              _buildBulletPoint('Email: privacy@sylonow.com'),
              _buildBulletPoint('Phone: +91-9876543210'),
              _buildBulletPoint('Address: 123 Business District, Tech City, TC 12345'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...content,
      ],
    );
  }

  Widget _buildSubSection({
    required String subtitle,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Okra',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontFamily: 'Okra',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontFamily: 'Okra',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}