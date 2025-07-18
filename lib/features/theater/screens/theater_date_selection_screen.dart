import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';

class TheaterDateSelectionScreen extends StatefulWidget {
  static const String routeName = '/theater/date-selection';

  const TheaterDateSelectionScreen({super.key});

  @override
  State<TheaterDateSelectionScreen> createState() => _TheaterDateSelectionScreenState();
}

class _TheaterDateSelectionScreenState extends State<TheaterDateSelectionScreen> {
  DateTime? selectedDate;
  late DateTime firstDate;
  late DateTime lastDate;

  @override
  void initState() {
    super.initState();
    firstDate = DateTime.now();
    lastDate = DateTime.now().add(const Duration(days: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Select Date',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Okra',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.movie,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Choose Your Perfect Date',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Okra',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'re asking for your preferred date to provide you with the best theater experience and availability. Select a date that works for you!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Okra',
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Date Selection Section
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Okra',
              ),
            ),
            const SizedBox(height: 16),
            
            // Date Picker Container
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: firstDate,
                lastDate: lastDate,
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ),
            
            const Spacer(),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedDate != null
                    ? () {
                        context.push(
                          '/theater/list',
                          extra: {
                            'selectedDate': selectedDate!.toIso8601String(),
                          },
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedDate != null 
                      ? AppTheme.primaryColor 
                      : Colors.grey[300],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: selectedDate != null ? 2 : 0,
                ),
                child: Text(
                  selectedDate != null 
                      ? 'Find Theaters - ${_formatDate(selectedDate!)}'
                      : 'Select a date to continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: selectedDate != null ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}