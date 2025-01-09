import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/receipt.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/cache_service.dart';
import '../../../core/providers/providers.dart';

part 'statistics_state.freezed.dart';

@freezed
class StatisticsState with _$StatisticsState {
  const factory StatisticsState({
    @Default(false) bool isLoading,
    String? error,
    @Default({}) Map<ReceiptCategory, CategoryStatistics> categoryStatistics,
    @Default([]) List<DailyStatistics> dailyStatistics,
    @Default([]) List<WeeklyStatistics> weeklyStatistics,
    @Default([]) List<MonthlyStatistics> monthlyStatistics,
    @Default({}) Map<String, double> merchantStatistics,
    @Default({}) Map<String, double> timeSlotStatistics,
    @Default(0.0) double totalAmount,
    @Default(0) int totalCount,
    @Default(0.0) double averageAmount,
    @Default(0.0) double maxAmount,
    @Default(0.0) double minAmount,
    DateTime? startDate,
    DateTime? endDate,
    @Default('daily') String trendType,
  }) = _StatisticsState;
}

@freezed
class CategoryStatistics with _$CategoryStatistics {
  const factory CategoryStatistics({
    required double amount,
    required int count,
    required double percentage,
    required double averageAmount,
    required double maxAmount,
    required double minAmount,
    required List<DailyStatistics> trend,
  }) = _CategoryStatistics;
}

@freezed
class DailyStatistics with _$DailyStatistics {
  const factory DailyStatistics({
    required DateTime date,
    required double amount,
    required int count,
    required double averageAmount,
    required double maxAmount,
    required double minAmount,
    Map<ReceiptCategory, double>? categoryAmounts,
  }) = _DailyStatistics;
}

@freezed
class WeeklyStatistics with _$WeeklyStatistics {
  const factory WeeklyStatistics({
    required DateTime startDate,
    required DateTime endDate,
    required double amount,
    required int count,
    required double averageAmount,
    required double maxAmount,
    required double minAmount,
    Map<ReceiptCategory, double>? categoryAmounts,
  }) = _WeeklyStatistics;
}

@freezed
class MonthlyStatistics with _$MonthlyStatistics {
  const factory MonthlyStatistics({
    required DateTime month,
    required double amount,
    required int count,
    required double averageAmount,
    required double maxAmount,
    required double minAmount,
    Map<ReceiptCategory, double>? categoryAmounts,
  }) = _MonthlyStatistics;
}

class StatisticsNotifier extends StateNotifier<StatisticsState> {
  final ApiService _apiService;
  final CacheService _cacheService;

  StatisticsNotifier(this._apiService, this._cacheService)
      : super(const StatisticsState());

  Future<void> loadStatistics({
    DateTime? startDate,
    DateTime? endDate,
    ReceiptCategory? category,
    bool forceRefresh = false,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        startDate: startDate,
        endDate: endDate,
      );

      // 尝试从缓存加载
      final cacheKey = CacheService.generateCacheKey('statistics', {
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'category': category?.toString(),
      });

      final cachedData = !forceRefresh
          ? await _cacheService.getCachedData(cacheKey, (json) => json)
          : null;

      final data = cachedData ??
          await _apiService.getReceiptStatistics(
            startDate: startDate,
            endDate: endDate,
            category: category,
            trendType: state.trendType,
            includeDetails: true,
          );

      if (cachedData == null) {
        await _cacheService.cacheData(cacheKey, data);
      }

      // 解析分类统计
      final categoryStatistics = <ReceiptCategory, CategoryStatistics>{};
      final categoryData = data['category_statistics'] as Map<String, dynamic>;
      final totalAmount = (data['total_amount'] as num).toDouble();

      categoryData.forEach((key, value) {
        final category = ReceiptCategory.values.firstWhere(
          (e) => e.toString().split('.').last == key,
        );
        final stats = value as Map<String, dynamic>;
        categoryStatistics[category] = CategoryStatistics(
          amount: (stats['amount'] as num).toDouble(),
          count: (stats['count'] as num).toInt(),
          percentage: (stats['amount'] as num).toDouble() / totalAmount,
          averageAmount: (stats['average_amount'] as num).toDouble(),
          maxAmount: (stats['max_amount'] as num).toDouble(),
          minAmount: (stats['min_amount'] as num).toDouble(),
          trend: (stats['trend'] as List)
              .map((item) => DailyStatistics(
                    date: DateTime.parse(item['date'] as String),
                    amount: (item['amount'] as num).toDouble(),
                    count: (item['count'] as num).toInt(),
                    averageAmount: (item['average_amount'] as num).toDouble(),
                    maxAmount: (item['max_amount'] as num).toDouble(),
                    minAmount: (item['min_amount'] as num).toDouble(),
                  ))
              .toList(),
        );
      });

      // 解析时间序列统计
      final dailyData = data['daily_statistics'] as List<dynamic>;
      final dailyStatistics = dailyData.map((item) {
        final categoryAmounts = (item['category_amounts'] as Map<String, dynamic>?)
            ?.map((key, value) {
          final category = ReceiptCategory.values.firstWhere(
            (e) => e.toString().split('.').last == key,
          );
          return MapEntry(category, (value as num).toDouble());
        });

        return DailyStatistics(
          date: DateTime.parse(item['date'] as String),
          amount: (item['amount'] as num).toDouble(),
          count: (item['count'] as num).toInt(),
          averageAmount: (item['average_amount'] as num).toDouble(),
          maxAmount: (item['max_amount'] as num).toDouble(),
          minAmount: (item['min_amount'] as num).toDouble(),
          categoryAmounts: categoryAmounts,
        );
      }).toList();

      // 计算周统计
      final weeklyStatistics = _calculateWeeklyStatistics(dailyStatistics);

      // 计算月统计
      final monthlyStatistics = _calculateMonthlyStatistics(dailyStatistics);

      // 加载商家统计
      final merchantData = await _apiService.getMerchantStatistics(
        startDate: startDate,
        endDate: endDate,
      );
      final merchantStatistics = (merchantData['merchant_statistics'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble()));

      // 加载时段统计
      final timeSlotData = await _apiService.getTimeSlotStatistics(
        startDate: startDate,
        endDate: endDate,
        interval: 'hour',
      );
      final timeSlotStatistics = (timeSlotData['time_slot_statistics'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble()));

      // 更新状态
      state = state.copyWith(
        isLoading: false,
        categoryStatistics: categoryStatistics,
        dailyStatistics: dailyStatistics,
        weeklyStatistics: weeklyStatistics,
        monthlyStatistics: monthlyStatistics,
        merchantStatistics: merchantStatistics,
        timeSlotStatistics: timeSlotStatistics,
        totalAmount: totalAmount,
        totalCount: (data['total_count'] as num).toInt(),
        averageAmount: (data['average_amount'] as num).toDouble(),
        maxAmount: (data['max_amount'] as num).toDouble(),
        minAmount: (data['min_amount'] as num).toDouble(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void updateTrendType(String type) {
    state = state.copyWith(trendType: type);
    loadStatistics(
      startDate: state.startDate,
      endDate: state.endDate,
      forceRefresh: true,
    );
  }

  List<WeeklyStatistics> _calculateWeeklyStatistics(
    List<DailyStatistics> dailyStats,
  ) {
    if (dailyStats.isEmpty) return [];

    final weeks = <WeeklyStatistics>[];
    var currentWeekStats = <DailyStatistics>[];

    for (final stat in dailyStats) {
      if (currentWeekStats.isEmpty ||
          stat.date.difference(currentWeekStats.first.date).inDays < 7) {
        currentWeekStats.add(stat);
      } else {
        weeks.add(_createWeeklyStatistics(currentWeekStats));
        currentWeekStats = [stat];
      }
    }

    if (currentWeekStats.isNotEmpty) {
      weeks.add(_createWeeklyStatistics(currentWeekStats));
    }

    return weeks;
  }

  WeeklyStatistics _createWeeklyStatistics(List<DailyStatistics> dailyStats) {
    final amounts = dailyStats.map((s) => s.amount).toList();
    final categoryAmounts = <ReceiptCategory, double>{};

    // 合并所有日期的分类金额
    for (final stat in dailyStats) {
      stat.categoryAmounts?.forEach((category, amount) {
        categoryAmounts[category] =
            (categoryAmounts[category] ?? 0.0) + amount;
      });
    }

    return WeeklyStatistics(
      startDate: dailyStats.first.date,
      endDate: dailyStats.last.date,
      amount: amounts.reduce((a, b) => a + b),
      count: dailyStats.map((s) => s.count).reduce((a, b) => a + b),
      averageAmount: amounts.reduce((a, b) => a + b) / dailyStats.length,
      maxAmount: amounts.reduce((a, b) => a > b ? a : b),
      minAmount: amounts.reduce((a, b) => a < b ? a : b),
      categoryAmounts: categoryAmounts,
    );
  }

  List<MonthlyStatistics> _calculateMonthlyStatistics(
    List<DailyStatistics> dailyStats,
  ) {
    if (dailyStats.isEmpty) return [];

    final monthlyMap = <String, List<DailyStatistics>>{};

    for (final stat in dailyStats) {
      final monthKey =
          '${stat.date.year}-${stat.date.month.toString().padLeft(2, '0')}';
      monthlyMap.putIfAbsent(monthKey, () => []).add(stat);
    }

    return monthlyMap.entries.map((entry) {
      final dailyStats = entry.value;
      final amounts = dailyStats.map((s) => s.amount).toList();
      final categoryAmounts = <ReceiptCategory, double>{};

      // 合并所有日期的分类金额
      for (final stat in dailyStats) {
        stat.categoryAmounts?.forEach((category, amount) {
          categoryAmounts[category] =
              (categoryAmounts[category] ?? 0.0) + amount;
        });
      }

      return MonthlyStatistics(
        month: dailyStats.first.date,
        amount: amounts.reduce((a, b) => a + b),
        count: dailyStats.map((s) => s.count).reduce((a, b) => a + b),
        averageAmount: amounts.reduce((a, b) => a + b) / dailyStats.length,
        maxAmount: amounts.reduce((a, b) => a > b ? a : b),
        minAmount: amounts.reduce((a, b) => a < b ? a : b),
        categoryAmounts: categoryAmounts,
      );
    }).toList();
  }
}

final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final cacheService = CacheService.instance;
  return StatisticsNotifier(apiService, cacheService);
});
