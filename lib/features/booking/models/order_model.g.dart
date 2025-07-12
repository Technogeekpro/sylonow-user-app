// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      vendorId: json['vendor_id'] as String?,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String?,
      customerEmail: json['customer_email'] as String?,
      serviceListingId: json['service_listing_id'] as String?,
      serviceTitle: json['service_title'] as String,
      serviceDescription: json['service_description'] as String?,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      bookingTime: json['booking_time'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      advanceAmount: (json['advance_amount'] as num?)?.toDouble() ?? 0,
      remainingAmount: (json['remaining_amount'] as num?)?.toDouble() ?? 0,
      advancePaymentId: json['advance_payment_id'] as String?,
      remainingPaymentId: json['remaining_payment_id'] as String?,
      status: json['status'] as String? ?? 'pending',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      specialRequirements: json['special_requirements'] as String?,
      venueAddress: json['venue_address'] as String?,
      venueCoordinates: json['venue_coordinates'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'vendor_id': instance.vendorId,
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
      'customer_email': instance.customerEmail,
      'service_listing_id': instance.serviceListingId,
      'service_title': instance.serviceTitle,
      'service_description': instance.serviceDescription,
      'booking_date': instance.bookingDate.toIso8601String(),
      'booking_time': instance.bookingTime,
      'total_amount': instance.totalAmount,
      'advance_amount': instance.advanceAmount,
      'remaining_amount': instance.remainingAmount,
      'advance_payment_id': instance.advancePaymentId,
      'remaining_payment_id': instance.remainingPaymentId,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'special_requirements': instance.specialRequirements,
      'venue_address': instance.venueAddress,
      'venue_coordinates': instance.venueCoordinates,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
