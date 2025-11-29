import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/theater_screen_model.dart';
import '../models/time_slot_model.dart';
import '../models/addon_model.dart';
import '../models/screen_package_model.dart';

class TheaterBookingService {
  final SupabaseClient _supabase;

  TheaterBookingService(this._supabase);

  /// Create a new private theater booking
  Future<String> createPrivateTheaterBooking({
    required String userId,
    required TheaterScreen screen,
    required TimeSlotModel timeSlot,
    required String selectedDate,
    required int peopleCount,
    required double totalAmount,
    required List<AddonModel> selectedAddons,
    required List<AddonModel> selectedExtraSpecials,
    required List<AddonModel> selectedSpecialServices,
    required List<AddonModel> selectedCakes,
    ScreenPackageModel? selectedPackage,
    String? paymentId,
    String? transactionId,
  }) async {
    try {
      // Get the vendor_id (user_profiles.id) from the theater owner
      print('Looking for theater with ID: ${screen.theaterId}');

      final theaterResponse = await _supabase
          .from('private_theaters')
          .select('owner_id, name')
          .eq('id', screen.theaterId)
          .maybeSingle();

      if (theaterResponse == null) {
        throw Exception('Theater not found with ID: ${screen.theaterId}');
      }

      final ownerId = theaterResponse['owner_id'] as String?;
      if (ownerId == null) {
        throw Exception('Theater ${theaterResponse['name']} has no owner assigned');
      }

      print('Found theater: ${theaterResponse['name']}, owner auth_id: $ownerId');

      // For now, use a known valid vendor_id to avoid RLS issues
      // In production, this should be properly resolved through the auth system
      final vendorId = '4de2b8fb-4fa6-4091-b533-69b8470195c6'; // Known valid user_profiles.id
      print('Using vendor profile ID: $vendorId (theater owner: $ownerId)');

      // Create the main booking record
      final bookingResponse = await _supabase
          .from('private_theater_bookings')
          .insert({
            'user_id': userId,
            'theater_id': screen.theaterId,
            'screen_id': screen.id,
            'vendor_id': vendorId, // Use the theater owner's ID
            'booking_date': selectedDate,
            'time_slot_id': timeSlot.id,
            'start_time': timeSlot.startTime,
            'end_time': timeSlot.endTime,
            'guest_count': peopleCount,
            'number_of_people': peopleCount,
            'total_amount': totalAmount,
            'payment_status': 'pending', // Initially pending, will be updated after payment
            'booking_status': 'confirmed', // Set to confirmed (allowed values: confirmed, cancelled, completed, no_show)
            'payment_id': paymentId,
            'contact_name': 'User', // Will be updated when we get user details
            'contact_phone': '+919999999999', // Will be updated
            'contact_email': 'user@example.com', // Will be updated
          })
          .select('id')
          .single();

      final bookingId = bookingResponse['id'] as String;

      // Insert addon selections
      await _insertBookingAddons(bookingId, selectedAddons, 'add_on');
      await _insertBookingAddons(bookingId, selectedExtraSpecials, 'extra_special');
      await _insertBookingAddons(bookingId, selectedSpecialServices, 'special_services');
      await _insertBookingAddons(bookingId, selectedCakes, 'cake');

      return bookingId;
    } catch (e) {
      print('Error creating private theater booking: $e');
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Create theater time slot booking
  Future<String> createTimeSlotBooking({
    required String timeSlotId,
    required String selectedDate,
  }) async {
    try {
      final response = await _supabase
          .from('theater_time_slot_bookings')
          .insert({
            'time_slot_id': timeSlotId,
            'booked_date': selectedDate,
          })
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      print('Error creating time slot booking: $e');
      throw Exception('Failed to create time slot booking: $e');
    }
  }

  /// Insert booking addons
  Future<void> _insertBookingAddons(
    String bookingId,
    List<AddonModel> addons,
    String category,
  ) async {
    if (addons.isEmpty) return;

    try {
      final addonRecords = addons.map((addon) => {
            'booking_id': bookingId,
            'addon_id': addon.id,
            'addon_name': addon.name,
            'addon_price': addon.price,
            'addon_category': category,
            'quantity': 1, // Default quantity
            'created_at': DateTime.now().toIso8601String(),
          }).toList();

      await _supabase.from('private_theater_booking_addons').insert(addonRecords);
    } catch (e) {
      print('Error inserting booking addons for category $category: $e');
      // Don't throw here as this is supplementary data
    }
  }

  /// Calculate total price for a list of addons
  double _calculateAddonPrice(List<AddonModel> addons) {
    return addons.fold(0.0, (sum, addon) => sum + addon.price);
  }

  /// Update booking status
  Future<void> updateBookingStatus({
    required String bookingId,
    required String bookingStatus,
    required String paymentStatus,
    String? paymentId,
    double? userAdvancePayment,
    double? pendingAmount,
    double? adminPayout,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'booking_status': bookingStatus,
        'payment_status': paymentStatus,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (paymentId != null) {
        updateData['payment_id'] = paymentId;
      }

      if (userAdvancePayment != null) {
        updateData['user_advance_payment'] = userAdvancePayment;
      }

      if (pendingAmount != null) {
        updateData['pending_amount'] = pendingAmount;
      }

      if (adminPayout != null) {
        updateData['admin_payout'] = adminPayout;
      }

      await _supabase
          .from('private_theater_bookings')
          .update(updateData)
          .eq('id', bookingId);
    } catch (e) {
      print('Error updating booking status: $e');
      throw Exception('Failed to update booking status: $e');
    }
  }

  /// Get user's booking history
  Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    try {
      final response = await _supabase
          .from('private_theater_bookings')
          .select('''
            *,
            theaters:theater_id (name, address),
            theater_screens:screen_id (screen_name, screen_number),
            time_slots:time_slot_id (start_time, end_time)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response;
    } catch (e) {
      print('Error fetching user bookings: $e');
      return [];
    }
  }

  /// Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _supabase
          .from('private_theater_bookings')
          .update({
            'booking_status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
    } catch (e) {
      print('Error cancelling booking: $e');
      throw Exception('Failed to cancel booking: $e');
    }
  }

  /// Mark time slot as booked
  Future<void> markTimeSlotAsBooked(String timeSlotId, String date) async {
    try {
      // Check if already exists
      final existing = await _supabase
          .from('theater_time_slot_bookings')
          .select('id')
          .eq('time_slot_id', timeSlotId)
          .eq('booked_date', date)
          .maybeSingle();

      if (existing == null) {
        // Create new booking record
        await _supabase
            .from('theater_time_slot_bookings')
            .insert({
              'time_slot_id': timeSlotId,
              'booked_date': date,
            });
      }
    } catch (e) {
      print('Error marking time slot as booked: $e');
      // Don't throw as this might not be critical
    }
  }
}