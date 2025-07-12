// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      vendorId: json['vendor_id'] as String,
      serviceListingId: json['service_listing_id'] as String,
      serviceTitle: json['service_title'] as String,
      serviceDescription: json['service_description'] as String?,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      bookingTime: json['booking_time'] as String,
      inquiryTime: DateTime.parse(json['inquiry_time'] as String),
      durationHours: (json['duration_hours'] as num).toInt(),
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String,
      customerEmail: json['customer_email'] as String?,
      venueAddress: json['venue_address'] as String,
      venueCoordinates: json['venue_coordinates'] as Map<String, dynamic>?,
      specialRequirements: json['special_requirements'] as String?,
      totalAmount: (json['total_amount'] as num).toDouble(),
      razorpayAmount: (json['razorpay_amount'] as num).toDouble(),
      sylonowQrAmount: (json['sylonow_qr_amount'] as num).toDouble(),
      razorpayPaymentId: json['razorpay_payment_id'] as String?,
      razorpayOrderId: json['razorpay_order_id'] as String?,
      sylonowQrPaymentId: json['sylonow_qr_payment_id'] as String?,
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      status: json['status'] as String? ?? 'pending',
      vendorConfirmation: json['vendor_confirmation'] as bool? ?? false,
      notificationSent: json['notification_sent'] as bool? ?? false,
      addOns: (json['add_ons'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'vendor_id': instance.vendorId,
      'service_listing_id': instance.serviceListingId,
      'service_title': instance.serviceTitle,
      'service_description': instance.serviceDescription,
      'booking_date': instance.bookingDate.toIso8601String(),
      'booking_time': instance.bookingTime,
      'inquiry_time': instance.inquiryTime.toIso8601String(),
      'duration_hours': instance.durationHours,
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
      'customer_email': instance.customerEmail,
      'venue_address': instance.venueAddress,
      'venue_coordinates': instance.venueCoordinates,
      'special_requirements': instance.specialRequirements,
      'total_amount': instance.totalAmount,
      'razorpay_amount': instance.razorpayAmount,
      'sylonow_qr_amount': instance.sylonowQrAmount,
      'razorpay_payment_id': instance.razorpayPaymentId,
      'razorpay_order_id': instance.razorpayOrderId,
      'sylonow_qr_payment_id': instance.sylonowQrPaymentId,
      'payment_status': instance.paymentStatus,
      'status': instance.status,
      'vendor_confirmation': instance.vendorConfirmation,
      'notification_sent': instance.notificationSent,
      'add_ons': instance.addOns,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };

_$TimeSlotModelImpl _$$TimeSlotModelImplFromJson(Map<String, dynamic> json) =>
    _$TimeSlotModelImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String,
      serviceListingId: json['service_listing_id'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      isAvailable: json['is_available'] as bool? ?? true,
      isBlocked: json['is_blocked'] as bool? ?? false,
      bookingId: json['booking_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TimeSlotModelImplToJson(_$TimeSlotModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'service_listing_id': instance.serviceListingId,
      'date': instance.date.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'is_available': instance.isAvailable,
      'is_blocked': instance.isBlocked,
      'booking_id': instance.bookingId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$VendorInquiryTimeModelImpl _$$VendorInquiryTimeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VendorInquiryTimeModelImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String,
      inquiryStartTime: DateTime.parse(json['inquiry_start_time'] as String),
      inquiryEndTime: json['inquiry_end_time'] == null
          ? null
          : DateTime.parse(json['inquiry_end_time'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$VendorInquiryTimeModelImplToJson(
        _$VendorInquiryTimeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'inquiry_start_time': instance.inquiryStartTime.toIso8601String(),
      'inquiry_end_time': instance.inquiryEndTime?.toIso8601String(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
