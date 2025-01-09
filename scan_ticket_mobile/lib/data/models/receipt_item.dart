import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_item.freezed.dart';
part 'receipt_item.g.dart';

@freezed
class ReceiptItem with _$ReceiptItem {
  const factory ReceiptItem({
    required String name,
    required double quantity,
    required double unitPrice,
    required double total,
    String? unit,
  }) = _ReceiptItem;

  factory ReceiptItem.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemFromJson(json);
}
