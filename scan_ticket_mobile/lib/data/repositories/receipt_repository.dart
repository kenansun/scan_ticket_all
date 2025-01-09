import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/receipt.dart';
import '../../core/services/api_service.dart';

class ReceiptRepository {
  final ApiService _apiService;

  ReceiptRepository(this._apiService);

  Future<String> uploadImage(String filePath) async {
    return await _apiService.uploadImage(filePath);
  }

  Future<Receipt> analyzeReceipt(String imageUrl) async {
    final data = await _apiService.analyzeReceipt(imageUrl);
    return Receipt.fromJson(data);
  }

  Future<List<Receipt>> getReceiptHistory({int page = 1}) async {
    final List<Map<String, dynamic>> data = await _apiService.getReceipts(page: page);
    return data.map((json) => Receipt.fromJson(json)).toList();
  }

  Future<Receipt> getReceiptDetail(String id) async {
    final data = await _apiService.getReceiptDetail(id);
    return Receipt.fromJson(data);
  }

  Future<void> updateReceipt(String id, Map<String, dynamic> data) async {
    await _apiService.updateReceipt(id, data);
  }

  Future<void> deleteReceipt(String id) async {
    await _apiService.deleteReceipt(id);
  }
}

final receiptRepositoryProvider = Provider<ReceiptRepository>((ref) {
  return ReceiptRepository(ApiService());
});
