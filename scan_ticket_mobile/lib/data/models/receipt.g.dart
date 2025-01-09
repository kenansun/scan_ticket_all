// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReceiptImpl _$$ReceiptImplFromJson(Map<String, dynamic> json) =>
    _$ReceiptImpl(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      scanDate: DateTime.parse(json['scanDate'] as String),
      merchantName: json['merchantName'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      details: json['details'] as Map<String, dynamic>?,
      note: json['note'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      status: $enumDecodeNullable(_$ReceiptStatusEnumMap, json['status']) ??
          ReceiptStatus.pending,
      category:
          $enumDecodeNullable(_$ReceiptCategoryEnumMap, json['category']) ??
              ReceiptCategory.other,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      location: json['location'] as String?,
      merchantAddress: json['merchantAddress'] as String?,
      merchantPhone: json['merchantPhone'] as String?,
      taxNumber: json['taxNumber'] as String?,
      taxAmount: (json['taxAmount'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      serialNumber: json['serialNumber'] as String?,
    );

Map<String, dynamic> _$$ReceiptImplToJson(_$ReceiptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'scanDate': instance.scanDate.toIso8601String(),
      'merchantName': instance.merchantName,
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'details': instance.details,
      'note': instance.note,
      'tags': instance.tags,
      'status': _$ReceiptStatusEnumMap[instance.status]!,
      'category': _$ReceiptCategoryEnumMap[instance.category]!,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'location': instance.location,
      'merchantAddress': instance.merchantAddress,
      'merchantPhone': instance.merchantPhone,
      'taxNumber': instance.taxNumber,
      'taxAmount': instance.taxAmount,
      'paymentMethod': instance.paymentMethod,
      'serialNumber': instance.serialNumber,
    };

const _$ReceiptStatusEnumMap = {
  ReceiptStatus.pending: 'pending',
  ReceiptStatus.verified: 'verified',
  ReceiptStatus.invalid: 'invalid',
};

const _$ReceiptCategoryEnumMap = {
  ReceiptCategory.food: 'food',
  ReceiptCategory.transport: 'transport',
  ReceiptCategory.shopping: 'shopping',
  ReceiptCategory.entertainment: 'entertainment',
  ReceiptCategory.medical: 'medical',
  ReceiptCategory.other: 'other',
};
