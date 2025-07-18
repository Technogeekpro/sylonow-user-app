import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class TermsOfServiceScreen extends ConsumerWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Terms of Service',
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
            Icons.description,
            size: 48,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Terms of Service',
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
            'These Terms of Service govern your use of the Sylonow platform and the services we provide. By using our services, you agree to these terms.',
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
            title: '1. Acceptance of Terms',
            content: [
              _buildSubSection(
                subtitle: 'Agreement',
                text: 'By accessing or using Sylonow, you agree to be bound by these Terms of Service and all applicable laws and regulations.',
              ),
              _buildSubSection(
                subtitle: 'Modifications',
                text: 'We reserve the right to modify these terms at any time. Changes will be effective immediately upon posting. Your continued use of our services constitutes acceptance of the modified terms.',
              ),
            ],
          ),
          _buildSection(
            title: '2. Description of Service',
            content: [
              _buildSubSection(
                subtitle: 'Platform',
                text: 'Sylonow is a digital marketplace platform that connects users with verified service providers for various services including home services, entertainment, and other professional services.',
              ),
              _buildSubSection(
                subtitle: 'Facilitation',
                text: 'We facilitate connections between users and service providers but do not directly provide the services. The actual services are provided by independent third-party service providers.',
              ),
            ],
          ),
          _buildSection(
            title: '3. User Accounts',
            content: [
              _buildSubSection(
                subtitle: 'Registration',
                text: 'To use our services, you must create an account and provide accurate, complete information. You are responsible for maintaining the confidentiality of your account credentials.',
              ),
              _buildSubSection(
                subtitle: 'Eligibility',
                text: 'You must be at least 18 years old to use our services. By using our platform, you represent that you meet this age requirement.',
              ),
              _buildSubSection(
                subtitle: 'Account Responsibility',
                text: 'You are responsible for all activities that occur under your account. You must notify us immediately of any unauthorized use of your account.',
              ),
            ],
          ),
          _buildSection(
            title: '4. Booking and Payments',
            content: [
              _buildSubSection(
                subtitle: 'Booking Process',
                text: 'When you book a service through our platform, you enter into a direct agreement with the service provider. We facilitate the booking process but are not a party to the service agreement.',
              ),
              _buildSubSection(
                subtitle: 'Payment Terms',
                text: 'Payment for services is processed through our platform. We may charge service fees and processing fees as disclosed at the time of booking.',
              ),
              _buildSubSection(
                subtitle: 'Cancellation Policy',
                text: 'Cancellation policies vary by service type and provider. Please review the specific cancellation terms before booking.',
              ),
            ],
          ),
          _buildSection(
            title: '5. User Responsibilities',
            content: [
              _buildBulletPoint('Provide accurate information when booking services'),
              _buildBulletPoint('Be present and available at the scheduled service time'),
              _buildBulletPoint('Treat service providers with respect and professionalism'),
              _buildBulletPoint('Pay for services as agreed'),
              _buildBulletPoint('Report any issues or concerns promptly'),
              _buildBulletPoint('Comply with all applicable laws and regulations'),
            ],
          ),
          _buildSection(
            title: '6. Service Provider Responsibilities',
            content: [
              _buildBulletPoint('Provide services as described and agreed upon'),
              _buildBulletPoint('Maintain professional standards and qualifications'),
              _buildBulletPoint('Arrive on time and prepared for the service'),
              _buildBulletPoint('Respect user privacy and property'),
              _buildBulletPoint('Follow all applicable safety and regulatory requirements'),
            ],
          ),
          _buildSection(
            title: '7. Platform Rules',
            content: [
              _buildSubSection(
                subtitle: 'Prohibited Activities',
                text: 'You may not use our platform for any illegal, harmful, or abusive activities. This includes but is not limited to:',
              ),
              _buildBulletPoint('Providing false or misleading information'),
              _buildBulletPoint('Harassing or discriminating against other users'),
              _buildBulletPoint('Attempting to bypass our payment systems'),
              _buildBulletPoint('Posting inappropriate or offensive content'),
              _buildBulletPoint('Interfering with platform operations'),
            ],
          ),
          _buildSection(
            title: '8. Intellectual Property',
            content: [
              _buildSubSection(
                subtitle: 'Platform Content',
                text: 'All content on our platform, including text, graphics, logos, and software, is owned by Sylonow or our licensors and is protected by copyright and other intellectual property laws.',
              ),
              _buildSubSection(
                subtitle: 'User Content',
                text: 'You retain ownership of content you submit to our platform but grant us a license to use, modify, and distribute such content in connection with our services.',
              ),
            ],
          ),
          _buildSection(
            title: '9. Disclaimer of Warranties',
            content: [
              _buildSubSection(
                subtitle: 'As-Is Basis',
                text: 'Our services are provided on an "as-is" and "as-available" basis. We make no warranties, express or implied, regarding the quality, reliability, or availability of our services.',
              ),
              _buildSubSection(
                subtitle: 'Service Provider Quality',
                text: 'While we strive to work with qualified service providers, we do not guarantee the quality of services provided by third parties.',
              ),
            ],
          ),
          _buildSection(
            title: '10. Limitation of Liability',
            content: [
              _buildSubSection(
                subtitle: 'Damages',
                text: 'To the maximum extent permitted by law, Sylonow shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of our services.',
              ),
              _buildSubSection(
                subtitle: 'Maximum Liability',
                text: 'Our total liability for any claim arising from or related to our services shall not exceed the amount you paid for the specific service in question.',
              ),
            ],
          ),
          _buildSection(
            title: '11. Indemnification',
            content: [
              _buildSubSection(
                subtitle: 'User Indemnification',
                text: 'You agree to indemnify and hold harmless Sylonow from any claims, damages, or expenses arising from your use of our services or violation of these terms.',
              ),
            ],
          ),
          _buildSection(
            title: '12. Termination',
            content: [
              _buildSubSection(
                subtitle: 'Termination Rights',
                text: 'We may terminate or suspend your account at any time for violation of these terms or for any other reason in our sole discretion.',
              ),
              _buildSubSection(
                subtitle: 'Effect of Termination',
                text: 'Upon termination, your right to use our services will cease immediately. Provisions that by their nature should survive termination will remain in effect.',
              ),
            ],
          ),
          _buildSection(
            title: '13. Governing Law',
            content: [
              _buildSubSection(
                subtitle: 'Jurisdiction',
                text: 'These terms shall be governed by and construed in accordance with the laws of India. Any disputes shall be subject to the exclusive jurisdiction of the courts in [Your City].',
              ),
            ],
          ),
          _buildSection(
            title: '14. Contact Information',
            content: [
              _buildSubSection(
                subtitle: 'Questions',
                text: 'If you have any questions about these Terms of Service, please contact us:',
              ),
              _buildBulletPoint('Email: legal@sylonow.com'),
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