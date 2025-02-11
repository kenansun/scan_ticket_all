// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScanState {
  String? get imagePath => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get isScanning => throw _privateConstructorUsedError;
  bool get isUploading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Map<String, dynamic>? get scanResult => throw _privateConstructorUsedError;

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanStateCopyWith<ScanState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanStateCopyWith<$Res> {
  factory $ScanStateCopyWith(ScanState value, $Res Function(ScanState) then) =
      _$ScanStateCopyWithImpl<$Res, ScanState>;
  @useResult
  $Res call(
      {String? imagePath,
      String? imageUrl,
      bool isScanning,
      bool isUploading,
      String? error,
      Map<String, dynamic>? scanResult});
}

/// @nodoc
class _$ScanStateCopyWithImpl<$Res, $Val extends ScanState>
    implements $ScanStateCopyWith<$Res> {
  _$ScanStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = freezed,
    Object? imageUrl = freezed,
    Object? isScanning = null,
    Object? isUploading = null,
    Object? error = freezed,
    Object? scanResult = freezed,
  }) {
    return _then(_value.copyWith(
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isScanning: null == isScanning
          ? _value.isScanning
          : isScanning // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      scanResult: freezed == scanResult
          ? _value.scanResult
          : scanResult // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$$ScanStateImplImplCopyWith<$Res>
    implements $ScanStateCopyWith<$Res> {
  factory _$$$ScanStateImplImplCopyWith(_$$ScanStateImplImpl value,
          $Res Function(_$$ScanStateImplImpl) then) =
      __$$$ScanStateImplImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? imagePath,
      String? imageUrl,
      bool isScanning,
      bool isUploading,
      String? error,
      Map<String, dynamic>? scanResult});
}

/// @nodoc
class __$$$ScanStateImplImplCopyWithImpl<$Res>
    extends _$ScanStateCopyWithImpl<$Res, _$$ScanStateImplImpl>
    implements _$$$ScanStateImplImplCopyWith<$Res> {
  __$$$ScanStateImplImplCopyWithImpl(
      _$$ScanStateImplImpl _value, $Res Function(_$$ScanStateImplImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = freezed,
    Object? imageUrl = freezed,
    Object? isScanning = null,
    Object? isUploading = null,
    Object? error = freezed,
    Object? scanResult = freezed,
  }) {
    return _then(_$$ScanStateImplImpl(
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isScanning: null == isScanning
          ? _value.isScanning
          : isScanning // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      scanResult: freezed == scanResult
          ? _value._scanResult
          : scanResult // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$$ScanStateImplImpl implements _$ScanStateImpl {
  const _$$ScanStateImplImpl(
      {this.imagePath,
      this.imageUrl,
      this.isScanning = false,
      this.isUploading = false,
      this.error,
      final Map<String, dynamic>? scanResult})
      : _scanResult = scanResult;

  @override
  final String? imagePath;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool isScanning;
  @override
  @JsonKey()
  final bool isUploading;
  @override
  final String? error;
  final Map<String, dynamic>? _scanResult;
  @override
  Map<String, dynamic>? get scanResult {
    final value = _scanResult;
    if (value == null) return null;
    if (_scanResult is EqualUnmodifiableMapView) return _scanResult;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ScanState(imagePath: $imagePath, imageUrl: $imageUrl, isScanning: $isScanning, isUploading: $isUploading, error: $error, scanResult: $scanResult)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$ScanStateImplImpl &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isScanning, isScanning) ||
                other.isScanning == isScanning) &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other._scanResult, _scanResult));
  }

  @override
  int get hashCode => Object.hash(runtimeType, imagePath, imageUrl, isScanning,
      isUploading, error, const DeepCollectionEquality().hash(_scanResult));

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$$ScanStateImplImplCopyWith<_$$ScanStateImplImpl> get copyWith =>
      __$$$ScanStateImplImplCopyWithImpl<_$$ScanStateImplImpl>(
          this, _$identity);
}

abstract class _$ScanStateImpl implements ScanState {
  const factory _$ScanStateImpl(
      {final String? imagePath,
      final String? imageUrl,
      final bool isScanning,
      final bool isUploading,
      final String? error,
      final Map<String, dynamic>? scanResult}) = _$$ScanStateImplImpl;

  @override
  String? get imagePath;
  @override
  String? get imageUrl;
  @override
  bool get isScanning;
  @override
  bool get isUploading;
  @override
  String? get error;
  @override
  Map<String, dynamic>? get scanResult;

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$$ScanStateImplImplCopyWith<_$$ScanStateImplImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
