import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt.freezed.dart';
part 'receipt.g.dart';

enum ReceiptStatus {
  @JsonValue('pending')
  pending, // 待验证
  @JsonValue('verified')
  verified, // 已验证
  @JsonValue('invalid')
  invalid, // 无效
}

enum ReceiptCategory {
  @JsonValue('food')
  food, // 餐饮
  @JsonValue('transport')
  transport, // 交通
  @JsonValue('shopping')
  shopping, // 购物
  @JsonValue('entertainment')
  entertainment, // 娱乐
  @JsonValue('medical')
  medical, // 医疗
  @JsonValue('other')
  other, // 其他
}

@freezed
class Receipt with _$Receipt {
  const factory Receipt({
    required String id,
    required String imageUrl,
    required DateTime scanDate,
    String? merchantName,
    double? totalAmount,
    String? currency,
    Map<String, dynamic>? details,
    String? note,
    @Default([]) List<String> tags,
    @Default(ReceiptStatus.pending) ReceiptStatus status,
    @Default(ReceiptCategory.other) ReceiptCategory category,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? location,
    String? merchantAddress,
    String? merchantPhone,
    String? taxNumber,
    double? taxAmount,
    String? paymentMethod,
    String? serialNumber,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);
}
