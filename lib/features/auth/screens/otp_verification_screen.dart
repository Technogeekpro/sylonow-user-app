import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/auth_controller.dart';
import '../providers/auth_providers.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _otp = '';
  bool _isLoading = false;
  bool _isResending = false;
  int _remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _remainingSeconds = 60;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        _startResendTimer();
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otp.length == 6) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = ref.read(authServiceProvider);
        await authService.verifyPhoneOtpAndSignIn(
          phoneNumber: widget.phoneNumber,
          otp: _otp,
        );
        
        if (mounted) {
          context.go(AppConstants.homeRoute);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_remainingSeconds == 0) {
      setState(() {
        _isResending = true;
      });

      try {
        final authService = ref.read(authServiceProvider);
        await authService.signInWithPhone(widget.phoneNumber);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP resent successfully')),
          );
          _startResendTimer();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to resend OTP: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isResending = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/otp_hand.png',
                height: 150,
              ),
              const SizedBox(height: 32),
              const Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We have sent the verification code to\n${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              OtpTextField(
                numberOfFields: 6,
                borderColor: AppTheme.primaryColor,
                focusedBorderColor: AppTheme.primaryColor,
                showFieldAsBox: true,
                borderWidth: 2.0,
                fieldWidth: 45,
                borderRadius: BorderRadius.circular(10),
                onSubmit: (String verificationCode) {
                  setState(() {
                    _otp = verificationCode;
                  });
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Verify',
                onPressed: _verifyOtp,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: _resendOtp,
                    child: Text(
                      _remainingSeconds > 0
                          ? 'Resend in $_remainingSeconds s'
                          : 'Resend OTP',
                      style: TextStyle(
                        color: _remainingSeconds > 0
                            ? AppTheme.textSecondaryColor
                            : AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isResending)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 