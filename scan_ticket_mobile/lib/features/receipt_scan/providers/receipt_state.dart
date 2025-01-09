import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/receipt.dart';
import '../../../data/repositories/receipt_repository.dart';

part 'receipt_state.freezed.dart';

@freezed
class ReceiptState with _$ReceiptState {
  const factory ReceiptState({
    @Default([]) List<Receipt> receipts,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    @Default(1) int currentPage,
    String? error,
    Receipt? selectedReceipt,
  }) = _ReceiptState;
}

class ReceiptStateNotifier extends StateNotifier<ReceiptState> {
  final ReceiptRepository _repository;

  ReceiptStateNotifier(this._repository) : super(const ReceiptState());

  Future<void> loadReceipts({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        currentPage: 1,
        hasMore: false,
        receipts: [],
      );
    }

    if (state.isLoading || (!state.hasMore && !refresh)) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newReceipts = await _repository.getReceiptHistory(
        page: state.currentPage,
      );
      
      state = state.copyWith(
        receipts: [...state.receipts, ...newReceipts],
        currentPage: state.currentPage + 1,
        hasMore: newReceipts.isNotEmpty,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void selectReceipt(Receipt? receipt) {
    state = state.copyWith(selectedReceipt: receipt);
  }

  Future<void> deleteReceipt(String id) async {
    try {
      await _repository.deleteReceipt(id);
      state = state.copyWith(
        receipts: state.receipts.where((r) => r.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<Receipt?> getReceiptDetail(String id) async {
    try {
      final receipt = await _repository.getReceiptDetail(id);
      return receipt;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<void> updateReceipt(Receipt updatedReceipt) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _repository.updateReceipt(
        updatedReceipt.id,
        updatedReceipt.toJson(),
      );
      
      final updatedReceipts = state.receipts.map((receipt) {
        return receipt.id == updatedReceipt.id ? updatedReceipt : receipt;
      }).toList();
      
      state = state.copyWith(
        isLoading: false,
        receipts: updatedReceipts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final receiptStateProvider =
    StateNotifierProvider<ReceiptStateNotifier, ReceiptState>((ref) {
  final repository = ref.watch(receiptRepositoryProvider);
  return ReceiptStateNotifier(repository);
});
