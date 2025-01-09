// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReceiptState {
  List<Receipt> get receipts => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Receipt? get selectedReceipt => throw _privateConstructorUsedError;

  /// Create a copy of ReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptStateCopyWith<ReceiptState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptStateCopyWith<$Res> {
  factory $ReceiptStateCopyWith(
          ReceiptState value, $Res Function(ReceiptState) then) =
      _$ReceiptStateCopyWithImpl<$Res, ReceiptState>;
  @useResult
  $Res call(
      {List<Receipt> receipts,
      bool isLoading,
      bool hasMore,
      int currentPage,
      String? error,
      Receipt? selectedReceipt});

  $ReceiptCopyWith<$Res>? get selectedReceipt;
}

/// @nodoc
class _$ReceiptStateCopyWithImpl<$Res, $Val extends ReceiptState>
    implements $ReceiptStateCopyWith<$Res> {
  _$ReceiptStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receipts = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? currentPage = null,
    Object? error = freezed,
    Object? selectedReceipt = freezed,
  }) {
    return _then(_value.copyWith(
      receipts: null == receipts
          ? _value.receipts
          : receipts // ignore: cast_nullable_to_non_nullable
              as List<Receipt>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedReceipt: freezed == selectedReceipt
          ? _value.selectedReceipt
          : selectedReceipt // ignore: cast_nullable_to_non_nullable
              as Receipt?,
    ) as $Val);
  }

  /// Create a copy of ReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReceiptCopyWith<$Res>? get selectedReceipt {
    if (_value.selectedReceipt == null) {
      return null;
    }

    return $ReceiptCopyWith<$Res>(_value.selectedReceipt!, (value) {
      return _then(_value.copyWith(selectedReceipt: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReceiptStateImplCopyWith<$Res>
    implements $ReceiptStateCopyWith<$Res> {
  factory _$$ReceiptStateImplCopyWith(
          _$ReceiptStateImpl value, $Res Function(_$ReceiptStateImpl) then) =
      __$$ReceiptStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Receipt> receipts,
      bool isLoading,
      bool hasMore,
      int currentPage,
      String? error,
      Receipt? selectedReceipt});

  @override
  $ReceiptCopyWith<$Res>? get selectedReceipt;
}

/// @nodoc
class __$$ReceiptStateImplCopyWithImpl<$Res>
    extends _$ReceiptStateCopyWithImpl<$Res, _$ReceiptStateImpl>
    implements _$$ReceiptStateImplCopyWith<$Res> {
  __$$ReceiptStateImplCopyWithImpl(
      _$ReceiptStateImpl _value, $Res Function(_$ReceiptStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? receipts = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? currentPage = null,
    Object? error = freezed,
    Object? selectedReceipt = freezed,
  }) {
    return _then(_$ReceiptStateImpl(
      receipts: null == receipts
          ? _value._receipts
          : receipts // ignore: cast_nullable_to_non_nullable
              as List<Receipt>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedReceipt: freezed == selectedReceipt
          ? _value.selectedReceipt
          : selectedReceipt // ignore: cast_nullable_to_non_nullable
              as Receipt?,
    ));
  }
}

/// @nodoc

class _$ReceiptStateImpl implements _ReceiptState {
  const _$ReceiptStateImpl(
      {final List<Receipt> receipts = const [],
      this.isLoading = false,
      this.hasMore = false,
      this.currentPage = 1,
      this.error,
      this.selectedReceipt})
      : _receipts = receipts;

  final List<Receipt> _receipts;
  @override
  @JsonKey()
  List<Receipt> get receipts {
    if (_receipts is EqualUnmodifiableListView) return _receipts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_receipts);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final int currentPage;
  @override
  final String? error;
  @override
  final Receipt? selectedReceipt;

  @override
  String toString() {
    return 'ReceiptState(receipts: $receipts, isLoading: $isLoading, hasMore: $hasMore, currentPage: $currentPage, error: $error, selectedReceipt: $selectedReceipt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptStateImpl &&
            const DeepCollectionEquality().equals(other._receipts, _receipts) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedReceipt, selectedReceipt) ||
                other.selectedReceipt == selectedReceipt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_receipts),
      isLoading,
      hasMore,
      currentPage,
      error,
      selectedReceipt);

  /// Create a copy of ReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptStateImplCopyWith<_$ReceiptStateImpl> get copyWith =>
      __$$ReceiptStateImplCopyWithImpl<_$ReceiptStateImpl>(this, _$identity);
}

abstract class _ReceiptState implements ReceiptState {
  const factory _ReceiptState(
      {final List<Receipt> receipts,
      final bool isLoading,
      final bool hasMore,
      final int currentPage,
      final String? error,
      final Receipt? selectedReceipt}) = _$ReceiptStateImpl;

  @override
  List<Receipt> get receipts;
  @override
  bool get isLoading;
  @override
  bool get hasMore;
  @override
  int get currentPage;
  @override
  String? get error;
  @override
  Receipt? get selectedReceipt;

  /// Create a copy of ReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptStateImplCopyWith<_$ReceiptStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
