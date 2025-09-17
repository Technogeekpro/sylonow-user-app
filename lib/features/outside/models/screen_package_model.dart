class ScreenPackageModel {
  final String id;
  final String screenId;
  final String packageName;
  final double packagePrice;
  final double? originalPrice;
  final String? packageDescription;
  final String? packageImage;
  final List<String>? packageAddons;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ScreenPackageModel({
    required this.id,
    required this.screenId,
    required this.packageName,
    required this.packagePrice,
    this.originalPrice,
    this.packageDescription,
    this.packageImage,
    this.packageAddons,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScreenPackageModel.fromJson(Map<String, dynamic> json) {
    return ScreenPackageModel(
      id: json['id'] as String,
      screenId: json['screen_id'] as String,
      packageName: json['package_name'] as String,
      packagePrice: (json['package_price'] as num).toDouble(),
      originalPrice: json['original_price'] != null ? (json['original_price'] as num).toDouble() : null,
      packageDescription: json['package_description'] as String?,
      packageImage: json['package_image'] as String?,
      packageAddons: (json['package_addons'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'screen_id': screenId,
      'package_name': packageName,
      'package_price': packagePrice,
      'original_price': originalPrice,
      'package_description': packageDescription,
      'package_image': packageImage,
      'package_addons': packageAddons,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ScreenPackageModel copyWith({
    String? id,
    String? screenId,
    String? packageName,
    double? packagePrice,
    double? originalPrice,
    String? packageDescription,
    String? packageImage,
    List<String>? packageAddons,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScreenPackageModel(
      id: id ?? this.id,
      screenId: screenId ?? this.screenId,
      packageName: packageName ?? this.packageName,
      packagePrice: packagePrice ?? this.packagePrice,
      originalPrice: originalPrice ?? this.originalPrice,
      packageDescription: packageDescription ?? this.packageDescription,
      packageImage: packageImage ?? this.packageImage,
      packageAddons: packageAddons ?? this.packageAddons,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods for better UX
  String get formattedPrice => '₹${packagePrice.round()}';
  
  String get formattedOriginalPrice => originalPrice != null ? '₹${originalPrice!.round()}' : '';
  
  bool get hasDiscount => originalPrice != null && originalPrice! > packagePrice;
  
  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - packagePrice) / originalPrice!) * 100).round();
  }

  List<String> get addonsList {
    return packageAddons ?? [];
  }
  
  List<String> get addonIds {
    return packageAddons ?? [];
  }

  bool get hasImage => packageImage != null && packageImage!.isNotEmpty;

  String get shortDescription {
    if (packageDescription == null || packageDescription!.isEmpty) {
      return 'Complete package with all essentials';
    }
    return packageDescription!.length > 100 
        ? '${packageDescription!.substring(0, 97)}...'
        : packageDescription!;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScreenPackageModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ScreenPackageModel(id: $id, packageName: $packageName, packagePrice: $packagePrice)';
  }
}