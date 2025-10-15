# QWEN.md

This file provides guidance to QWEN Code (QWEN.ai/code) when working with code in this repository.

## Project Overview

**Sylonow User** is a Flutter mobile application that serves as a service marketplace platform connecting users with verified service providers. Users can discover, browse, and book various services ranging from home services to entertainment options like private theaters.

## Core Architecture

### State Management Pattern
- **Primary**: Riverpod with `flutter_riverpod` v2.5.1
- **Code Generation**: Uses `riverpod_annotation` and `riverpod_generator` for automatic provider generation
- **Structure**: Feature-based providers with dependency injection pattern
- **Example**: `final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.watch(supabaseClientProvider)))`

### Data Layer Architecture
- **Backend**: Supabase (BaaS) with `supabase_flutter` v2.9.1
- **Models**: Freezed immutable classes with JSON serialization
- **Repositories**: Data access layer abstracting Supabase operations
- **Pattern**: Repository → Service → Controller → Provider → UI

### Navigation
- **Router**: Go Router v14.2.0 with declarative routing
- **Configuration**: Centralized in `/lib/core/router/app_router.dart`
- **Route Protection**: Authentication state-based redirects handled in splash screen

## Essential Development Commands

### Code Generation (Required for Freezed models and Riverpod providers)
```bash
# Generate all code (run after model/provider changes)
flutter packages pub run build_runner build

# Watch mode for continuous generation during development
flutter packages pub run build_runner watch

# Clean and regenerate (use when generation conflicts occur)
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Build Commands
```bash
# Development run
flutter run

# Debug build with device selection
flutter run -d <device-id>

# Release builds
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android App Bundle
flutter build ios --release          # iOS
flutter build web                    # Web
```

### Icon Generation
```bash
# Generate launcher icons (after updating assets/images/app_icon.png)
flutter pub run flutter_launcher_icons
```

### Quality Assurance
```bash
# Lint analysis (includes custom Riverpod linting)
flutter analyze

# Run tests (when test files exist)
flutter test
```

## Feature Module Structure

Each feature follows a consistent architecture pattern:

```
feature_name/
├── controllers/     # Business logic with StateNotifier
├── models/         # Freezed data models with JSON serialization
├── providers/      # Riverpod providers for dependency injection
├── repositories/   # Data access layer (Supabase operations)
├── screens/        # UI screens and pages
├── services/       # Feature-specific business services
└── widgets/        # Feature-specific reusable components
```

### Model Pattern (Freezed + JSON)
All data models use Freezed for immutability and code generation:
```dart
@freezed
class ServiceListingModel with _$ServiceListingModel {
  const factory ServiceListingModel({
    required String id,
    @JsonKey(name: 'title') required String name,
    // ... other fields
  }) = _ServiceListingModel;
  
  factory ServiceListingModel.fromJson(Map<String, dynamic> json) => 
      _$ServiceListingModelFromJson(json);
}
```

## Core Dependencies

### State Management & Architecture
- `flutter_riverpod`: Provider-based state management
- `riverpod_annotation` + `riverpod_generator`: Code generation for providers
- `freezed` + `json_serializable`: Immutable models with JSON support

### Backend & Services
- `supabase_flutter`: Database, authentication, real-time features
- `google_sign_in`: OAuth integration
- `geolocator` + `geocoding`: Location services

### UI & Navigation
- `go_router`: Declarative routing
- `flutter_svg`: Vector graphics
- `cached_network_image`: Optimized image loading
- `lottie`: Animations

## Important Implementation Details

### Authentication Flow
1. **Splash Screen**: Initial auth state check and routing decision
2. **Supabase Auth**: Email/phone + Google OAuth integration
3. **Route Protection**: Handled via Go Router redirect logic
4. **State Management**: `isAuthenticatedProvider` for auth state tracking

### Theming System
- **Design System**: Material Design 3 with custom pink theme (#FF0080)
- **Typography**: Custom Okra font family (Regular, Medium, Bold, ExtraBold)
- **Location**: `/lib/core/theme/app_theme.dart`

### Supabase Integration
- **Client Initialization**: In `main.dart` with environment constants
- **Database Schema**: Tables for vendors, service_types, service_listings, quotes
- **MCP Integration**: Cursor has Supabase MCP server configured in `.cursor/mcp.json`

## Development Workflow

### Adding New Features
1. Create feature directory following the established structure
2. Define models with Freezed annotations
3. Implement repository for data access
4. Create service layer for business logic
5. Set up providers for dependency injection
6. Build UI screens and widgets
7. Add routes to `/lib/core/router/app_router.dart`
8. Run code generation: `flutter packages pub run build_runner build`

### Working with State
- Use `StateNotifierProvider` for complex state with actions
- Use `FutureProvider` for async data fetching
- Use `Provider` for simple dependency injection
- Follow Riverpod best practices with proper disposal

### Common Patterns
- **Async Operations**: Wrap in `AsyncValue<T>` for loading/error states
- **Navigation**: Use `context.go()` for navigation, `context.push()` for stacks
- **Error Handling**: Consistent error handling through service layer
- **Form Validation**: Custom validators in `/lib/core/utils/validators.dart`

## Current Development Status

### Implemented Features
- Authentication (login, register, OTP verification)
- Home screen with service discovery
- Service detail screens
- Address management
- Basic profile functionality

### Placeholder Implementations (in app_router.dart)
- Edit Profile Screen
- Booking History Screen  
- Payment Methods Screen
- Notifications Screen
- Help & Support Screen
- Settings Screen

These placeholder screens are defined inline in the router file and should be moved to proper feature modules when implementing.

## Security Considerations

- Supabase API keys are currently in source code (should be moved to environment variables)
- Row Level Security (RLS) policies should be implemented in Supabase
- Runtime permissions properly handled for location and camera access
