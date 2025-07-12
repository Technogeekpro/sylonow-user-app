import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'vendor_id') String? vendorId,
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'service_listing_id') String? serviceListingId,
    @JsonKey(name: 'service_title') required String serviceTitle,
    @JsonKey(name: 'service_description') String? serviceDescription,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'booking_time') String? bookingTime,
    @JsonKey(name: 'total_amount') @Default(0) double totalAmount,
    @JsonKey(name: 'advance_amount') @Default(0) double advanceAmount,
    @JsonKey(name: 'remaining_amount') @Default(0) double remainingAmount,
    @JsonKey(name: 'advance_payment_id') String? advancePaymentId,
    @JsonKey(name: 'remaining_payment_id') String? remainingPaymentId,
    @Default('pending') String status,
    @JsonKey(name: 'payment_status') @Default('pending') String paymentStatus,
    @JsonKey(name: 'special_requirements') String? specialRequirements,
    @JsonKey(name: 'venue_address') String? venueAddress,
    @JsonKey(name: 'venue_coordinates') Map<String, dynamic>? venueCoordinates,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

// Enum for order status
enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

// Enum for payment status
enum OrderPaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('advance_paid')
  advancePaid,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('refunded')
  refunded,
}