import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/statistics_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../data/models/receipt.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _selectedDateRange;
  String _selectedPeriod = AppConstants.statisticsPeriods[2]; // 默认显示本月

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _updateDateRange(_selectedPeriod);
    _loadStatistics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateDateRange(String period) {
    final now = DateTime.now();
    setState(() {
      _selectedPeriod = period;
      switch (period) {
        case '今日':
          _selectedDateRange = DateTimeRange(
            start: DateTime(now.year, now.month, now.day),
            end: now,
          );
          break;
        case '本周':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          _selectedDateRange = DateTimeRange(
            start: DateTime(weekStart.year, weekStart.month, weekStart.day),
            end: now,
          );
          break;
        case '本月':
          _selectedDateRange = DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          );
          break;
        case '今年':
          _selectedDateRange = DateTimeRange(
            start: DateTime(now.year, 1, 1),
            end: now,
          );
          break;
        case '自定义':
          // 保持当前选择的日期范围
          break;
      }
    });
  }

  Future<void> _loadStatistics() async {
    if (_selectedDateRange != null) {
      await ref.read(statisticsProvider.notifier).loadStatistics(
            startDate: _selectedDateRange!.start,
            endDate: _selectedDateRange!.end,
          );
    }
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: context.colorScheme.primary,
                  onPrimary: context.colorScheme.onPrimary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedPeriod = '自定义';
        _selectedDateRange = picked;
      });
      _loadStatistics();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('消费统计'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '分类统计'),
            Tab(text: '趋势分析'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadStatistics(),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '加载失败: ${state.error}',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadStatistics,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildPeriodSelector(context),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildCategoryStatistics(context, state),
                          _buildTrendStatistics(context, state),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...AppConstants.statisticsPeriods.map(
            (period) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(period),
                selected: _selectedPeriod == period,
                onSelected: (selected) {
                  if (selected) {
                    if (period == '自定义') {
                      _selectDateRange();
                    } else {
                      _updateDateRange(period);
                      _loadStatistics();
                    }
                  }
                },
              ),
            ),
          ),
          if (_selectedDateRange != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextButton.icon(
                onPressed: _selectDateRange,
                icon: const Icon(Icons.date_range, size: 18),
                label: Text(
                  '${DateFormat('MM/dd').format(_selectedDateRange!.start)} - ${DateFormat('MM/dd').format(_selectedDateRange!.end)}',
                  style: context.textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryStatistics(BuildContext context, StatisticsState state) {
    final categories = state.categoryStatistics.keys.toList();
    final statistics = state.categoryStatistics.values.toList();
    final total = statistics.fold<double>(
        0, (sum, stats) => sum + stats.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 总计
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '总消费金额',
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '¥${state.totalAmount.toStringAsFixed(2)}',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMetricItem(
                        context,
                        '总笔数',
                        '${state.totalCount}笔',
                      ),
                      const SizedBox(width: 16),
                      _buildMetricItem(
                        context,
                        '平均消费',
                        '¥${state.averageAmount.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMetricItem(
                        context,
                        '最高消费',
                        '¥${state.maxAmount.toStringAsFixed(2)}',
                      ),
                      const SizedBox(width: 16),
                      _buildMetricItem(
                        context,
                        '最低消费',
                        '¥${state.minAmount.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 饼图
          if (total > 0) ...[
            Text(
              '分类占比',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: List.generate(categories.length, (index) {
                    final category = categories[index];
                    final stats = statistics[index];
                    return PieChartSectionData(
                      color: Colors.primaries[index % Colors.primaries.length],
                      value: stats.amount,
                      title: '${(stats.percentage * 100).toStringAsFixed(1)}%',
                      radius: 100,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 图例
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: List.generate(categories.length, (index) {
                final category = categories[index];
                final stats = statistics[index];
                return _buildLegendItem(
                  context,
                  Colors.primaries[index % Colors.primaries.length],
                  AppConstants.receiptCategoryText[
                      category.toString().split('.').last]!,
                  stats,
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendStatistics(BuildContext context, StatisticsState state) {
    if (state.dailyStatistics.isEmpty) {
      return const Center(child: Text('暂无数据'));
    }

    final trendTypes = AppConstants.trendTypes;

    return Column(
      children: [
        // 趋势类型选择器
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: trendTypes.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(entry.value),
                  selected: state.trendType == entry.key,
                  onSelected: (selected) {
                    if (selected) {
                      ref
                          .read(statisticsProvider.notifier)
                          .updateTrendType(entry.key);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 折线图
                Text(
                  '消费趋势',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: LineChart(
                    _buildLineChartData(context, state),
                  ),
                ),
                const SizedBox(height: 24),
                // 趋势列表
                Text(
                  '消费明细',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTrendList(context, state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _buildLineChartData(BuildContext context, StatisticsState state) {
    final List<FlSpot> spots;
    final List<String> bottomTitles;
    double maxY = 0;

    switch (state.trendType) {
      case 'daily':
        final stats = state.dailyStatistics;
        spots = List.generate(stats.length, (index) {
          final amount = stats[index].amount;
          if (amount > maxY) maxY = amount;
          return FlSpot(index.toDouble(), amount);
        });
        bottomTitles = stats
            .map((s) => DateFormat('dd').format(s.date))
            .toList();
        break;
      case 'weekly':
        final stats = state.weeklyStatistics;
        spots = List.generate(stats.length, (index) {
          final amount = stats[index].amount;
          if (amount > maxY) maxY = amount;
          return FlSpot(index.toDouble(), amount);
        });
        bottomTitles = stats
            .map((s) =>
                '${DateFormat('MM/dd').format(s.startDate)}\n${DateFormat('MM/dd').format(s.endDate)}')
            .toList();
        break;
      case 'monthly':
        final stats = state.monthlyStatistics;
        spots = List.generate(stats.length, (index) {
          final amount = stats[index].amount;
          if (amount > maxY) maxY = amount;
          return FlSpot(index.toDouble(), amount);
        });
        bottomTitles = stats
            .map((s) => DateFormat('yyyy/MM').format(s.month))
            .toList();
        break;
      default:
        spots = [];
        bottomTitles = [];
    }

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < bottomTitles.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    bottomTitles[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: context.colorScheme.primary,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: context.colorScheme.primary.withOpacity(0.1),
          ),
        ),
      ],
      minY: 0,
      maxY: maxY * 1.1,
    );
  }

  Widget _buildTrendList(BuildContext context, StatisticsState state) {
    switch (state.trendType) {
      case 'daily':
        return Column(
          children: state.dailyStatistics.map((stat) => _buildTrendListItem(
                context,
                DateFormat('yyyy-MM-dd').format(stat.date),
                stat.amount,
                stat.count,
                stat.averageAmount,
              )).toList(),
        );
      case 'weekly':
        return Column(
          children: state.weeklyStatistics.map((stat) => _buildTrendListItem(
                context,
                '${DateFormat('MM/dd').format(stat.startDate)} - ${DateFormat('MM/dd').format(stat.endDate)}',
                stat.amount,
                stat.count,
                stat.averageAmount,
              )).toList(),
        );
      case 'monthly':
        return Column(
          children: state.monthlyStatistics.map((stat) => _buildTrendListItem(
                context,
                DateFormat('yyyy年MM月').format(stat.month),
                stat.amount,
                stat.count,
                stat.averageAmount,
              )).toList(),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildTrendListItem(
    BuildContext context,
    String title,
    double amount,
    int count,
    double average,
  ) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('${count}笔 · 平均 ¥${average.toStringAsFixed(2)}'),
        trailing: Text(
          '¥${amount.toStringAsFixed(2)}',
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(BuildContext context, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    Color color,
    String label,
    CategoryStatistics stats,
  ) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.bodyMedium,
                ),
                Text(
                  '¥${stats.amount.toStringAsFixed(2)} (${(stats.percentage * 100).toStringAsFixed(1)}%)',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${stats.count}笔 · 平均 ¥${stats.averageAmount.toStringAsFixed(2)}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
