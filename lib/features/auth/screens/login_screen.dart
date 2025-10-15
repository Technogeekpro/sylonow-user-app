import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool _acceptTerms = false;
  bool _isAppleSignInAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkAppleSignInAvailability();
  }

  Future<void> _checkAppleSignInAvailability() async {
    final authService = ref.read(authServiceProvider);
    final isAvailable = await authService.isAppleSignInAvailable();
    setState(() {
      _isAppleSignInAvailable = isAvailable;
    });
  }

  void _continueWithPhone() {
    if (!_acceptTerms) {
      _showTermsError();
      return;
    }
    // Navigate to phone input screen
    context.push(PhoneInputScreen.routeName);
  }

  void _showTermsError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please accept the Terms and Privacy Policy to continue'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _continueWithApple() async {
    if (!_acceptTerms) {
      _showTermsError();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);

      // Sign in with Apple
      final response = await authService.signInWithApple();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response != null && response.user != null) {
          // Check if onboarding is completed
          final isOnboardingCompleted = await authService.isOnboardingCompleted();

          if (mounted) {
            if (isOnboardingCompleted) {
              // Onboarding completed, go to home
              context.go(AppConstants.homeRoute);
            } else {
              // Onboarding not completed, go to welcome screen
              context.go(AppConstants.welcomeRoute);
            }
          }
        } else {
          // User canceled the sign-in
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign in was canceled')));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Apple sign in failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _continueWithGoogle() async {
    if (!_acceptTerms) {
      _showTermsError();
      return;
    }
    
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
          // Check if onboarding is completed
          final isOnboardingCompleted = await authService.isOnboardingCompleted();

          if (mounted) {
            if (isOnboardingCompleted) {
              // Onboarding completed, go to home
              context.go(AppConstants.homeRoute);
            } else {
              // Onboarding not completed, go to welcome screen
              context.go(AppConstants.welcomeRoute);
            }
          }
        } else {
          // User canceled the sign-in
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign in was canceled')));
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
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Top Half - Primary Background with Logo
            Expanded(
              flex: 1,
              child: SvgPicture.asset(
                'assets/svgs/app_logo.svg',
                fit: BoxFit.contain,
              ),
            ),

          
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                 

                    // Continue with Phone Button
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _acceptTerms ? _continueWithPhone : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey[600],
                          disabledForegroundColor: Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(56),
                          ),
                          elevation: 2,
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
                          child: Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Okra',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Continue with Google Button
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading || !_acceptTerms ? null : _continueWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(56),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          elevation: 2,
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
                                  const Icon(FontAwesomeIcons.google, size: 24),
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

                    // Continue with Apple Button (only shown on iOS)
                    if (_isAppleSignInAvailable) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading || !_acceptTerms ? null : _continueWithApple,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(56),
                            ),
                            elevation: 2,
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
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(FontAwesomeIcons.apple, size: 24),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Continue with Apple',
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
                    ],

                    const SizedBox(height: 24),

                    // Terms and Privacy Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                          activeColor: Colors.white,
                          checkColor: AppTheme.primaryColor,
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'I agree to the Terms of Service and Privacy Policy',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Okra',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
