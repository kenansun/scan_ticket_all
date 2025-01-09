import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/receipt_state.dart';
import '../../../ui/widgets/receipt_card.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/extensions/context_extension.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 初始加载
    Future.microtask(() {
      ref.read(receiptStateProvider.notifier).loadReceipts();
    });

    // 添加滚动监听以实现分页
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receiptStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的小票'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.search);
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.statistics);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(receiptStateProvider.notifier).loadReceipts(refresh: true);
            },
          ),
        ],
      ),
      body: state.isLoading && state.receipts.isEmpty
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
                            Icons.receipt_long,
                            size: 64,
                            color: context.colorScheme.primary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '暂无小票',
                            style: context.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '点击右下角按钮开始扫描',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
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
                        itemCount: state.receipts.length + (state.hasMore ? 1 : 0),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.scan);
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
