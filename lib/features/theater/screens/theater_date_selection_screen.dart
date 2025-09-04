import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';

class TheaterDateSelectionScreen extends StatefulWidget {
  static const String routeName = '/theater/date-selection';

  const TheaterDateSelectionScreen({super.key});

  @override
  State<TheaterDateSelectionScreen> createState() =>
      _TheaterDateSelectionScreenState();
}

class _TheaterDateSelectionScreenState
    extends State<TheaterDateSelectionScreen> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

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
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Okra',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 20 : 24,
                24,
                isSmallScreen ? 20 : 24,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.movie_outlined,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose Your Perfect Date',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Okra',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your preferred date to find available theaters\nand check real-time availability.',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 15,
                      color: Colors.grey[600],
                      fontFamily: 'Okra',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.grey[200],
            ),

            // Calendar Section
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Okra',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Calendar
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme:
                              ColorScheme.fromSeed(
                                seedColor: AppTheme.primaryColor,
                                brightness: Brightness.light,
                              ).copyWith(
                                primary: AppTheme.primaryColor,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                                surfaceContainerHighest: Colors.grey[100],
                              ),
                          textTheme: Theme.of(context).textTheme.copyWith(
                            bodyLarge: const TextStyle(fontFamily: 'Okra'),
                            bodyMedium: const TextStyle(fontFamily: 'Okra'),
                            titleMedium: const TextStyle(fontFamily: 'Okra'),
                          ),
                          datePickerTheme: DatePickerThemeData(
                            dayStyle: const TextStyle(
                              fontFamily: 'Okra',
                              fontWeight: FontWeight.w500,
                            ),
                            todayBackgroundColor: WidgetStateProperty.all(
                              AppTheme.primaryColor.withOpacity(0.1),
                            ),
                            todayForegroundColor: WidgetStateProperty.all(
                              AppTheme.primaryColor,
                            ),
                            dayBackgroundColor: WidgetStateProperty.resolveWith(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppTheme.primaryColor;
                                }
                                return Colors.transparent;
                              },
                            ),
                            dayForegroundColor: WidgetStateProperty.resolveWith(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors.white;
                                }
                                return Colors.black;
                              },
                            ),
                            dayShape: WidgetStateProperty.all(
                              const CircleBorder(),
                            ),
                            rangePickerBackgroundColor: Colors.white,
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: firstDate,
                          lastDate: lastDate,
                          onDateChanged: (date) {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Selected Date Display
            if (selectedDate != null)
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 24,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'Okra',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(selectedDate!),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Okra',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Continue Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 20,
                      color: selectedDate != null
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedDate != null
                          ? 'Find Available Theaters'
                          : 'Select a date to continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                        color: selectedDate != null
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
