import 'package:freezed_annotation/freezed_annotation.dart';

part 'cake_model.freezed.dart';
part 'cake_model.g.dart';

@freezed
class CakeModel with _$CakeModel {
  const factory CakeModel({
    required String id,
    required String theaterId,
    required String name,
    String? description,
    String? imageUrl,
    required double price,
    String? size,
    String? flavor,
    @Default(true) bool isAvailable,
    @Default(60) int preparationTimeMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CakeModel;

  factory CakeModel.fromJson(Map<String, dynamic> json) => 
      _$CakeModelFromJson(json);
}

extension CakeModelExtension on CakeModel {
  String get displayPrice {
    return '₹${price.toInt()}';
  }

  String get displaySize {
    return size ?? '1 kg';
  }

  String get displayFlavor {
    return flavor ?? 'Mixed';
  }

  String get preparationTimeText {
    if (preparationTimeMinutes <= 60) {
      return '$preparationTimeMinutes mins';
    }
    final hours = preparationTimeMinutes ~/ 60;
    final minutes = preparationTimeMinutes % 60;
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  String get availabilityText {
    return isAvailable ? 'Available' : 'Out of Stock';
  }

  bool get isInStock {
    return isAvailable;
  }

  // Get category from flavor (for filtering)
  String get category {
    return flavor ?? 'Other';
  }
}