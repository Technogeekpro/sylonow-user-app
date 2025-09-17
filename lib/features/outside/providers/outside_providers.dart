import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/theater_screen_model.dart';
import '../models/addon_model.dart';
import '../services/theater_service.dart';
import '../services/addon_service.dart';
import '../../theater/providers/theater_providers.dart' as theater;

// Service providers
final theaterServiceProvider = Provider<TheaterService>((ref) {
  return TheaterService();
});

final addonServiceProvider = Provider<AddonService>((ref) {
  return AddonService(Supabase.instance.client);
});

// Theater screen provider (single screen by ID)
final theaterScreenProvider = FutureProvider.family<TheaterScreen?, String>((ref, screenId) async {
  final service = ref.read(theaterServiceProvider);
  final screens = await service.fetchTheaterScreensWithPricing();

  try {
    return screens.firstWhere((screen) => screen.id == screenId);
  } catch (e) {
    return null;
  }
});

// Add-ons provider
final addOnsProvider = FutureProvider<List<AddonModel>>((ref) async {
  final service = ref.read(addonServiceProvider);
  return await service.getActiveAddons();
});

// Add-ons by IDs provider
final addonsByIdsProvider = FutureProvider.family<List<AddonModel>, List<String>>((ref, addonIds) async {
  final service = ref.read(addonServiceProvider);
  return await service.getAddonsByIds(addonIds);
});

// Re-export commonly used providers from theater
final occasionsProvider = theater.occasionsProvider;
final specialServicesProvider = theater.specialServicesProvider;