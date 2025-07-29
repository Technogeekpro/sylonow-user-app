import 'package:freezed_annotation/freezed_annotation.dart';

part 'theater_time_slot_model.freezed.dart';
part 'theater_time_slot_model.g.dart';

@freezed
class TheaterTimeSlotModel with _$TheaterTimeSlotModel {
  const factory TheaterTimeSlotModel({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    @JsonKey(name: 'slot_name') required String slotName,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'base_price') required double basePrice,
    @JsonKey(name: 'price_per_hour') required double pricePerHour,
    @JsonKey(name: 'weekday_multiplier') required double weekdayMultiplier,
    @JsonKey(name: 'weekend_multiplier') required double weekendMultiplier,
    @JsonKey(name: 'holiday_multiplier') required double holidayMultiplier,
    @JsonKey(name: 'max_duration_hours') required int maxDurationHours,
    @JsonKey(name: 'min_duration_hours') required int minDurationHours,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _TheaterTimeSlotModel;

  factory TheaterTimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterTimeSlotModelFromJson(json);
}

@freezed
class TheaterSlotBookingModel with _$TheaterSlotBookingModel {
  const factory TheaterSlotBookingModel({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    @JsonKey(name: 'time_slot_id') required String timeSlotId,
    @JsonKey(name: 'booking_date') required String bookingDate,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    required String status, // 'available', 'booked', 'blocked', 'maintenance'
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'slot_price') required double slotPrice,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _TheaterSlotBookingModel;

  factory TheaterSlotBookingModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterSlotBookingModelFromJson(json);
}

enum SlotStatus {
  available,
  booked,
  blocked,
  maintenance,
}

extension SlotStatusExtension on SlotStatus {
  String get value {
    switch (this) {
      case SlotStatus.available:
        return 'available';
      case SlotStatus.booked:
        return 'booked';
      case SlotStatus.blocked:
        return 'blocked';
      case SlotStatus.maintenance:
        return 'maintenance';
    }
  }

  static SlotStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return SlotStatus.available;
      case 'booked':
        return SlotStatus.booked;
      case 'blocked':
        return SlotStatus.blocked;
      case 'maintenance':
        return SlotStatus.maintenance;
      default:
        return SlotStatus.available;
    }
  }
}