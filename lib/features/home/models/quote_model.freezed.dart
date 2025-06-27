// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuoteModel _$QuoteModelFromJson(Map<String, dynamic> json) {
  return _QuoteModel.fromJson(json);
}

/// @nodoc
mixin _$QuoteModel {
  /// Unique identifier for the quote
  String get id => throw _privateConstructorUsedError;

  /// The quote text content
  String get text => throw _privateConstructorUsedError;

  /// Author of the quote (optional)
  String? get author => throw _privateConstructorUsedError;

  /// Category or theme of the quote (optional)
  String? get category => throw _privateConstructorUsedError;

  /// Background image URL for the quote (optional)
  String? get backgroundUrl => throw _privateConstructorUsedError;

  /// Text color for better contrast (optional)
  String? get textColor => throw _privateConstructorUsedError;

  /// Whether this quote is currently active
  bool get isActive => throw _privateConstructorUsedError;

  /// Timestamp when the quote was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when the quote was last updated
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this QuoteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuoteModelCopyWith<QuoteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteModelCopyWith<$Res> {
  factory $QuoteModelCopyWith(
          QuoteModel value, $Res Function(QuoteModel) then) =
      _$QuoteModelCopyWithImpl<$Res, QuoteModel>;
  @useResult
  $Res call(
      {String id,
      String text,
      String? author,
      String? category,
      String? backgroundUrl,
      String? textColor,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$QuoteModelCopyWithImpl<$Res, $Val extends QuoteModel>
    implements $QuoteModelCopyWith<$Res> {
  _$QuoteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? author = freezed,
    Object? category = freezed,
    Object? backgroundUrl = freezed,
    Object? textColor = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundUrl: freezed == backgroundUrl
          ? _value.backgroundUrl
          : backgroundUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      textColor: freezed == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuoteModelImplCopyWith<$Res>
    implements $QuoteModelCopyWith<$Res> {
  factory _$$QuoteModelImplCopyWith(
          _$QuoteModelImpl value, $Res Function(_$QuoteModelImpl) then) =
      __$$QuoteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String text,
      String? author,
      String? category,
      String? backgroundUrl,
      String? textColor,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$QuoteModelImplCopyWithImpl<$Res>
    extends _$QuoteModelCopyWithImpl<$Res, _$QuoteModelImpl>
    implements _$$QuoteModelImplCopyWith<$Res> {
  __$$QuoteModelImplCopyWithImpl(
      _$QuoteModelImpl _value, $Res Function(_$QuoteModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? author = freezed,
    Object? category = freezed,
    Object? backgroundUrl = freezed,
    Object? textColor = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$QuoteModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundUrl: freezed == backgroundUrl
          ? _value.backgroundUrl
          : backgroundUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      textColor: freezed == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteModelImpl implements _QuoteModel {
  const _$QuoteModelImpl(
      {required this.id,
      required this.text,
      this.author,
      this.category,
      this.backgroundUrl,
      this.textColor,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt});

  factory _$QuoteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteModelImplFromJson(json);

  /// Unique identifier for the quote
  @override
  final String id;

  /// The quote text content
  @override
  final String text;

  /// Author of the quote (optional)
  @override
  final String? author;

  /// Category or theme of the quote (optional)
  @override
  final String? category;

  /// Background image URL for the quote (optional)
  @override
  final String? backgroundUrl;

  /// Text color for better contrast (optional)
  @override
  final String? textColor;

  /// Whether this quote is currently active
  @override
  @JsonKey()
  final bool isActive;

  /// Timestamp when the quote was created
  @override
  final DateTime createdAt;

  /// Timestamp when the quote was last updated
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'QuoteModel(id: $id, text: $text, author: $author, category: $category, backgroundUrl: $backgroundUrl, textColor: $textColor, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.backgroundUrl, backgroundUrl) ||
                other.backgroundUrl == backgroundUrl) &&
            (identical(other.textColor, textColor) ||
                other.textColor == textColor) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, author, category,
      backgroundUrl, textColor, isActive, createdAt, updatedAt);

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteModelImplCopyWith<_$QuoteModelImpl> get copyWith =>
      __$$QuoteModelImplCopyWithImpl<_$QuoteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteModelImplToJson(
      this,
    );
  }
}

abstract class _QuoteModel implements QuoteModel {
  const factory _QuoteModel(
      {required final String id,
      required final String text,
      final String? author,
      final String? category,
      final String? backgroundUrl,
      final String? textColor,
      final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$QuoteModelImpl;

  factory _QuoteModel.fromJson(Map<String, dynamic> json) =
      _$QuoteModelImpl.fromJson;

  /// Unique identifier for the quote
  @override
  String get id;

  /// The quote text content
  @override
  String get text;

  /// Author of the quote (optional)
  @override
  String? get author;

  /// Category or theme of the quote (optional)
  @override
  String? get category;

  /// Background image URL for the quote (optional)
  @override
  String? get backgroundUrl;

  /// Text color for better contrast (optional)
  @override
  String? get textColor;

  /// Whether this quote is currently active
  @override
  bool get isActive;

  /// Timestamp when the quote was created
  @override
  DateTime get createdAt;

  /// Timestamp when the quote was last updated
  @override
  DateTime get updatedAt;

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteModelImplCopyWith<_$QuoteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
