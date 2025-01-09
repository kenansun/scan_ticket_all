import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/receipt_state.dart';
import '../providers/filter_state.dart';
import '../widgets/filter_sheet.dart';
import '../../../ui/widgets/receipt_card.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extension.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
      ref.read(filterProvider.notifier).updateSearchQuery(_searchController.text);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(receiptStateProvider);
      if (!state.isLoading && state.hasMore) {
        ref.read(receiptStateProvider.notifier).loadReceipts();
      }
    }
  }

  void _showFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterSheet(),
    ).then((_) {
      // 应用筛选条件并重新加载数据
      ref.read(receiptStateProvider.notifier).loadReceipts(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receiptStateProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '搜索商家名称、金额等',
            border: InputBorder.none,
            suffixIcon: _showClearButton
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) {
            ref.read(receiptStateProvider.notifier).loadReceipts(refresh: true);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilter,
          ),
        ],
      ),
      body: Column(
        children: [
          // 活跃筛选条件
          if (_hasActiveFilters(filter))
            Container(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (filter.category != null)
                      _buildFilterChip(
                        AppConstants.receiptCategoryText[
                            filter.category.toString().split('.').last]!,
                        () {
                          ref.read(filterProvider.notifier).updateCategory(null);
                          ref
                              .read(receiptStateProvider.notifier)
                              .loadReceipts(refresh: true);
                        },
                      ),
                    if (filter.status != null)
                      _buildFilterChip(
                        AppConstants.receiptStatusText[
                            filter.status.toString().split('.').last]!,
                        () {
                          ref.read(filterProvider.notifier).updateStatus(null);
                          ref
                              .read(receiptStateProvider.notifier)
                              .loadReceipts(refresh: true);
                        },
                      ),
                    if (filter.minAmount != null || filter.maxAmount != null)
                      _buildFilterChip(
                        '${filter.minAmount ?? 0} - ${filter.maxAmount ?? '∞'}',
                        () {
                          ref
                              .read(filterProvider.notifier)
                              .updateAmountRange(null, null);
                          ref
                              .read(receiptStateProvider.notifier)
                              .loadReceipts(refresh: true);
                        },
                      ),
                    if (filter.startDate != null || filter.endDate != null)
                      _buildFilterChip(
                        '${filter.startDate?.toString().split(' ')[0] ?? ''} - ${filter.endDate?.toString().split(' ')[0] ?? ''}',
                        () {
                          ref
                              .read(filterProvider.notifier)
                              .updateDateRange(null, null);
                          ref
                              .read(receiptStateProvider.notifier)
                              .loadReceipts(refresh: true);
                        },
                      ),
                    if (filter.tags != null)
                      ...filter.tags!.map(
                        (tag) => _buildFilterChip(
                          tag,
                          () {
                            final tags = filter.tags!.toList()..remove(tag);
                            ref
                                .read(filterProvider.notifier)
                                .updateTags(tags.isEmpty ? null : tags);
                            ref
                                .read(receiptStateProvider.notifier)
                                .loadReceipts(refresh: true);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          // 搜索结果
          Expanded(
            child: state.isLoading && state.receipts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.error != null && state.receipts.isEmpty
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
                              onPressed: () {
                                ref
                                    .read(receiptStateProvider.notifier)
                                    .loadReceipts(refresh: true);
                              },
                              child: const Text('重试'),
                            ),
                          ],
                        ),
                      )
                    : state.receipts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: context.colorScheme.primary
                                      .withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '未找到相关小票',
                                  style: context.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await ref
                                  .read(receiptStateProvider.notifier)
                                  .loadReceipts(refresh: true);
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: state.receipts.length +
                                  (state.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.receipts.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final receipt = state.receipts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ReceiptCard(
                                    receipt: receipt,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRouter.receiptDetail,
                                        arguments: receipt.id,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters(ReceiptFilter filter) {
    return filter.category != null ||
        filter.status != null ||
        filter.minAmount != null ||
        filter.maxAmount != null ||
        filter.startDate != null ||
        filter.endDate != null ||
        (filter.tags != null && filter.tags!.isNotEmpty);
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onDeleted,
      ),
    );
  }
}
