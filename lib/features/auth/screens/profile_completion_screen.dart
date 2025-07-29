import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sylonow_user/core/theme/app_theme.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileCompletionScreen extends ConsumerStatefulWidget {
  static const String routeName = '/profile-completion';

  const ProfileCompletionScreen({super.key});

  @override
  ConsumerState<ProfileCompletionScreen> createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends ConsumerState<ProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;

  final List<String> _genderOptions = ['male', 'female', 'other'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your gender'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      debugPrint('Current user: ${user?.id}, email: ${user?.email}, phone: ${user?.phone}');

      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Map gender to database format
      String? dbGender;
      if (_selectedGender != null) {
        switch (_selectedGender!) {
          case 'male':
            dbGender = 'male';
            break;
          case 'female':
            dbGender = 'female';
            break;
          case 'other':
            dbGender = 'other';
            break;
        }
      }

      // Update or insert user profile using auth_user_id as conflict resolution key
      final profileData = {
        'auth_user_id': user.id,
        'full_name': _nameController.text.trim(),
        'gender': dbGender,
        'app_type': 'customer',
        'email': user.email,
        'phone_number': user.phone,
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('Attempting to upsert profile data: $profileData');
      
      final response = await supabase
          .from('user_profiles')
          .upsert(profileData, onConflict: 'auth_user_id')
          .select();
      
      debugPrint('Profile upsert response: $response');

      // Mark profile as completed for tutorial trigger
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_completed_profile', true);
      
      // Navigate to home screen
      if (mounted) {
        context.go('/');
      }
    } catch (e, stackTrace) {
      debugPrint('Profile completion error: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to complete profile: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Okra'),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Welcome Header
                const Text(
                  'Welcome to Sylonow! 🎉',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Okra',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Let\'s complete your profile to personalize your experience',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Okra',
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 48),

                // Full Name Field
                const Text(
                  'What should we call you?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: const TextStyle(
                      fontFamily: 'Okra',
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppTheme.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Okra',
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Gender Field
                const Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedGender == null ? Colors.grey[300]! : AppTheme.primaryColor,
                    ),
                  ),
                  child: Column(
                    children: _genderOptions.map((gender) {
                      final isSelected = _selectedGender == gender;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedGender = gender;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppTheme.primaryColor.withOpacity(0.1) 
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                  gender == 'male' 
                                    ? Icons.male
                                    : gender == 'female' 
                                        ? Icons.female
                                        : Icons.transgender,
                                color: isSelected 
                                    ? AppTheme.primaryColor 
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  gender,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Okra',
                                    color: isSelected 
                                        ? AppTheme.primaryColor 
                                        : Colors.black,
                                    fontWeight: isSelected 
                                        ? FontWeight.w600 
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.primaryColor,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                const Spacer(),

                // Complete Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading || _selectedGender == null 
                        ? null 
                        : _completeProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Completing Profile...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Okra',
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Complete Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Okra',
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}