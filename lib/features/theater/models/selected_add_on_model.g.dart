// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_add_on_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SelectedAddOnModelImpl _$$SelectedAddOnModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SelectedAddOnModelImpl(
      addOn: AddOnModel.fromJson(json['addOn'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$SelectedAddOnModelImplToJson(
        _$SelectedAddOnModelImpl instance) =>
    <String, dynamic>{
      'addOn': instance.addOn,
      'quantity': instance.quantity,
    };
