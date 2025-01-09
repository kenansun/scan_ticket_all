import 'package:flutter/material.dart';
import '../../data/models/receipt.dart';
import '../../core/extensions/context_extension.dart';

class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  final VoidCallback? onTap;

  const ReceiptCard({
    super.key,
    required this.receipt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      receipt.merchantName ?? '未知商家',
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '¥${receipt.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                receipt.scanDate.toString().split('.')[0],
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              if (receipt.note != null) ...[
                const SizedBox(height: 8),
                Text(
                  receipt.note!,
                  style: context.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
