import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sylonow_user/features/theater/models/decoration_model.dart';
import 'package:sylonow_user/features/theater/models/occasion_model.dart';
import 'package:sylonow_user/features/theater/models/add_on_model.dart';

part 'theater_booking_selection_model.freezed.dart';
part 'theater_booking_selection_model.g.dart';

@freezed
class TheaterBookingSelectionModel with _$TheaterBookingSelectionModel {
  const factory TheaterBookingSelectionModel({
    required String theaterId,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    DecorationModel? selectedDecoration,
    OccasionModel? selectedOccasion,
    @Default([]) List<AddOnModel> selectedAddOns,
    @Default(0.0) double totalPrice,
  }) = _TheaterBookingSelectionModel;

  factory TheaterBookingSelectionModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterBookingSelectionModelFromJson(json);
}