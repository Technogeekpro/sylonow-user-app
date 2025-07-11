import 'package:flutter/material.dart';

/// Design Tokens for Sylonow User App
/// Contains standardized spacing, colors, typography, and component specifications
class DesignTokens {
  // ═══════════════════════════════════════════════════════════════════════════
  // Colors
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Primary Brand Colors
  static const Color primary = Color(0xFFFF0080);
  static const Color primaryLight = Color(0xFFFF4DA6);
  static const Color primaryDark = Color(0xFFCC0066);
  
  // Neutral Colors
  static const Color neutral900 = Color(0xFF1A1A1A);
  static const Color neutral800 = Color(0xFF2A2A2A);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral600 = Color(0xFF6B6B6B);
  static const Color neutral500 = Color(0xFF8E8E8E);
  static const Color neutral400 = Color(0xFFB8B8B8);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral200 = Color(0xFFE8E8E8);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Surface Colors
  static const Color surfacePrimary = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFFAFAFA);
  static const Color surfaceTertiary = Color(0xFFF5F5F5);
  
  // Border Colors
  static const Color borderPrimary = Color(0xFFE5E7EB);
  static const Color borderSecondary = Color(0xFFD1D5DB);
  static const Color borderFocus = primary;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Typography
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const String fontFamily = 'Okra';
  
  // Display Typography
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -0.5,
    color: neutral900,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.25,
    color: neutral900,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: neutral900,
  );
  
  // Heading Typography
  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: neutral900,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: neutral900,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: neutral900,
  );
  
  // Body Typography
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: neutral700,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: neutral700,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: neutral600,
  );
  
  // Label Typography
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    color: neutral900,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: neutral900,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: neutral600,
  );
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Spacing
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;
  static const double space80 = 80.0;
  static const double space96 = 96.0;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Border Radius
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const double radiusXS = 4.0;
  static const double radiusS = 6.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radius2XL = 20.0;
  static const double radius3XL = 24.0;
  static const double radiusFull = 999.0;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Shadows
  // ═══════════════════════════════════════════════════════════════════════════
  
  static List<BoxShadow> shadowXS = [
    BoxShadow(
      color: neutral900.withOpacity(0.05),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  
  static List<BoxShadow> shadowS = [
    BoxShadow(
      color: neutral900.withOpacity(0.1),
      offset: const Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: neutral900.withOpacity(0.06),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  
  static List<BoxShadow> shadowM = [
    BoxShadow(
      color: neutral900.withOpacity(0.1),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: neutral900.withOpacity(0.06),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];
  
  static List<BoxShadow> shadowL = [
    BoxShadow(
      color: neutral900.withOpacity(0.1),
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: neutral900.withOpacity(0.05),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];
  
  static List<BoxShadow> shadowXL = [
    BoxShadow(
      color: neutral900.withOpacity(0.1),
      offset: const Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: neutral900.withOpacity(0.04),
      offset: const Offset(0, 10),
      blurRadius: 10,
      spreadRadius: -5,
    ),
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Component Specifications
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Button Heights
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 52.0;
  
  // Input Heights
  static const double inputHeightSmall = 36.0;
  static const double inputHeightMedium = 44.0;
  static const double inputHeightLarge = 52.0;
  
  // Icon Sizes
  static const double iconXS = 12.0;
  static const double iconS = 16.0;
  static const double iconM = 20.0;
  static const double iconL = 24.0;
  static const double iconXL = 32.0;
  static const double icon2XL = 40.0;
  
  // Avatar Sizes
  static const double avatarXS = 24.0;
  static const double avatarS = 32.0;
  static const double avatarM = 40.0;
  static const double avatarL = 48.0;
  static const double avatarXL = 64.0;
  static const double avatar2XL = 80.0;
  
  // Container Max Widths
  static const double containerXS = 320.0;
  static const double containerS = 384.0;
  static const double containerM = 448.0;
  static const double containerL = 512.0;
  static const double containerXL = 576.0;
  static const double container2XL = 672.0;
  
  // Z-Index
  static const int zIndexDropdown = 1000;
  static const int zIndexSticky = 1020;
  static const int zIndexFixed = 1030;
  static const int zIndexModal = 1040;
  static const int zIndexPopover = 1050;
  static const int zIndexTooltip = 1060;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Animation Durations
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // Curves
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveEnter = Curves.easeOut;
  static const Curve curveExit = Curves.easeIn;
}