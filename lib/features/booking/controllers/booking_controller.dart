import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../repositories/booking_repository.dart';
import '../providers/booking_providers.dart';

class BookingController extends StateNotifier<AsyncValue<void>> {
  final BookingRepository _repository;

  BookingController(this._repository) : super(const AsyncValue.data(null));

  Future<void> cancelBooking(String bookingId) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateBookingStatus(
        bookingId: bookingId,
        status: 'cancelled',
      );
      
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> confirmBooking(String bookingId) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateBookingStatus(
        bookingId: bookingId,
        status: 'confirmed',
        vendorConfirmation: true,
        confirmedAt: DateTime.now(),
      );
      
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> completeBooking(String bookingId) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateBookingStatus(
        bookingId: bookingId,
        status: 'completed',
        completedAt: DateTime.now(),
      );
      
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

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
    state = const AsyncValue.loading();

    try {
      final booking = await _repository.createBooking(
        userId: userId,
        vendorId: vendorId,
        serviceListingId: serviceListingId,
        serviceTitle: serviceTitle,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        customerName: customerName,
        customerPhone: customerPhone,
        venueAddress: venueAddress,
        totalAmount: totalAmount,
        serviceDescription: serviceDescription,
        customerEmail: customerEmail,
        venueCoordinates: venueCoordinates,
        specialRequirements: specialRequirements,
        addOns: addOns,
      );
      
      state = const AsyncValue.data(null);
      return booking;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final bookingControllerProvider = StateNotifierProvider<BookingController, AsyncValue<void>>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return BookingController(repository);
});