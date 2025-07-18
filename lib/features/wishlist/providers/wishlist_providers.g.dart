// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userWishlistHash() => r'7a13d98059a2055bec8d9ea25987956df29e9910';

/// See also [userWishlist].
@ProviderFor(userWishlist)
final userWishlistProvider =
    AutoDisposeFutureProvider<List<WishlistWithService>>.internal(
  userWishlist,
  name: r'userWishlistProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userWishlistHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserWishlistRef
    = AutoDisposeFutureProviderRef<List<WishlistWithService>>;
String _$isServiceInWishlistHash() =>
    r'e504c628c90ac0fed097ae9dd2d30f306cf6f792';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [isServiceInWishlist].
@ProviderFor(isServiceInWishlist)
const isServiceInWishlistProvider = IsServiceInWishlistFamily();

/// See also [isServiceInWishlist].
class IsServiceInWishlistFamily extends Family<AsyncValue<bool>> {
  /// See also [isServiceInWishlist].
  const IsServiceInWishlistFamily();

  /// See also [isServiceInWishlist].
  IsServiceInWishlistProvider call(
    String serviceId,
  ) {
    return IsServiceInWishlistProvider(
      serviceId,
    );
  }

  @override
  IsServiceInWishlistProvider getProviderOverride(
    covariant IsServiceInWishlistProvider provider,
  ) {
    return call(
      provider.serviceId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isServiceInWishlistProvider';
}

/// See also [isServiceInWishlist].
class IsServiceInWishlistProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [isServiceInWishlist].
  IsServiceInWishlistProvider(
    String serviceId,
  ) : this._internal(
          (ref) => isServiceInWishlist(
            ref as IsServiceInWishlistRef,
            serviceId,
          ),
          from: isServiceInWishlistProvider,
          name: r'isServiceInWishlistProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isServiceInWishlistHash,
          dependencies: IsServiceInWishlistFamily._dependencies,
          allTransitiveDependencies:
              IsServiceInWishlistFamily._allTransitiveDependencies,
          serviceId: serviceId,
        );

  IsServiceInWishlistProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceId,
  }) : super.internal();

  final String serviceId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsServiceInWishlistRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsServiceInWishlistProvider._internal(
        (ref) => create(ref as IsServiceInWishlistRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceId: serviceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsServiceInWishlistProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsServiceInWishlistProvider && other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsServiceInWishlistRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `serviceId` of this provider.
  String get serviceId;
}

class _IsServiceInWishlistProviderElement
    extends AutoDisposeFutureProviderElement<bool> with IsServiceInWishlistRef {
  _IsServiceInWishlistProviderElement(super.provider);

  @override
  String get serviceId => (origin as IsServiceInWishlistProvider).serviceId;
}

String _$wishlistCountHash() => r'6c6fbc8ac0a3e155dd51fed6eddb522f582e52e8';

/// See also [wishlistCount].
@ProviderFor(wishlistCount)
final wishlistCountProvider = AutoDisposeFutureProvider<int>.internal(
  wishlistCount,
  name: r'wishlistCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wishlistCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WishlistCountRef = AutoDisposeFutureProviderRef<int>;
String _$wishlistNotifierHash() => r'1d7c02d96959aa26ac1d89b87bea87757e4f8280';

/// See also [WishlistNotifier].
@ProviderFor(WishlistNotifier)
final wishlistNotifierProvider = AutoDisposeAsyncNotifierProvider<
    WishlistNotifier, List<WishlistWithService>>.internal(
  WishlistNotifier.new,
  name: r'wishlistNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wishlistNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WishlistNotifier
    = AutoDisposeAsyncNotifier<List<WishlistWithService>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
