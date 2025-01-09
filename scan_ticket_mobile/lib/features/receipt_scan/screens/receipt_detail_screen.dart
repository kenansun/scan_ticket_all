import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/receipt.dart';
import '../../../core/extensions/context_extension.dart';
import '../providers/receipt_state.dart';

class ReceiptDetailScreen extends ConsumerWidget {
  final String receiptId;

  const ReceiptDetailScreen({
    super.key,
    required this.receiptId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('小票详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await context.showConfirmDialog(
                title: '删除小票',
                message: '确定要删除这张小票吗？此操作不可撤销。',
              );
              
              if (confirm == true && context.mounted) {
                await ref.read(receiptStateProvider.notifier).deleteReceipt(receiptId);
                if (context.mounted) {
                  context.pop();
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Receipt?>(
        future: ref.read(receiptStateProvider.notifier).getReceiptDetail(receiptId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '加载失败: ${snapshot.error}',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // 强制重新加载
                      ref.refresh(receiptStateProvider);
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          final receipt = snapshot.data;
          if (receipt == null) {
            return const Center(child: Text('未找到小票信息'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (receipt.imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      receipt.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 48),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                _buildSection(
                  context,
                  '基本信息',
                  [
                    _buildInfoRow('商家', receipt.merchantName ?? '未知'),
                    _buildInfoRow(
                      '金额',
                      '¥${receipt.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                    _buildInfoRow(
                      '日期',
                      receipt.scanDate.toString().split('.')[0],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (receipt.details != null && receipt.details!.isNotEmpty) ...[
                  _buildSection(
                    context,
                    '商品明细',
                    receipt.details!['items']?.map<Widget>((item) {
                          return ListTile(
                            dense: true,
                            title: Text(item['name'] ?? '未知商品'),
                            trailing: Text('¥${item['price']?.toString() ?? '0.00'}'),
                          );
                        }).toList() ??
                        [],
                  ),
                  const SizedBox(height: 24),
                ],
                if (receipt.note != null && receipt.note!.isNotEmpty) ...[
                  _buildSection(
                    context,
                    '备注',
                    [Text(receipt.note!)],
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
