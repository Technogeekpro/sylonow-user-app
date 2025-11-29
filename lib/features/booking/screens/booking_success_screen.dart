import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/models/service_listing_model.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final String paymentMethod;

  const BookingSuccessScreen({
    super.key,
    required this.bookingData,
    required this.paymentMethod,
  });

  static const String routeName = '/booking/success';

  @override
  Widget build(BuildContext context) {
    final service = bookingData['service'] as ServiceListingModel;
    final advanceAmount = bookingData['advanceAmount'] as double;
    final remainingAmount = bookingData['remainingAmount'] as double;
    final orderId = bookingData['orderId'] as String? ?? 'ORDER_ID_NOT_AVAILABLE';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(
              Icons.close,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Success Animation
                Lottie.asset(
                  'assets/animations/success.json',
                  width: 120,
                  height: 120,
                  repeat: false,
                ),
                
                const SizedBox(height: 20),
                
                // Success Message
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Your ${service.name} service has been booked',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryColor,
                    fontFamily: 'Okra',
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // QR Code Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: QrImageView(
                          data: orderId,
                          version: QrVersions.auto,
                          size: 120,
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: AppTheme.textPrimaryColor,
                          ),
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'This QR you have to show when vendor visit your location to start the service',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue.shade700,
                                  fontFamily: 'Okra',
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Payment Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Okra',
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildPaymentRow(
                        'Advance Paid',
                        advanceAmount,
                        Icons.check_circle_outline,
                        Colors.green.shade600,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildPaymentRow(
                        'Pay after service',
                        remainingAmount,
                        Icons.schedule,
                        Colors.orange.shade600,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Service Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Order ID', orderId),
                      const SizedBox(height: 12),
                      _buildDetailRow('Service', service.name),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Date', 
                        bookingData['selectedDate']?.toString().split(' ')[0] ?? 'TBD',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Time', 
                        bookingData['selectedTimeSlot'] ?? 'TBD',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Action Buttons
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/profile/bookings'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'View Booking History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => context.go('/home'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.textSecondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, double amount, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
              fontFamily: 'Okra',
            ),
          ),
        ),
        Text(
          '₹${_formatAmount(amount)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
            fontFamily: 'Okra',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
              fontFamily: 'Okra',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimaryColor,
              fontFamily: 'Okra',
            ),
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!$))'),
      (Match m) => '${m[1]},',
    );
  }
}