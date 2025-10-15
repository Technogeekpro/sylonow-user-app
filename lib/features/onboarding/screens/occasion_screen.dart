import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/onboarding_providers.dart';
import '../models/category_model.dart';
import 'date_screen.dart';

class OccasionScreen extends ConsumerStatefulWidget {
  static const String routeName = '/onboarding/occasion';

  const OccasionScreen({super.key});

  @override
  ConsumerState<OccasionScreen> createState() => _OccasionScreenState();
}

class _OccasionScreenState extends ConsumerState<OccasionScreen> {
  String? _selectedOccasionId;
  String? _selectedOccasionName;
  String? _customOccasion;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;
  bool _isLoadingCategories = false;
  List<CategoryModel> _categories = [];
  final TextEditingController _customTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _customTextController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('categories')
          .select()
          .order('name');

      final List<CategoryModel> categories = (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load categories: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _continue() async {
    String occasionIdToSave;
    String occasionNameToSave;
    
    if (_selectedOccasionId == 'other') {
      if (_customOccasion == null || _customOccasion!.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter your custom occasion'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // For custom occasion, we'll save the name and empty ID
      occasionIdToSave = '';
      occasionNameToSave = _customOccasion!.trim();
    } else if (_selectedOccasionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an occasion'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else {
      // For selected category, save both ID and name
      occasionIdToSave = _selectedOccasionId!;
      occasionNameToSave = _selectedOccasionName!;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(onboardingControllerProvider.notifier)
          .updateOccasionWithId(occasionIdToSave, occasionNameToSave);
      
      // Save celebration time if selected
      if (_selectedTime != null) {
        final timeString = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00';
        await ref.read(onboardingControllerProvider.notifier)
            .updateCelebrationTime(timeString);
      }
      
      if (mounted) {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const DateScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save occasion: $e'),
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
          // Step 2 - Active
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
          // Step 3 - Inactive
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
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
                        
                        // Illustration - Hide when keyboard is open
                        if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              'assets/images/occasion.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ] else ...[
                          const SizedBox(height: 16),
                        ],
                        
                        // Title
                        Text(
                          'What are you celebrating?',
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
                          'Choose the occasion you want us to make special.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Okra',
                            color: Colors.grey[600],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Dropdown for Categories
                        if (_isLoadingCategories)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dropdown
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedOccasionId,
                                    hint: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'Birthday',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: 'Okra',
                                        ),
                                      ),
                                    ),
                                    isExpanded: true,
                                    items: [
                                      ..._categories.map((category) => DropdownMenuItem<String>(
                                          value: category.id,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Text(
                                              category.name,
                                              style: const TextStyle(
                                                fontFamily: 'Okra',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        )),
                                      // Other option
                                      const DropdownMenuItem<String>(
                                        value: 'other',
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          child: Text(
                                            'Other',
                                            style: TextStyle(
                                              fontFamily: 'Okra',
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOccasionId = value;
                                        if (value != 'other') {
                                          // Find the selected category name
                                          final selectedCategory = _categories.firstWhere(
                                            (cat) => cat.id == value,
                                            orElse: () => CategoryModel(id: '', name: ''),
                                          );
                                          _selectedOccasionName = selectedCategory.name;
                                          _customOccasion = null;
                                          _customTextController.clear();
                                        } else {
                                          _selectedOccasionName = null;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Custom input field (shows only when "Other" is selected)
                              if (_selectedOccasionId == 'other') ...[
                                Text(
                                  'Please specify your occasion:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Okra',
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _customTextController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your custom occasion',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontFamily: 'Okra',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: const Color(0xFF1E3A5F), width: 2),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Okra',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _customOccasion = value;
                                    });
                                  },
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ],
                              
                              // Time Picker Section
                              const SizedBox(height: 20),
                              Text(
                                'When is the celebration?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Okra',
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: _selectedTime ?? const TimeOfDay(hour: 18, minute: 0),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: Theme.of(context).colorScheme.copyWith(
                                            primary: const Color(0xFF1E3A5F),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null && picked != _selectedTime) {
                                    setState(() {
                                      _selectedTime = picked;
                                    });
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedTime != null 
                                            ? _selectedTime!.format(context)
                                            : 'Select celebration time (optional)',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Okra',
                                          color: _selectedTime != null 
                                              ? Colors.black
                                              : Colors.grey[400],
                                        ),
                                      ),
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.grey[400],
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        
                        const Spacer(),
                      ],
                    ),
                  ),
                  
                  // Continue Button
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 32,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (_selectedOccasionId != null && 
                                          (_selectedOccasionId != 'other' || 
                                           (_customOccasion != null && _customOccasion!.trim().isNotEmpty)))
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