import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter_model.dart';
import '../models/service_listing_model.dart';
import 'home_providers.dart';

// Filter state provider for inside decoration services
final insideFilterProvider = StateProvider<ServiceFilter>((ref) {
  return const ServiceFilter();
});

// Filter state provider for outside decoration services  
final outsideFilterProvider = StateProvider<ServiceFilter>((ref) {
  return const ServiceFilter();
});

// Filtered services provider for inside decoration
final filteredInsideServicesProvider = FutureProvider<List<ServiceListingModel>>((ref) async {
  try {
    // Get the base services from the existing provider
    final baseServices = await ref.watch(servicesByDecorationTypeProvider('inside').future);
    final filter = ref.watch(insideFilterProvider);
    
    print('🔍 FILTER_PROVIDER: Inside services received - count: ${baseServices.length ?? 0}');
    
    final filteredServices = _applyFilters(baseServices, filter);
    print('🔍 FILTER_PROVIDER: Inside services after filtering - count: ${filteredServices.length}');
    return filteredServices;
  } catch (e, stackTrace) {
    print('🔍 FILTER_PROVIDER: Error in filteredInsideServicesProvider: $e');
    print('🔍 FILTER_PROVIDER: Stack trace: $stackTrace');
    return <ServiceListingModel>[];
  }
});

// Filtered services provider for outside decoration
final filteredOutsideServicesProvider = FutureProvider<List<ServiceListingModel>>((ref) async {
  try {
    print('🐛 FILTER_PROVIDER: filteredOutsideServicesProvider - Line 41: Starting outside services fetch');
    // Get the base services from the existing provider
    final baseServices = await ref.watch(servicesByDecorationTypeProvider('outside').future);
    final filter = ref.watch(outsideFilterProvider);
    
    print('🔍 FILTER_PROVIDER: Outside services received - count: ${baseServices.length ?? 0}');
    print('🐛 FILTER_PROVIDER: baseServices type: ${baseServices.runtimeType}');
    
    print('🐛 FILTER_PROVIDER: About to call _applyFilters with ${baseServices.length} services');
    final filteredServices = _applyFilters(baseServices, filter);
    print('🔍 FILTER_PROVIDER: Outside services after filtering - count: ${filteredServices.length}');
    return filteredServices;
  } catch (e, stackTrace) {
    print('🐛 CRITICAL ERROR at Line 41 - filteredOutsideServicesProvider: $e');
    print('🐛 Stack trace: $stackTrace');
    return <ServiceListingModel>[];
  }
});

// Helper function to apply filters to services
List<ServiceListingModel> _applyFilters(List<ServiceListingModel> services, ServiceFilter filter) {
  try {
    print('🐛 FILTER_PROVIDER: _applyFilters - Line 68: Starting filter application');
    print('🐛 Services count: ${services.length}');
    
    if (services.isEmpty) {
      print('🔍 FILTER_PROVIDER: No services to filter');
      return <ServiceListingModel>[];
    }
    
    print('🐛 FILTER_PROVIDER: Filtering out null services');
    // Filter out any null services
    var filteredServices = services.where((service) => service != null).toList();
    print('🐛 FILTER_PROVIDER: After null filter: ${filteredServices.length} services');
  
  // Apply category filter
  if (filter.categories.isNotEmpty) {
    filteredServices = filteredServices.where((service) {
      return filter.categories.any((category) => 
        service.category?.toLowerCase().contains(category.toLowerCase()) == true ||
        service.name.toLowerCase().contains(category.toLowerCase()) ||
        service.description?.toLowerCase().contains(category.toLowerCase()) == true
      );
    }).toList();
  }
  
  print('🐛 FILTER_PROVIDER: Applying price range filter');
  // Apply price range filter
  filteredServices = filteredServices.where((service) {
    try {
      print('🐛 FILTER_PROVIDER: Processing service ${service.id} for price filter');
      print('🐛 displayOfferPrice: ${service.displayOfferPrice}, displayOriginalPrice: ${service.displayOriginalPrice}');
      final price = service.displayOfferPrice ?? service.displayOriginalPrice ?? 0.0;
      print('🐛 Final price used: $price');
      final result = price >= filter.minPrice && price <= filter.maxPrice;
      print('🐛 Price filter result for ${service.id}: $result');
      return result;
    } catch (e, stackTrace) {
      print('🐛 CRITICAL ERROR in price filter for service ${service.id}: $e');
      print('🐛 Stack trace: $stackTrace');
      return false;
    }
  }).toList();
  print('🐛 FILTER_PROVIDER: After price filter: ${filteredServices.length} services');
  
  // Apply rating filter
  if (filter.minRating > 0) {
    filteredServices = filteredServices.where((service) {
      return (service.rating ?? 0.0) >= filter.minRating;
    }).toList();
  }
  
  // Apply featured filter
  if (filter.onlyFeatured) {
    filteredServices = filteredServices.where((service) {
      return service.isFeatured == true;
    }).toList();
  }
  
  // Apply offers filter
  if (filter.hasOffers) {
    filteredServices = filteredServices.where((service) {
      final offerPrice = service.offerPrice;
      final originalPrice = service.originalPrice;
      return offerPrice != null && 
             originalPrice != null &&
             offerPrice < originalPrice;
    }).toList();
  }
  
  // Apply customization filter
  if (filter.customizationAvailable) {
    filteredServices = filteredServices.where((service) {
      return service.customizationAvailable == true;
    }).toList();
  }
  
  // Apply venue type filter
  if (filter.venueTypes.isNotEmpty) {
    filteredServices = filteredServices.where((service) {
      return service.venueTypes?.any((venueType) => 
        filter.venueTypes.contains(venueType)
      ) == true;
    }).toList();
  }
  
  // Apply theme filter
  if (filter.themeTags.isNotEmpty) {
    filteredServices = filteredServices.where((service) {
      return service.themeTags?.any((theme) => 
        filter.themeTags.contains(theme)
      ) == true;
    }).toList();
  }
  
  // Apply service environment filter
  if (filter.serviceEnvironments.isNotEmpty) {
    filteredServices = filteredServices.where((service) {
      return service.serviceEnvironment?.any((env) => 
        filter.serviceEnvironments.contains(env)
      ) == true;
    }).toList();
  }
  
  // Apply distance filter (if location data is available)
  if (filter.maxDistanceKm < 50) {
    filteredServices = filteredServices.where((service) {
      final distance = service.distanceKm;
      if (distance == null) return true; // Include services without distance data
      return distance <= filter.maxDistanceKm;
    }).toList();
  }
  
  // Apply sorting
  switch (filter.sortBy) {
    case SortOption.priceLowToHigh:
      filteredServices.sort((a, b) {
        final priceA = a.displayOfferPrice ?? a.displayOriginalPrice ?? 0.0;
        final priceB = b.displayOfferPrice ?? b.displayOriginalPrice ?? 0.0;
        return priceA.compareTo(priceB);
      });
      break;
    case SortOption.priceHighToLow:
      filteredServices.sort((a, b) {
        final priceA = a.displayOfferPrice ?? a.displayOriginalPrice ?? 0.0;
        final priceB = b.displayOfferPrice ?? b.displayOriginalPrice ?? 0.0;
        return priceB.compareTo(priceA);
      });
      break;
    case SortOption.ratingHighToLow:
      filteredServices.sort((a, b) {
        final ratingA = a.rating ?? 0.0;
        final ratingB = b.rating ?? 0.0;
        return ratingB.compareTo(ratingA);
      });
      break;
    case SortOption.ratingLowToHigh:
      filteredServices.sort((a, b) {
        final ratingA = a.rating ?? 0.0;
        final ratingB = b.rating ?? 0.0;
        return ratingA.compareTo(ratingB);
      });
      break;
    case SortOption.newest:
      filteredServices.sort((a, b) {
        final dateA = a.createdAt ?? DateTime.now();
        final dateB = b.createdAt ?? DateTime.now();
        return dateB.compareTo(dateA);
      });
      break;
    case SortOption.mostPopular:
      filteredServices.sort((a, b) {
        final reviewsA = a.reviewsCount ?? 0;
        final reviewsB = b.reviewsCount ?? 0;
        return reviewsB.compareTo(reviewsA);
      });
      break;
    case SortOption.nearestFirst:
      filteredServices.sort((a, b) {
        final distanceA = a.distanceKm ?? 999.0;
        final distanceB = b.distanceKm ?? 999.0;
        return distanceA.compareTo(distanceB);
      });
      break;
    case SortOption.relevance:
    default:
      // Keep original order or apply relevance-based sorting
      break;
  }
  
  print('🐛 FILTER_PROVIDER: Completed filtering, returning ${filteredServices.length} services');
  return filteredServices;
  } catch (e, stackTrace) {
    print('🐛 CRITICAL ERROR at Line 68 - _applyFilters(): $e');
    print('🐛 Stack trace: $stackTrace');
    print('🐛 Services that caused error: ${services.map((s) => s.id ?? 'null').toList()}');
    return <ServiceListingModel>[];
  }
}

// This provider should already exist in home_providers.dart, 
// so we don't need to redefine it here.

// Active filters count provider for inside services
final insideActiveFiltersCountProvider = Provider<int>((ref) {
  final filter = ref.watch(insideFilterProvider);
  return _countActiveFilters(filter);
});

// Active filters count provider for outside services
final outsideActiveFiltersCountProvider = Provider<int>((ref) {
  final filter = ref.watch(outsideFilterProvider);
  return _countActiveFilters(filter);
});

// Helper function to count active filters
int _countActiveFilters(ServiceFilter filter) {
  int count = 0;
  
  if (filter.categories.isNotEmpty) count++;
  if (filter.minPrice > 0 || filter.maxPrice < 10000) count++;
  if (filter.minRating > 0) count++;
  if (filter.sortBy != SortOption.relevance) count++;
  if (filter.maxDistanceKm < 50) count++;
  if (filter.onlyFeatured) count++;
  if (filter.hasOffers) count++;
  if (filter.customizationAvailable) count++;
  if (filter.venueTypes.isNotEmpty) count++;
  if (filter.themeTags.isNotEmpty) count++;
  if (filter.serviceEnvironments.isNotEmpty) count++;
  
  return count;
}