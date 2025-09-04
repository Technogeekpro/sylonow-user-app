import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/core/providers/core_providers.dart' as core;
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import 'package:sylonow_user/features/theater/models/theater_model.dart';
import 'package:sylonow_user/features/theater/models/decoration_model.dart';
import 'package:sylonow_user/features/theater/models/occasion_model.dart';
import 'package:sylonow_user/features/theater/models/add_on_model.dart';
import 'package:sylonow_user/features/theater/models/special_service_model.dart';
import 'package:sylonow_user/features/theater/models/cake_model.dart';
import 'package:sylonow_user/features/theater/models/theater_time_slot_model.dart';
import 'package:sylonow_user/features/theater/models/theater_screen_model.dart';
import 'package:sylonow_user/features/theater/repositories/theater_repository.dart';
import 'package:sylonow_user/features/theater/models/theater_booking_model.dart';
import 'package:sylonow_user/features/theater/repositories/theater_booking_repository.dart';

// Repository provider
final theaterRepositoryProvider = Provider<TheaterRepository>((ref) {
  final supabase = ref.watch(core.supabaseClientProvider);
  return TheaterRepository(supabase);
});

// Theater list provider
final theatersProvider = FutureProvider<List<TheaterModel>>((ref) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaters();
});

// Theater by ID provider
final theaterByIdProvider = FutureProvider.family<TheaterModel?, String>((ref, id) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterById(id);
});

// Search theaters provider
final searchTheatersProvider = FutureProvider.family<List<TheaterModel>, String>((ref, query) async {
  if (query.isEmpty) return [];
  
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.searchTheaters(query);
});

// Nearby theaters provider
final nearbyTheatersProvider = FutureProvider.family<List<TheaterModel>, Map<String, double>>((ref, location) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getNearbyTheaters(
    latitude: location['latitude']!,
    longitude: location['longitude']!,
    radiusKm: location['radius'] ?? 10.0,
  );
});

// Individual theater provider
final theaterProvider = FutureProvider.family<TheaterModel?, String>((ref, theaterId) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterById(theaterId);
});

// Theater decorations provider
final theaterDecorationsProvider = FutureProvider.family<List<DecorationModel>, String>((ref, theaterId) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterDecorations(theaterId);
});

// Occasions provider
final occasionsProvider = FutureProvider<List<OccasionModel>>((ref) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getOccasions();
});

// Theater add-ons provider
final theaterAddOnsProvider = FutureProvider.family<List<AddOnModel>, String>((ref, theaterId) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterAddOns(theaterId);
});

// Special services provider
final specialServicesProvider = FutureProvider<List<SpecialServiceModel>>((ref) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getSpecialServices();
});

// Theater cakes provider
final theaterCakesProvider = FutureProvider.family<List<CakeModel>, String>((ref, theaterId) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterCakes(theaterId);
});

// Theater time slots provider (legacy)
final theaterTimeSlotsProvider = FutureProvider.family<List<TheaterSlotBookingModel>, Map<String, String>>((ref, params) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterTimeSlots(params['theaterId']!, params['date']!);
});

// ===== NEW SCREEN-BASED PROVIDERS =====

// Theater screens provider
final theaterScreensProvider = FutureProvider.family<List<TheaterScreenModel>, String>((ref, theaterId) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterScreens(theaterId);
});

// Theater time slots with automatic screen allocation provider  
final theaterTimeSlotsWithScreensProvider = FutureProvider.family.autoDispose<List<TheaterTimeSlotWithScreenModel>, String>((ref, key) async {
  final parts = key.split('|');
  final theaterId = parts[0];
  final date = parts[1];
  
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterTimeSlotsWithScreens(theaterId, date);
});

// Screen-specific time slots provider with availability checking
final screenTimeSlotsProvider = FutureProvider.family.autoDispose<List<Map<String, dynamic>>, String>((ref, key) async {
  final parts = key.split('|');
  final screenId = parts[0];
  final date = parts[1];
  
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getScreenTimeSlotsWithAvailability(screenId, date);
});

// Direct theater time slots provider with booking status from theater_time_slots table
final theaterTimeSlotsDirectProvider = FutureProvider.family.autoDispose<List<Map<String, dynamic>>, String>((ref, key) async {
  final parts = key.split('|');
  final theaterId = parts[0];
  final date = parts[1];
  
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheaterTimeSlotsDirectWithBookingStatus(theaterId, date);
});

// Theater booking selection state provider for managing the booking flow
final theaterBookingSelectionProvider = StateNotifierProvider<TheaterBookingSelectionNotifier, TheaterBookingSelectionState>((ref) {
  return TheaterBookingSelectionNotifier();
});

// Theater booking selection state class
class TheaterBookingSelectionState {
  final TheaterModel? selectedTheater;
  final TheaterTimeSlotWithScreenModel? selectedTimeSlot;
  final String? selectedDate;
  final List<OccasionModel> selectedOccasions;
  final List<DecorationModel> selectedDecorations;
  final List<AddOnModel> selectedAddOns;
  final List<SpecialServiceModel> selectedSpecialServices;
  final List<CakeModel> selectedCakes;
  final double totalAmount;
  final Map<String, dynamic> additionalData;

  const TheaterBookingSelectionState({
    this.selectedTheater,
    this.selectedTimeSlot,
    this.selectedDate,
    this.selectedOccasions = const [],
    this.selectedDecorations = const [],
    this.selectedAddOns = const [],
    this.selectedSpecialServices = const [],
    this.selectedCakes = const [],
    this.totalAmount = 0.0,
    this.additionalData = const {},
  });

  TheaterBookingSelectionState copyWith({
    TheaterModel? selectedTheater,
    TheaterTimeSlotWithScreenModel? selectedTimeSlot,
    String? selectedDate,
    List<OccasionModel>? selectedOccasions,
    List<DecorationModel>? selectedDecorations,
    List<AddOnModel>? selectedAddOns,
    List<SpecialServiceModel>? selectedSpecialServices,
    List<CakeModel>? selectedCakes,
    double? totalAmount,
    Map<String, dynamic>? additionalData,
  }) {
    return TheaterBookingSelectionState(
      selectedTheater: selectedTheater ?? this.selectedTheater,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedOccasions: selectedOccasions ?? this.selectedOccasions,
      selectedDecorations: selectedDecorations ?? this.selectedDecorations,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
      selectedSpecialServices: selectedSpecialServices ?? this.selectedSpecialServices,
      selectedCakes: selectedCakes ?? this.selectedCakes,
      totalAmount: totalAmount ?? this.totalAmount,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}

// Theater booking selection notifier
class TheaterBookingSelectionNotifier extends StateNotifier<TheaterBookingSelectionState> {
  TheaterBookingSelectionNotifier() : super(const TheaterBookingSelectionState());

  void setTheater(TheaterModel theater) {
    state = state.copyWith(selectedTheater: theater);
  }

  void setTimeSlot(TheaterTimeSlotWithScreenModel timeSlot) {
    state = state.copyWith(
      selectedTimeSlot: timeSlot,
      totalAmount: _calculateTotalAmount(),
    );
  }

  void setDate(String date) {
    state = state.copyWith(selectedDate: date);
  }

  void setOccasions(List<OccasionModel> occasions) {
    state = state.copyWith(
      selectedOccasions: occasions,
      totalAmount: _calculateTotalAmount(),
    );
  }

  void setDecorations(List<DecorationModel> decorations) {
    state = state.copyWith(
      selectedDecorations: decorations,
      totalAmount: _calculateTotalAmount(),
    );
  }

  void setAddOns(List<AddOnModel> addOns) {
    state = state.copyWith(
      selectedAddOns: addOns,
      totalAmount: _calculateTotalAmount(),
    );
  }

  void setSpecialServices(List<SpecialServiceModel> services) {
    state = state.copyWith(
      selectedSpecialServices: services,
      totalAmount: _calculateTotalAmount(),
    );
  }

  void setCakes(List<CakeModel> cakes) {
    state = state.copyWith(
      selectedCakes: cakes,
      totalAmount: _calculateTotalAmount(),
    );
  }

  void setAdditionalData(Map<String, dynamic> data) {
    state = state.copyWith(additionalData: {...state.additionalData, ...data});
  }

  void clearSelection() {
    state = const TheaterBookingSelectionState();
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    
    // Add time slot price
    if (state.selectedTimeSlot != null) {
      total += state.selectedTimeSlot!.basePrice;
    }
    
    // Add decorations
    for (final decoration in state.selectedDecorations) {
      total += decoration.price;
    }
    
    // Add add-ons
    for (final addOn in state.selectedAddOns) {
      total += addOn.price;
    }
    
    // Add special services
    for (final service in state.selectedSpecialServices) {
      total += service.price;
    }
    
    // Add cakes
    for (final cake in state.selectedCakes) {
      total += cake.price;
    }
    
    return total;
  }
}

// ===== THEATER BOOKING PROVIDERS =====

// Theater booking repository provider
final theaterBookingRepositoryProvider = Provider<TheaterBookingRepository>((ref) {
  final supabase = ref.watch(core.supabaseClientProvider);
  return TheaterBookingRepository(supabase);
});

// User theater bookings provider
final userTheaterBookingsProvider = FutureProvider<List<TheaterBookingModel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  final repository = ref.watch(theaterBookingRepositoryProvider);
  return repository.getUserTheaterBookings(user.id);
});

// Theater booking by ID provider
final theaterBookingByIdProvider = FutureProvider.family<TheaterBookingModel?, String>((ref, bookingId) async {
  final repository = ref.watch(theaterBookingRepositoryProvider);
  return repository.getTheaterBookingById(bookingId);
});

// Theater booking statistics provider
final theaterBookingStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return {};
  
  final repository = ref.watch(theaterBookingRepositoryProvider);
  return repository.getUserTheaterBookingStats(user.id);
});

// Theater booking cancellation notifier
class TheaterBookingCancellationNotifier extends StateNotifier<AsyncValue<void>> {
  final TheaterBookingRepository _repository;

  TheaterBookingCancellationNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> cancelBooking(String bookingId) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.cancelTheaterBooking(bookingId);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final theaterBookingCancellationProvider = StateNotifierProvider<TheaterBookingCancellationNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(theaterBookingRepositoryProvider);
  return TheaterBookingCancellationNotifier(repository);
});

// ===== DEBUG PROVIDERS =====

// Debug provider to get raw theater data
final debugTheatersRawProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(theaterRepositoryProvider);
  return repository.getTheatersRaw();
});

// Debug provider to create sample theater data
final debugCreateSampleTheatersProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(theaterRepositoryProvider);
  await repository.createSampleTheaterData();
});