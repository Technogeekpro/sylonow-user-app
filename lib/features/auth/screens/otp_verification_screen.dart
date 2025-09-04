import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
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

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> with CodeAutoFill {
  String _otp = '';
  bool _isLoading = false;
  bool _isResending = false;
  int _remainingSeconds = 60;
  Timer? _timer;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _initSmsListener();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void _initSmsListener() async {
    // Listen for SMS messages
    await SmsAutoFill().listenForCode();
  }

  @override
  void codeUpdated() {
    // This method is called when SMS is received
    if (code != null && code!.length == 6) {
      setState(() {
        _otp = code!;
        _otpController.text = code!;
      });
      // Auto verify when OTP is received
      _verifyOtp();
    }
  }

  void _startResendTimer() {
    setState(() {
      _remainingSeconds = 60;
    });
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
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
    if (_remainingSeconds == 0 && !_isResending) {
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
          // Clear the OTP field and restart timer
          _otpController.clear();
          setState(() {
            _otp = '';
          });
          _startResendTimer();
          // Re-initialize SMS listener for new OTP
          _initSmsListener();
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
              PinFieldAutoFill(
                decoration: BoxLooseDecoration(
                  strokeColorBuilder: FixedColorBuilder(AppTheme.primaryColor),
                  bgColorBuilder: FixedColorBuilder(Colors.transparent),
                  strokeWidth: 2.0,
                  radius: const Radius.circular(10),
                ),
                currentCode: _otp,
                codeLength: 6,
                controller: _otpController,
                onCodeSubmitted: (code) {
                  setState(() {
                    _otp = code;
                  });
                  if (code.length == 6) {
                    _verifyOtp();
                  }
                },
                onCodeChanged: (code) {
                  setState(() {
                    _otp = code ?? '';
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