import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

enum AddressType { home, work, hotel, other }

@freezed
class Address with _$Address {
  const factory Address({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'address_for') required AddressType addressFor,
    required String address,
    String? area,
    String? nearby,
    String? name,
    String? floor,
    @JsonKey(name: 'phone_number') String? phoneNumber,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
} 