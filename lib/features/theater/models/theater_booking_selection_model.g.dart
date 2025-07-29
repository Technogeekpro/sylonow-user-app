// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_booking_selection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TheaterBookingSelectionModelImpl _$$TheaterBookingSelectionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TheaterBookingSelectionModelImpl(
      theaterId: json['theaterId'] as String,
      selectedDate: json['selectedDate'] == null
          ? null
          : DateTime.parse(json['selectedDate'] as String),
      selectedTimeSlot: json['selectedTimeSlot'] as String?,
      selectedDecoration: json['selectedDecoration'] == null
          ? null
          : DecorationModel.fromJson(
              json['selectedDecoration'] as Map<String, dynamic>),
      selectedOccasion: json['selectedOccasion'] == null
          ? null
          : OccasionModel.fromJson(
              json['selectedOccasion'] as Map<String, dynamic>),
      selectedAddOns: (json['selectedAddOns'] as List<dynamic>?)
              ?.map((e) => AddOnModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TheaterBookingSelectionModelImplToJson(
        _$TheaterBookingSelectionModelImpl instance) =>
    <String, dynamic>{
      'theaterId': instance.theaterId,
      'selectedDate': instance.selectedDate?.toIso8601String(),
      'selectedTimeSlot': instance.selectedTimeSlot,
      'selectedDecoration': instance.selectedDecoration,
      'selectedOccasion': instance.selectedOccasion,
      'selectedAddOns': instance.selectedAddOns,
      'totalPrice': instance.totalPrice,
    };
