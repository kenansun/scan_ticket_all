// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Receipt _$ReceiptFromJson(Map<String, dynamic> json) {
  return _Receipt.fromJson(json);
}

/// @nodoc
mixin _$Receipt {
  String get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  DateTime get scanDate => throw _privateConstructorUsedError;
  String? get merchantName => throw _privateConstructorUsedError;
  double? get totalAmount => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  Map<String, dynamic>? get details => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  ReceiptStatus get status => throw _privateConstructorUsedError;
  ReceiptCategory get category => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get merchantAddress => throw _privateConstructorUsedError;
  String? get merchantPhone => throw _privateConstructorUsedError;
  String? get taxNumber => throw _privateConstructorUsedError;
  double? get taxAmount => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get serialNumber => throw _privateConstructorUsedError;

  /// Serializes this Receipt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptCopyWith<Receipt> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptCopyWith<$Res> {
  factory $ReceiptCopyWith(Receipt value, $Res Function(Receipt) then) =
      _$ReceiptCopyWithImpl<$Res, Receipt>;
  @useResult
  $Res call(
      {String id,
      String imageUrl,
      DateTime scanDate,
      String? merchantName,
      double? totalAmount,
      String? currency,
      Map<String, dynamic>? details,
      String? note,
      List<String> tags,
      ReceiptStatus status,
      ReceiptCategory category,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? location,
      String? merchantAddress,
      String? merchantPhone,
      String? taxNumber,
      double? taxAmount,
      String? paymentMethod,
      String? serialNumber});
}

/// @nodoc
class _$ReceiptCopyWithImpl<$Res, $Val extends Receipt>
    implements $ReceiptCopyWith<$Res> {
  _$ReceiptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? scanDate = null,
    Object? merchantName = freezed,
    Object? totalAmount = freezed,
    Object? currency = freezed,
    Object? details = freezed,
    Object? note = freezed,
    Object? tags = null,
    Object? status = null,
    Object? category = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? location = freezed,
    Object? merchantAddress = freezed,
    Object? merchantPhone = freezed,
    Object? taxNumber = freezed,
    Object? taxAmount = freezed,
    Object? paymentMethod = freezed,
    Object? serialNumber = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      scanDate: null == scanDate
          ? _value.scanDate
          : scanDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      merchantName: freezed == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReceiptStatus,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ReceiptCategory,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantAddress: freezed == merchantAddress
          ? _value.merchantAddress
          : merchantAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantPhone: freezed == merchantPhone
          ? _value.merchantPhone
          : merchantPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      taxNumber: freezed == taxNumber
          ? _value.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      taxAmount: freezed == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceiptImplCopyWith<$Res> implements $ReceiptCopyWith<$Res> {
  factory _$$ReceiptImplCopyWith(
          _$ReceiptImpl value, $Res Function(_$ReceiptImpl) then) =
      __$$ReceiptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String imageUrl,
      DateTime scanDate,
      String? merchantName,
      double? totalAmount,
      String? currency,
      Map<String, dynamic>? details,
      String? note,
      List<String> tags,
      ReceiptStatus status,
      ReceiptCategory category,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? location,
      String? merchantAddress,
      String? merchantPhone,
      String? taxNumber,
      double? taxAmount,
      String? paymentMethod,
      String? serialNumber});
}

/// @nodoc
class __$$ReceiptImplCopyWithImpl<$Res>
    extends _$ReceiptCopyWithImpl<$Res, _$ReceiptImpl>
    implements _$$ReceiptImplCopyWith<$Res> {
  __$$ReceiptImplCopyWithImpl(
      _$ReceiptImpl _value, $Res Function(_$ReceiptImpl) _then)
      : super(_value, _then);

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? scanDate = null,
    Object? merchantName = freezed,
    Object? totalAmount = freezed,
    Object? currency = freezed,
    Object? details = freezed,
    Object? note = freezed,
    Object? tags = null,
    Object? status = null,
    Object? category = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? location = freezed,
    Object? merchantAddress = freezed,
    Object? merchantPhone = freezed,
    Object? taxNumber = freezed,
    Object? taxAmount = freezed,
    Object? paymentMethod = freezed,
    Object? serialNumber = freezed,
  }) {
    return _then(_$ReceiptImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      scanDate: null == scanDate
          ? _value.scanDate
          : scanDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      merchantName: freezed == merchantName
          ? _value.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      details: freezed == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReceiptStatus,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ReceiptCategory,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantAddress: freezed == merchantAddress
          ? _value.merchantAddress
          : merchantAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantPhone: freezed == merchantPhone
          ? _value.merchantPhone
          : merchantPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      taxNumber: freezed == taxNumber
          ? _value.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      taxAmount: freezed == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptImpl implements _Receipt {
  const _$ReceiptImpl(
      {required this.id,
      required this.imageUrl,
      required this.scanDate,
      this.merchantName,
      this.totalAmount,
      this.currency,
      final Map<String, dynamic>? details,
      this.note,
      final List<String> tags = const [],
      this.status = ReceiptStatus.pending,
      this.category = ReceiptCategory.other,
      this.createdAt,
      this.updatedAt,
      this.location,
      this.merchantAddress,
      this.merchantPhone,
      this.taxNumber,
      this.taxAmount,
      this.paymentMethod,
      this.serialNumber})
      : _details = details,
        _tags = tags;

  factory _$ReceiptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptImplFromJson(json);

  @override
  final String id;
  @override
  final String imageUrl;
  @override
  final DateTime scanDate;
  @override
  final String? merchantName;
  @override
  final double? totalAmount;
  @override
  final String? currency;
  final Map<String, dynamic>? _details;
  @override
  Map<String, dynamic>? get details {
    final value = _details;
    if (value == null) return null;
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? note;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final ReceiptStatus status;
  @override
  @JsonKey()
  final ReceiptCategory category;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? location;
  @override
  final String? merchantAddress;
  @override
  final String? merchantPhone;
  @override
  final String? taxNumber;
  @override
  final double? taxAmount;
  @override
  final String? paymentMethod;
  @override
  final String? serialNumber;

  @override
  String toString() {
    return 'Receipt(id: $id, imageUrl: $imageUrl, scanDate: $scanDate, merchantName: $merchantName, totalAmount: $totalAmount, currency: $currency, details: $details, note: $note, tags: $tags, status: $status, category: $category, createdAt: $createdAt, updatedAt: $updatedAt, location: $location, merchantAddress: $merchantAddress, merchantPhone: $merchantPhone, taxNumber: $taxNumber, taxAmount: $taxAmount, paymentMethod: $paymentMethod, serialNumber: $serialNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.scanDate, scanDate) ||
                other.scanDate == scanDate) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.merchantAddress, merchantAddress) ||
                other.merchantAddress == merchantAddress) &&
            (identical(other.merchantPhone, merchantPhone) ||
                other.merchantPhone == merchantPhone) &&
            (identical(other.taxNumber, taxNumber) ||
                other.taxNumber == taxNumber) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        imageUrl,
        scanDate,
        merchantName,
        totalAmount,
        currency,
        const DeepCollectionEquality().hash(_details),
        note,
        const DeepCollectionEquality().hash(_tags),
        status,
        category,
        createdAt,
        updatedAt,
        location,
        merchantAddress,
        merchantPhone,
        taxNumber,
        taxAmount,
        paymentMethod,
        serialNumber
      ]);

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptImplCopyWith<_$ReceiptImpl> get copyWith =>
      __$$ReceiptImplCopyWithImpl<_$ReceiptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptImplToJson(
      this,
    );
  }
}

abstract class _Receipt implements Receipt {
  const factory _Receipt(
      {required final String id,
      required final String imageUrl,
      required final DateTime scanDate,
      final String? merchantName,
      final double? totalAmount,
      final String? currency,
      final Map<String, dynamic>? details,
      final String? note,
      final List<String> tags,
      final ReceiptStatus status,
      final ReceiptCategory category,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? location,
      final String? merchantAddress,
      final String? merchantPhone,
      final String? taxNumber,
      final double? taxAmount,
      final String? paymentMethod,
      final String? serialNumber}) = _$ReceiptImpl;

  factory _Receipt.fromJson(Map<String, dynamic> json) = _$ReceiptImpl.fromJson;

  @override
  String get id;
  @override
  String get imageUrl;
  @override
  DateTime get scanDate;
  @override
  String? get merchantName;
  @override
  double? get totalAmount;
  @override
  String? get currency;
  @override
  Map<String, dynamic>? get details;
  @override
  String? get note;
  @override
  List<String> get tags;
  @override
  ReceiptStatus get status;
  @override
  ReceiptCategory get category;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get location;
  @override
  String? get merchantAddress;
  @override
  String? get merchantPhone;
  @override
  String? get taxNumber;
  @override
  double? get taxAmount;
  @override
  String? get paymentMethod;
  @override
  String? get serialNumber;

  /// Create a copy of Receipt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptImplCopyWith<_$ReceiptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
