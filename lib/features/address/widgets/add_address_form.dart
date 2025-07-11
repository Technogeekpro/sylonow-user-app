import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/features/address/models/address_model.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';
import 'package:sylonow_user/features/auth/providers/auth_providers.dart';
import 'package:uuid/uuid.dart';

class AddAddressForm extends ConsumerStatefulWidget {
  const AddAddressForm({super.key});

  @override
  ConsumerState<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends ConsumerState<AddAddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _areaController = TextEditingController();
  final _nearbyController = TextEditingController();
  final _nameController = TextEditingController();
  final _floorController = TextEditingController();
  final _phoneController = TextEditingController();
  AddressType _addressType = AddressType.home;

  @override
  void dispose() {
    _addressController.dispose();
    _areaController.dispose();
    _nearbyController.dispose();
    _nameController.dispose();
    _floorController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        final newAddress = Address(
          id: const Uuid().v4(),
          userId: user.id,
          addressFor: _addressType,
          address: _addressController.text,
          area: _areaController.text,
          nearby: _nearbyController.text,
          name: _nameController.text,
          floor: _floorController.text,
          phoneNumber: _phoneController.text,
        );
        ref.read(addressRepositoryProvider).addAddress(newAddress).then((_) {
          ref.refresh(addressesProvider);
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Address')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an address' : null,
              ),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: 'Area'),
              ),
              TextFormField(
                controller: _nearbyController,
                decoration: const InputDecoration(labelText: 'Nearby Landmark'),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _floorController,
                decoration: const InputDecoration(labelText: 'Floor'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              DropdownButtonFormField<AddressType>(
                value: _addressType,
                decoration: const InputDecoration(labelText: 'Address For'),
                items: AddressType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _addressType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 