// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater_booking_selection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TheaterBookingSelectionModel _$TheaterBookingSelectionModelFromJson(
    Map<String, dynamic> json) {
  return _TheaterBookingSelectionModel.fromJson(json);
}

/// @nodoc
mixin _$TheaterBookingSelectionModel {
  String get theaterId => throw _privateConstructorUsedError;
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  String? get selectedTimeSlot => throw _privateConstructorUsedError;
  DecorationModel? get selectedDecoration => throw _privateConstructorUsedError;
  OccasionModel? get selectedOccasion => throw _privateConstructorUsedError;
  List<AddOnModel> get selectedAddOns => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;

  /// Serializes this TheaterBookingSelectionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TheaterBookingSelectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TheaterBookingSelectionModelCopyWith<TheaterBookingSelectionModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterBookingSelectionModelCopyWith<$Res> {
  factory $TheaterBookingSelectionModelCopyWith(
          TheaterBookingSelectionModel value,
          $Res Function(TheaterBookingSelectionModel) then) =
      _$TheaterBookingSelectionModelCopyWithImpl<$Res,
          TheaterBookingSelectionModel>;
  @useResult
  $Res call(
      {String theaterId,
      DateTime? selectedDate,
      String? selectedTimeSlot,
      DecorationModel? selectedDecoration,
      OccasionModel? selectedOccasion,
      List<AddOnModel> selectedAddOns,
      double totalPrice});

  $DecorationModelCopyWith<$Res>? get selectedDecoration;
  $OccasionModelCopyWith<$Res>? get selectedOccasion;
}

/// @nodoc
class _$TheaterBookingSelectionModelCopyWithImpl<$Res,
        $Val extends TheaterBookingSelectionModel>
    implements $TheaterBookingSelectionModelCopyWith<$Res> {
  _$TheaterBookingSelectionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TheaterBookingSelectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theaterId = null,
    Object? selectedDate = freezed,
    Object? selectedTimeSlot = freezed,
    Object? selectedDecoration = freezed,
    Object? selectedOccasion = freezed,
    Object? selectedAddOns = null,
    Object? totalPrice = null,
  }) {
    return _then(_value.copyWith(
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedTimeSlot: freezed == selectedTimeSlot
          ? _value.selectedTimeSlot
          : selectedTimeSlot // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDecoration: freezed == selectedDecoration
          ? _value.selectedDecoration
          : selectedDecoration // ignore: cast_nullable_to_non_nullable
              as DecorationModel?,
      selectedOccasion: freezed == selectedOccasion
          ? _value.selectedOccasion
          : selectedOccasion // ignore: cast_nullable_to_non_nullable
              as OccasionModel?,
      selectedAddOns: null == selectedAddOns
          ? _value.selectedAddOns
          : selectedAddOns // ignore: cast_nullable_to_non_nullable
              as List<AddOnModel>,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of TheaterBookingSelectionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DecorationModelCopyWith<$Res>? get selectedDecoration {
    if (_value.selectedDecoration == null) {
      return null;
    }

    return $DecorationModelCopyWith<$Res>(_value.selectedDecoration!, (value) {
      return _then(_value.copyWith(selectedDecoration: value) as $Val);
    });
  }

  /// Create a copy of TheaterBookingSelectionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OccasionModelCopyWith<$Res>? get selectedOccasion {
    if (_value.selectedOccasion == null) {
      return null;
    }

    return $OccasionModelCopyWith<$Res>(_value.selectedOccasion!, (value) {
      return _then(_value.copyWith(selectedOccasion: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TheaterBookingSelectionModelImplCopyWith<$Res>
    implements $TheaterBookingSelectionModelCopyWith<$Res> {
  factory _$$TheaterBookingSelectionModelImplCopyWith(
          _$TheaterBookingSelectionModelImpl value,
          $Res Function(_$TheaterBookingSelectionModelImpl) then) =
      __$$TheaterBookingSelectionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String theaterId,
      DateTime? selectedDate,
      String? selectedTimeSlot,
      DecorationModel? selectedDecoration,
      OccasionModel? selectedOccasion,
      List<AddOnModel> selectedAddOns,
      double totalPrice});

  @override
  $DecorationModelCopyWith<$Res>? get selectedDecoration;
  @override
  $OccasionModelCopyWith<$Res>? get selectedOccasion;
}

/// @nodoc
class __$$TheaterBookingSelectionModelImplCopyWithImpl<$Res>
    extends _$TheaterBookingSelectionModelCopyWithImpl<$Res,
        _$TheaterBookingSelectionModelImpl>
    implements _$$TheaterBookingSelectionModelImplCopyWith<$Res> {
  __$$TheaterBookingSelectionModelImplCopyWithImpl(
      _$TheaterBookingSelectionModelImpl _value,
      $Res Function(_$TheaterBookingSelectionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TheaterBookingSelectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theaterId = null,
    Object? selectedDate = freezed,
    Object? selectedTimeSlot = freezed,
    Object? selectedDecoration = freezed,
    Object? selectedOccasion = freezed,
    Object? selectedAddOns = null,
    Object? totalPrice = null,
  }) {
    return _then(_$TheaterBookingSelectionModelImpl(
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedTimeSlot: freezed == selectedTimeSlot
          ? _value.selectedTimeSlot
          : selectedTimeSlot // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDecoration: freezed == selectedDecoration
          ? _value.selectedDecoration
          : selectedDecoration // ignore: cast_nullable_to_non_nullable
              as DecorationModel?,
      selectedOccasion: freezed == selectedOccasion
          ? _value.selectedOccasion
          : selectedOccasion // ignore: cast_nullable_to_non_nullable
              as OccasionModel?,
      selectedAddOns: null == selectedAddOns
          ? _value._selectedAddOns
          : selectedAddOns // ignore: cast_nullable_to_non_nullable
              as List<AddOnModel>,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TheaterBookingSelectionModelImpl
    implements _TheaterBookingSelectionModel {
  const _$TheaterBookingSelectionModelImpl(
      {required this.theaterId,
      this.selectedDate,
      this.selectedTimeSlot,
      this.selectedDecoration,
      this.selectedOccasion,
      final List<AddOnModel> selectedAddOns = const [],
      this.totalPrice = 0.0})
      : _selectedAddOns = selectedAddOns;

  factory _$TheaterBookingSelectionModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TheaterBookingSelectionModelImplFromJson(json);

  @override
  final String theaterId;
  @override
  final DateTime? selectedDate;
  @override
  final String? selectedTimeSlot;
  @override
  final DecorationModel? selectedDecoration;
  @override
  final OccasionModel? selectedOccasion;
  final List<AddOnModel> _selectedAddOns;
  @override
  @JsonKey()
  List<AddOnModel> get selectedAddOns {
    if (_selectedAddOns is EqualUnmodifiableListView) return _selectedAddOns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedAddOns);
  }

  @override
  @JsonKey()
  final double totalPrice;

  @override
  String toString() {
    return 'TheaterBookingSelectionModel(theaterId: $theaterId, selectedDate: $selectedDate, selectedTimeSlot: $selectedTimeSlot, selectedDecoration: $selectedDecoration, selectedOccasion: $selectedOccasion, selectedAddOns: $selectedAddOns, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterBookingSelectionModelImpl &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.selectedTimeSlot, selectedTimeSlot) ||
                other.selectedTimeSlot == selectedTimeSlot) &&
            (identical(other.selectedDecoration, selectedDecoration) ||
                other.selectedDecoration == selectedDecoration) &&
            (identical(other.selectedOccasion, selectedOccasion) ||
                other.selectedOccasion == selectedOccasion) &&
            const DeepCollectionEquality()
                .equals(other._selectedAddOns, _selectedAddOns) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      theaterId,
      selectedDate,
      selectedTimeSlot,
      selectedDecoration,
      selectedOccasion,
      const DeepCollectionEquality().hash(_selectedAddOns),
      totalPrice);

  /// Create a copy of TheaterBookingSelectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterBookingSelectionModelImplCopyWith<
          _$TheaterBookingSelectionModelImpl>
      get copyWith => __$$TheaterBookingSelectionModelImplCopyWithImpl<
          _$TheaterBookingSelectionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterBookingSelectionModelImplToJson(
      this,
    );
  }
}

abstract class _TheaterBookingSelectionModel
    implements TheaterBookingSelectionModel {
  const factory _TheaterBookingSelectionModel(
      {required final String theaterId,
      final DateTime? selectedDate,
      final String? selectedTimeSlot,
      final DecorationModel? selectedDecoration,
      final OccasionModel? selectedOccasion,
      final List<AddOnModel> selectedAddOns,
      final double totalPrice}) = _$TheaterBookingSelectionModelImpl;

  factory _TheaterBookingSelectionModel.fromJson(Map<String, dynamic> json) =
      _$TheaterBookingSelectionModelImpl.fromJson;

  @override
  String get theaterId;
  @override
  DateTime? get selectedDate;
  @override
  String? get selectedTimeSlot;
  @override
  DecorationModel? get selectedDecoration;
  @override
  OccasionModel? get selectedOccasion;
  @override
  List<AddOnModel> get selectedAddOns;
  @override
  double get totalPrice;

  /// Create a copy of TheaterBookingSelectionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TheaterBookingSelectionModelImplCopyWith<
          _$TheaterBookingSelectionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
