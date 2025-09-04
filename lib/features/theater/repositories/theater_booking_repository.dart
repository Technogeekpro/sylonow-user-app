import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/theater_booking_model.dart';

class TheaterBookingRepository {
  final SupabaseClient _supabase;

  TheaterBookingRepository(this._supabase);

  /// Get user's theater booking history
  Future<List<TheaterBookingModel>> getUserTheaterBookings(String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('private_theater_bookings')
          .select('''
            *,
            private_theaters!inner(
              name,
              address,
              images
            ),
            private_theater_booking_addons(
              *,
              add_ons(
                name,
                description,
                image_url,
                category
              )
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List).map((data) {
        // Transform the nested data structure
        final theaterData = data['private_theaters'] as Map<String, dynamic>?;
        final addonsData = data['private_theater_booking_addons'] as List<dynamic>?;
        
        // Transform addons data
        List<TheaterBookingAddonModel> addons = [];
        if (addonsData != null) {
          addons = addonsData.map((addonData) {
            final addonInfo = addonData['add_ons'] as Map<String, dynamic>?;
            return TheaterBookingAddonModel(
              id: addonData['id'],
              bookingId: addonData['booking_id'],
              addonId: addonData['addon_id'],
              quantity: addonData['quantity'],
              unitPrice: (addonData['unit_price'] as num).toDouble(),
              totalPrice: (addonData['total_price'] as num).toDouble(),
              createdAt: addonData['created_at'] != null 
                  ? DateTime.parse(addonData['created_at']) 
                  : null,
              addonName: addonInfo?['name'],
              addonDescription: addonInfo?['description'],
              addonImageUrl: addonInfo?['image_url'],
              addonCategory: addonInfo?['category'],
            );
          }).toList();
        }

        return TheaterBookingModel(
          id: data['id'],
          theaterId: data['theater_id'],
          timeSlotId: data['time_slot_id'],
          userId: data['user_id'],
          bookingDate: DateTime.parse(data['booking_date']),
          startTime: data['start_time'],
          endTime: data['end_time'],
          totalAmount: (data['total_amount'] as num).toDouble(),
          paymentStatus: data['payment_status'],
          paymentId: data['payment_id'],
          bookingStatus: data['booking_status'],
          guestCount: data['guest_count'],
          specialRequests: data['special_requests'],
          contactName: data['contact_name'],
          contactPhone: data['contact_phone'],
          contactEmail: data['contact_email'],
          celebrationName: data['celebration_name'],
          numberOfPeople: data['number_of_people'],
          createdAt: data['created_at'] != null 
              ? DateTime.parse(data['created_at']) 
              : null,
          updatedAt: data['updated_at'] != null 
              ? DateTime.parse(data['updated_at']) 
              : null,
          vendorId: data['vendor_id'],
          theaterName: theaterData?['name'],
          theaterAddress: theaterData?['address'],
          theaterImages: theaterData?['images'] != null 
              ? List<String>.from(theaterData!['images']) 
              : null,
          addons: addons,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get user theater bookings: $e');
    }
  }

  /// Get theater booking by ID
  Future<TheaterBookingModel?> getTheaterBookingById(String bookingId) async {
    try {
      final response = await _supabase
          .from('private_theater_bookings')
          .select('''
            *,
            private_theaters!inner(
              name,
              address,
              images
            ),
            private_theater_booking_addons(
              *,
              add_ons(
                name,
                description,
                image_url,
                category
              )
            )
          ''')
          .eq('id', bookingId)
          .maybeSingle();

      if (response == null) return null;

      // Transform the nested data structure
      final theaterData = response['private_theaters'] as Map<String, dynamic>?;
      final addonsData = response['private_theater_booking_addons'] as List<dynamic>?;
      
      // Transform addons data
      List<TheaterBookingAddonModel> addons = [];
      if (addonsData != null) {
        addons = addonsData.map((addonData) {
          final addonInfo = addonData['add_ons'] as Map<String, dynamic>?;
          return TheaterBookingAddonModel(
            id: addonData['id'],
            bookingId: addonData['booking_id'],
            addonId: addonData['addon_id'],
            quantity: addonData['quantity'],
            unitPrice: (addonData['unit_price'] as num).toDouble(),
            totalPrice: (addonData['total_price'] as num).toDouble(),
            createdAt: addonData['created_at'] != null 
                ? DateTime.parse(addonData['created_at']) 
                : null,
            addonName: addonInfo?['name'],
            addonDescription: addonInfo?['description'],
            addonImageUrl: addonInfo?['image_url'],
            addonCategory: addonInfo?['category'],
          );
        }).toList();
      }

      return TheaterBookingModel(
        id: response['id'],
        theaterId: response['theater_id'],
        timeSlotId: response['time_slot_id'],
        userId: response['user_id'],
        bookingDate: DateTime.parse(response['booking_date']),
        startTime: response['start_time'],
        endTime: response['end_time'],
        totalAmount: (response['total_amount'] as num).toDouble(),
        paymentStatus: response['payment_status'],
        paymentId: response['payment_id'],
        bookingStatus: response['booking_status'],
        guestCount: response['guest_count'],
        specialRequests: response['special_requests'],
        contactName: response['contact_name'],
        contactPhone: response['contact_phone'],
        contactEmail: response['contact_email'],
        celebrationName: response['celebration_name'],
        numberOfPeople: response['number_of_people'],
        createdAt: response['created_at'] != null 
            ? DateTime.parse(response['created_at']) 
            : null,
        updatedAt: response['updated_at'] != null 
            ? DateTime.parse(response['updated_at']) 
            : null,
        vendorId: response['vendor_id'],
        theaterName: theaterData?['name'],
        theaterAddress: theaterData?['address'],
        theaterImages: theaterData?['images'] != null 
            ? List<String>.from(theaterData!['images']) 
            : null,
        addons: addons,
      );
    } catch (e) {
      throw Exception('Failed to get theater booking: $e');
    }
  }

  /// Cancel a theater booking
  Future<void> cancelTheaterBooking(String bookingId) async {
    try {
      await _supabase
          .from('private_theater_bookings')
          .update({
            'booking_status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
    } catch (e) {
      throw Exception('Failed to cancel theater booking: $e');
    }
  }

  /// Get theater booking statistics for user
  Future<Map<String, dynamic>> getUserTheaterBookingStats(String userId) async {
    try {
      final response = await _supabase
          .from('private_theater_bookings')
          .select('booking_status, payment_status, total_amount')
          .eq('user_id', userId);

      int totalBookings = 0;
      int confirmedBookings = 0;
      int completedBookings = 0;
      int cancelledBookings = 0;
      double totalSpent = 0.0;

      for (final booking in response as List) {
        totalBookings++;
        totalSpent += (booking['total_amount'] as num).toDouble();
        
        switch (booking['booking_status']) {
          case 'confirmed':
            confirmedBookings++;
            break;
          case 'completed':
            completedBookings++;
            break;
          case 'cancelled':
            cancelledBookings++;
            break;
        }
      }

      return {
        'totalBookings': totalBookings,
        'confirmedBookings': confirmedBookings,
        'completedBookings': completedBookings,
        'cancelledBookings': cancelledBookings,
        'totalSpent': totalSpent,
      };
    } catch (e) {
      throw Exception('Failed to get theater booking stats: $e');
    }
  }
}
