// Theater screen data class based on theater_screens table schema
class TheaterScreen {
  final String id;
  final String theaterId;
  final String screenName;
  final int screenNumber;
  final int capacity;
  final List<String>? amenities;
  final double hourlyRate;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? totalCapacity;
  final int? allowedCapacity;
  final double? chargesExtraPerPerson;
  final String? videoUrl;
  final List<String>? images;
  final String? description;
  final Map<String, dynamic>? timeSlots;
  final List<String>? whatIncluded;
  final String? categoryId;

  const TheaterScreen({
    required this.id,
    required this.theaterId,
    required this.screenName,
    required this.screenNumber,
    required this.capacity,
    this.amenities,
    required this.hourlyRate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.totalCapacity,
    this.allowedCapacity,
    this.chargesExtraPerPerson,
    this.videoUrl,
    this.images,
    this.description,
    this.timeSlots,
    this.whatIncluded,
    this.categoryId,
  });

  factory TheaterScreen.fromJson(Map<String, dynamic> json) {
    return TheaterScreen(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      screenName: json['screen_name'] as String,
      screenNumber: json['screen_number'] as int,
      capacity: json['capacity'] as int,
      amenities: json['amenities'] != null && json['amenities'] is List
          ? List<String>.from(json['amenities'])
          : null,
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      totalCapacity: json['total_capacity'] as int?,
      allowedCapacity: json['allowed_capacity'] as int?,
      chargesExtraPerPerson: json['charges_extra_per_person']?.toDouble(),
      videoUrl: json['video_url'] as String?,
      images: json['images'] != null && json['images'] is List
          ? List<String>.from(json['images'])
          : null,
      description: json['description'] as String?,
      timeSlots: json['time_slots'] != null && json['time_slots'] is Map
          ? json['time_slots'] as Map<String, dynamic>
          : null,
      whatIncluded:
          json['what_included'] != null && json['what_included'] is List
          ? List<String>.from(json['what_included'])
          : null,
      categoryId: json['category_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'theater_id': theaterId,
      'screen_name': screenName,
      'screen_number': screenNumber,
      'capacity': capacity,
      'amenities': amenities,
      'hourly_rate': hourlyRate,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'total_capacity': totalCapacity,
      'allowed_capacity': allowedCapacity,
      'charges_extra_per_person': chargesExtraPerPerson,
      'video_url': videoUrl,
      'images': images,
      'description': description,
      'time_slots': timeSlots,
      'what_included': whatIncluded,
      'category_id': categoryId,
    };
  }

  TheaterScreen copyWith({
    String? id,
    String? theaterId,
    String? screenName,
    int? screenNumber,
    int? capacity,
    List<String>? amenities,
    double? hourlyRate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalCapacity,
    int? allowedCapacity,
    double? chargesExtraPerPerson,
    String? videoUrl,
    List<String>? images,
    String? description,
    Map<String, dynamic>? timeSlots,
    List<String>? whatIncluded,
    String? categoryId,
  }) {
    return TheaterScreen(
      id: id ?? this.id,
      theaterId: theaterId ?? this.theaterId,
      screenName: screenName ?? this.screenName,
      screenNumber: screenNumber ?? this.screenNumber,
      capacity: capacity ?? this.capacity,
      amenities: amenities ?? this.amenities,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      allowedCapacity: allowedCapacity ?? this.allowedCapacity,
      chargesExtraPerPerson: chargesExtraPerPerson ?? this.chargesExtraPerPerson,
      videoUrl: videoUrl ?? this.videoUrl,
      images: images ?? this.images,
      description: description ?? this.description,
      timeSlots: timeSlots ?? this.timeSlots,
      whatIncluded: whatIncluded ?? this.whatIncluded,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TheaterScreen && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TheaterScreen(id: $id, screenName: $screenName, capacity: $capacity, hourlyRate: $hourlyRate)';
  }
}