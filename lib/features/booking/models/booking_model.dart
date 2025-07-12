import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'service_listing_id') required String serviceListingId,
    @JsonKey(name: 'service_title') required String serviceTitle,
    @JsonKey(name: 'service_description') String? serviceDescription,
    
    // Time and Date Information
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'booking_time') required String bookingTime, // Time slot (e.g., "14:00-16:00")
    @JsonKey(name: 'inquiry_time') required DateTime inquiryTime, // When service provider was available for inquiry
    @JsonKey(name: 'duration_hours') required int durationHours,
    
    // Customer Information
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'customer_phone') required String customerPhone,
    @JsonKey(name: 'customer_email') String? customerEmail,
    
    // Address Information
    @JsonKey(name: 'venue_address') required String venueAddress,
    @JsonKey(name: 'venue_coordinates') Map<String, dynamic>? venueCoordinates,
    @JsonKey(name: 'special_requirements') String? specialRequirements,
    
    // Pricing Information
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'razorpay_amount') required double razorpayAmount, // 60% of total
    @JsonKey(name: 'sylonow_qr_amount') required double sylonowQrAmount, // 40% of total
    
    // Payment Information
    @JsonKey(name: 'razorpay_payment_id') String? razorpayPaymentId,
    @JsonKey(name: 'razorpay_order_id') String? razorpayOrderId,
    @JsonKey(name: 'sylonow_qr_payment_id') String? sylonowQrPaymentId,
    @JsonKey(name: 'payment_status') @Default('pending') String paymentStatus, // pending, partial, completed, failed
    
    // Booking Status
    @Default('pending') String status, // pending, confirmed, in_progress, completed, cancelled
    @JsonKey(name: 'vendor_confirmation') @Default(false) bool vendorConfirmation,
    @JsonKey(name: 'notification_sent') @Default(false) bool notificationSent,
    
    // Additional Information
    @JsonKey(name: 'add_ons') List<Map<String, dynamic>>? addOns,
    Map<String, dynamic>? metadata,
    
    // Timestamps
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}

// Enum for booking status
enum BookingStatus {
  pending,
  confirmed,
  @JsonValue('in_progress')
  inProgress,
  completed,
  cancelled,
}

// Enum for payment status
enum PaymentStatus {
  pending,
  partial, // Only one payment method completed
  completed, // Both payments completed
  failed,
  refunded,
}

// Time slot model for availability checking
@freezed
class TimeSlotModel with _$TimeSlotModel {
  const factory TimeSlotModel({
    required String id,
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'service_listing_id') required String serviceListingId,
    required DateTime date,
    @JsonKey(name: 'start_time') required String startTime, // "14:00"
    @JsonKey(name: 'end_time') required String endTime, // "16:00"
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'is_blocked') @Default(false) bool isBlocked, // Manually blocked by vendor
    @JsonKey(name: 'booking_id') String? bookingId, // If booked, reference to booking
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _TimeSlotModel;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);
}

// Vendor inquiry time tracking
@freezed
class VendorInquiryTimeModel with _$VendorInquiryTimeModel {
  const factory VendorInquiryTimeModel({
    required String id,
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'inquiry_start_time') required DateTime inquiryStartTime,
    @JsonKey(name: 'inquiry_end_time') DateTime? inquiryEndTime,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _VendorInquiryTimeModel;

  factory VendorInquiryTimeModel.fromJson(Map<String, dynamic> json) =>
      _$VendorInquiryTimeModelFromJson(json);
} 