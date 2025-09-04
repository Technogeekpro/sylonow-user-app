// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OnboardingDataModel _$OnboardingDataModelFromJson(Map<String, dynamic> json) {
  return _OnboardingDataModel.fromJson(json);
}

/// @nodoc
mixin _$OnboardingDataModel {
  String? get userName => throw _privateConstructorUsedError;
  String? get selectedOccasion => throw _privateConstructorUsedError;
  String? get celebrationDate => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OnboardingDataModelCopyWith<OnboardingDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingDataModelCopyWith<$Res> {
  factory $OnboardingDataModelCopyWith(
          OnboardingDataModel value, $Res Function(OnboardingDataModel) then) =
      _$OnboardingDataModelCopyWithImpl<$Res, OnboardingDataModel>;
  @useResult
  $Res call(
      {String? userName,
      String? selectedOccasion,
      String? celebrationDate,
      bool isCompleted});
}

/// @nodoc
class _$OnboardingDataModelCopyWithImpl<$Res, $Val extends OnboardingDataModel>
    implements $OnboardingDataModelCopyWith<$Res> {
  _$OnboardingDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = freezed,
    Object? selectedOccasion = freezed,
    Object? celebrationDate = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedOccasion: freezed == selectedOccasion
          ? _value.selectedOccasion
          : selectedOccasion // ignore: cast_nullable_to_non_nullable
              as String?,
      celebrationDate: freezed == celebrationDate
          ? _value.celebrationDate
          : celebrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingDataModelImplCopyWith<$Res>
    implements $OnboardingDataModelCopyWith<$Res> {
  factory _$$OnboardingDataModelImplCopyWith(_$OnboardingDataModelImpl value,
          $Res Function(_$OnboardingDataModelImpl) then) =
      __$$OnboardingDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? userName,
      String? selectedOccasion,
      String? celebrationDate,
      bool isCompleted});
}

/// @nodoc
class __$$OnboardingDataModelImplCopyWithImpl<$Res>
    extends _$OnboardingDataModelCopyWithImpl<$Res, _$OnboardingDataModelImpl>
    implements _$$OnboardingDataModelImplCopyWith<$Res> {
  __$$OnboardingDataModelImplCopyWithImpl(_$OnboardingDataModelImpl _value,
      $Res Function(_$OnboardingDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = freezed,
    Object? selectedOccasion = freezed,
    Object? celebrationDate = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_$OnboardingDataModelImpl(
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedOccasion: freezed == selectedOccasion
          ? _value.selectedOccasion
          : selectedOccasion // ignore: cast_nullable_to_non_nullable
              as String?,
      celebrationDate: freezed == celebrationDate
          ? _value.celebrationDate
          : celebrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingDataModelImpl implements _OnboardingDataModel {
  const _$OnboardingDataModelImpl(
      {this.userName,
      this.selectedOccasion,
      this.celebrationDate,
      this.isCompleted = false});

  factory _$OnboardingDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingDataModelImplFromJson(json);

  @override
  final String? userName;
  @override
  final String? selectedOccasion;
  @override
  final String? celebrationDate;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'OnboardingDataModel(userName: $userName, selectedOccasion: $selectedOccasion, celebrationDate: $celebrationDate, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingDataModelImpl &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.selectedOccasion, selectedOccasion) ||
                other.selectedOccasion == selectedOccasion) &&
            (identical(other.celebrationDate, celebrationDate) ||
                other.celebrationDate == celebrationDate) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userName, selectedOccasion, celebrationDate, isCompleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingDataModelImplCopyWith<_$OnboardingDataModelImpl> get copyWith =>
      __$$OnboardingDataModelImplCopyWithImpl<_$OnboardingDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingDataModelImplToJson(
      this,
    );
  }
}

abstract class _OnboardingDataModel implements OnboardingDataModel {
  const factory _OnboardingDataModel(
      {final String? userName,
      final String? selectedOccasion,
      final String? celebrationDate,
      final bool isCompleted}) = _$OnboardingDataModelImpl;

  factory _OnboardingDataModel.fromJson(Map<String, dynamic> json) =
      _$OnboardingDataModelImpl.fromJson;

  @override
  String? get userName;
  @override
  String? get selectedOccasion;
  @override
  String? get celebrationDate;
  @override
  bool get isCompleted;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingDataModelImplCopyWith<_$OnboardingDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OccasionOption _$OccasionOptionFromJson(Map<String, dynamic> json) {
  return _OccasionOption.fromJson(json);
}

/// @nodoc
mixin _$OccasionOption {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OccasionOptionCopyWith<OccasionOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OccasionOptionCopyWith<$Res> {
  factory $OccasionOptionCopyWith(
          OccasionOption value, $Res Function(OccasionOption) then) =
      _$OccasionOptionCopyWithImpl<$Res, OccasionOption>;
  @useResult
  $Res call({String id, String label, String emoji});
}

/// @nodoc
class _$OccasionOptionCopyWithImpl<$Res, $Val extends OccasionOption>
    implements $OccasionOptionCopyWith<$Res> {
  _$OccasionOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? emoji = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OccasionOptionImplCopyWith<$Res>
    implements $OccasionOptionCopyWith<$Res> {
  factory _$$OccasionOptionImplCopyWith(_$OccasionOptionImpl value,
          $Res Function(_$OccasionOptionImpl) then) =
      __$$OccasionOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String label, String emoji});
}

/// @nodoc
class __$$OccasionOptionImplCopyWithImpl<$Res>
    extends _$OccasionOptionCopyWithImpl<$Res, _$OccasionOptionImpl>
    implements _$$OccasionOptionImplCopyWith<$Res> {
  __$$OccasionOptionImplCopyWithImpl(
      _$OccasionOptionImpl _value, $Res Function(_$OccasionOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? emoji = null,
  }) {
    return _then(_$OccasionOptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OccasionOptionImpl implements _OccasionOption {
  const _$OccasionOptionImpl(
      {required this.id, required this.label, required this.emoji});

  factory _$OccasionOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$OccasionOptionImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final String emoji;

  @override
  String toString() {
    return 'OccasionOption(id: $id, label: $label, emoji: $emoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OccasionOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.emoji, emoji) || other.emoji == emoji));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, emoji);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OccasionOptionImplCopyWith<_$OccasionOptionImpl> get copyWith =>
      __$$OccasionOptionImplCopyWithImpl<_$OccasionOptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OccasionOptionImplToJson(
      this,
    );
  }
}

abstract class _OccasionOption implements OccasionOption {
  const factory _OccasionOption(
      {required final String id,
      required final String label,
      required final String emoji}) = _$OccasionOptionImpl;

  factory _OccasionOption.fromJson(Map<String, dynamic> json) =
      _$OccasionOptionImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  String get emoji;
  @override
  @JsonKey(ignore: true)
  _$$OccasionOptionImplCopyWith<_$OccasionOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
