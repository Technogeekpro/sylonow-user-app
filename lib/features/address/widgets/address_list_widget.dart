import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_user/features/address/providers/address_providers.dart';
import 'package:sylonow_user/features/address/widgets/add_address_form.dart';

class AddressListWidget extends ConsumerWidget {
  final ScrollController scrollController;
  const AddressListWidget({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    return addressesAsync.when(
      data: (addresses) {
        return ListView.builder(
          controller: scrollController,
          itemCount: addresses.length + 1,
          itemBuilder: (context, index) {
            if (index == addresses.length) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddAddressForm(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Address'),
                ),
              );
            }
            final address = addresses[index];
            return ListTile(
              title: Text(address.name ?? 'Unnamed'),
              subtitle: Text(address.address),
              onTap: () {
                ref.read(selectedAddressProvider.notifier).state = address;
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
} 