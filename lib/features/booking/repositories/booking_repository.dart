import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final SupabaseClient _supabase;

  BookingRepository(this._supabase);

  /// Check if a specific time slot is available for booking
  Future<bool> isTimeSlotAvailable({
    required String vendorId,
    required String serviceListingId,
    required DateTime date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final response = await _supabase
          .from('time_slots')
          .select()
          .eq('vendor_id', vendorId)
          .eq('service_listing_id', serviceListingId)
          .eq('date', date.toIso8601String().split('T')[0])
          .eq('start_time', startTime)
          .eq('end_time', endTime)
          .eq('is_available', true)
          .eq('is_blocked', false)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check time slot availability: $e');
    }
  }

  /// Check if there are any conflicting bookings for a time slot
  Future<bool> hasConflictingBookings({
    required String vendorId,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('vendor_id', vendorId)
          .eq('booking_date', bookingDate.toIso8601String().split('T')[0])
          .neq('status', 'cancelled')
          .filter('booking_time', 'cs', startTime); // Contains start time

      return response.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check conflicting bookings: $e');
    }
  }

  /// Get vendor's current inquiry time
  Future<VendorInquiryTimeModel?> getVendorCurrentInquiryTime(String vendorId) async {
    try {
      final response = await _supabase
          .from('vendor_inquiry_times')
          .select()
          .eq('vendor_id', vendorId)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return VendorInquiryTimeModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get vendor inquiry time: $e');
    }
  }

  /// Validate if booking time is greater than inquiry time
  Future<bool> validateBookingTimeAfterInquiry({
    required String vendorId,
    required DateTime bookingDateTime,
  }) async {
    try {
      final inquiryTime = await getVendorCurrentInquiryTime(vendorId);
      
      if (inquiryTime == null) {
        // If no inquiry time is set, allow booking
        return true;
      }

      // Check if booking time is after inquiry start time
      return bookingDateTime.isAfter(inquiryTime.inquiryStartTime);
    } catch (e) {
      throw Exception('Failed to validate booking time: $e');
    }
  }

  /// Get available time slots for a vendor on a specific date
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String vendorId,
    required String serviceListingId,
    required DateTime date,
  }) async {
    try {
      final response = await _supabase
          .from('time_slots')
          .select()
          .eq('vendor_id', vendorId)
          .eq('service_listing_id', serviceListingId)
          .eq('date', date.toIso8601String().split('T')[0])
          .eq('is_available', true)
          .eq('is_blocked', false)
          .order('start_time');

      return response
          .map<TimeSlotModel>((data) => TimeSlotModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get available time slots: $e');
    }
  }

  /// Create a new booking
  Future<BookingModel> createBooking({
    required String userId,
    required String vendorId,
    required String serviceListingId,
    required String serviceTitle,
    required DateTime bookingDate,
    required String bookingTime,
    required String customerName,
    required String customerPhone,
    required String venueAddress,
    required double totalAmount,
    String? serviceDescription,
    String? customerEmail,
    Map<String, dynamic>? venueCoordinates,
    String? specialRequirements,
    List<Map<String, dynamic>>? addOns,
  }) async {
    try {
      // Calculate payment split (60% Razorpay, 40% Sylonow QR)
      final razorpayAmount = totalAmount * 0.6;
      final sylonowQrAmount = totalAmount * 0.4;

      // Get vendor inquiry time for validation
      final inquiryTime = await getVendorCurrentInquiryTime(vendorId);
      final inquiryDateTime = inquiryTime?.inquiryStartTime ?? DateTime.now();

      final bookingData = {
        'user_id': userId,
        'vendor_id': vendorId,
        'service_listing_id': serviceListingId,
        'service_title': serviceTitle,
        'service_description': serviceDescription,
        'booking_date': bookingDate.toIso8601String(),
        'booking_time': bookingTime,
        'inquiry_time': inquiryDateTime.toIso8601String(),
        'duration_hours': 2, // Default duration
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'customer_email': customerEmail,
        'venue_address': venueAddress,
        'venue_coordinates': venueCoordinates,
        'special_requirements': specialRequirements,
        'total_amount': totalAmount,
        'razorpay_amount': razorpayAmount,
        'sylonow_qr_amount': sylonowQrAmount,
        'status': 'pending',
        'payment_status': 'pending',
        'vendor_confirmation': false,
        'notification_sent': false,
        'add_ons': addOns ?? [],
        'metadata': {},
      };

      final response = await _supabase
          .from('bookings')
          .insert(bookingData)
          .select()
          .single();

      return BookingModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Update booking status
  Future<BookingModel> updateBookingStatus({
    required String bookingId,
    required String status,
    bool? vendorConfirmation,
    DateTime? confirmedAt,
    DateTime? completedAt,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (vendorConfirmation != null) {
        updateData['vendor_confirmation'] = vendorConfirmation;
      }
      if (confirmedAt != null) {
        updateData['confirmed_at'] = confirmedAt.toIso8601String();
      }
      if (completedAt != null) {
        updateData['completed_at'] = completedAt.toIso8601String();
      }

      final response = await _supabase
          .from('bookings')
          .update(updateData)
          .eq('id', bookingId)
          .select()
          .single();

      return BookingModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  /// Update booking payment status
  Future<BookingModel> updateBookingPaymentStatus({
    required String bookingId,
    required String paymentStatus,
    String? razorpayPaymentId,
    String? razorpayOrderId,
    String? sylonowQrPaymentId,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'payment_status': paymentStatus,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (razorpayPaymentId != null) {
        updateData['razorpay_payment_id'] = razorpayPaymentId;
      }
      if (razorpayOrderId != null) {
        updateData['razorpay_order_id'] = razorpayOrderId;
      }
      if (sylonowQrPaymentId != null) {
        updateData['sylonow_qr_payment_id'] = sylonowQrPaymentId;
      }

      final response = await _supabase
          .from('bookings')
          .update(updateData)
          .eq('id', bookingId)
          .select()
          .single();

      return BookingModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update booking payment status: $e');
    }
  }

  /// Get booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('id', bookingId)
          .maybeSingle();

      if (response == null) return null;

      return BookingModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  /// Get user's bookings
  Future<List<BookingModel>> getUserBookings(String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response
          .map<BookingModel>((data) => BookingModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user bookings: $e');
    }
  }

  /// Get vendor's bookings
  Future<List<BookingModel>> getVendorBookings(String vendorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('vendor_id', vendorId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response
          .map<BookingModel>((data) => BookingModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to get vendor bookings: $e');
    }
  }

  /// Block/unblock a time slot
  Future<void> blockTimeSlot({
    required String vendorId,
    required String serviceListingId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required bool isBlocked,
  }) async {
    try {
      await _supabase
          .from('time_slots')
          .upsert({
            'vendor_id': vendorId,
            'service_listing_id': serviceListingId,
            'date': date.toIso8601String().split('T')[0],
            'start_time': startTime,
            'end_time': endTime,
            'is_available': !isBlocked,
            'is_blocked': isBlocked,
          });
    } catch (e) {
      throw Exception('Failed to block/unblock time slot: $e');
    }
  }

  /// Reserve a time slot for booking
  Future<void> reserveTimeSlot({
    required String vendorId,
    required String serviceListingId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String bookingId,
  }) async {
    try {
      await _supabase
          .from('time_slots')
          .upsert({
            'vendor_id': vendorId,
            'service_listing_id': serviceListingId,
            'date': date.toIso8601String().split('T')[0],
            'start_time': startTime,
            'end_time': endTime,
            'is_available': false,
            'is_blocked': false,
            'booking_id': bookingId,
          });
    } catch (e) {
      throw Exception('Failed to reserve time slot: $e');
    }
  }

  /// Release a time slot (when booking is cancelled)
  Future<void> releaseTimeSlot({
    required String vendorId,
    required DateTime date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      await _supabase
          .from('time_slots')
          .update({
            'is_available': true,
            'booking_id': null,
          })
          .eq('vendor_id', vendorId)
          .eq('date', date.toIso8601String().split('T')[0])
          .eq('start_time', startTime)
          .eq('end_time', endTime);
    } catch (e) {
      throw Exception('Failed to release time slot: $e');
    }
  }
} 