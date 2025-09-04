import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sylonow_user/features/theater/models/add_on_model.dart';

part 'selected_add_on_model.freezed.dart';
part 'selected_add_on_model.g.dart';

@freezed
class SelectedAddOnModel with _$SelectedAddOnModel {
  const factory SelectedAddOnModel({
    required AddOnModel addOn,
    @Default(1) int quantity,
  }) = _SelectedAddOnModel;

  factory SelectedAddOnModel.fromJson(Map<String, dynamic> json) =>
      _$SelectedAddOnModelFromJson(json);
}

extension SelectedAddOnModelExtension on SelectedAddOnModel {
  double get totalPrice => addOn.price * quantity;
  String get id => addOn.id;
  String get name => addOn.name;
  String get category => addOn.category;
  String? get imageUrl => addOn.imageUrl;
}