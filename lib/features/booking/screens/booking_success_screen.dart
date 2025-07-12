import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Success Animation
                Lottie.asset(
                  'assets/animations/success.json',
                  width: 200,
                  height: 200,
                  repeat: false,
                ),
                const SizedBox(height: 32),
                // Success Message
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your ${service.name} service has been booked successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Okra',
                  ),
                ),
                const SizedBox(height: 40),
                // Booking Details Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Okra',
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildDetailRow(
                        'Service',
                        service.name,
                        Icons.celebration,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Date',
                        bookingData['selectedDate']?.toString().split(' ')[0] ?? 'TBD',
                        Icons.calendar_today,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Time',
                        bookingData['selectedTimeSlot'] ?? 'TBD',
                        Icons.access_time,
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      // Payment Details
                      _buildPaymentDetail(
                        'Advance Paid',
                        advanceAmount,
                        isPaid: true,
                      ),
                      const SizedBox(height: 16),
                      _buildPaymentDetail(
                        'Remaining Payment',
                        remainingAmount,
                        isRemaining: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Back to Home Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentDetail(String label, double amount, {
    bool isPaid = false,
    bool isRemaining = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isPaid ? Icons.check_circle : Icons.info_outline,
              size: 20,
              color: isPaid ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isPaid ? Colors.green : Colors.orange,
                fontFamily: 'Okra',
              ),
            ),
          ],
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPaid ? Colors.green : Colors.orange,
            fontFamily: 'Okra',
          ),
        ),
      ],
    );
  }
} 