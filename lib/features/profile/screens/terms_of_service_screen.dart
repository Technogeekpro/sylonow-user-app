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
            'Effective Date: [Add Date]\nLast Updated: [Add Date]\nCompany: Sylonow Vision Private Limited\nPlatform: Sylonow User App',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Okra',
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome to Sylonow. These Terms & Conditions govern your access to and use of the Sylonow User App operated by Sylonow Vision Private Limited. By using the Sylonow User App, you agree to these Terms, which form a legally binding contract between you and Sylonow.',
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
                text: 'If you do not agree with any of these Terms, you must not access or use the Platform.',
              ),
            ],
          ),
          _buildSection(
            title: '2. Definitions',
            content: [
              _buildBulletPoint('User: Any individual using the Sylonow User App'),
              _buildBulletPoint('Vendor: Third-party service providers listed on the Sylonow Platform'),
              _buildBulletPoint('Wallet: Virtual credit issued by Sylonow, which can be used only within the Sylonow platform for future bookings'),
              _buildBulletPoint('Order: A confirmed booking made by a User through the Sylonow User App'),
              _buildBulletPoint('Advance Payment: Minimum 60% of the order value paid upfront by the User to confirm the booking'),
            ],
          ),
          _buildSection(
            title: '3. User Eligibility',
            content: [
              _buildSubSection(
                subtitle: 'Age Requirement',
                text: 'You must be at least 18 years old to use the Sylonow User App. By using this platform, you represent that you have the legal capacity to enter into a binding contract under the Indian Contract Act, 1872.',
              ),
            ],
          ),
          _buildSection(
            title: '4. Services Provided',
            content: [
              _buildSubSection(
                subtitle: 'Platform Role',
                text: 'Sylonow is a booking facilitator that connects Users with third-party vendors for services such as decorations, events, surprise arrangements, and related services. Sylonow is not the service provider and is not responsible for the actual execution, quality, or delivery of the booked services.',
              ),
            ],
          ),
          _buildSection(
            title: '5. User Account and Security',
            content: [
              _buildBulletPoint('Users must register with accurate and complete information'),
              _buildBulletPoint('Users are responsible for maintaining the confidentiality of their login credentials'),
              _buildBulletPoint('Sylonow shall not be liable for any loss arising from unauthorized access to your account'),
              _buildBulletPoint('Users must immediately notify Sylonow of any unauthorized activity'),
            ],
          ),
          _buildSection(
            title: '6. Payments',
            content: [
              _buildBulletPoint('All bookings require a minimum 60% advance payment for confirmation'),
              _buildBulletPoint('The remaining balance, if any, must be settled as per the vendor\'s payment terms at the time of service'),
              _buildBulletPoint('Payments must be made through the approved payment gateways provided in the app'),
              _buildBulletPoint('Sylonow is not responsible for payment failures, payment delays, or issues caused by payment gateways'),
              _buildBulletPoint('Razorpay or any other listed gateway fees apply'),
            ],
          ),
          _buildSection(
            title: '7. Cancellation & Refund Policy',
            content: [
              _buildSubSection(
                subtitle: 'Refund Schedule',
                text: 'Time Before Service | Bank Refund | Wallet Refund\nMore than 24 Hours | 50% of Advance Payment | 100% of Advance Payment\n24 to 12 Hours | 30% of Advance Payment | 100% of Advance Payment\n12 to 6 Hours | 17% of Advance Payment | 100% of Advance Payment\nLess than 6 Hours | No Refund | 100% of Advance Payment',
              ),
              _buildSubSection(
                subtitle: 'Wallet Terms',
                text: '• Bank refunds processed within 5-7 working days\n• Wallet refunds are instant\n• Wallet balances do not expire\n• Maximum wallet balance: ₹10,000\n• Maximum wallet usage per order: 20% of order value\n• Wallet refund processing fee: ₹100 per cancellation',
              ),
            ],
          ),
          _buildSection(
            title: '8. Pricing Policy',
            content: [
              _buildBulletPoint('Prices displayed are dynamic and may vary based on time, location, availability, and wallet refund selection'),
              _buildBulletPoint('Wallet refund customers will be shown adjusted prices on future bookings'),
              _buildBulletPoint('Sylonow reserves the right to change prices at any time without prior notice'),
            ],
          ),
          _buildSection(
            title: '9. Wallet Restrictions',
            content: [
              _buildBulletPoint('Wallet balances can only be used on the Sylonow User App'),
              _buildBulletPoint('Wallet balances cannot be transferred to another user or used on other platforms'),
              _buildBulletPoint('Sylonow reserves the right to deduct wallet balances if policy misuse is detected'),
              _buildBulletPoint('Wallet balances are purely virtual and hold no real cash value'),
            ],
          ),
          _buildSection(
            title: '10. User Obligations',
            content: [
              _buildBulletPoint('Users must ensure correct booking details, location, and timing'),
              _buildBulletPoint('Users must make themselves or their representatives available at the time of service'),
              _buildBulletPoint('Users must make full payments as per the booking terms'),
              _buildBulletPoint('Sylonow may cancel bookings if payment is not completed as per the process'),
            ],
          ),
          _buildSection(
            title: '11. Vendor Responsibility',
            content: [
              _buildBulletPoint('Vendors are solely responsible for delivering the booked service'),
              _buildBulletPoint('Sylonow does not guarantee service execution, quality, or timeliness'),
              _buildBulletPoint('Any issues related to vendor performance must be resolved directly with the vendor'),
            ],
          ),
          _buildSection(
            title: '12. Sylonow\'s Limitation of Liability',
            content: [
              _buildSubSection(
                subtitle: 'Liability Limitations',
                text: 'Sylonow is not liable for any direct, indirect, incidental, or consequential losses, service delays, or failures arising from vendor actions, technical glitches, or force majeure events. Sylonow\'s liability in all cases is strictly limited to the amount paid by the User for the specific booking in question.',
              ),
            ],
          ),
          _buildSection(
            title: '13. Data Privacy',
            content: [
              _buildSubSection(
                subtitle: 'Compliance',
                text: 'Sylonow collects, stores, and uses personal information in compliance with the Information Technology Act, 2000 and all applicable data protection laws in India. Detailed privacy practices are outlined in our Privacy Policy, which forms part of these Terms & Conditions.',
              ),
            ],
          ),
          _buildSection(
            title: '14. Updates to Terms',
            content: [
              _buildSubSection(
                subtitle: 'Modifications',
                text: 'Sylonow reserves the right to modify these Terms & Conditions at any time. The updated Terms will be effective immediately upon publication. Continued use of the Sylonow User App signifies your acceptance of the latest Terms.',
              ),
            ],
          ),
          _buildSection(
            title: '15. Intellectual Property',
            content: [
              _buildSubSection(
                subtitle: 'Ownership',
                text: 'All content, logos, trademarks, and designs on the Sylonow User App are the exclusive property of Sylonow Vision Private Limited. Unauthorized use, reproduction, or distribution is strictly prohibited.',
              ),
            ],
          ),
          _buildSection(
            title: '16. Termination',
            content: [
              _buildSubSection(
                subtitle: 'Termination Rights',
                text: 'Sylonow reserves the right to suspend or terminate your account without notice in case of policy violations, fraudulent activities, or misuse of the platform.',
              ),
            ],
          ),
          _buildSection(
            title: '17. Governing Law & Jurisdiction',
            content: [
              _buildSubSection(
                subtitle: 'Legal Framework',
                text: 'These Terms are governed by the laws of India. All disputes are subject to the exclusive jurisdiction of the courts in Bangalore, Karnataka.',
              ),
            ],
          ),
          _buildSection(
            title: '18. Contact Information',
            content: [
              _buildSubSection(
                subtitle: 'Legal Notices & Support',
                text: 'For any questions, complaints, or legal notices, contact:',
              ),
              _buildBulletPoint('Email: info@sylonow.com'),
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