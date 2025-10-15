// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_add_on_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SelectedAddOnModel _$SelectedAddOnModelFromJson(Map<String, dynamic> json) {
  return _SelectedAddOnModel.fromJson(json);
}

/// @nodoc
mixin _$SelectedAddOnModel {
  AddOnModel get addOn => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SelectedAddOnModelCopyWith<SelectedAddOnModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedAddOnModelCopyWith<$Res> {
  factory $SelectedAddOnModelCopyWith(
          SelectedAddOnModel value, $Res Function(SelectedAddOnModel) then) =
      _$SelectedAddOnModelCopyWithImpl<$Res, SelectedAddOnModel>;
  @useResult
  $Res call({AddOnModel addOn, int quantity});

  $AddOnModelCopyWith<$Res> get addOn;
}

/// @nodoc
class _$SelectedAddOnModelCopyWithImpl<$Res, $Val extends SelectedAddOnModel>
    implements $SelectedAddOnModelCopyWith<$Res> {
  _$SelectedAddOnModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addOn = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      addOn: null == addOn
          ? _value.addOn
          : addOn // ignore: cast_nullable_to_non_nullable
              as AddOnModel,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AddOnModelCopyWith<$Res> get addOn {
    return $AddOnModelCopyWith<$Res>(_value.addOn, (value) {
      return _then(_value.copyWith(addOn: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SelectedAddOnModelImplCopyWith<$Res>
    implements $SelectedAddOnModelCopyWith<$Res> {
  factory _$$SelectedAddOnModelImplCopyWith(_$SelectedAddOnModelImpl value,
          $Res Function(_$SelectedAddOnModelImpl) then) =
      __$$SelectedAddOnModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AddOnModel addOn, int quantity});

  @override
  $AddOnModelCopyWith<$Res> get addOn;
}

/// @nodoc
class __$$SelectedAddOnModelImplCopyWithImpl<$Res>
    extends _$SelectedAddOnModelCopyWithImpl<$Res, _$SelectedAddOnModelImpl>
    implements _$$SelectedAddOnModelImplCopyWith<$Res> {
  __$$SelectedAddOnModelImplCopyWithImpl(_$SelectedAddOnModelImpl _value,
      $Res Function(_$SelectedAddOnModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addOn = null,
    Object? quantity = null,
  }) {
    return _then(_$SelectedAddOnModelImpl(
      addOn: null == addOn
          ? _value.addOn
          : addOn // ignore: cast_nullable_to_non_nullable
              as AddOnModel,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectedAddOnModelImpl implements _SelectedAddOnModel {
  const _$SelectedAddOnModelImpl({required this.addOn, this.quantity = 1});

  factory _$SelectedAddOnModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectedAddOnModelImplFromJson(json);

  @override
  final AddOnModel addOn;
  @override
  @JsonKey()
  final int quantity;

  @override
  String toString() {
    return 'SelectedAddOnModel(addOn: $addOn, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedAddOnModelImpl &&
            (identical(other.addOn, addOn) || other.addOn == addOn) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, addOn, quantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedAddOnModelImplCopyWith<_$SelectedAddOnModelImpl> get copyWith =>
      __$$SelectedAddOnModelImplCopyWithImpl<_$SelectedAddOnModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectedAddOnModelImplToJson(
      this,
    );
  }
}

abstract class _SelectedAddOnModel implements SelectedAddOnModel {
  const factory _SelectedAddOnModel(
      {required final AddOnModel addOn,
      final int quantity}) = _$SelectedAddOnModelImpl;

  factory _SelectedAddOnModel.fromJson(Map<String, dynamic> json) =
      _$SelectedAddOnModelImpl.fromJson;

  @override
  AddOnModel get addOn;
  @override
  int get quantity;
  @override
  @JsonKey(ignore: true)
  _$$SelectedAddOnModelImplCopyWith<_$SelectedAddOnModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
