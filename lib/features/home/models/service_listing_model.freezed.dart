// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_listing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceListingModel _$ServiceListingModelFromJson(Map<String, dynamic> json) {
  return _ServiceListingModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceListingModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String? get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_photo')
  String get image => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviews_count')
  int? get reviewsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'offers_count')
  int? get offersCount => throw _privateConstructorUsedError;
  VendorModel? get vendor => throw _privateConstructorUsedError;
  @JsonKey(name: 'promotional_tag')
  String? get promotionalTag => throw _privateConstructorUsedError;
  List<String>? get inclusions => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_price')
  double? get originalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'offer_price')
  double? get offerPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool? get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;
  List<String>? get photos =>
      throw _privateConstructorUsedError; // Array of service images
  String? get category =>
      throw _privateConstructorUsedError; // Service category for finding related services
// Enhanced booking fields from database
  @JsonKey(name: 'venue_types')
  List<String>? get venueTypes => throw _privateConstructorUsedError;
  @JsonKey(name: 'theme_tags')
  List<String>? get themeTags => throw _privateConstructorUsedError;
  @JsonKey(name: 'add_ons')
  List<Map<String, dynamic>>? get addOns => throw _privateConstructorUsedError;
  @JsonKey(name: 'setup_time')
  String? get setupTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_notice')
  String? get bookingNotice => throw _privateConstructorUsedError;
  @JsonKey(name: 'customization_available')
  bool? get customizationAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'customization_note')
  String? get customizationNote => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_environment')
  List<String>? get serviceEnvironment => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'decoration_type')
  String? get decorationType =>
      throw _privateConstructorUsedError; // 'inside', 'outside', or 'both'
// Location fields
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude =>
      throw _privateConstructorUsedError; // Calculated fields (not from database)
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get distanceKm => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get adjustedOfferPrice => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get adjustedOriginalPrice => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isPriceAdjusted => throw _privateConstructorUsedError;

  /// Serializes this ServiceListingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceListingModelCopyWith<ServiceListingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceListingModelCopyWith<$Res> {
  factory $ServiceListingModelCopyWith(
          ServiceListingModel value, $Res Function(ServiceListingModel) then) =
      _$ServiceListingModelCopyWithImpl<$Res, ServiceListingModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'title') String name,
      @JsonKey(name: 'cover_photo') String image,
      String? description,
      double? rating,
      @JsonKey(name: 'reviews_count') int? reviewsCount,
      @JsonKey(name: 'offers_count') int? offersCount,
      VendorModel? vendor,
      @JsonKey(name: 'promotional_tag') String? promotionalTag,
      List<String>? inclusions,
      @JsonKey(name: 'original_price') double? originalPrice,
      @JsonKey(name: 'offer_price') double? offerPrice,
      @JsonKey(name: 'is_featured') bool? isFeatured,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'is_active') bool? isActive,
      List<String>? photos,
      String? category,
      @JsonKey(name: 'venue_types') List<String>? venueTypes,
      @JsonKey(name: 'theme_tags') List<String>? themeTags,
      @JsonKey(name: 'add_ons') List<Map<String, dynamic>>? addOns,
      @JsonKey(name: 'setup_time') String? setupTime,
      @JsonKey(name: 'booking_notice') String? bookingNotice,
      @JsonKey(name: 'customization_available') bool? customizationAvailable,
      @JsonKey(name: 'customization_note') String? customizationNote,
      @JsonKey(name: 'service_environment') List<String>? serviceEnvironment,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'decoration_type') String? decorationType,
      double? latitude,
      double? longitude,
      @JsonKey(includeFromJson: false, includeToJson: false) double? distanceKm,
      @JsonKey(includeFromJson: false, includeToJson: false)
      double? adjustedOfferPrice,
      @JsonKey(includeFromJson: false, includeToJson: false)
      double? adjustedOriginalPrice,
      @JsonKey(includeFromJson: false, includeToJson: false)
      bool? isPriceAdjusted});

  $VendorModelCopyWith<$Res>? get vendor;
}

/// @nodoc
class _$ServiceListingModelCopyWithImpl<$Res, $Val extends ServiceListingModel>
    implements $ServiceListingModelCopyWith<$Res> {
  _$ServiceListingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = freezed,
    Object? name = null,
    Object? image = null,
    Object? description = freezed,
    Object? rating = freezed,
    Object? reviewsCount = freezed,
    Object? offersCount = freezed,
    Object? vendor = freezed,
    Object? promotionalTag = freezed,
    Object? inclusions = freezed,
    Object? originalPrice = freezed,
    Object? offerPrice = freezed,
    Object? isFeatured = freezed,
    Object? createdAt = freezed,
    Object? isActive = freezed,
    Object? photos = freezed,
    Object? category = freezed,
    Object? venueTypes = freezed,
    Object? themeTags = freezed,
    Object? addOns = freezed,
    Object? setupTime = freezed,
    Object? bookingNotice = freezed,
    Object? customizationAvailable = freezed,
    Object? customizationNote = freezed,
    Object? serviceEnvironment = freezed,
    Object? videoUrl = freezed,
    Object? decorationType = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? distanceKm = freezed,
    Object? adjustedOfferPrice = freezed,
    Object? adjustedOriginalPrice = freezed,
    Object? isPriceAdjusted = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewsCount: freezed == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      offersCount: freezed == offersCount
          ? _value.offersCount
          : offersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      vendor: freezed == vendor
          ? _value.vendor
          : vendor // ignore: cast_nullable_to_non_nullable
              as VendorModel?,
      promotionalTag: freezed == promotionalTag
          ? _value.promotionalTag
          : promotionalTag // ignore: cast_nullable_to_non_nullable
              as String?,
      inclusions: freezed == inclusions
          ? _value.inclusions
          : inclusions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      offerPrice: freezed == offerPrice
          ? _value.offerPrice
          : offerPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      photos: freezed == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      venueTypes: freezed == venueTypes
          ? _value.venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      themeTags: freezed == themeTags
          ? _value.themeTags
          : themeTags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      addOns: freezed == addOns
          ? _value.addOns
          : addOns // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      setupTime: freezed == setupTime
          ? _value.setupTime
          : setupTime // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingNotice: freezed == bookingNotice
          ? _value.bookingNotice
          : bookingNotice // ignore: cast_nullable_to_non_nullable
              as String?,
      customizationAvailable: freezed == customizationAvailable
          ? _value.customizationAvailable
          : customizationAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      customizationNote: freezed == customizationNote
          ? _value.customizationNote
          : customizationNote // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceEnvironment: freezed == serviceEnvironment
          ? _value.serviceEnvironment
          : serviceEnvironment // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      decorationType: freezed == decorationType
          ? _value.decorationType
          : decorationType // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      adjustedOfferPrice: freezed == adjustedOfferPrice
          ? _value.adjustedOfferPrice
          : adjustedOfferPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      adjustedOriginalPrice: freezed == adjustedOriginalPrice
          ? _value.adjustedOriginalPrice
          : adjustedOriginalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isPriceAdjusted: freezed == isPriceAdjusted
          ? _value.isPriceAdjusted
          : isPriceAdjusted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorModelCopyWith<$Res>? get vendor {
    if (_value.vendor == null) {
      return null;
    }

    return $VendorModelCopyWith<$Res>(_value.vendor!, (value) {
      return _then(_value.copyWith(vendor: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ServiceListingModelImplCopyWith<$Res>
    implements $ServiceListingModelCopyWith<$Res> {
  factory _$$ServiceListingModelImplCopyWith(_$ServiceListingModelImpl value,
          $Res Function(_$ServiceListingModelImpl) then) =
      __$$ServiceListingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'title') String name,
      @JsonKey(name: 'cover_photo') String image,
      String? description,
      double? rating,
      @JsonKey(name: 'reviews_count') int? reviewsCount,
      @JsonKey(name: 'offers_count') int? offersCount,
      VendorModel? vendor,
      @JsonKey(name: 'promotional_tag') String? promotionalTag,
      List<String>? inclusions,
      @JsonKey(name: 'original_price') double? originalPrice,
      @JsonKey(name: 'offer_price') double? offerPrice,
      @JsonKey(name: 'is_featured') bool? isFeatured,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'is_active') bool? isActive,
      List<String>? photos,
      String? category,
      @JsonKey(name: 'venue_types') List<String>? venueTypes,
      @JsonKey(name: 'theme_tags') List<String>? themeTags,
      @JsonKey(name: 'add_ons') List<Map<String, dynamic>>? addOns,
      @JsonKey(name: 'setup_time') String? setupTime,
      @JsonKey(name: 'booking_notice') String? bookingNotice,
      @JsonKey(name: 'customization_available') bool? customizationAvailable,
      @JsonKey(name: 'customization_note') String? customizationNote,
      @JsonKey(name: 'service_environment') List<String>? serviceEnvironment,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'decoration_type') String? decorationType,
      double? latitude,
      double? longitude,
      @JsonKey(includeFromJson: false, includeToJson: false) double? distanceKm,
      @JsonKey(includeFromJson: false, includeToJson: false)
      double? adjustedOfferPrice,
      @JsonKey(includeFromJson: false, includeToJson: false)
      double? adjustedOriginalPrice,
      @JsonKey(includeFromJson: false, includeToJson: false)
      bool? isPriceAdjusted});

  @override
  $VendorModelCopyWith<$Res>? get vendor;
}

/// @nodoc
class __$$ServiceListingModelImplCopyWithImpl<$Res>
    extends _$ServiceListingModelCopyWithImpl<$Res, _$ServiceListingModelImpl>
    implements _$$ServiceListingModelImplCopyWith<$Res> {
  __$$ServiceListingModelImplCopyWithImpl(_$ServiceListingModelImpl _value,
      $Res Function(_$ServiceListingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = freezed,
    Object? name = null,
    Object? image = null,
    Object? description = freezed,
    Object? rating = freezed,
    Object? reviewsCount = freezed,
    Object? offersCount = freezed,
    Object? vendor = freezed,
    Object? promotionalTag = freezed,
    Object? inclusions = freezed,
    Object? originalPrice = freezed,
    Object? offerPrice = freezed,
    Object? isFeatured = freezed,
    Object? createdAt = freezed,
    Object? isActive = freezed,
    Object? photos = freezed,
    Object? category = freezed,
    Object? venueTypes = freezed,
    Object? themeTags = freezed,
    Object? addOns = freezed,
    Object? setupTime = freezed,
    Object? bookingNotice = freezed,
    Object? customizationAvailable = freezed,
    Object? customizationNote = freezed,
    Object? serviceEnvironment = freezed,
    Object? videoUrl = freezed,
    Object? decorationType = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? distanceKm = freezed,
    Object? adjustedOfferPrice = freezed,
    Object? adjustedOriginalPrice = freezed,
    Object? isPriceAdjusted = freezed,
  }) {
    return _then(_$ServiceListingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewsCount: freezed == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      offersCount: freezed == offersCount
          ? _value.offersCount
          : offersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      vendor: freezed == vendor
          ? _value.vendor
          : vendor // ignore: cast_nullable_to_non_nullable
              as VendorModel?,
      promotionalTag: freezed == promotionalTag
          ? _value.promotionalTag
          : promotionalTag // ignore: cast_nullable_to_non_nullable
              as String?,
      inclusions: freezed == inclusions
          ? _value._inclusions
          : inclusions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      offerPrice: freezed == offerPrice
          ? _value.offerPrice
          : offerPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      photos: freezed == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      venueTypes: freezed == venueTypes
          ? _value._venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      themeTags: freezed == themeTags
          ? _value._themeTags
          : themeTags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      addOns: freezed == addOns
          ? _value._addOns
          : addOns // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      setupTime: freezed == setupTime
          ? _value.setupTime
          : setupTime // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingNotice: freezed == bookingNotice
          ? _value.bookingNotice
          : bookingNotice // ignore: cast_nullable_to_non_nullable
              as String?,
      customizationAvailable: freezed == customizationAvailable
          ? _value.customizationAvailable
          : customizationAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      customizationNote: freezed == customizationNote
          ? _value.customizationNote
          : customizationNote // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceEnvironment: freezed == serviceEnvironment
          ? _value._serviceEnvironment
          : serviceEnvironment // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      decorationType: freezed == decorationType
          ? _value.decorationType
          : decorationType // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      adjustedOfferPrice: freezed == adjustedOfferPrice
          ? _value.adjustedOfferPrice
          : adjustedOfferPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      adjustedOriginalPrice: freezed == adjustedOriginalPrice
          ? _value.adjustedOriginalPrice
          : adjustedOriginalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isPriceAdjusted: freezed == isPriceAdjusted
          ? _value.isPriceAdjusted
          : isPriceAdjusted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceListingModelImpl implements _ServiceListingModel {
  const _$ServiceListingModelImpl(
      {required this.id,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'title') required this.name,
      @JsonKey(name: 'cover_photo') required this.image,
      this.description,
      this.rating,
      @JsonKey(name: 'reviews_count') this.reviewsCount,
      @JsonKey(name: 'offers_count') this.offersCount,
      this.vendor,
      @JsonKey(name: 'promotional_tag') this.promotionalTag,
      final List<String>? inclusions,
      @JsonKey(name: 'original_price') this.originalPrice,
      @JsonKey(name: 'offer_price') this.offerPrice,
      @JsonKey(name: 'is_featured') this.isFeatured,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'is_active') this.isActive,
      final List<String>? photos,
      this.category,
      @JsonKey(name: 'venue_types') final List<String>? venueTypes,
      @JsonKey(name: 'theme_tags') final List<String>? themeTags,
      @JsonKey(name: 'add_ons') final List<Map<String, dynamic>>? addOns,
      @JsonKey(name: 'setup_time') this.setupTime,
      @JsonKey(name: 'booking_notice') this.bookingNotice,
      @JsonKey(name: 'customization_available') this.customizationAvailable,
      @JsonKey(name: 'customization_note') this.customizationNote,
      @JsonKey(name: 'service_environment')
      final List<String>? serviceEnvironment,
      @JsonKey(name: 'video_url') this.videoUrl,
      @JsonKey(name: 'decoration_type') this.decorationType,
      this.latitude,
      this.longitude,
      @JsonKey(includeFromJson: false, includeToJson: false) this.distanceKm,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.adjustedOfferPrice,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.adjustedOriginalPrice,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isPriceAdjusted})
      : _inclusions = inclusions,
        _photos = photos,
        _venueTypes = venueTypes,
        _themeTags = themeTags,
        _addOns = addOns,
        _serviceEnvironment = serviceEnvironment;

  factory _$ServiceListingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceListingModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vendor_id')
  final String? vendorId;
  @override
  @JsonKey(name: 'title')
  final String name;
  @override
  @JsonKey(name: 'cover_photo')
  final String image;
  @override
  final String? description;
  @override
  final double? rating;
  @override
  @JsonKey(name: 'reviews_count')
  final int? reviewsCount;
  @override
  @JsonKey(name: 'offers_count')
  final int? offersCount;
  @override
  final VendorModel? vendor;
  @override
  @JsonKey(name: 'promotional_tag')
  final String? promotionalTag;
  final List<String>? _inclusions;
  @override
  List<String>? get inclusions {
    final value = _inclusions;
    if (value == null) return null;
    if (_inclusions is EqualUnmodifiableListView) return _inclusions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'original_price')
  final double? originalPrice;
  @override
  @JsonKey(name: 'offer_price')
  final double? offerPrice;
  @override
  @JsonKey(name: 'is_featured')
  final bool? isFeatured;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;
  final List<String>? _photos;
  @override
  List<String>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Array of service images
  @override
  final String? category;
// Service category for finding related services
// Enhanced booking fields from database
  final List<String>? _venueTypes;
// Service category for finding related services
// Enhanced booking fields from database
  @override
  @JsonKey(name: 'venue_types')
  List<String>? get venueTypes {
    final value = _venueTypes;
    if (value == null) return null;
    if (_venueTypes is EqualUnmodifiableListView) return _venueTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _themeTags;
  @override
  @JsonKey(name: 'theme_tags')
  List<String>? get themeTags {
    final value = _themeTags;
    if (value == null) return null;
    if (_themeTags is EqualUnmodifiableListView) return _themeTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _addOns;
  @override
  @JsonKey(name: 'add_ons')
  List<Map<String, dynamic>>? get addOns {
    final value = _addOns;
    if (value == null) return null;
    if (_addOns is EqualUnmodifiableListView) return _addOns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'setup_time')
  final String? setupTime;
  @override
  @JsonKey(name: 'booking_notice')
  final String? bookingNotice;
  @override
  @JsonKey(name: 'customization_available')
  final bool? customizationAvailable;
  @override
  @JsonKey(name: 'customization_note')
  final String? customizationNote;
  final List<String>? _serviceEnvironment;
  @override
  @JsonKey(name: 'service_environment')
  List<String>? get serviceEnvironment {
    final value = _serviceEnvironment;
    if (value == null) return null;
    if (_serviceEnvironment is EqualUnmodifiableListView)
      return _serviceEnvironment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @override
  @JsonKey(name: 'decoration_type')
  final String? decorationType;
// 'inside', 'outside', or 'both'
// Location fields
  @override
  final double? latitude;
  @override
  final double? longitude;
// Calculated fields (not from database)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double? distanceKm;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double? adjustedOfferPrice;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double? adjustedOriginalPrice;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool? isPriceAdjusted;

  @override
  String toString() {
    return 'ServiceListingModel(id: $id, vendorId: $vendorId, name: $name, image: $image, description: $description, rating: $rating, reviewsCount: $reviewsCount, offersCount: $offersCount, vendor: $vendor, promotionalTag: $promotionalTag, inclusions: $inclusions, originalPrice: $originalPrice, offerPrice: $offerPrice, isFeatured: $isFeatured, createdAt: $createdAt, isActive: $isActive, photos: $photos, category: $category, venueTypes: $venueTypes, themeTags: $themeTags, addOns: $addOns, setupTime: $setupTime, bookingNotice: $bookingNotice, customizationAvailable: $customizationAvailable, customizationNote: $customizationNote, serviceEnvironment: $serviceEnvironment, videoUrl: $videoUrl, decorationType: $decorationType, latitude: $latitude, longitude: $longitude, distanceKm: $distanceKm, adjustedOfferPrice: $adjustedOfferPrice, adjustedOriginalPrice: $adjustedOriginalPrice, isPriceAdjusted: $isPriceAdjusted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceListingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.offersCount, offersCount) ||
                other.offersCount == offersCount) &&
            (identical(other.vendor, vendor) || other.vendor == vendor) &&
            (identical(other.promotionalTag, promotionalTag) ||
                other.promotionalTag == promotionalTag) &&
            const DeepCollectionEquality()
                .equals(other._inclusions, _inclusions) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.offerPrice, offerPrice) ||
                other.offerPrice == offerPrice) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._venueTypes, _venueTypes) &&
            const DeepCollectionEquality()
                .equals(other._themeTags, _themeTags) &&
            const DeepCollectionEquality().equals(other._addOns, _addOns) &&
            (identical(other.setupTime, setupTime) ||
                other.setupTime == setupTime) &&
            (identical(other.bookingNotice, bookingNotice) ||
                other.bookingNotice == bookingNotice) &&
            (identical(other.customizationAvailable, customizationAvailable) ||
                other.customizationAvailable == customizationAvailable) &&
            (identical(other.customizationNote, customizationNote) ||
                other.customizationNote == customizationNote) &&
            const DeepCollectionEquality()
                .equals(other._serviceEnvironment, _serviceEnvironment) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.decorationType, decorationType) ||
                other.decorationType == decorationType) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.adjustedOfferPrice, adjustedOfferPrice) ||
                other.adjustedOfferPrice == adjustedOfferPrice) &&
            (identical(other.adjustedOriginalPrice, adjustedOriginalPrice) ||
                other.adjustedOriginalPrice == adjustedOriginalPrice) &&
            (identical(other.isPriceAdjusted, isPriceAdjusted) ||
                other.isPriceAdjusted == isPriceAdjusted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        vendorId,
        name,
        image,
        description,
        rating,
        reviewsCount,
        offersCount,
        vendor,
        promotionalTag,
        const DeepCollectionEquality().hash(_inclusions),
        originalPrice,
        offerPrice,
        isFeatured,
        createdAt,
        isActive,
        const DeepCollectionEquality().hash(_photos),
        category,
        const DeepCollectionEquality().hash(_venueTypes),
        const DeepCollectionEquality().hash(_themeTags),
        const DeepCollectionEquality().hash(_addOns),
        setupTime,
        bookingNotice,
        customizationAvailable,
        customizationNote,
        const DeepCollectionEquality().hash(_serviceEnvironment),
        videoUrl,
        decorationType,
        latitude,
        longitude,
        distanceKm,
        adjustedOfferPrice,
        adjustedOriginalPrice,
        isPriceAdjusted
      ]);

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceListingModelImplCopyWith<_$ServiceListingModelImpl> get copyWith =>
      __$$ServiceListingModelImplCopyWithImpl<_$ServiceListingModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceListingModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceListingModel implements ServiceListingModel {
  const factory _ServiceListingModel(
      {required final String id,
      @JsonKey(name: 'vendor_id') required final String? vendorId,
      @JsonKey(name: 'title') required final String name,
      @JsonKey(name: 'cover_photo') required final String image,
      final String? description,
      final double? rating,
      @JsonKey(name: 'reviews_count') final int? reviewsCount,
      @JsonKey(name: 'offers_count') final int? offersCount,
      final VendorModel? vendor,
      @JsonKey(name: 'promotional_tag') final String? promotionalTag,
      final List<String>? inclusions,
      @JsonKey(name: 'original_price') final double? originalPrice,
      @JsonKey(name: 'offer_price') final double? offerPrice,
      @JsonKey(name: 'is_featured') final bool? isFeatured,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'is_active') final bool? isActive,
      final List<String>? photos,
      final String? category,
      @JsonKey(name: 'venue_types') final List<String>? venueTypes,
      @JsonKey(name: 'theme_tags') final List<String>? themeTags,
      @JsonKey(name: 'add_ons') final List<Map<String, dynamic>>? addOns,
      @JsonKey(name: 'setup_time') final String? setupTime,
      @JsonKey(name: 'booking_notice') final String? bookingNotice,
      @JsonKey(name: 'customization_available')
      final bool? customizationAvailable,
      @JsonKey(name: 'customization_note') final String? customizationNote,
      @JsonKey(name: 'service_environment')
      final List<String>? serviceEnvironment,
      @JsonKey(name: 'video_url') final String? videoUrl,
      @JsonKey(name: 'decoration_type') final String? decorationType,
      final double? latitude,
      final double? longitude,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final double? distanceKm,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final double? adjustedOfferPrice,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final double? adjustedOriginalPrice,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final bool? isPriceAdjusted}) = _$ServiceListingModelImpl;

  factory _ServiceListingModel.fromJson(Map<String, dynamic> json) =
      _$ServiceListingModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vendor_id')
  String? get vendorId;
  @override
  @JsonKey(name: 'title')
  String get name;
  @override
  @JsonKey(name: 'cover_photo')
  String get image;
  @override
  String? get description;
  @override
  double? get rating;
  @override
  @JsonKey(name: 'reviews_count')
  int? get reviewsCount;
  @override
  @JsonKey(name: 'offers_count')
  int? get offersCount;
  @override
  VendorModel? get vendor;
  @override
  @JsonKey(name: 'promotional_tag')
  String? get promotionalTag;
  @override
  List<String>? get inclusions;
  @override
  @JsonKey(name: 'original_price')
  double? get originalPrice;
  @override
  @JsonKey(name: 'offer_price')
  double? get offerPrice;
  @override
  @JsonKey(name: 'is_featured')
  bool? get isFeatured;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;
  @override
  List<String>? get photos; // Array of service images
  @override
  String? get category; // Service category for finding related services
// Enhanced booking fields from database
  @override
  @JsonKey(name: 'venue_types')
  List<String>? get venueTypes;
  @override
  @JsonKey(name: 'theme_tags')
  List<String>? get themeTags;
  @override
  @JsonKey(name: 'add_ons')
  List<Map<String, dynamic>>? get addOns;
  @override
  @JsonKey(name: 'setup_time')
  String? get setupTime;
  @override
  @JsonKey(name: 'booking_notice')
  String? get bookingNotice;
  @override
  @JsonKey(name: 'customization_available')
  bool? get customizationAvailable;
  @override
  @JsonKey(name: 'customization_note')
  String? get customizationNote;
  @override
  @JsonKey(name: 'service_environment')
  List<String>? get serviceEnvironment;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override
  @JsonKey(name: 'decoration_type')
  String? get decorationType; // 'inside', 'outside', or 'both'
// Location fields
  @override
  double? get latitude;
  @override
  double? get longitude; // Calculated fields (not from database)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get distanceKm;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get adjustedOfferPrice;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  double? get adjustedOriginalPrice;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isPriceAdjusted;

  /// Create a copy of ServiceListingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceListingModelImplCopyWith<_$ServiceListingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
