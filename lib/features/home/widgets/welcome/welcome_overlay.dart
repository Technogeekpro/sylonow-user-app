import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import 'package:sylonow_user/features/profile/providers/profile_providers.dart';

/// Welcome overlay widget that displays a semi-circular welcome message
/// with pulse animation for first-time users
class WelcomeOverlay extends ConsumerStatefulWidget {
  const WelcomeOverlay({
    super.key,
    required this.onSkip,
    required this.onNext,
  });

  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  ConsumerState<WelcomeOverlay> createState() => _WelcomeOverlayState();
}

class _WelcomeOverlayState extends ConsumerState<WelcomeOverlay>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  int _currentStep = 0;

  final List<WelcomeStep> _steps = [
    WelcomeStep(
      title: "Hi, Bhakti Gharat 👋",
      message: "Welcome to Sylonow! Let's transform your space into a masterpiece.",
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
    
    // Pulse animation controller
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _fadeAnimationController.forward();
    _pulseAnimationController.repeat(reverse: true);
    
    // Auto advance to next step
    if (_currentStep == 0) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _currentStep = 1;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final userProfile = ref.watch(currentUserProfileProvider);
    
    return userProfile.when(
      data: (profile) {
        final userName = profile?.fullName ?? user?.email?.split('@').first ?? "User";
        
        return AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                // Semi-transparent background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.3 * _fadeAnimation.value),
                ),
                
                // Semi-circular overlay positioned at top
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _currentStep == 0 
                              ? _buildSemiCircularWelcome(userName, profile)
                              : _buildSemiCircularSelection(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSemiCircularWelcome(String userName, dynamic profile) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final statusBarHeight = mediaQuery.padding.top;
    
    return ClipPath(
      clipper: SemiCircularClipper(),
      child: Container(
        width: screenWidth,
        height: screenWidth * 0.9 + statusBarHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF0080), // Primary pink
              Color(0xFFFF4081),
              Color(0xFFE91E63),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: statusBarHeight + 60,
            left: 24,
            right: 24,
            bottom: 40,
          ),
          child: Column(
            children: [
              // Profile avatar
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
                          errorBuilder: (context, error, stackTrace) => Icon(
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
              const SizedBox(height: 16),
              
              // Welcome message
              Text(
                "Hi, $userName 👋",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Okra',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              const Text(
                "\"Welcome to Sylonow! Let's transform your space into a masterpiece.\"",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Okra',
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSemiCircularSelection() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final statusBarHeight = mediaQuery.padding.top;
    
    return ClipPath(
      clipper: SemiCircularClipper(),
      child: Container(
        width: screenWidth,
        height: screenWidth * 0.9 + statusBarHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF0080), // Primary pink
              Color(0xFFFF4081),
              Color(0xFFE91E63),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: statusBarHeight + 60,
            left: 24,
            right: 24,
            bottom: 40,
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Date",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                        fontFamily: 'Okra',
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Time selector
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Time",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                        fontFamily: 'Okra',
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              
              // Skip button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onSkip,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Skip",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Okra',
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
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

/// Custom clipper for semi-circular shape
class SemiCircularClipper extends CustomClipper<Path> {
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
      size.height,      // Control point Y (bottom)
      0,               // End point X (left)
      size.height * 0.7, // End point Y
    );
    
    // Close the path back to start
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}