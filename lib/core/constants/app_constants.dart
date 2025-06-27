class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://txgszrxjyanazlrupaty.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR4Z3N6cnhqeWFuYXpscnVwYXR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAyNzU4MjcsImV4cCI6MjA2NTg1MTgyN30.7MDiDGMCEa-E8c3HgIGxSpkOsH9kClD5i5LNSjzFul4';
  
  // App Information
  static const String appName = 'Sylonow';
  static const String appVersion = '1.0.0';
  
  // Shared Preferences Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userPhoneKey = 'user_phone';
  static const String isLoggedInKey = 'is_logged_in';
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String otpVerificationRoute = '/otp-verification';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
} 