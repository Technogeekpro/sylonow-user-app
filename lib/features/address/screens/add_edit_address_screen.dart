import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_user/core/providers/core_providers.dart';
import 'package:sylonow_user/features/address/models/address_model.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import 'package:uuid/uuid.dart';

class AddEditAddressScreen extends ConsumerStatefulWidget {
  const AddEditAddressScreen({super.key, this.addressId});

  final String? addressId;
  static const routeName = '/add-edit-address';

  @override
  ConsumerState<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends ConsumerState<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _areaController = TextEditingController();
  final _nearbyController = TextEditingController();
  final _floorController = TextEditingController();
  final _phoneController = TextEditingController();
  AddressType _addressType = AddressType.home;
  bool _isLoading = false;
  Address? _existingAddress;
  bool get _isEditing => widget.addressId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadExistingAddress();
    }
  }

  Future<void> _loadExistingAddress() async {
    if (widget.addressId == null) return;
    
    setState(() => _isLoading = true);
    try {
      final addresses = await ref.read(addressesProvider.future);
      _existingAddress = addresses.firstWhere(
        (address) => address.id == widget.addressId,
        orElse: () => throw Exception('Address not found'),
      );
      
      _nameController.text = _existingAddress?.name ?? '';
      _addressController.text = _existingAddress?.address ?? '';
      _areaController.text = _existingAddress?.area ?? '';
      _nearbyController.text = _existingAddress?.nearby ?? '';
      _floorController.text = _existingAddress?.floor ?? '';
      _phoneController.text = _existingAddress?.phoneNumber ?? '';
      _addressType = _existingAddress?.addressFor ?? AddressType.home;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading address: $e')),
        );
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _nearbyController.dispose();
    _floorController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          _addressController.text = '${p.street}, ${p.subLocality}';
          _areaController.text = p.locality ?? '';
          _nearbyController.text = p.subAdministrativeArea ?? '';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching location: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = ref.read(currentUserProvider);
        if (user == null) {
          throw Exception('User not logged in');
        }

        final address = Address(
          id: _isEditing ? widget.addressId! : const Uuid().v4(),
          userId: user.id,
          name: _nameController.text,
          address: _addressController.text,
          area: _areaController.text,
          nearby: _nearbyController.text,
          floor: _floorController.text,
          phoneNumber: _phoneController.text,
          addressFor: _addressType,
        );

        if (_isEditing) {
          await ref.read(addressRepositoryProvider).updateAddress(address);
        } else {
          await ref.read(addressRepositoryProvider).addAddress(address);
        }

        ref.invalidate(addressesProvider);

        if (mounted) {
          context.pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving address: $e')));
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Address' : 'Add New Address'),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name (e.g., John Doe)'),
                      validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address (House No, Street)'),
                      validator: (value) => value!.isEmpty ? 'Please enter an address' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _areaController,
                      decoration: const InputDecoration(labelText: 'Area / Sector / Locality'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nearbyController,
                      decoration: const InputDecoration(labelText: 'Nearby Landmark (Optional)'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _floorController,
                      decoration: const InputDecoration(labelText: 'Floor / Building (Optional)'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<AddressType>(
                      value: _addressType,
                      onChanged: (value) {
                        setState(() {
                          _addressType = value!;
                        });
                      },
                      items: AddressType.values
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.toString().split('.').last.capitalize()),
                              ))
                          .toList(),
                      decoration: const InputDecoration(labelText: 'Address Type'),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _fetchCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Use Current Location'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveAddress,
                      child: Text(_isEditing ? 'Update Address' : 'Save Address'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
} 