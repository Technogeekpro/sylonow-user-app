import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_user/features/address/models/address_model.dart';

class AddressRepository {
  final SupabaseClient _supabaseClient;

  AddressRepository(this._supabaseClient);

  Future<List<Address>> getAddresses() async {
    final response = await _supabaseClient.from('addresses').select();
    return (response as List).map((e) => Address.fromJson(e)).toList();
  }

  Future<void> addAddress(Address address) async {
    await _supabaseClient.from('addresses').insert(address.toJson());
  }

  Future<void> updateAddress(Address address) async {
    await _supabaseClient
        .from('addresses')
        .update(address.toJson())
        .eq('id', address.id);
  }

  Future<void> deleteAddress(String id) async {
    await _supabaseClient.from('addresses').delete().eq('id', id);
  }
} 