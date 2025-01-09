import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/repositories/receipt_repository.dart';

part 'scan_state.freezed.dart';

@freezed
class ScanState with _$ScanState {
  const factory ScanState({
    String? imagePath,
    String? imageUrl,
    @Default(false) bool isScanning,
    @Default(false) bool isUploading,
    String? error,
    Map<String, dynamic>? scanResult,
  }) = _$ScanStateImpl;
}

class ScanStateNotifier extends StateNotifier<ScanState> {
  final ReceiptRepository _repository;

  ScanStateNotifier(this._repository) : super(const ScanState());

  Future<void> scanImage(String imagePath) async {
    state = state.copyWith(
      imagePath: imagePath,
      isScanning: true,
      error: null,
      scanResult: null,
    );

    try {
      // 上传图片
      state = state.copyWith(isUploading: true);
      final url = await _repository.uploadImage(imagePath);
      state = state.copyWith(
        isUploading: false,
        imageUrl: url,
      );

      // 分析小票
      final result = await _repository.analyzeReceipt(url);
      
      state = state.copyWith(
        isScanning: false,
        scanResult: result.toJson(),
      );
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        isUploading: false,
        error: e.toString(),
      );
    }
  }

  // 设置已上传图片的URL
  Future<void> setImageUrl(String imageUrl) async {
    state = state.copyWith(
      imagePath: imageUrl,
      isScanning: true,
      error: null,
      scanResult: null,
    );

    try {
      // 直接分析小票,因为图片已经上传
      final result = await _repository.analyzeReceipt(imageUrl);
      
      state = state.copyWith(
        isScanning: false,
        scanResult: result.toJson(),
      );
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const ScanState();
  }
}

final scanStateProvider =
    StateNotifierProvider<ScanStateNotifier, ScanState>((ref) {
  final repository = ref.watch(receiptRepositoryProvider);
  return ScanStateNotifier(repository);
});
