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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        elevation: 0,
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
                    _buildSectionTitle('Personal Information'),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildSectionTitle('Address Details'),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Street Address',
                      hint: 'House number, street name',
                      validator: (value) => value!.isEmpty ? 'Please enter your street address' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _areaController,
                      label: 'Area / Locality',
                      hint: 'Sector, locality or area',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nearbyController,
                      label: 'Nearby Landmark',
                      hint: 'Any landmark nearby (optional)',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _floorController,
                      label: 'Floor / Building',
                      hint: 'Apartment, floor, building (optional)',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Contact Number',
                      hint: 'Phone number for delivery contact',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),
                    
                    _buildSectionTitle('Address Type'),
                    _buildAddressTypeSelector(),
                    const SizedBox(height: 32),
                    
                    _buildLocationButton(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Okra',
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildAddressTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: AddressType.values.map((type) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _addressType = type;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _addressType == type 
                      ? Theme.of(context).primaryColor 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      type == AddressType.home 
                          ? Icons.home_outlined 
                          : type == AddressType.work 
                              ? Icons.work_outline 
                              : Icons.location_on_outlined,
                      color: _addressType == type ? Colors.white : Colors.grey[700],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type.toString().split('.').last.capitalize(),
                      style: TextStyle(
                        color: _addressType == type ? Colors.white : Colors.grey[700],
                        fontWeight: _addressType == type ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLocationButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
        elevation: 0,
      ),
      onPressed: _fetchCurrentLocation,
      icon: const Icon(Icons.my_location),
      label: const Text('Use Current Location'),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveAddress,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1581C6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  _isEditing ? 'Update Address' : 'Save Address',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Okra',
                  ),
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