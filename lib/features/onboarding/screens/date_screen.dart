import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/onboarding_providers.dart';

class DateScreen extends ConsumerStatefulWidget {
  static const String routeName = '/onboarding/date';

  const DateScreen({super.key});

  @override
  ConsumerState<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends ConsumerState<DateScreen> {
  DateTime? _selectedDate;
  final _dateFormatter = DateFormat('MMMM d, y');
  bool _isLoading = false;

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tempSelectedDate = _selectedDate ?? today;
    
    // Ensure tempSelectedDate is not before today
    if (tempSelectedDate.isBefore(today)) {
      tempSelectedDate = today;
    }
    
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                  Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Okra',
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = tempSelectedDate;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Okra',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Cupertino Date Picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempSelectedDate,
                  minimumDate: today,
                  maximumDate: today.add(const Duration(days: 365 * 2)),
                  onDateTimeChanged: (DateTime newDate) {
                    tempSelectedDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _continue() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dateString = _selectedDate!.toIso8601String();
      await ref.read(onboardingControllerProvider.notifier)
          .updateCelebrationDate(dateString);
      
      // Complete onboarding after saving the date
      await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
      
      if (mounted) {
        // Navigate to home screen with no back navigation
        context.go(AppConstants.homeRoute);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save date: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _skip() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Complete onboarding even when skipping date selection
      await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
      
      if (mounted) {
        // Navigate to home screen with no back navigation
        context.go(AppConstants.homeRoute);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      child: Row(
        children: [
          // Step 1 - Completed
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Step 2 - Completed
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Step 3 - Active
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                        MediaQuery.of(context).viewInsets.bottom - 
                        MediaQuery.of(context).viewPadding.top - 48,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Progress Indicator
                  _buildProgressIndicator(),
                  
                  // Main Content
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        
                        // Illustration
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'assets/images/date_picker.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Title
                        Text(
                          'When is your celebration?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Okra',
                            color: Colors.black,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Subtitle
                        Text(
                          'We\'ll help you get everything ready on time.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Okra',
                            color: Colors.grey[600],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Date Input Field
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedDate != null
                                        ? _dateFormatter.format(_selectedDate!)
                                        : 'dd/mm/yyyy',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Okra',
                                      color: _selectedDate != null
                                          ? Colors.black
                                          : Colors.grey[400],
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                      ],
                    ),
                  ),
                  
                  // Continue Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedDate != null 
                              ? const Color(0xFF1E3A5F)
                              : Colors.grey[300],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Okra',
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}