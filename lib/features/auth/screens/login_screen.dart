import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_providers.dart';
import 'phone_input_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  void _continueWithPhone() {
    // Navigate to phone input screen
    context.push(PhoneInputScreen.routeName);
  }

  Future<void> _continueWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      
      // Sign in with Google
      final response = await authService.signInWithGoogle();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
        
        if (response != null && response.user != null) {
          // Successfully signed in, navigate to home
      context.go(AppConstants.homeRoute);
        } else {
          // User canceled the sign-in
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign in was canceled')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign in failed: ${e.toString()}')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Column(
        children: [
          // Top Half - Primary Background with Logo
          Container(
            height: screenHeight * 0.6, // 60% of screen height
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
                  Image.asset(
                    'assets/images/sylonow_white_logo.png',
                    width: MediaQuery.of(context).size.width * 0.5,
              ),
                  const SizedBox(height: 24),
              
                  // Welcome Text
              const Text(
                    'Welcome to Sylonow',
                style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                    'Your one-stop solution for all services',
                style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
                ),
            ),
              ),
              
          // Bottom Half - Login Options
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const Text(
                    'Choose your login method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Okra',
                    ),
                  ),
                  const SizedBox(height: 32),
                    
                  // Continue with Phone Button
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _continueWithPhone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'Continue with Phone',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                  // OR Divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontFamily: 'Okra',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                    ),
                    
                  const SizedBox(height: 16),
                    
                  // Continue with Google Button
                    SizedBox(
                    height: 56,
                      width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _continueWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black54,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/app_icon.png', // You can replace with Google logo
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Okra',
                      ),
                    ),
                  ],
                            ),
                ),
              ),
              
                  const SizedBox(height: 32),
              
                  // Terms and Privacy
                  Text(
                    'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: 'Okra',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 