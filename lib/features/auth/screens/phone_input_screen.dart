import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/widgets/gredient_elevated_button.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../providers/auth_providers.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  static const String routeName = '/phone-input';

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Auto-focus on phone input when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String? _validateIndianMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    
    // Check if it starts with valid Indian mobile number prefixes
    final firstDigit = value[0];
    if (!['6', '7', '8', '9'].contains(firstDigit)) {
      return 'Please enter a valid Indian mobile number';
    }
    
    return null;
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    final phoneNumber = '+91${_phoneController.text.trim()}';
    
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      
      // Send OTP to phone number
      await authService.signInWithPhone(phoneNumber);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Navigate to OTP verification screen
        context.push(AppConstants.otpVerificationRoute, extra: {
          'phoneNumber': phoneNumber,
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).viewInsets.bottom - 
                          MediaQuery.of(context).viewPadding.top - 48,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    
                    // Title 
                    Text(
                      'Continue with phone',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Okra',
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Okra',
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(text: 'We will send '),
                          TextSpan(
                            text: 'One Time Password',
                            style: TextStyle(color: AppTheme.primaryColor),
                          ),
                          TextSpan(text: ' on this phone number'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // OTP Illustration - Hide when keyboard is open
                    if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
                      Container(
                        height: 200,
                        width: 200,
                       
                        child: Image.asset(
                          'assets/images/otp_hand.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ] else ...[
                      const SizedBox(height: 20),
                    ],
                    
                    // Label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter your phone number',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Phone Input Field
                    TextFormField(
                      controller: _phoneController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Okra',
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🇮🇳', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                '+91',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Okra',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                height: 20,
                                width: 1,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                        hintText: '9876543210',
                        counterText: '',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: 'Okra',
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                      validator: (value) => _validateIndianMobile(value),
                      onFieldSubmitted: (_) => _sendOTP(),
                    ),
                    
                    const Spacer(),
                    
                    // Get OTP Button
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 32,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A5F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Get OTP',
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
      ),
    );
  }
}