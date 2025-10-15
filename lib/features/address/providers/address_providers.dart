import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:sylonow_user/features/address/models/address_model.dart';
import 'package:sylonow_user/features/address/repositories/address_repository.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AddressRepository(supabaseClient);
});

final addressesProvider = FutureProvider<List<Address>>((ref) async {
  final addressRepository = ref.watch(addressRepositoryProvider);
  return addressRepository.getAddresses();
});

final selectedAddressProvider = StateProvider<Address?>((ref) => null);

// Provider to trigger location refresh
final locationRefreshProvider = StateProvider<int>((ref) => 0);

final currentLocationAddressProvider = FutureProvider<String>((ref) async {
  // Watch the refresh trigger to invalidate when needed
  ref.watch(locationRefreshProvider);
  
  final locationService = ref.watch(locationServiceProvider);
  final position = await locationService.getCurrentLocation();
  if (position != null) {
    return locationService.getAddressFromLatLng(position);
  } else {
    return 'Select Location';
  }
});

// Helper function to refresh location
void refreshLocation(WidgetRef ref) {
  ref.read(locationRefreshProvider.notifier).state++;
} 