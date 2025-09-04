/// Category mapping constants for inside and outside screens
class CategoryConstants {
  CategoryConstants._();

  /// Maps inside screen UI category names to database category values
  static const Map<String, String> insideCategoryMapping = {
    'Private Birthday': 'Birthday',
    'Anniversary': 'Anniversary',
    'Theme Birthday': 'Theme Party',
    'Wedding Decor': 'Wedding',
    'Baby Shower': 'Baby Shower',
    'Corporate Events': 'Corporate Event',
  };

  /// Maps outside screen UI category names to database category values
  static const Map<String, String> outsideCategoryMapping = {
    'Garden Decoration': 'Garden Party',
    'Terrace Setup': 'Terrace Setup',
    'Pool Party': 'Pool Party',
    'Outdoor Wedding': 'Wedding',
    'Lawn Events': 'Festival',
    'Outdoor Lighting': 'Outdoor Lighting',
  };

  /// All inside screen category names
  static const List<String> insideCategories = [
    'Private Birthday',
    'Anniversary',
    'Theme Birthday',
    'Wedding Decor',
    'Baby Shower',
    'Corporate Events',
  ];

  /// All outside screen category names
  static const List<String> outsideCategories = [
    'Garden Decoration',
    'Terrace Setup',
    'Pool Party',
    'Outdoor Wedding',
    'Lawn Events',
    'Outdoor Lighting',
  ];

  /// Gets database category name from UI category name
  static String? getDatabaseCategory(String uiCategory, {required bool isInside}) {
    if (isInside) {
      return insideCategoryMapping[uiCategory];
    } else {
      return outsideCategoryMapping[uiCategory];
    }
  }

  /// Gets decoration type string for database filtering
  static String getDecorationType(bool isInside) {
    return isInside ? 'inside' : 'outside';
  }
}