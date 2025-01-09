import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/receipt.dart';

part 'filter_state.freezed.dart';

@freezed
class ReceiptFilter with _$ReceiptFilter {
  const factory ReceiptFilter({
    String? searchQuery,
    double? minAmount,
    double? maxAmount,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
    ReceiptCategory? category,
    ReceiptStatus? status,
    @Default('scanDate') String sortBy,
    @Default(false) bool ascending,
  }) = _ReceiptFilter;
}

class FilterNotifier extends StateNotifier<ReceiptFilter> {
  FilterNotifier() : super(const ReceiptFilter());

  void updateSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateAmountRange(double? min, double? max) {
    state = state.copyWith(minAmount: min, maxAmount: max);
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void updateTags(List<String>? tags) {
    state = state.copyWith(tags: tags);
  }

  void updateCategory(ReceiptCategory? category) {
    state = state.copyWith(category: category);
  }

  void updateStatus(ReceiptStatus? status) {
    state = state.copyWith(status: status);
  }

  void updateSort(String sortBy, bool ascending) {
    state = state.copyWith(sortBy: sortBy, ascending: ascending);
  }

  void reset() {
    state = const ReceiptFilter();
  }
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, ReceiptFilter>((ref) {
  return FilterNotifier();
});
