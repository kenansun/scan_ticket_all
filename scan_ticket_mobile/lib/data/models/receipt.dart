import 'package:freezed_annotation/freezed_annotation.dart';
import 'receipt_item.dart';

part 'receipt.freezed.dart';
part 'receipt.g.dart';

enum ReceiptStatus {
  @JsonValue('pending')
  pending, // 待处理
  @JsonValue('processing')
  processing, // 处理中
  @JsonValue('completed')
  completed, // 已完成
  @JsonValue('failed')
  failed, // 处理失败
}

enum ReceiptCategory {
  @JsonValue('food')
  food, // 餐饮
  @JsonValue('shopping')
  shopping, // 购物
  @JsonValue('transport')
  transport, // 交通
  @JsonValue('entertainment')
  entertainment, // 娱乐
  @JsonValue('medical')
  medical, // 医疗
  @JsonValue('education')
  education, // 教育
  @JsonValue('other')
  other, // 其他
}

@freezed
class Receipt with _$Receipt {
  const factory Receipt({
    required String id,
    required String imageUrl,
    @Default(ReceiptStatus.pending) ReceiptStatus status,
    @Default(ReceiptCategory.other) ReceiptCategory category,
    
    // 商家信息
    required String merchantName,
    String? merchantAddress,
    String? merchantPhone,
    String? merchantTaxNumber,
    
    // 交易信息
    required DateTime transactionDate,
    String? transactionTime,
    required double totalAmount,
    @Default('CNY') String currency,
    String? paymentMethod,
    
    // 商品清单
    @Default([]) List<ReceiptItem> items,
    
    // 标签
    @Default([]) List<String> tags,
    
    // 元数据
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Receipt;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
}
