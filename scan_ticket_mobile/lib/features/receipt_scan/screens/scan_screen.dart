import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/scan_state.dart';
import '../../../core/extensions/context_extension.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        await ref.read(scanStateProvider.notifier).scanImage(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('扫描小票'),
        actions: [
          if (state.imagePath != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _pickImage(context, ref),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.imagePath != null) ...[
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    state.imagePath!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (state.isUploading || state.isScanning)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        state.isUploading ? '正在上传图片...' : '正在识别小票...',
                        style: context.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              )
            else if (state.error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '识别失败: ${state.error}',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _pickImage(context, ref),
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                ),
              )
            else if (state.scanResult != null)
              Expanded(
                flex: 3,
                child: Card(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '识别结果',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultItem('商家', state.scanResult!['merchantName']),
                        _buildResultItem('金额', '¥${state.scanResult!['totalAmount']}'),
                        _buildResultItem('日期', state.scanResult!['date']),
                        const Divider(),
                        if (state.scanResult!['items'] != null) ...[
                          const Text(
                            '商品明细',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.from(state.scanResult!['items']).map(
                            (item) => ListTile(
                              dense: true,
                              title: Text(item['name']),
                              trailing: Text('¥${item['price']}'),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Save receipt
                              Navigator.pop(context);
                            },
                            child: const Text('保存'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 64,
                        color: context.colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '点击下方按钮开始扫描小票',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(context, ref),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('开始扫描'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value ?? '未识别'),
        ],
      ),
    );
  }
}
