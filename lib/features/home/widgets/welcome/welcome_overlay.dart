import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import 'package:sylonow_user/features/profile/providers/profile_providers.dart';
import 'package:sylonow_user/features/profile/repositories/profile_repository.dart';
import 'package:sylonow_user/core/providers/welcome_providers.dart';

/// Welcome overlay widget that displays a semi-circular welcome message
/// with pulse animation for first-time users
class WelcomeOverlay extends ConsumerStatefulWidget {
  const WelcomeOverlay({super.key, required this.onSkip, required this.onNext});

  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  ConsumerState<WelcomeOverlay> createState() => _WelcomeOverlayState();
}

class _WelcomeOverlayState extends ConsumerState<WelcomeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  int _currentStep = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isUpdating = false;

  final List<WelcomeStep> _steps = [
    WelcomeStep(
      title: "Hi, Bhakti Gharat 👋",
      message:
          "Welcome to Sylonow! Let's transform your space into a masterpiece.",
      showButtons: false,
    ),
    WelcomeStep(
      title: "🎉 when you want to celebrate? 🎉",
      message: "select special day and time",
      showButtons: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final userProfile = ref.watch(currentUserProfileProvider);
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;

    return userProfile.when(
      data: (profile) {
        final userName =
            profile?.fullName ?? user?.email?.split('@').first ?? "User";

        return AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Positioned.fill(
              child: Stack(
                children: [
                  // Semi-transparent background covering full screen
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.3 * _fadeAnimation.value),
                  ),

                  // Semi-circular overlay positioned based on current step
                  if (_currentStep == 0)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildTopSemiCircularWelcome(userName, profile),
                      ),
                    )
                  else
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildBottomSemiCircularSelection(bottomPadding),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildTopSemiCircularWelcome(String userName, dynamic profile) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final statusBarHeight = mediaQuery.padding.top;

    return ClipPath(
      clipper: TopSemiCircularClipper(),
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.65 + statusBarHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1683C9), // Primary pink
              Color(0xFF0C4366),
           
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: statusBarHeight + 80,
            left: 32,
            right: 32,
            bottom: 60,
          ),
          child: Column(
            children: [
              // Profile avatar
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: profile?.profileImageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              profile!.profileImageUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white.withOpacity(0.7),
                          ),
                  ),
                  const SizedBox(width: 16),

                  // Welcome message
                  Row(
                    children: [
                      Text(
                        "Hi, $userName ",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Okra',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      //Lottie Aniamtion
                      Lottie.asset(
                        'assets/animations/wave.json',
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const Text(
                "\"Welcome to Sylonow! Let's transform your space into a masterpiece.\"",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Okra',
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF0080),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Okra',
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

  Widget _buildBottomSemiCircularSelection(double bottomPadding) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return ClipPath(
      clipper: BottomSemiCircularClipper(
        
      ),
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.7 + bottomPadding,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1683C9), // Primary pink
              Color(0xFF0C4366),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.2,
            left: 24,
            right: 24,
            bottom: bottomPadding + 80,
          ),
          child: Column(
            children: [
              const Text(
                "🎉 when you want to celebrate? 🎉",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Okra',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              const Text(
                "select special day and time",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Okra',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Date selector
              TextField(
                readOnly: true,
                onTap: () => _selectDate(context),

                decoration: InputDecoration(
                  hintText: _selectedDate != null
                      ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                      : "Select Date",
                  suffixIcon: Icon(Icons.keyboard_arrow_up),

                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Okra',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Time selector
              TextField(
                readOnly: true,
                onTap: () => _selectTime(context),

                decoration: InputDecoration(
                  hintText: _selectedTime != null
                      ? _selectedTime!.format(context)
                      : "Select Time",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Okra',
                  ),
                ),
              ),
              const Spacer(),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: widget.onSkip,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Okra',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isUpdating
                          ? null
                          : () => _saveCelebrationPreferences(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF0080),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isUpdating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF0080),
                                ),
                              ),
                            )
                          : const Text(
                              'Save & Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Okra',
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF0080),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF0080),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF0080),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF0080),
              ),
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
  }

  Future<void> _saveCelebrationPreferences() async {
    if (_selectedDate == null && _selectedTime == null) {
      // Skip if no preferences selected
      widget.onSkip();
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      // Save to welcome preferences service (local storage)
      final welcomeService = ref.read(welcomePreferencesServiceProvider);
      await welcomeService.saveCelebrationPreferences(
        celebrationDate: _selectedDate,
        celebrationTime: _selectedTime,
      );

      // Also try to save to profile repository (remote storage)
      final user = ref.read(currentUserProvider);
      if (user != null) {
        try {
          final profileRepo = ref.read(profileRepositoryProvider);
          await profileRepo.updateCelebrationPreferences(
            userId: user.id,
            celebrationDate: _selectedDate,
            celebrationTime: _selectedTime,
          );

          // Refresh the current user profile
          ref.invalidate(currentUserProfileProvider);
        } catch (e) {
          debugPrint('Warning: Failed to save to profile repository: $e');
          // Continue anyway since we saved locally
        }
      }

      // Invalidate welcome providers to refresh cached data
      ref.invalidate(celebrationDateProvider);
      ref.invalidate(celebrationTimeProvider);
      ref.invalidate(formattedCelebrationDateProvider);
      ref.invalidate(formattedCelebrationTimeProvider);

      widget.onNext();
    } catch (e) {
      debugPrint('Error saving celebration preferences: $e');
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }
}

/// Data model for welcome overlay steps
class WelcomeStep {
  final String title;
  final String message;
  final bool showButtons;

  WelcomeStep({
    required this.title,
    required this.message,
    required this.showButtons,
  });
}

/// Custom clipper for top semi-circular shape
class TopSemiCircularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top left
    path.moveTo(0, 0);

    // Go to top right
    path.lineTo(size.width, 0);

    // Go down on the right side
    path.lineTo(size.width, size.height * 0.7);

    // Create a curved bottom using quadratic bezier curve
    path.quadraticBezierTo(
      size.width * 0.5, // Control point X (center)
      size.height, // Control point Y (bottom)
      0, // End point X (left)
      size.height * 0.7, // End point Y
    );

    // Close the path back to start
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Custom clipper for bottom semi-circular shape
class BottomSemiCircularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from bottom left
    path.moveTo(0, size.height);

    // Go to bottom right
    path.lineTo(size.width, size.height);

    // Go up on the right side
    path.lineTo(size.width, size.height * 0.2);

    // Create a curved top using quadratic bezier curve
    path.quadraticBezierTo(
      size.width * 0.5, // Control point X (center)
      0, // Control point Y (top)
      0, // End point X (left)
      size.height * 0.3, // End point Y
    );

    // Close the path back to start
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
