import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/time_slot_model.dart';
import '../models/screen_package_model.dart';
import '../models/addon_model.dart';
import '../services/theater_screen_detail_service.dart';
import '../services/screen_package_service.dart';
import '../services/addon_service.dart';

// Service providers
final theaterScreenDetailServiceProvider = Provider<TheaterScreenDetailService>((ref) {
  return TheaterScreenDetailService();
});

final screenPackageServiceProvider = Provider<ScreenPackageService>((ref) {
  return ScreenPackageService();
});

final addonServiceProvider = Provider<AddonService>((ref) {
  return AddonService(Supabase.instance.client);
});

// Parameters class for better provider caching
class TimeSlotParams {
  final String screenId;
  final String date;

  const TimeSlotParams({
    required this.screenId,
    required this.date,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlotParams &&
        other.screenId == screenId &&
        other.date == date;
  }

  @override
  int get hashCode => screenId.hashCode ^ date.hashCode;
}

// Time slots provider for a specific screen and date - using proper parameter class
final timeSlotsByScreenProvider = FutureProvider.family<List<TimeSlotModel>, TimeSlotParams>((ref, params) async {
  final service = ref.read(theaterScreenDetailServiceProvider);
  return await service.getTimeSlotsByScreenAndDate(params.screenId, params.date);
});

// Check if a specific time slot is available
final timeSlotAvailabilityProvider = FutureProvider.family<bool, Map<String, String>>((ref, params) async {
  final service = ref.read(theaterScreenDetailServiceProvider);
  final timeSlotId = params['timeSlotId']!;
  final date = params['date']!;
  
  return await service.isTimeSlotAvailable(timeSlotId, date);
});

// Book a time slot
final bookTimeSlotProvider = FutureProvider.family<bool, Map<String, dynamic>>((ref, params) async {
  final service = ref.read(theaterScreenDetailServiceProvider);
  return await service.bookTimeSlot(params);
});

// Get booking history for a user
final userBookingHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.read(theaterScreenDetailServiceProvider);
  return await service.getUserBookingHistory();
});

// Screen packages provider for a specific screen
final screenPackagesProvider = FutureProvider.family<List<ScreenPackageModel>, String>((ref, screenId) async {
  final service = ref.read(screenPackageServiceProvider);
  return await service.getPackagesByScreenId(screenId);
});

// Featured packages provider
final featuredPackagesProvider = FutureProvider<List<ScreenPackageModel>>((ref) async {
  final service = ref.read(screenPackageServiceProvider);
  return await service.getFeaturedPackages(limit: 10);
});

// Package by ID provider
final packageByIdProvider = FutureProvider.family<ScreenPackageModel?, String>((ref, packageId) async {
  final service = ref.read(screenPackageServiceProvider);
  return await service.getPackageById(packageId);
});

// Addon providers
final addonsByIdsProvider = FutureProvider.family<List<AddonModel>, List<String>>((ref, addonIds) async {
  final service = ref.read(addonServiceProvider);
  return await service.getAddonsByIds(addonIds);
});

final addonByIdProvider = FutureProvider.family<AddonModel?, String>((ref, addonId) async {
  final service = ref.read(addonServiceProvider);
  return await service.getAddonById(addonId);
});

final addonsByTheaterProvider = FutureProvider.family<List<AddonModel>, String>((ref, theaterId) async {
  final service = ref.read(addonServiceProvider);
  return await service.getAddonsByTheaterId(theaterId);
});