// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingServiceHash() => r'c99e33b0a42a45db23a5a05ee920207a3225c7b4';

/// See also [onboardingService].
@ProviderFor(onboardingService)
final onboardingServiceProvider =
    AutoDisposeProvider<OnboardingService>.internal(
  onboardingService,
  name: r'onboardingServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OnboardingServiceRef = AutoDisposeProviderRef<OnboardingService>;
String _$isOnboardingCompletedHash() =>
    r'd8e127e9bf24d420ba1f24569508e6cc48868aed';

/// See also [isOnboardingCompleted].
@ProviderFor(isOnboardingCompleted)
final isOnboardingCompletedProvider = AutoDisposeFutureProvider<bool>.internal(
  isOnboardingCompleted,
  name: r'isOnboardingCompletedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isOnboardingCompletedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsOnboardingCompletedRef = AutoDisposeFutureProviderRef<bool>;
String _$onboardingDataHash() => r'f745e5c107e9c2c62b8d7ff3e694772a289e74ba';

/// See also [onboardingData].
@ProviderFor(onboardingData)
final onboardingDataProvider =
    AutoDisposeFutureProvider<OnboardingDataModel>.internal(
  onboardingData,
  name: r'onboardingDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OnboardingDataRef = AutoDisposeFutureProviderRef<OnboardingDataModel>;
String _$onboardingControllerHash() =>
    r'1c047b7732ad542b0e2c02ba0b577e61e3476646';

/// See also [OnboardingController].
@ProviderFor(OnboardingController)
final onboardingControllerProvider = AutoDisposeNotifierProvider<
    OnboardingController, OnboardingDataModel>.internal(
  OnboardingController.new,
  name: r'onboardingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OnboardingController = AutoDisposeNotifier<OnboardingDataModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
