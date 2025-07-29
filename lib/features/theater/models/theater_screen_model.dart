import 'package:freezed_annotation/freezed_annotation.dart';

part 'theater_screen_model.freezed.dart';
part 'theater_screen_model.g.dart';

@freezed
class TheaterScreenModel with _$TheaterScreenModel {
  const factory TheaterScreenModel({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    @JsonKey(name: 'screen_name') required String screenName,
    @JsonKey(name: 'screen_number') required int screenNumber,
    required int capacity,
    @Default([]) List<String> amenities,
    @JsonKey(name: 'hourly_rate') required double hourlyRate,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _TheaterScreenModel;

  factory TheaterScreenModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterScreenModelFromJson(json);
}

@freezed
class TheaterTimeSlotWithScreenModel with _$TheaterTimeSlotWithScreenModel {
  const factory TheaterTimeSlotWithScreenModel({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    @JsonKey(name: 'screen_id') required String screenId,
    @JsonKey(name: 'slot_date') required String slotDate,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'base_price') required double basePrice,
    @JsonKey(name: 'price_per_hour') required double pricePerHour,
    @JsonKey(name: 'weekday_multiplier') @Default(1.0) double weekdayMultiplier,
    @JsonKey(name: 'weekend_multiplier') @Default(1.2) double weekendMultiplier,
    @JsonKey(name: 'holiday_multiplier') @Default(1.5) double holidayMultiplier,
    @JsonKey(name: 'max_duration_hours') @Default(3) int maxDurationHours,
    @JsonKey(name: 'min_duration_hours') @Default(2) int minDurationHours,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    
    // Screen information (joined data)
    @JsonKey(name: 'screen_name') String? screenName,
    @JsonKey(name: 'screen_number') int? screenNumber,
    @JsonKey(name: 'screen_capacity') int? screenCapacity,
    @JsonKey(name: 'screen_amenities') List<String>? screenAmenities,
    @JsonKey(name: 'screen_hourly_rate') double? screenHourlyRate,
  }) = _TheaterTimeSlotWithScreenModel;

  factory TheaterTimeSlotWithScreenModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterTimeSlotWithScreenModelFromJson(json);
}

// Extended booking model that includes screen allocation
@freezed
class TheaterBookingWithScreenModel with _$TheaterBookingWithScreenModel {
  const factory TheaterBookingWithScreenModel({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    @JsonKey(name: 'screen_id') required String screenId,
    @JsonKey(name: 'time_slot_id') required String timeSlotId,
    @JsonKey(name: 'booking_date') required String bookingDate,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    required String status, // 'available', 'booked', 'blocked', 'maintenance'
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'slot_price') required double slotPrice,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    
    // Screen details
    @JsonKey(name: 'screen_name') String? screenName,
    @JsonKey(name: 'screen_number') int? screenNumber,
    @JsonKey(name: 'screen_capacity') int? screenCapacity,
    @JsonKey(name: 'screen_amenities') List<String>? screenAmenities,
  }) = _TheaterBookingWithScreenModel;

  factory TheaterBookingWithScreenModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterBookingWithScreenModelFromJson(json);
}