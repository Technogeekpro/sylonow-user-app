import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';
import 'package:sylonow_user/features/address/screens/add_edit_address_screen.dart';

class ManageAddressScreen extends ConsumerStatefulWidget {
  const ManageAddressScreen({super.key});

  static const routeName = '/manage-address';

  @override
  ConsumerState<ManageAddressScreen> createState() =>
      _ManageAddressScreenState();
}

class _ManageAddressScreenState extends ConsumerState<ManageAddressScreen> {
  final _searchController = TextEditingController();
  bool _isLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  Future<void> _checkLocationStatus() async {
    final locationService = ref.read(locationServiceProvider);
    try {
      final permissionStatus = await locationService.getPermissionStatus();
      final serviceEnabled = await locationService.isLocationServiceEnabled();
      
      setState(() {
        _isLocationEnabled = serviceEnabled && 
            (permissionStatus == LocationPermission.whileInUse || 
             permissionStatus == LocationPermission.always);
      });
    } catch (e) {
      setState(() {
        _isLocationEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressesAsync = ref.watch(addressesProvider);
    final locationService = ref.watch(locationServiceProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Select a location',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for area, street name...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, color: Colors.pink[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Location Permission Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Location Permission Row
                    if (!_isLocationEnabled)
                      Row(
                        children: [
                          Icon(
                            Icons.location_searching,
                            color: Colors.pink[400],
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Device location not enabled',
                                  style: TextStyle(
                                    color: Colors.pink[400],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  'Tap here to enable your device location for a better experience',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await locationService.requestPermission();
                              _checkLocationStatus();
                            },
                            child: Text(
                              'Enable',
                              style: TextStyle(
                                color: Colors.pink[400],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (!_isLocationEnabled) const SizedBox(height: 16),
                    // Add Address Button
                    InkWell(
                      onTap: () => context.go(AddEditAddressScreen.routeName),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Colors.pink[400],
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Add Address',
                            style: TextStyle(
                              color: Colors.pink[400],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Saved Addresses Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Text(
                    'SAVED ADDRESSES',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  addressesAsync.when(
                    data: (addresses) => addresses.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                            onPressed: () {
                              // Navigate to edit addresses screen
                              context.go('/edit-addresses');
                            },
                          )
                        : const SizedBox(),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ),

            // Address List
            addressesAsync.when(
              data: (addresses) {
                if (addresses.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No saved addresses yet'),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      address.addressFor.toString().contains(
                                            'home',
                                          )
                                          ? Icons.home_outlined
                                          : Icons.work_outline,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      address.addressFor
                                          .toString()
                                          .split('.')
                                          .last
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  address.address,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                if (address.phoneNumber != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Phone number: ${address.phoneNumber}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
      ),
    );
  }
}
