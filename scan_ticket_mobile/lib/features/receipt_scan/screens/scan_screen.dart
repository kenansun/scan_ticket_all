import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../providers/scan_state.dart';
import '../../../core/extensions/context_extension.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  Future<void> _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        await ref.read(scanStateProvider.notifier).scanImage(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(ref.context!).showSnackBar(
        SnackBar(content: Text('选择图片失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('扫描小票'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(scanStateProvider);
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (state.imagePath != null) ...[
                    AspectRatio(
                      aspectRatio: 3/4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: state.imageUrl != null
                            ? Image.network(
                                state.imageUrl!,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  print('图片加载错误: $error');
                                  return state.imagePath != null
                                      ? Image.file(
                                          File(state.imagePath!),
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.error);
                                },
                              )
                            : Image.file(
                                File(state.imagePath!),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (state.isUploading || state.isScanning)
                    const CircularProgressIndicator(),
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (state.scanResult != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '识别结果',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(state.scanResult.toString()),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(ref),
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
