// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceFilter _$ServiceFilterFromJson(Map<String, dynamic> json) {
  return _ServiceFilter.fromJson(json);
}

/// @nodoc
mixin _$ServiceFilter {
// Category filters
  List<String> get categories =>
      throw _privateConstructorUsedError; // Price range filters
  double get minPrice => throw _privateConstructorUsedError;
  double get maxPrice => throw _privateConstructorUsedError; // Rating filter
  double get minRating => throw _privateConstructorUsedError; // Sorting options
  SortOption get sortBy =>
      throw _privateConstructorUsedError; // Location filter
  double get maxDistanceKm =>
      throw _privateConstructorUsedError; // Feature filters
  bool get onlyFeatured => throw _privateConstructorUsedError;
  bool get hasOffers => throw _privateConstructorUsedError;
  bool get customizationAvailable =>
      throw _privateConstructorUsedError; // Venue type filters
  List<String> get venueTypes =>
      throw _privateConstructorUsedError; // Theme filters
  List<String> get themeTags =>
      throw _privateConstructorUsedError; // Environment filter (inside/outside/both)
  List<String> get serviceEnvironments =>
      throw _privateConstructorUsedError; // Availability filter
  bool get availableToday => throw _privateConstructorUsedError;
  bool get availableThisWeek => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceFilterCopyWith<ServiceFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceFilterCopyWith<$Res> {
  factory $ServiceFilterCopyWith(
          ServiceFilter value, $Res Function(ServiceFilter) then) =
      _$ServiceFilterCopyWithImpl<$Res, ServiceFilter>;
  @useResult
  $Res call(
      {List<String> categories,
      double minPrice,
      double maxPrice,
      double minRating,
      SortOption sortBy,
      double maxDistanceKm,
      bool onlyFeatured,
      bool hasOffers,
      bool customizationAvailable,
      List<String> venueTypes,
      List<String> themeTags,
      List<String> serviceEnvironments,
      bool availableToday,
      bool availableThisWeek});
}

/// @nodoc
class _$ServiceFilterCopyWithImpl<$Res, $Val extends ServiceFilter>
    implements $ServiceFilterCopyWith<$Res> {
  _$ServiceFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? minPrice = null,
    Object? maxPrice = null,
    Object? minRating = null,
    Object? sortBy = null,
    Object? maxDistanceKm = null,
    Object? onlyFeatured = null,
    Object? hasOffers = null,
    Object? customizationAvailable = null,
    Object? venueTypes = null,
    Object? themeTags = null,
    Object? serviceEnvironments = null,
    Object? availableToday = null,
    Object? availableThisWeek = null,
  }) {
    return _then(_value.copyWith(
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      minPrice: null == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double,
      maxPrice: null == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double,
      minRating: null == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as SortOption,
      maxDistanceKm: null == maxDistanceKm
          ? _value.maxDistanceKm
          : maxDistanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      onlyFeatured: null == onlyFeatured
          ? _value.onlyFeatured
          : onlyFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      hasOffers: null == hasOffers
          ? _value.hasOffers
          : hasOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      customizationAvailable: null == customizationAvailable
          ? _value.customizationAvailable
          : customizationAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      venueTypes: null == venueTypes
          ? _value.venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      themeTags: null == themeTags
          ? _value.themeTags
          : themeTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      serviceEnvironments: null == serviceEnvironments
          ? _value.serviceEnvironments
          : serviceEnvironments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableToday: null == availableToday
          ? _value.availableToday
          : availableToday // ignore: cast_nullable_to_non_nullable
              as bool,
      availableThisWeek: null == availableThisWeek
          ? _value.availableThisWeek
          : availableThisWeek // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceFilterImplCopyWith<$Res>
    implements $ServiceFilterCopyWith<$Res> {
  factory _$$ServiceFilterImplCopyWith(
          _$ServiceFilterImpl value, $Res Function(_$ServiceFilterImpl) then) =
      __$$ServiceFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> categories,
      double minPrice,
      double maxPrice,
      double minRating,
      SortOption sortBy,
      double maxDistanceKm,
      bool onlyFeatured,
      bool hasOffers,
      bool customizationAvailable,
      List<String> venueTypes,
      List<String> themeTags,
      List<String> serviceEnvironments,
      bool availableToday,
      bool availableThisWeek});
}

/// @nodoc
class __$$ServiceFilterImplCopyWithImpl<$Res>
    extends _$ServiceFilterCopyWithImpl<$Res, _$ServiceFilterImpl>
    implements _$$ServiceFilterImplCopyWith<$Res> {
  __$$ServiceFilterImplCopyWithImpl(
      _$ServiceFilterImpl _value, $Res Function(_$ServiceFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? minPrice = null,
    Object? maxPrice = null,
    Object? minRating = null,
    Object? sortBy = null,
    Object? maxDistanceKm = null,
    Object? onlyFeatured = null,
    Object? hasOffers = null,
    Object? customizationAvailable = null,
    Object? venueTypes = null,
    Object? themeTags = null,
    Object? serviceEnvironments = null,
    Object? availableToday = null,
    Object? availableThisWeek = null,
  }) {
    return _then(_$ServiceFilterImpl(
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      minPrice: null == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double,
      maxPrice: null == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double,
      minRating: null == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as SortOption,
      maxDistanceKm: null == maxDistanceKm
          ? _value.maxDistanceKm
          : maxDistanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      onlyFeatured: null == onlyFeatured
          ? _value.onlyFeatured
          : onlyFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      hasOffers: null == hasOffers
          ? _value.hasOffers
          : hasOffers // ignore: cast_nullable_to_non_nullable
              as bool,
      customizationAvailable: null == customizationAvailable
          ? _value.customizationAvailable
          : customizationAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      venueTypes: null == venueTypes
          ? _value._venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      themeTags: null == themeTags
          ? _value._themeTags
          : themeTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      serviceEnvironments: null == serviceEnvironments
          ? _value._serviceEnvironments
          : serviceEnvironments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableToday: null == availableToday
          ? _value.availableToday
          : availableToday // ignore: cast_nullable_to_non_nullable
              as bool,
      availableThisWeek: null == availableThisWeek
          ? _value.availableThisWeek
          : availableThisWeek // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceFilterImpl implements _ServiceFilter {
  const _$ServiceFilterImpl(
      {final List<String> categories = const [],
      this.minPrice = 0,
      this.maxPrice = 10000,
      this.minRating = 0,
      this.sortBy = SortOption.relevance,
      this.maxDistanceKm = 10,
      this.onlyFeatured = false,
      this.hasOffers = false,
      this.customizationAvailable = false,
      final List<String> venueTypes = const [],
      final List<String> themeTags = const [],
      final List<String> serviceEnvironments = const [],
      this.availableToday = false,
      this.availableThisWeek = false})
      : _categories = categories,
        _venueTypes = venueTypes,
        _themeTags = themeTags,
        _serviceEnvironments = serviceEnvironments;

  factory _$ServiceFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceFilterImplFromJson(json);

// Category filters
  final List<String> _categories;
// Category filters
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

// Price range filters
  @override
  @JsonKey()
  final double minPrice;
  @override
  @JsonKey()
  final double maxPrice;
// Rating filter
  @override
  @JsonKey()
  final double minRating;
// Sorting options
  @override
  @JsonKey()
  final SortOption sortBy;
// Location filter
  @override
  @JsonKey()
  final double maxDistanceKm;
// Feature filters
  @override
  @JsonKey()
  final bool onlyFeatured;
  @override
  @JsonKey()
  final bool hasOffers;
  @override
  @JsonKey()
  final bool customizationAvailable;
// Venue type filters
  final List<String> _venueTypes;
// Venue type filters
  @override
  @JsonKey()
  List<String> get venueTypes {
    if (_venueTypes is EqualUnmodifiableListView) return _venueTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_venueTypes);
  }

// Theme filters
  final List<String> _themeTags;
// Theme filters
  @override
  @JsonKey()
  List<String> get themeTags {
    if (_themeTags is EqualUnmodifiableListView) return _themeTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_themeTags);
  }

// Environment filter (inside/outside/both)
  final List<String> _serviceEnvironments;
// Environment filter (inside/outside/both)
  @override
  @JsonKey()
  List<String> get serviceEnvironments {
    if (_serviceEnvironments is EqualUnmodifiableListView)
      return _serviceEnvironments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceEnvironments);
  }

// Availability filter
  @override
  @JsonKey()
  final bool availableToday;
  @override
  @JsonKey()
  final bool availableThisWeek;

  @override
  String toString() {
    return 'ServiceFilter(categories: $categories, minPrice: $minPrice, maxPrice: $maxPrice, minRating: $minRating, sortBy: $sortBy, maxDistanceKm: $maxDistanceKm, onlyFeatured: $onlyFeatured, hasOffers: $hasOffers, customizationAvailable: $customizationAvailable, venueTypes: $venueTypes, themeTags: $themeTags, serviceEnvironments: $serviceEnvironments, availableToday: $availableToday, availableThisWeek: $availableThisWeek)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceFilterImpl &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.maxDistanceKm, maxDistanceKm) ||
                other.maxDistanceKm == maxDistanceKm) &&
            (identical(other.onlyFeatured, onlyFeatured) ||
                other.onlyFeatured == onlyFeatured) &&
            (identical(other.hasOffers, hasOffers) ||
                other.hasOffers == hasOffers) &&
            (identical(other.customizationAvailable, customizationAvailable) ||
                other.customizationAvailable == customizationAvailable) &&
            const DeepCollectionEquality()
                .equals(other._venueTypes, _venueTypes) &&
            const DeepCollectionEquality()
                .equals(other._themeTags, _themeTags) &&
            const DeepCollectionEquality()
                .equals(other._serviceEnvironments, _serviceEnvironments) &&
            (identical(other.availableToday, availableToday) ||
                other.availableToday == availableToday) &&
            (identical(other.availableThisWeek, availableThisWeek) ||
                other.availableThisWeek == availableThisWeek));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      minPrice,
      maxPrice,
      minRating,
      sortBy,
      maxDistanceKm,
      onlyFeatured,
      hasOffers,
      customizationAvailable,
      const DeepCollectionEquality().hash(_venueTypes),
      const DeepCollectionEquality().hash(_themeTags),
      const DeepCollectionEquality().hash(_serviceEnvironments),
      availableToday,
      availableThisWeek);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceFilterImplCopyWith<_$ServiceFilterImpl> get copyWith =>
      __$$ServiceFilterImplCopyWithImpl<_$ServiceFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceFilterImplToJson(
      this,
    );
  }
}

abstract class _ServiceFilter implements ServiceFilter {
  const factory _ServiceFilter(
      {final List<String> categories,
      final double minPrice,
      final double maxPrice,
      final double minRating,
      final SortOption sortBy,
      final double maxDistanceKm,
      final bool onlyFeatured,
      final bool hasOffers,
      final bool customizationAvailable,
      final List<String> venueTypes,
      final List<String> themeTags,
      final List<String> serviceEnvironments,
      final bool availableToday,
      final bool availableThisWeek}) = _$ServiceFilterImpl;

  factory _ServiceFilter.fromJson(Map<String, dynamic> json) =
      _$ServiceFilterImpl.fromJson;

  @override // Category filters
  List<String> get categories;
  @override // Price range filters
  double get minPrice;
  @override
  double get maxPrice;
  @override // Rating filter
  double get minRating;
  @override // Sorting options
  SortOption get sortBy;
  @override // Location filter
  double get maxDistanceKm;
  @override // Feature filters
  bool get onlyFeatured;
  @override
  bool get hasOffers;
  @override
  bool get customizationAvailable;
  @override // Venue type filters
  List<String> get venueTypes;
  @override // Theme filters
  List<String> get themeTags;
  @override // Environment filter (inside/outside/both)
  List<String> get serviceEnvironments;
  @override // Availability filter
  bool get availableToday;
  @override
  bool get availableThisWeek;
  @override
  @JsonKey(ignore: true)
  _$$ServiceFilterImplCopyWith<_$ServiceFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FilterCategories _$FilterCategoriesFromJson(Map<String, dynamic> json) {
  return _FilterCategories.fromJson(json);
}

/// @nodoc
mixin _$FilterCategories {
  List<String> get decorationCategories => throw _privateConstructorUsedError;
  List<String> get venueTypes => throw _privateConstructorUsedError;
  List<String> get themeTags => throw _privateConstructorUsedError;
  List<String> get serviceEnvironments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilterCategoriesCopyWith<FilterCategories> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterCategoriesCopyWith<$Res> {
  factory $FilterCategoriesCopyWith(
          FilterCategories value, $Res Function(FilterCategories) then) =
      _$FilterCategoriesCopyWithImpl<$Res, FilterCategories>;
  @useResult
  $Res call(
      {List<String> decorationCategories,
      List<String> venueTypes,
      List<String> themeTags,
      List<String> serviceEnvironments});
}

/// @nodoc
class _$FilterCategoriesCopyWithImpl<$Res, $Val extends FilterCategories>
    implements $FilterCategoriesCopyWith<$Res> {
  _$FilterCategoriesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? decorationCategories = null,
    Object? venueTypes = null,
    Object? themeTags = null,
    Object? serviceEnvironments = null,
  }) {
    return _then(_value.copyWith(
      decorationCategories: null == decorationCategories
          ? _value.decorationCategories
          : decorationCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueTypes: null == venueTypes
          ? _value.venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      themeTags: null == themeTags
          ? _value.themeTags
          : themeTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      serviceEnvironments: null == serviceEnvironments
          ? _value.serviceEnvironments
          : serviceEnvironments // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterCategoriesImplCopyWith<$Res>
    implements $FilterCategoriesCopyWith<$Res> {
  factory _$$FilterCategoriesImplCopyWith(_$FilterCategoriesImpl value,
          $Res Function(_$FilterCategoriesImpl) then) =
      __$$FilterCategoriesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> decorationCategories,
      List<String> venueTypes,
      List<String> themeTags,
      List<String> serviceEnvironments});
}

/// @nodoc
class __$$FilterCategoriesImplCopyWithImpl<$Res>
    extends _$FilterCategoriesCopyWithImpl<$Res, _$FilterCategoriesImpl>
    implements _$$FilterCategoriesImplCopyWith<$Res> {
  __$$FilterCategoriesImplCopyWithImpl(_$FilterCategoriesImpl _value,
      $Res Function(_$FilterCategoriesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? decorationCategories = null,
    Object? venueTypes = null,
    Object? themeTags = null,
    Object? serviceEnvironments = null,
  }) {
    return _then(_$FilterCategoriesImpl(
      decorationCategories: null == decorationCategories
          ? _value._decorationCategories
          : decorationCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueTypes: null == venueTypes
          ? _value._venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      themeTags: null == themeTags
          ? _value._themeTags
          : themeTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      serviceEnvironments: null == serviceEnvironments
          ? _value._serviceEnvironments
          : serviceEnvironments // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterCategoriesImpl implements _FilterCategories {
  const _$FilterCategoriesImpl(
      {final List<String> decorationCategories = const [],
      final List<String> venueTypes = const [],
      final List<String> themeTags = const [],
      final List<String> serviceEnvironments = const []})
      : _decorationCategories = decorationCategories,
        _venueTypes = venueTypes,
        _themeTags = themeTags,
        _serviceEnvironments = serviceEnvironments;

  factory _$FilterCategoriesImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterCategoriesImplFromJson(json);

  final List<String> _decorationCategories;
  @override
  @JsonKey()
  List<String> get decorationCategories {
    if (_decorationCategories is EqualUnmodifiableListView)
      return _decorationCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_decorationCategories);
  }

  final List<String> _venueTypes;
  @override
  @JsonKey()
  List<String> get venueTypes {
    if (_venueTypes is EqualUnmodifiableListView) return _venueTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_venueTypes);
  }

  final List<String> _themeTags;
  @override
  @JsonKey()
  List<String> get themeTags {
    if (_themeTags is EqualUnmodifiableListView) return _themeTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_themeTags);
  }

  final List<String> _serviceEnvironments;
  @override
  @JsonKey()
  List<String> get serviceEnvironments {
    if (_serviceEnvironments is EqualUnmodifiableListView)
      return _serviceEnvironments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceEnvironments);
  }

  @override
  String toString() {
    return 'FilterCategories(decorationCategories: $decorationCategories, venueTypes: $venueTypes, themeTags: $themeTags, serviceEnvironments: $serviceEnvironments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterCategoriesImpl &&
            const DeepCollectionEquality()
                .equals(other._decorationCategories, _decorationCategories) &&
            const DeepCollectionEquality()
                .equals(other._venueTypes, _venueTypes) &&
            const DeepCollectionEquality()
                .equals(other._themeTags, _themeTags) &&
            const DeepCollectionEquality()
                .equals(other._serviceEnvironments, _serviceEnvironments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_decorationCategories),
      const DeepCollectionEquality().hash(_venueTypes),
      const DeepCollectionEquality().hash(_themeTags),
      const DeepCollectionEquality().hash(_serviceEnvironments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterCategoriesImplCopyWith<_$FilterCategoriesImpl> get copyWith =>
      __$$FilterCategoriesImplCopyWithImpl<_$FilterCategoriesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterCategoriesImplToJson(
      this,
    );
  }
}

abstract class _FilterCategories implements FilterCategories {
  const factory _FilterCategories(
      {final List<String> decorationCategories,
      final List<String> venueTypes,
      final List<String> themeTags,
      final List<String> serviceEnvironments}) = _$FilterCategoriesImpl;

  factory _FilterCategories.fromJson(Map<String, dynamic> json) =
      _$FilterCategoriesImpl.fromJson;

  @override
  List<String> get decorationCategories;
  @override
  List<String> get venueTypes;
  @override
  List<String> get themeTags;
  @override
  List<String> get serviceEnvironments;
  @override
  @JsonKey(ignore: true)
  _$$FilterCategoriesImplCopyWith<_$FilterCategoriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
