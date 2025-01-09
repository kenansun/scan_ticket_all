// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StatisticsState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Map<ReceiptCategory, CategoryStatistics> get categoryStatistics =>
      throw _privateConstructorUsedError;
  List<DailyStatistics> get dailyStatistics =>
      throw _privateConstructorUsedError;
  List<WeeklyStatistics> get weeklyStatistics =>
      throw _privateConstructorUsedError;
  List<MonthlyStatistics> get monthlyStatistics =>
      throw _privateConstructorUsedError;
  Map<String, double> get merchantStatistics =>
      throw _privateConstructorUsedError;
  Map<String, double> get timeSlotStatistics =>
      throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  double get averageAmount => throw _privateConstructorUsedError;
  double get maxAmount => throw _privateConstructorUsedError;
  double get minAmount => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String get trendType => throw _privateConstructorUsedError;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatisticsStateCopyWith<StatisticsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsStateCopyWith<$Res> {
  factory $StatisticsStateCopyWith(
          StatisticsState value, $Res Function(StatisticsState) then) =
      _$StatisticsStateCopyWithImpl<$Res, StatisticsState>;
  @useResult
  $Res call(
      {bool isLoading,
      String? error,
      Map<ReceiptCategory, CategoryStatistics> categoryStatistics,
      List<DailyStatistics> dailyStatistics,
      List<WeeklyStatistics> weeklyStatistics,
      List<MonthlyStatistics> monthlyStatistics,
      Map<String, double> merchantStatistics,
      Map<String, double> timeSlotStatistics,
      double totalAmount,
      int totalCount,
      double averageAmount,
      double maxAmount,
      double minAmount,
      DateTime? startDate,
      DateTime? endDate,
      String trendType});
}

/// @nodoc
class _$StatisticsStateCopyWithImpl<$Res, $Val extends StatisticsState>
    implements $StatisticsStateCopyWith<$Res> {
  _$StatisticsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? categoryStatistics = null,
    Object? dailyStatistics = null,
    Object? weeklyStatistics = null,
    Object? monthlyStatistics = null,
    Object? merchantStatistics = null,
    Object? timeSlotStatistics = null,
    Object? totalAmount = null,
    Object? totalCount = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? trendType = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryStatistics: null == categoryStatistics
          ? _value.categoryStatistics
          : categoryStatistics // ignore: cast_nullable_to_non_nullable
              as Map<ReceiptCategory, CategoryStatistics>,
      dailyStatistics: null == dailyStatistics
          ? _value.dailyStatistics
          : dailyStatistics // ignore: cast_nullable_to_non_nullable
              as List<DailyStatistics>,
      weeklyStatistics: null == weeklyStatistics
          ? _value.weeklyStatistics
          : weeklyStatistics // ignore: cast_nullable_to_non_nullable
              as List<WeeklyStatistics>,
      monthlyStatistics: null == monthlyStatistics
          ? _value.monthlyStatistics
          : monthlyStatistics // ignore: cast_nullable_to_non_nullable
              as List<MonthlyStatistics>,
      merchantStatistics: null == merchantStatistics
          ? _value.merchantStatistics
          : merchantStatistics // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      timeSlotStatistics: null == timeSlotStatistics
          ? _value.timeSlotStatistics
          : timeSlotStatistics // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trendType: null == trendType
          ? _value.trendType
          : trendType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatisticsStateImplCopyWith<$Res>
    implements $StatisticsStateCopyWith<$Res> {
  factory _$$StatisticsStateImplCopyWith(_$StatisticsStateImpl value,
          $Res Function(_$StatisticsStateImpl) then) =
      __$$StatisticsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String? error,
      Map<ReceiptCategory, CategoryStatistics> categoryStatistics,
      List<DailyStatistics> dailyStatistics,
      List<WeeklyStatistics> weeklyStatistics,
      List<MonthlyStatistics> monthlyStatistics,
      Map<String, double> merchantStatistics,
      Map<String, double> timeSlotStatistics,
      double totalAmount,
      int totalCount,
      double averageAmount,
      double maxAmount,
      double minAmount,
      DateTime? startDate,
      DateTime? endDate,
      String trendType});
}

/// @nodoc
class __$$StatisticsStateImplCopyWithImpl<$Res>
    extends _$StatisticsStateCopyWithImpl<$Res, _$StatisticsStateImpl>
    implements _$$StatisticsStateImplCopyWith<$Res> {
  __$$StatisticsStateImplCopyWithImpl(
      _$StatisticsStateImpl _value, $Res Function(_$StatisticsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? categoryStatistics = null,
    Object? dailyStatistics = null,
    Object? weeklyStatistics = null,
    Object? monthlyStatistics = null,
    Object? merchantStatistics = null,
    Object? timeSlotStatistics = null,
    Object? totalAmount = null,
    Object? totalCount = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? trendType = null,
  }) {
    return _then(_$StatisticsStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryStatistics: null == categoryStatistics
          ? _value._categoryStatistics
          : categoryStatistics // ignore: cast_nullable_to_non_nullable
              as Map<ReceiptCategory, CategoryStatistics>,
      dailyStatistics: null == dailyStatistics
          ? _value._dailyStatistics
          : dailyStatistics // ignore: cast_nullable_to_non_nullable
              as List<DailyStatistics>,
      weeklyStatistics: null == weeklyStatistics
          ? _value._weeklyStatistics
          : weeklyStatistics // ignore: cast_nullable_to_non_nullable
              as List<WeeklyStatistics>,
      monthlyStatistics: null == monthlyStatistics
          ? _value._monthlyStatistics
          : monthlyStatistics // ignore: cast_nullable_to_non_nullable
              as List<MonthlyStatistics>,
      merchantStatistics: null == merchantStatistics
          ? _value._merchantStatistics
          : merchantStatistics // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      timeSlotStatistics: null == timeSlotStatistics
          ? _value._timeSlotStatistics
          : timeSlotStatistics // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trendType: null == trendType
          ? _value.trendType
          : trendType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StatisticsStateImpl implements _StatisticsState {
  const _$StatisticsStateImpl(
      {this.isLoading = false,
      this.error,
      final Map<ReceiptCategory, CategoryStatistics> categoryStatistics =
          const {},
      final List<DailyStatistics> dailyStatistics = const [],
      final List<WeeklyStatistics> weeklyStatistics = const [],
      final List<MonthlyStatistics> monthlyStatistics = const [],
      final Map<String, double> merchantStatistics = const {},
      final Map<String, double> timeSlotStatistics = const {},
      this.totalAmount = 0.0,
      this.totalCount = 0,
      this.averageAmount = 0.0,
      this.maxAmount = 0.0,
      this.minAmount = 0.0,
      this.startDate,
      this.endDate,
      this.trendType = 'daily'})
      : _categoryStatistics = categoryStatistics,
        _dailyStatistics = dailyStatistics,
        _weeklyStatistics = weeklyStatistics,
        _monthlyStatistics = monthlyStatistics,
        _merchantStatistics = merchantStatistics,
        _timeSlotStatistics = timeSlotStatistics;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  final Map<ReceiptCategory, CategoryStatistics> _categoryStatistics;
  @override
  @JsonKey()
  Map<ReceiptCategory, CategoryStatistics> get categoryStatistics {
    if (_categoryStatistics is EqualUnmodifiableMapView)
      return _categoryStatistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryStatistics);
  }

  final List<DailyStatistics> _dailyStatistics;
  @override
  @JsonKey()
  List<DailyStatistics> get dailyStatistics {
    if (_dailyStatistics is EqualUnmodifiableListView) return _dailyStatistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyStatistics);
  }

  final List<WeeklyStatistics> _weeklyStatistics;
  @override
  @JsonKey()
  List<WeeklyStatistics> get weeklyStatistics {
    if (_weeklyStatistics is EqualUnmodifiableListView)
      return _weeklyStatistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyStatistics);
  }

  final List<MonthlyStatistics> _monthlyStatistics;
  @override
  @JsonKey()
  List<MonthlyStatistics> get monthlyStatistics {
    if (_monthlyStatistics is EqualUnmodifiableListView)
      return _monthlyStatistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlyStatistics);
  }

  final Map<String, double> _merchantStatistics;
  @override
  @JsonKey()
  Map<String, double> get merchantStatistics {
    if (_merchantStatistics is EqualUnmodifiableMapView)
      return _merchantStatistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_merchantStatistics);
  }

  final Map<String, double> _timeSlotStatistics;
  @override
  @JsonKey()
  Map<String, double> get timeSlotStatistics {
    if (_timeSlotStatistics is EqualUnmodifiableMapView)
      return _timeSlotStatistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timeSlotStatistics);
  }

  @override
  @JsonKey()
  final double totalAmount;
  @override
  @JsonKey()
  final int totalCount;
  @override
  @JsonKey()
  final double averageAmount;
  @override
  @JsonKey()
  final double maxAmount;
  @override
  @JsonKey()
  final double minAmount;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final String trendType;

  @override
  String toString() {
    return 'StatisticsState(isLoading: $isLoading, error: $error, categoryStatistics: $categoryStatistics, dailyStatistics: $dailyStatistics, weeklyStatistics: $weeklyStatistics, monthlyStatistics: $monthlyStatistics, merchantStatistics: $merchantStatistics, timeSlotStatistics: $timeSlotStatistics, totalAmount: $totalAmount, totalCount: $totalCount, averageAmount: $averageAmount, maxAmount: $maxAmount, minAmount: $minAmount, startDate: $startDate, endDate: $endDate, trendType: $trendType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other._categoryStatistics, _categoryStatistics) &&
            const DeepCollectionEquality()
                .equals(other._dailyStatistics, _dailyStatistics) &&
            const DeepCollectionEquality()
                .equals(other._weeklyStatistics, _weeklyStatistics) &&
            const DeepCollectionEquality()
                .equals(other._monthlyStatistics, _monthlyStatistics) &&
            const DeepCollectionEquality()
                .equals(other._merchantStatistics, _merchantStatistics) &&
            const DeepCollectionEquality()
                .equals(other._timeSlotStatistics, _timeSlotStatistics) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.averageAmount, averageAmount) ||
                other.averageAmount == averageAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.trendType, trendType) ||
                other.trendType == trendType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      error,
      const DeepCollectionEquality().hash(_categoryStatistics),
      const DeepCollectionEquality().hash(_dailyStatistics),
      const DeepCollectionEquality().hash(_weeklyStatistics),
      const DeepCollectionEquality().hash(_monthlyStatistics),
      const DeepCollectionEquality().hash(_merchantStatistics),
      const DeepCollectionEquality().hash(_timeSlotStatistics),
      totalAmount,
      totalCount,
      averageAmount,
      maxAmount,
      minAmount,
      startDate,
      endDate,
      trendType);

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsStateImplCopyWith<_$StatisticsStateImpl> get copyWith =>
      __$$StatisticsStateImplCopyWithImpl<_$StatisticsStateImpl>(
          this, _$identity);
}

abstract class _StatisticsState implements StatisticsState {
  const factory _StatisticsState(
      {final bool isLoading,
      final String? error,
      final Map<ReceiptCategory, CategoryStatistics> categoryStatistics,
      final List<DailyStatistics> dailyStatistics,
      final List<WeeklyStatistics> weeklyStatistics,
      final List<MonthlyStatistics> monthlyStatistics,
      final Map<String, double> merchantStatistics,
      final Map<String, double> timeSlotStatistics,
      final double totalAmount,
      final int totalCount,
      final double averageAmount,
      final double maxAmount,
      final double minAmount,
      final DateTime? startDate,
      final DateTime? endDate,
      final String trendType}) = _$StatisticsStateImpl;

  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  Map<ReceiptCategory, CategoryStatistics> get categoryStatistics;
  @override
  List<DailyStatistics> get dailyStatistics;
  @override
  List<WeeklyStatistics> get weeklyStatistics;
  @override
  List<MonthlyStatistics> get monthlyStatistics;
  @override
  Map<String, double> get merchantStatistics;
  @override
  Map<String, double> get timeSlotStatistics;
  @override
  double get totalAmount;
  @override
  int get totalCount;
  @override
  double get averageAmount;
  @override
  double get maxAmount;
  @override
  double get minAmount;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  String get trendType;

  /// Create a copy of StatisticsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticsStateImplCopyWith<_$StatisticsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CategoryStatistics {
  double get amount => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  double get averageAmount => throw _privateConstructorUsedError;
  double get maxAmount => throw _privateConstructorUsedError;
  double get minAmount => throw _privateConstructorUsedError;
  List<DailyStatistics> get trend => throw _privateConstructorUsedError;

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryStatisticsCopyWith<CategoryStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryStatisticsCopyWith<$Res> {
  factory $CategoryStatisticsCopyWith(
          CategoryStatistics value, $Res Function(CategoryStatistics) then) =
      _$CategoryStatisticsCopyWithImpl<$Res, CategoryStatistics>;
  @useResult
  $Res call(
      {double amount,
      int count,
      double percentage,
      double averageAmount,
      double maxAmount,
      double minAmount,
      List<DailyStatistics> trend});
}

/// @nodoc
class _$CategoryStatisticsCopyWithImpl<$Res, $Val extends CategoryStatistics>
    implements $CategoryStatisticsCopyWith<$Res> {
  _$CategoryStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? count = null,
    Object? percentage = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? trend = null,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as List<DailyStatistics>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryStatisticsImplCopyWith<$Res>
    implements $CategoryStatisticsCopyWith<$Res> {
  factory _$$CategoryStatisticsImplCopyWith(_$CategoryStatisticsImpl value,
          $Res Function(_$CategoryStatisticsImpl) then) =
      __$$CategoryStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      int count,
      double percentage,
      double averageAmount,
      double maxAmount,
      double minAmount,
      List<DailyStatistics> trend});
}

/// @nodoc
class __$$CategoryStatisticsImplCopyWithImpl<$Res>
    extends _$CategoryStatisticsCopyWithImpl<$Res, _$CategoryStatisticsImpl>
    implements _$$CategoryStatisticsImplCopyWith<$Res> {
  __$$CategoryStatisticsImplCopyWithImpl(_$CategoryStatisticsImpl _value,
      $Res Function(_$CategoryStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? count = null,
    Object? percentage = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? trend = null,
  }) {
    return _then(_$CategoryStatisticsImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value._trend
          : trend // ignore: cast_nullable_to_non_nullable
              as List<DailyStatistics>,
    ));
  }
}

/// @nodoc

class _$CategoryStatisticsImpl implements _CategoryStatistics {
  const _$CategoryStatisticsImpl(
      {required this.amount,
      required this.count,
      required this.percentage,
      required this.averageAmount,
      required this.maxAmount,
      required this.minAmount,
      required final List<DailyStatistics> trend})
      : _trend = trend;

  @override
  final double amount;
  @override
  final int count;
  @override
  final double percentage;
  @override
  final double averageAmount;
  @override
  final double maxAmount;
  @override
  final double minAmount;
  final List<DailyStatistics> _trend;
  @override
  List<DailyStatistics> get trend {
    if (_trend is EqualUnmodifiableListView) return _trend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trend);
  }

  @override
  String toString() {
    return 'CategoryStatistics(amount: $amount, count: $count, percentage: $percentage, averageAmount: $averageAmount, maxAmount: $maxAmount, minAmount: $minAmount, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryStatisticsImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.averageAmount, averageAmount) ||
                other.averageAmount == averageAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            const DeepCollectionEquality().equals(other._trend, _trend));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      amount,
      count,
      percentage,
      averageAmount,
      maxAmount,
      minAmount,
      const DeepCollectionEquality().hash(_trend));

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryStatisticsImplCopyWith<_$CategoryStatisticsImpl> get copyWith =>
      __$$CategoryStatisticsImplCopyWithImpl<_$CategoryStatisticsImpl>(
          this, _$identity);
}

abstract class _CategoryStatistics implements CategoryStatistics {
  const factory _CategoryStatistics(
      {required final double amount,
      required final int count,
      required final double percentage,
      required final double averageAmount,
      required final double maxAmount,
      required final double minAmount,
      required final List<DailyStatistics> trend}) = _$CategoryStatisticsImpl;

  @override
  double get amount;
  @override
  int get count;
  @override
  double get percentage;
  @override
  double get averageAmount;
  @override
  double get maxAmount;
  @override
  double get minAmount;
  @override
  List<DailyStatistics> get trend;

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryStatisticsImplCopyWith<_$CategoryStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DailyStatistics {
  DateTime get date => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get averageAmount => throw _privateConstructorUsedError;
  double get maxAmount => throw _privateConstructorUsedError;
  double get minAmount => throw _privateConstructorUsedError;
  Map<ReceiptCategory, double>? get categoryAmounts =>
      throw _privateConstructorUsedError;

  /// Create a copy of DailyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyStatisticsCopyWith<DailyStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyStatisticsCopyWith<$Res> {
  factory $DailyStatisticsCopyWith(
          DailyStatistics value, $Res Function(DailyStatistics) then) =
      _$DailyStatisticsCopyWithImpl<$Res, DailyStatistics>;
  @useResult
  $Res call(
      {DateTime date,
      double amount,
      int count,
      double averageAmount,
      double maxAmount,
      double minAmount,
      Map<ReceiptCategory, double>? categoryAmounts});
}

/// @nodoc
class _$DailyStatisticsCopyWithImpl<$Res, $Val extends DailyStatistics>
    implements $DailyStatisticsCopyWith<$Res> {
  _$DailyStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? amount = null,
    Object? count = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? categoryAmounts = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryAmounts: freezed == categoryAmounts
          ? _value.categoryAmounts
          : categoryAmounts // ignore: cast_nullable_to_non_nullable
              as Map<ReceiptCategory, double>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyStatisticsImplCopyWith<$Res>
    implements $DailyStatisticsCopyWith<$Res> {
  factory _$$DailyStatisticsImplCopyWith(_$DailyStatisticsImpl value,
          $Res Function(_$DailyStatisticsImpl) then) =
      __$$DailyStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double amount,
      int count,
      double averageAmount,
      double maxAmount,
      double minAmount,
      Map<ReceiptCategory, double>? categoryAmounts});
}

/// @nodoc
class __$$DailyStatisticsImplCopyWithImpl<$Res>
    extends _$DailyStatisticsCopyWithImpl<$Res, _$DailyStatisticsImpl>
    implements _$$DailyStatisticsImplCopyWith<$Res> {
  __$$DailyStatisticsImplCopyWithImpl(
      _$DailyStatisticsImpl _value, $Res Function(_$DailyStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? amount = null,
    Object? count = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? categoryAmounts = freezed,
  }) {
    return _then(_$DailyStatisticsImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryAmounts: freezed == categoryAmounts
          ? _value._categoryAmounts
          : categoryAmounts // ignore: cast_nullable_to_non_nullable
              as Map<ReceiptCategory, double>?,
    ));
  }
}

/// @nodoc

class _$DailyStatisticsImpl implements _DailyStatistics {
  const _$DailyStatisticsImpl(
      {required this.date,
      required this.amount,
      required this.count,
      required this.averageAmount,
      required this.maxAmount,
      required this.minAmount,
      final Map<ReceiptCategory, double>? categoryAmounts})
      : _categoryAmounts = categoryAmounts;

  @override
  final DateTime date;
  @override
  final double amount;
  @override
  final int count;
  @override
  final double averageAmount;
  @override
  final double maxAmount;
  @override
  final double minAmount;
  final Map<ReceiptCategory, double>? _categoryAmounts;
  @override
  Map<ReceiptCategory, double>? get categoryAmounts {
    final value = _categoryAmounts;
    if (value == null) return null;
    if (_categoryAmounts is EqualUnmodifiableMapView) return _categoryAmounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'DailyStatistics(date: $date, amount: $amount, count: $count, averageAmount: $averageAmount, maxAmount: $maxAmount, minAmount: $minAmount, categoryAmounts: $categoryAmounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyStatisticsImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.averageAmount, averageAmount) ||
                other.averageAmount == averageAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            const DeepCollectionEquality()
                .equals(other._categoryAmounts, _categoryAmounts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      amount,
      count,
      averageAmount,
      maxAmount,
      minAmount,
      const DeepCollectionEquality().hash(_categoryAmounts));

  /// Create a copy of DailyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyStatisticsImplCopyWith<_$DailyStatisticsImpl> get copyWith =>
      __$$DailyStatisticsImplCopyWithImpl<_$DailyStatisticsImpl>(
          this, _$identity);
}

abstract class _DailyStatistics implements DailyStatistics {
  const factory _DailyStatistics(
          {required final DateTime date,
          required final double amount,
          required final int count,
          required final double averageAmount,
          required final double maxAmount,
          required final double minAmount,
          final Map<ReceiptCategory, double>? categoryAmounts}) =
      _$DailyStatisticsImpl;

  @override
  DateTime get date;
  @override
  double get amount;
  @override
  int get count;
  @override
  double get averageAmount;
  @override
  double get maxAmount;
  @override
  double get minAmount;
  @override
  Map<ReceiptCategory, double>? get categoryAmounts;

  /// Create a copy of DailyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyStatisticsImplCopyWith<_$DailyStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WeeklyStatistics {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get averageAmount => throw _privateConstructorUsedError;
  double get maxAmount => throw _privateConstructorUsedError;
  double get minAmount => throw _privateConstructorUsedError;
  Map<ReceiptCategory, double>? get categoryAmounts =>
      throw _privateConstructorUsedError;

  /// Create a copy of WeeklyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyStatisticsCopyWith<WeeklyStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyStatisticsCopyWith<$Res> {
  factory $WeeklyStatisticsCopyWith(
          WeeklyStatistics value, $Res Function(WeeklyStatistics) then) =
      _$WeeklyStatisticsCopyWithImpl<$Res, WeeklyStatistics>;
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      double amount,
      int count,
      double averageAmount,
      double maxAmount,
      double minAmount,
      Map<ReceiptCategory, double>? categoryAmounts});
}

/// @nodoc
class _$WeeklyStatisticsCopyWithImpl<$Res, $Val extends WeeklyStatistics>
    implements $WeeklyStatisticsCopyWith<$Res> {
  _$WeeklyStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? amount = null,
    Object? count = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? categoryAmounts = freezed,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryAmounts: freezed == categoryAmounts
          ? _value.categoryAmounts
          : categoryAmounts // ignore: cast_nullable_to_non_nullable
              as Map<ReceiptCategory, double>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyStatisticsImplCopyWith<$Res>
    implements $WeeklyStatisticsCopyWith<$Res> {
  factory _$$WeeklyStatisticsImplCopyWith(_$WeeklyStatisticsImpl value,
          $Res Function(_$WeeklyStatisticsImpl) then) =
      __$$WeeklyStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      double amount,
      int count,
      double averageAmount,
      double maxAmount,
      double minAmount,
      Map<ReceiptCategory, double>? categoryAmounts});
}

/// @nodoc
class __$$WeeklyStatisticsImplCopyWithImpl<$Res>
    extends _$WeeklyStatisticsCopyWithImpl<$Res, _$WeeklyStatisticsImpl>
    implements _$$WeeklyStatisticsImplCopyWith<$Res> {
  __$$WeeklyStatisticsImplCopyWithImpl(_$WeeklyStatisticsImpl _value,
      $Res Function(_$WeeklyStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeeklyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? amount = null,
    Object? count = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? categoryAmounts = freezed,
  }) {
    return _then(_$WeeklyStatisticsImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryAmounts: freezed == categoryAmounts
          ? _value._categoryAmounts
          : categoryAmounts // ignore: cast_nullable_to_non_nullable
              as Map<ReceiptCategory, double>?,
    ));
  }
}

/// @nodoc

class _$WeeklyStatisticsImpl implements _WeeklyStatistics {
  const _$WeeklyStatisticsImpl(
      {required this.startDate,
      required this.endDate,
      required this.amount,
      required this.count,
      required this.averageAmount,
      required this.maxAmount,
      required this.minAmount,
      final Map<ReceiptCategory, double>? categoryAmounts})
      : _categoryAmounts = categoryAmounts;

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final double amount;
  @override
  final int count;
  @override
  final double averageAmount;
  @override
  final double maxAmount;
  @override
  final double minAmount;
  final Map<ReceiptCategory, double>? _categoryAmounts;
  @override
  Map<ReceiptCategory, double>? get categoryAmounts {
    final value = _categoryAmounts;
    if (value == null) return null;
    if (_categoryAmounts is EqualUnmodifiableMapView) return _categoryAmounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'WeeklyStatistics(startDate: $startDate, endDate: $endDate, amount: $amount, count: $count, averageAmount: $averageAmount, maxAmount: $maxAmount, minAmount: $minAmount, categoryAmounts: $categoryAmounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyStatisticsImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.averageAmount, averageAmount) ||
                other.averageAmount == averageAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            const DeepCollectionEquality()
                .equals(other._categoryAmounts, _categoryAmounts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      startDate,
      endDate,
      amount,
      count,
      averageAmount,
      maxAmount,
      minAmount,
      const DeepCollectionEquality().hash(_categoryAmounts));

  /// Create a copy of WeeklyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyStatisticsImplCopyWith<_$WeeklyStatisticsImpl> get copyWith =>
      __$$WeeklyStatisticsImplCopyWithImpl<_$WeeklyStatisticsImpl>(
          this, _$identity);
}

abstract class _WeeklyStatistics implements WeeklyStatistics {
  const factory _WeeklyStatistics(
          {required final DateTime startDate,
          required final DateTime endDate,
          required final double amount,
          required final int count,
          required final double averageAmount,
          required final double maxAmount,
          required final double minAmount,
          final Map<ReceiptCategory, double>? categoryAmounts}) =
      _$WeeklyStatisticsImpl;

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  double get amount;
  @override
  int get count;
  @override
  double get averageAmount;
  @override
  double get maxAmount;
  @override
  double get minAmount;
  @override
  Map<ReceiptCategory, double>? get categoryAmounts;

  /// Create a copy of WeeklyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyStatisticsImplCopyWith<_$WeeklyStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MonthlyStatistics {
  DateTime get month => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get averageAmount => throw _privateConstructorUsedError;
  double get maxAmount => throw _privateConstructorUsedError;
  double get minAmount => throw _privateConstructorUsedError;
  Map<ReceiptCategory, double>? get categoryAmounts =>
      throw _privateConstructorUsedError;

  /// Create a copy of MonthlyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyStatisticsCopyWith<MonthlyStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyStatisticsCopyWith<$Res> {
  factory $MonthlyStatisticsCopyWith(
          MonthlyStatistics value, $Res Function(MonthlyStatistics) then) =
      _$MonthlyStatisticsCopyWithImpl<$Res, MonthlyStatistics>;
  @useResult
  $Res call(
      {DateTime month,
      double amount,
      int count,
      double averageAmount,
      double maxAmount,
      double minAmount,
      Map<ReceiptCategory, double>? categoryAmounts});
}

/// @nodoc
class _$MonthlyStatisticsCopyWithImpl<$Res, $Val extends MonthlyStatistics>
    implements $MonthlyStatisticsCopyWith<$Res> {
  _$MonthlyStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? amount = null,
    Object? count = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? categoryAmounts = freezed,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryAmounts: freezed == categoryAmounts
          ? _value.categoryAmounts
          : categoryAmounts // ignore: cast_nullable_to_non_nullable
              as Map<ReceiptCategory, double>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyStatisticsImplCopyWith<$Res>
    implements $MonthlyStatisticsCopyWith<$Res> {
  factory _$$MonthlyStatisticsImplCopyWith(_$MonthlyStatisticsImpl value,
          $Res Function(_$MonthlyStatisticsImpl) then) =
      __$$MonthlyStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime month,
      double amount,
      int count,
      double averageAmount,
      double maxAmount,
      double minAmount,
      Map<ReceiptCategory, double>? categoryAmounts});
}

/// @nodoc
class __$$MonthlyStatisticsImplCopyWithImpl<$Res>
    extends _$MonthlyStatisticsCopyWithImpl<$Res, _$MonthlyStatisticsImpl>
    implements _$$MonthlyStatisticsImplCopyWith<$Res> {
  __$$MonthlyStatisticsImplCopyWithImpl(_$MonthlyStatisticsImpl _value,
      $Res Function(_$MonthlyStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? amount = null,
    Object? count = null,
    Object? averageAmount = null,
    Object? maxAmount = null,
    Object? minAmount = null,
    Object? categoryAmounts = freezed,
  }) {
    return _then(_$MonthlyStatisticsImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      averageAmount: null == averageAmount
          ? _value.averageAmount
          : averageAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      categoryAmounts: freezed == categoryAmounts
          ? _value._categoryAmounts
          : categoryAmounts // ignore: cast_nullable_to_non_nullable
              as Map<ReceiptCategory, double>?,
    ));
  }
}

/// @nodoc

class _$MonthlyStatisticsImpl implements _MonthlyStatistics {
  const _$MonthlyStatisticsImpl(
      {required this.month,
      required this.amount,
      required this.count,
      required this.averageAmount,
      required this.maxAmount,
      required this.minAmount,
      final Map<ReceiptCategory, double>? categoryAmounts})
      : _categoryAmounts = categoryAmounts;

  @override
  final DateTime month;
  @override
  final double amount;
  @override
  final int count;
  @override
  final double averageAmount;
  @override
  final double maxAmount;
  @override
  final double minAmount;
  final Map<ReceiptCategory, double>? _categoryAmounts;
  @override
  Map<ReceiptCategory, double>? get categoryAmounts {
    final value = _categoryAmounts;
    if (value == null) return null;
    if (_categoryAmounts is EqualUnmodifiableMapView) return _categoryAmounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MonthlyStatistics(month: $month, amount: $amount, count: $count, averageAmount: $averageAmount, maxAmount: $maxAmount, minAmount: $minAmount, categoryAmounts: $categoryAmounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyStatisticsImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.averageAmount, averageAmount) ||
                other.averageAmount == averageAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            const DeepCollectionEquality()
                .equals(other._categoryAmounts, _categoryAmounts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      month,
      amount,
      count,
      averageAmount,
      maxAmount,
      minAmount,
      const DeepCollectionEquality().hash(_categoryAmounts));

  /// Create a copy of MonthlyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyStatisticsImplCopyWith<_$MonthlyStatisticsImpl> get copyWith =>
      __$$MonthlyStatisticsImplCopyWithImpl<_$MonthlyStatisticsImpl>(
          this, _$identity);
}

abstract class _MonthlyStatistics implements MonthlyStatistics {
  const factory _MonthlyStatistics(
          {required final DateTime month,
          required final double amount,
          required final int count,
          required final double averageAmount,
          required final double maxAmount,
          required final double minAmount,
          final Map<ReceiptCategory, double>? categoryAmounts}) =
      _$MonthlyStatisticsImpl;

  @override
  DateTime get month;
  @override
  double get amount;
  @override
  int get count;
  @override
  double get averageAmount;
  @override
  double get maxAmount;
  @override
  double get minAmount;
  @override
  Map<ReceiptCategory, double>? get categoryAmounts;

  /// Create a copy of MonthlyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyStatisticsImplCopyWith<_$MonthlyStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
