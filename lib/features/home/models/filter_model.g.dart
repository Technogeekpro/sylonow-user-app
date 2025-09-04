// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceFilterImpl _$$ServiceFilterImplFromJson(Map<String, dynamic> json) =>
    _$ServiceFilterImpl(
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 10000,
      minRating: (json['minRating'] as num?)?.toDouble() ?? 0,
      sortBy: $enumDecodeNullable(_$SortOptionEnumMap, json['sortBy']) ??
          SortOption.relevance,
      maxDistanceKm: (json['maxDistanceKm'] as num?)?.toDouble() ?? 10,
      onlyFeatured: json['onlyFeatured'] as bool? ?? false,
      hasOffers: json['hasOffers'] as bool? ?? false,
      customizationAvailable: json['customizationAvailable'] as bool? ?? false,
      venueTypes: (json['venueTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      themeTags: (json['themeTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      serviceEnvironments: (json['serviceEnvironments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      availableToday: json['availableToday'] as bool? ?? false,
      availableThisWeek: json['availableThisWeek'] as bool? ?? false,
    );

Map<String, dynamic> _$$ServiceFilterImplToJson(_$ServiceFilterImpl instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'minRating': instance.minRating,
      'sortBy': _$SortOptionEnumMap[instance.sortBy]!,
      'maxDistanceKm': instance.maxDistanceKm,
      'onlyFeatured': instance.onlyFeatured,
      'hasOffers': instance.hasOffers,
      'customizationAvailable': instance.customizationAvailable,
      'venueTypes': instance.venueTypes,
      'themeTags': instance.themeTags,
      'serviceEnvironments': instance.serviceEnvironments,
      'availableToday': instance.availableToday,
      'availableThisWeek': instance.availableThisWeek,
    };

const _$SortOptionEnumMap = {
  SortOption.relevance: 'relevance',
  SortOption.priceLowToHigh: 'priceLowToHigh',
  SortOption.priceHighToLow: 'priceHighToLow',
  SortOption.ratingHighToLow: 'ratingHighToLow',
  SortOption.ratingLowToHigh: 'ratingLowToHigh',
  SortOption.newest: 'newest',
  SortOption.mostPopular: 'mostPopular',
  SortOption.nearestFirst: 'nearestFirst',
};

_$FilterCategoriesImpl _$$FilterCategoriesImplFromJson(
        Map<String, dynamic> json) =>
    _$FilterCategoriesImpl(
      decorationCategories: (json['decorationCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      venueTypes: (json['venueTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      themeTags: (json['themeTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      serviceEnvironments: (json['serviceEnvironments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FilterCategoriesImplToJson(
        _$FilterCategoriesImpl instance) =>
    <String, dynamic>{
      'decorationCategories': instance.decorationCategories,
      'venueTypes': instance.venueTypes,
      'themeTags': instance.themeTags,
      'serviceEnvironments': instance.serviceEnvironments,
    };
