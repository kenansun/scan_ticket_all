import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/receipt.dart';
import '../providers/filter_state.dart';
import '../../../core/extensions/context_extension.dart';

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.defaultBorderRadius),
            ),
          ),
          child: Column(
            children: [
              // 标题栏
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        notifier.reset();
                      },
                      child: const Text('重置'),
                    ),
                    Text(
                      '筛选',
                      style: context.textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('完成'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 筛选内容
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  children: [
                    // 金额范围
                    _buildSectionTitle(context, '金额范围'),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: '最小金额',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final min = double.tryParse(value);
                              notifier.updateAmountRange(
                                min,
                                filter.maxAmount,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: '最大金额',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final max = double.tryParse(value);
                              notifier.updateAmountRange(
                                filter.minAmount,
                                max,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 日期范围
                    _buildSectionTitle(context, '日期范围'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker(
                            context,
                            '开始日期',
                            filter.startDate,
                            (date) {
                              notifier.updateDateRange(date, filter.endDate);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDatePicker(
                            context,
                            '结束日期',
                            filter.endDate,
                            (date) {
                              notifier.updateDateRange(filter.startDate, date);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 分类
                    _buildSectionTitle(context, '分类'),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('全部'),
                          selected: filter.category == null,
                          onSelected: (selected) {
                            if (selected) {
                              notifier.updateCategory(null);
                            }
                          },
                        ),
                        ...ReceiptCategory.values.map((category) {
                          return FilterChip(
                            label: Text(AppConstants.receiptCategoryText[
                                category.toString().split('.').last]!),
                            selected: filter.category == category,
                            onSelected: (selected) {
                              notifier.updateCategory(
                                selected ? category : null,
                              );
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 状态
                    _buildSectionTitle(context, '状态'),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('全部'),
                          selected: filter.status == null,
                          onSelected: (selected) {
                            if (selected) {
                              notifier.updateStatus(null);
                            }
                          },
                        ),
                        ...ReceiptStatus.values.map((status) {
                          return FilterChip(
                            label: Text(AppConstants.receiptStatusText[
                                status.toString().split('.').last]!),
                            selected: filter.status == status,
                            onSelected: (selected) {
                              notifier.updateStatus(
                                selected ? status : null,
                              );
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 标签
                    _buildSectionTitle(context, '标签'),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('全部'),
                          selected: filter.tags == null,
                          onSelected: (selected) {
                            if (selected) {
                              notifier.updateTags(null);
                            }
                          },
                        ),
                        ...AppConstants.defaultTags.map((tag) {
                          return FilterChip(
                            label: Text(tag),
                            selected: filter.tags?.contains(tag) ?? false,
                            onSelected: (selected) {
                              final currentTags = filter.tags?.toList() ?? [];
                              if (selected) {
                                currentTags.add(tag);
                              } else {
                                currentTags.remove(tag);
                              }
                              notifier.updateTags(
                                currentTags.isEmpty ? null : currentTags,
                              );
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 排序
                    _buildSectionTitle(context, '排序'),
                    ListTile(
                      title: const Text('扫描日期'),
                      trailing: Icon(
                        filter.ascending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                      selected: filter.sortBy == 'scanDate',
                      onTap: () {
                        if (filter.sortBy == 'scanDate') {
                          notifier.updateSort(
                            'scanDate',
                            !filter.ascending,
                          );
                        } else {
                          notifier.updateSort('scanDate', false);
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('金额'),
                      trailing: Icon(
                        filter.ascending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                      selected: filter.sortBy == 'totalAmount',
                      onTap: () {
                        if (filter.sortBy == 'totalAmount') {
                          notifier.updateSort(
                            'totalAmount',
                            !filter.ascending,
                          );
                        } else {
                          notifier.updateSort('totalAmount', false);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    void Function(DateTime?) onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        onChanged(date);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          selectedDate == null
              ? '选择日期'
              : selectedDate.toString().split(' ')[0],
        ),
      ),
    );
  }
}
