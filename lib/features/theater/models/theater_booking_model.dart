import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theater_booking_model.freezed.dart';
part 'theater_booking_model.g.dart';

@freezed
class TheaterBookingModel with _$TheaterBookingModel {
  const factory TheaterBookingModel({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    @JsonKey(name: 'time_slot_id') String? timeSlotId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'payment_status') @Default('pending') String paymentStatus,
    @JsonKey(name: 'payment_id') String? paymentId,
    @JsonKey(name: 'booking_status') @Default('confirmed') String bookingStatus,
    @JsonKey(name: 'guest_count') @Default(1) int guestCount,
    @JsonKey(name: 'special_requests') String? specialRequests,
    @JsonKey(name: 'contact_name') required String contactName,
    @JsonKey(name: 'contact_phone') required String contactPhone,
    @JsonKey(name: 'contact_email') String? contactEmail,
    @JsonKey(name: 'celebration_name') String? celebrationName,
    @JsonKey(name: 'number_of_people') @Default(2) int numberOfPeople,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'vendor_id') required String vendorId,
    
    // Joined data from theater
    @JsonKey(name: 'theater_name') String? theaterName,
    @JsonKey(name: 'theater_address') String? theaterAddress,
    @JsonKey(name: 'theater_images') List<String>? theaterImages,

    // Joined data from screen
    @JsonKey(name: 'screen_name') String? screenName,
    @JsonKey(name: 'screen_number') int? screenNumber,

    // Joined data from add-ons
    @JsonKey(name: 'addons') List<TheaterBookingAddonModel>? addons,
  }) = _TheaterBookingModel;

  factory TheaterBookingModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterBookingModelFromJson(json);
}

@freezed
class TheaterBookingAddonModel with _$TheaterBookingAddonModel {
  const factory TheaterBookingAddonModel({
    required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'addon_id') required String addonId,
    required int quantity,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    
    // Joined data from add_ons table
    @JsonKey(name: 'addon_name') String? addonName,
    @JsonKey(name: 'addon_description') String? addonDescription,
    @JsonKey(name: 'addon_image_url') String? addonImageUrl,
    @JsonKey(name: 'addon_category') String? addonCategory,
  }) = _TheaterBookingAddonModel;

  factory TheaterBookingAddonModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterBookingAddonModelFromJson(json);
}

// Enum for booking status
enum TheaterBookingStatus {
  confirmed,
  cancelled,
  completed,
  @JsonValue('no_show')
  noShow,
}

// Enum for payment status
enum TheaterPaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

extension TheaterBookingStatusExtension on TheaterBookingStatus {
  String get displayName {
    switch (this) {
      case TheaterBookingStatus.confirmed:
        return 'Confirmed';
      case TheaterBookingStatus.cancelled:
        return 'Cancelled';
      case TheaterBookingStatus.completed:
        return 'Completed';
      case TheaterBookingStatus.noShow:
        return 'No Show';
    }
  }

  Color get color {
    switch (this) {
      case TheaterBookingStatus.confirmed:
        return Colors.blue;
      case TheaterBookingStatus.cancelled:
        return Colors.red;
      case TheaterBookingStatus.completed:
        return Colors.green;
      case TheaterBookingStatus.noShow:
        return Colors.orange;
    }
  }
}

extension TheaterPaymentStatusExtension on TheaterPaymentStatus {
  String get displayName {
    switch (this) {
      case TheaterPaymentStatus.pending:
        return 'Pending';
      case TheaterPaymentStatus.paid:
        return 'Paid';
      case TheaterPaymentStatus.failed:
        return 'Failed';
      case TheaterPaymentStatus.refunded:
        return 'Refunded';
    }
  }

  Color get color {
    switch (this) {
      case TheaterPaymentStatus.pending:
        return Colors.orange;
      case TheaterPaymentStatus.paid:
        return Colors.green;
      case TheaterPaymentStatus.failed:
        return Colors.red;
      case TheaterPaymentStatus.refunded:
        return Colors.grey;
    }
  }
}
