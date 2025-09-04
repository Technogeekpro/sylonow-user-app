import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_model.freezed.dart';
part 'filter_model.g.dart';

@freezed
class ServiceFilter with _$ServiceFilter {
  const factory ServiceFilter({
    // Category filters
    @Default([]) List<String> categories,
    
    // Price range filters
    @Default(0) double minPrice,
    @Default(10000) double maxPrice,
    
    // Rating filter
    @Default(0) double minRating,
    
    // Sorting options
    @Default(SortOption.relevance) SortOption sortBy,
    
    // Location filter
    @Default(10) double maxDistanceKm,
    
    // Feature filters
    @Default(false) bool onlyFeatured,
    @Default(false) bool hasOffers,
    @Default(false) bool customizationAvailable,
    
    // Venue type filters
    @Default([]) List<String> venueTypes,
    
    // Theme filters
    @Default([]) List<String> themeTags,
    
    // Environment filter (inside/outside/both)
    @Default([]) List<String> serviceEnvironments,
    
    // Availability filter
    @Default(false) bool availableToday,
    @Default(false) bool availableThisWeek,
  }) = _ServiceFilter;

  factory ServiceFilter.fromJson(Map<String, dynamic> json) =>
      _$ServiceFilterFromJson(json);
}

enum SortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  ratingLowToHigh,
  newest,
  mostPopular,
  nearestFirst,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.relevance:
        return 'Relevance';
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case SortOption.priceHighToLow:
        return 'Price: High to Low';
      case SortOption.ratingHighToLow:
        return 'Rating: High to Low';
      case SortOption.ratingLowToHigh:
        return 'Rating: Low to High';
      case SortOption.newest:
        return 'Newest First';
      case SortOption.mostPopular:
        return 'Most Popular';
      case SortOption.nearestFirst:
        return 'Nearest First';
    }
  }
}

@freezed
class FilterCategories with _$FilterCategories {
  const factory FilterCategories({
    @Default([]) List<String> decorationCategories,
    @Default([]) List<String> venueTypes,
    @Default([]) List<String> themeTags,
    @Default([]) List<String> serviceEnvironments,
  }) = _FilterCategories;

  factory FilterCategories.fromJson(Map<String, dynamic> json) =>
      _$FilterCategoriesFromJson(json);
}