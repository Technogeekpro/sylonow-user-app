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
            'Effective Date: May 12, 2025\nLast Updated: July 2, 2025\nOwned by: Sylonow Vision Private Limited',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Okra',
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Sylonow Vision Private Limited is committed to protecting your privacy and ensuring the safety of your personal data. This Privacy Policy explains how we collect, use, share, and store your information when you use the Sylonow User App.',
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
            title: '1. Introduction',
            content: [
              _buildSubSection(
                subtitle: 'Agreement',
                text: 'By downloading, installing, or using the App, you agree to this Privacy Policy and consent to the handling of your data in accordance with the Information Technology Act, 2000, the Information Technology (Reasonable Security Practices and Procedures and Sensitive Personal Data or Information) Rules, 2011, and the Consumer Protection (E-Commerce) Rules, 2020.',
              ),
            ],
          ),
          _buildSection(
            title: '2. Information We Collect',
            content: [
              _buildSubSection(
                subtitle: 'Personal Information',
                text: '• Full name\n• Mobile number\n• Email address (optional)\n• GPS-based location\n• Delivery address\n• Payment details (via secure third-party gateways)\n• Identity proof (if required for certain services)',
              ),
              _buildSubSection(
                subtitle: 'Device & Usage Data',
                text: '• IP address\n• Device type, OS version\n• App activity logs, clicks, and crash reports',
              ),
              _buildSubSection(
                subtitle: 'Third-Party Login Data',
                text: '• Google account information (name, email, profile image) if login is via Google',
              ),
            ],
          ),
          _buildSection(
            title: '3. Use of Information',
            content: [
              _buildBulletPoint('Register and manage your account'),
              _buildBulletPoint('Process bookings and payments'),
              _buildBulletPoint('Enable QR-based vendor verification'),
              _buildBulletPoint('Provide customer support'),
              _buildBulletPoint('Send booking updates and important notifications'),
              _buildBulletPoint('Improve app security, performance, and functionality'),
              _buildBulletPoint('Detect fraud and ensure regulatory compliance'),
              _buildBulletPoint('Send promotional messages (opt-out available anytime)'),
            ],
          ),
          _buildSection(
            title: '4. Data Sharing & Disclosure',
            content: [
              _buildSubSection(
                subtitle: 'Policy',
                text: 'We never sell or rent your personal data.',
              ),
              _buildSubSection(
                subtitle: 'We may share information with',
                text: '• Verified vendors (only relevant booking details like your name and location)\n• Delivery partners\n• Payment processors (Razorpay, Paytm, etc.)\n• Cloud hosting and SMS/email service providers\n• Legal authorities if required under law\n\nAll sharing is strictly controlled through secure agreements.',
              ),
            ],
          ),
          _buildSection(
            title: '5. QR-Based Vendor Security',
            content: [
              _buildBulletPoint('Vendor identity is shared shortly before their arrival'),
              _buildBulletPoint('QR code scanning is mandatory for vendor verification'),
              _buildBulletPoint('The user is solely responsible for granting access after a successful QR scan'),
              _buildBulletPoint('No interaction data with vendors is recorded by Sylonow'),
            ],
          ),
          _buildSection(
            title: '6. Data Security',
            content: [
              _buildSubSection(
                subtitle: 'Security Measures',
                text: 'We apply industry-standard security measures including:\n• SSL/TLS encrypted data transmission\n• Secure cloud storage with limited access\n• OTP-based user login\n• Regular security audits and threat detection',
              ),
              _buildSubSection(
                subtitle: 'Data Breach Notification',
                text: 'In the event of a data breach, users will be informed within 72 hours in accordance with Indian laws.',
              ),
            ],
          ),
          _buildSection(
            title: '7. Data Retention',
            content: [
              _buildSubSection(
                subtitle: 'Retention Period',
                text: 'We retain your data:\n• As long as your account is active\n• To comply with legal, accounting, fraud-prevention, and tax obligations\n• Or until you request deletion of your data',
              ),
            ],
          ),
          _buildSection(
            title: '8. Cookies & Tracking',
            content: [
              _buildSubSection(
                subtitle: 'Usage',
                text: 'The App uses cookies and tracking technologies to:\n• Improve app performance\n• Analyze user behavior\n• Personalize advertising (where applicable)',
              ),
            ],
          ),
          _buildSection(
            title: '9. Your Rights Under Indian Law',
            content: [
              _buildSubSection(
                subtitle: 'Your Rights',
                text: 'As per Indian law and the SPDI Rules, you may:\n• Access your personal data\n• Correct or update your information\n• Withdraw consent at any time (may impact service availability)\n• Request data or account deletion\n\nFor any such request, contact us at: info@sylonow.com',
              ),
            ],
          ),
          _buildSection(
            title: '10. Children\'s Privacy',
            content: [
              _buildSubSection(
                subtitle: 'Age Restriction',
                text: 'The Sylonow User App is not intended for individuals under the age of 18. We do not knowingly collect data from minors.',
              ),
            ],
          ),
          _buildSection(
            title: '11. Changes to This Policy',
            content: [
              _buildSubSection(
                subtitle: 'Updates',
                text: 'We may update this Privacy Policy to reflect legal updates or app changes. Users will be notified of updates via the app, and changes will be reflected in the "Last Updated" date.',
              ),
            ],
          ),
          _buildSection(
            title: '12. Contact Information',
            content: [
              _buildSubSection(
                subtitle: 'Support & Complaints',
                text: 'For questions, support, or complaints, contact:',
              ),
              _buildBulletPoint('Sylonow Vision Private Limited'),
              _buildBulletPoint('Address: Bengaluru, Karnataka, India'),
              _buildBulletPoint('Email: info@sylonow.com'),
              _buildBulletPoint('Helpline: 9741338102 / 8867266638'),
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