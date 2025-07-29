// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TheaterScreenModelImpl _$$TheaterScreenModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TheaterScreenModelImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      screenName: json['screen_name'] as String,
      screenNumber: (json['screen_number'] as num).toInt(),
      capacity: (json['capacity'] as num).toInt(),
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TheaterScreenModelImplToJson(
        _$TheaterScreenModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'screen_name': instance.screenName,
      'screen_number': instance.screenNumber,
      'capacity': instance.capacity,
      'amenities': instance.amenities,
      'hourly_rate': instance.hourlyRate,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$TheaterTimeSlotWithScreenModelImpl
    _$$TheaterTimeSlotWithScreenModelImplFromJson(Map<String, dynamic> json) =>
        _$TheaterTimeSlotWithScreenModelImpl(
          id: json['id'] as String,
          theaterId: json['theater_id'] as String,
          screenId: json['screen_id'] as String,
          slotDate: json['slot_date'] as String,
          startTime: json['start_time'] as String,
          endTime: json['end_time'] as String,
          basePrice: (json['base_price'] as num).toDouble(),
          pricePerHour: (json['price_per_hour'] as num).toDouble(),
          weekdayMultiplier:
              (json['weekday_multiplier'] as num?)?.toDouble() ?? 1.0,
          weekendMultiplier:
              (json['weekend_multiplier'] as num?)?.toDouble() ?? 1.2,
          holidayMultiplier:
              (json['holiday_multiplier'] as num?)?.toDouble() ?? 1.5,
          maxDurationHours: (json['max_duration_hours'] as num?)?.toInt() ?? 3,
          minDurationHours: (json['min_duration_hours'] as num?)?.toInt() ?? 2,
          isAvailable: json['is_available'] as bool? ?? true,
          isActive: json['is_active'] as bool? ?? true,
          createdAt: json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
          updatedAt: json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
          screenName: json['screen_name'] as String?,
          screenNumber: (json['screen_number'] as num?)?.toInt(),
          screenCapacity: (json['screen_capacity'] as num?)?.toInt(),
          screenAmenities: (json['screen_amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          screenHourlyRate: (json['screen_hourly_rate'] as num?)?.toDouble(),
        );

Map<String, dynamic> _$$TheaterTimeSlotWithScreenModelImplToJson(
        _$TheaterTimeSlotWithScreenModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'screen_id': instance.screenId,
      'slot_date': instance.slotDate,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'base_price': instance.basePrice,
      'price_per_hour': instance.pricePerHour,
      'weekday_multiplier': instance.weekdayMultiplier,
      'weekend_multiplier': instance.weekendMultiplier,
      'holiday_multiplier': instance.holidayMultiplier,
      'max_duration_hours': instance.maxDurationHours,
      'min_duration_hours': instance.minDurationHours,
      'is_available': instance.isAvailable,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'screen_name': instance.screenName,
      'screen_number': instance.screenNumber,
      'screen_capacity': instance.screenCapacity,
      'screen_amenities': instance.screenAmenities,
      'screen_hourly_rate': instance.screenHourlyRate,
    };

_$TheaterBookingWithScreenModelImpl
    _$$TheaterBookingWithScreenModelImplFromJson(Map<String, dynamic> json) =>
        _$TheaterBookingWithScreenModelImpl(
          id: json['id'] as String,
          theaterId: json['theater_id'] as String,
          screenId: json['screen_id'] as String,
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
          screenName: json['screen_name'] as String?,
          screenNumber: (json['screen_number'] as num?)?.toInt(),
          screenCapacity: (json['screen_capacity'] as num?)?.toInt(),
          screenAmenities: (json['screen_amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$$TheaterBookingWithScreenModelImplToJson(
        _$TheaterBookingWithScreenModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'screen_id': instance.screenId,
      'time_slot_id': instance.timeSlotId,
      'booking_date': instance.bookingDate,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'booking_id': instance.bookingId,
      'slot_price': instance.slotPrice,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'screen_name': instance.screenName,
      'screen_number': instance.screenNumber,
      'screen_capacity': instance.screenCapacity,
      'screen_amenities': instance.screenAmenities,
    };
