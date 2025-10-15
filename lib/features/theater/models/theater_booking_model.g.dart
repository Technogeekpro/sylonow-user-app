// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TheaterBookingModelImpl _$$TheaterBookingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TheaterBookingModelImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      timeSlotId: json['time_slot_id'] as String?,
      userId: json['user_id'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      paymentId: json['payment_id'] as String?,
      bookingStatus: json['booking_status'] as String? ?? 'confirmed',
      guestCount: (json['guest_count'] as num?)?.toInt() ?? 1,
      specialRequests: json['special_requests'] as String?,
      contactName: json['contact_name'] as String,
      contactPhone: json['contact_phone'] as String,
      contactEmail: json['contact_email'] as String?,
      celebrationName: json['celebration_name'] as String?,
      numberOfPeople: (json['number_of_people'] as num?)?.toInt() ?? 2,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      vendorId: json['vendor_id'] as String,
      theaterName: json['theater_name'] as String?,
      theaterAddress: json['theater_address'] as String?,
      theaterImages: (json['theater_images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      screenName: json['screen_name'] as String?,
      screenNumber: (json['screen_number'] as num?)?.toInt(),
      addons: (json['addons'] as List<dynamic>?)
          ?.map((e) =>
              TheaterBookingAddonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TheaterBookingModelImplToJson(
        _$TheaterBookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'time_slot_id': instance.timeSlotId,
      'user_id': instance.userId,
      'booking_date': instance.bookingDate.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'total_amount': instance.totalAmount,
      'payment_status': instance.paymentStatus,
      'payment_id': instance.paymentId,
      'booking_status': instance.bookingStatus,
      'guest_count': instance.guestCount,
      'special_requests': instance.specialRequests,
      'contact_name': instance.contactName,
      'contact_phone': instance.contactPhone,
      'contact_email': instance.contactEmail,
      'celebration_name': instance.celebrationName,
      'number_of_people': instance.numberOfPeople,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'vendor_id': instance.vendorId,
      'theater_name': instance.theaterName,
      'theater_address': instance.theaterAddress,
      'theater_images': instance.theaterImages,
      'screen_name': instance.screenName,
      'screen_number': instance.screenNumber,
      'addons': instance.addons,
    };

_$TheaterBookingAddonModelImpl _$$TheaterBookingAddonModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TheaterBookingAddonModelImpl(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      addonId: json['addon_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      addonName: json['addon_name'] as String?,
      addonDescription: json['addon_description'] as String?,
      addonImageUrl: json['addon_image_url'] as String?,
      addonCategory: json['addon_category'] as String?,
    );

Map<String, dynamic> _$$TheaterBookingAddonModelImplToJson(
        _$TheaterBookingAddonModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'addon_id': instance.addonId,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'created_at': instance.createdAt?.toIso8601String(),
      'addon_name': instance.addonName,
      'addon_description': instance.addonDescription,
      'addon_image_url': instance.addonImageUrl,
      'addon_category': instance.addonCategory,
    };
