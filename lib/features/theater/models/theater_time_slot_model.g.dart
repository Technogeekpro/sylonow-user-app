// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_time_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TheaterTimeSlotModelImpl _$$TheaterTimeSlotModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TheaterTimeSlotModelImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      slotName: json['slot_name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      basePrice: (json['base_price'] as num).toDouble(),
      pricePerHour: (json['price_per_hour'] as num).toDouble(),
      weekdayMultiplier: (json['weekday_multiplier'] as num).toDouble(),
      weekendMultiplier: (json['weekend_multiplier'] as num).toDouble(),
      holidayMultiplier: (json['holiday_multiplier'] as num).toDouble(),
      maxDurationHours: (json['max_duration_hours'] as num).toInt(),
      minDurationHours: (json['min_duration_hours'] as num).toInt(),
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TheaterTimeSlotModelImplToJson(
        _$TheaterTimeSlotModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'slot_name': instance.slotName,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'base_price': instance.basePrice,
      'price_per_hour': instance.pricePerHour,
      'weekday_multiplier': instance.weekdayMultiplier,
      'weekend_multiplier': instance.weekendMultiplier,
      'holiday_multiplier': instance.holidayMultiplier,
      'max_duration_hours': instance.maxDurationHours,
      'min_duration_hours': instance.minDurationHours,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$TheaterSlotBookingModelImpl _$$TheaterSlotBookingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TheaterSlotBookingModelImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      timeSlotId: json['time_slot_id'] as String,
      bookingDate: json['booking_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: json['status'] as String,
      bookingId: json['booking_id'] as String?,
      slotPrice: (json['slot_price'] as num).toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TheaterSlotBookingModelImplToJson(
        _$TheaterSlotBookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'time_slot_id': instance.timeSlotId,
      'booking_date': instance.bookingDate,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'booking_id': instance.bookingId,
      'slot_price': instance.slotPrice,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
