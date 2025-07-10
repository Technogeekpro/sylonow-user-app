// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressImpl _$$AddressImplFromJson(Map<String, dynamic> json) =>
    _$AddressImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      addressFor: $enumDecode(_$AddressTypeEnumMap, json['address_for']),
      address: json['address'] as String,
      area: json['area'] as String?,
      nearby: json['nearby'] as String?,
      name: json['name'] as String?,
      floor: json['floor'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );

Map<String, dynamic> _$$AddressImplToJson(_$AddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'address_for': _$AddressTypeEnumMap[instance.addressFor]!,
      'address': instance.address,
      'area': instance.area,
      'nearby': instance.nearby,
      'name': instance.name,
      'floor': instance.floor,
      'phone_number': instance.phoneNumber,
    };

const _$AddressTypeEnumMap = {
  AddressType.home: 'home',
  AddressType.work: 'work',
  AddressType.hotel: 'hotel',
  AddressType.other: 'other',
};
