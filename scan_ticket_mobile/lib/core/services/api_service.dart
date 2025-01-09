import 'package:dio/dio.dart';
import '../utils/http_client.dart';
import '../constants/app_constants.dart';
import '../../data/models/receipt.dart';

class ApiService {
  final Dio _client = HttpClient.instance;

  // OSS 相关
  Future<String> uploadImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _client.post(
        '${AppConstants.apiPrefix}/oss/upload',
        data: formData,
      );

      if (response.data['code'] == 200) {
        return response.data['data']['url'];
      } else {
        throw Exception(response.data['message'] ?? '上传失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  // AI 分析相关
  Future<Map<String, dynamic>> analyzeReceipt(String imageUrl) async {
    try {
      final response = await _client.post(
        '${AppConstants.apiPrefix}/ai/analyze',
        data: {'image_url': imageUrl},
      );

      if (response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? '分析失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  // 小票相关
  Future<List<Map<String, dynamic>>> getReceipts({
    int page = 1,
    int pageSize = AppConstants.defaultPageSize,
    ReceiptStatus? status,
    ReceiptCategory? category,
    String? searchQuery,
    List<String>? tags,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool? ascending,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'page_size': pageSize,
        if (status != null) 'status': status.toString().split('.').last,
        if (category != null) 'category': category.toString().split('.').last,
        if (searchQuery != null && searchQuery.isNotEmpty) 'q': searchQuery,
        if (tags != null && tags.isNotEmpty) 'tags': tags.join(','),
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (sortBy != null) 'sort_by': sortBy,
        if (ascending != null) 'ascending': ascending,
      };

      final response = await _client.get(
        '${AppConstants.apiPrefix}/receipts',
        queryParameters: queryParams,
      );

      if (response.data['code'] == 200) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '获取小票列表失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getReceiptDetail(String id) async {
    try {
      final response = await _client.get(
        '${AppConstants.apiPrefix}/receipts/$id',
      );

      if (response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? '获取小票详情失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  Future<void> updateReceipt(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.put(
        '${AppConstants.apiPrefix}/receipts/$id',
        data: data,
      );

      if (response.data['code'] != 200) {
        throw Exception(response.data['message'] ?? '更新小票失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  Future<void> updateReceiptStatus(String id, ReceiptStatus status) async {
    try {
      final response = await _client.put(
        '${AppConstants.apiPrefix}/receipts/$id/status',
        data: {'status': status.toString().split('.').last},
      );

      if (response.data['code'] != 200) {
        throw Exception(response.data['message'] ?? '更新小票状态失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  Future<void> updateReceiptTags(String id, List<String> tags) async {
    try {
      final response = await _client.put(
        '${AppConstants.apiPrefix}/receipts/$id/tags',
        data: {'tags': tags},
      );

      if (response.data['code'] != 200) {
        throw Exception(response.data['message'] ?? '更新小票标签失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  Future<void> deleteReceipt(String id) async {
    try {
      final response = await _client.delete(
        '${AppConstants.apiPrefix}/receipts/$id',
      );

      if (response.data['code'] != 200) {
        throw Exception(response.data['message'] ?? '删除小票失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  // 统计相关
  Future<Map<String, dynamic>> getReceiptStatistics({
    DateTime? startDate,
    DateTime? endDate,
    ReceiptCategory? category,
    String? trendType = 'daily',
    bool includeDetails = true,
  }) async {
    try {
      final queryParams = {
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (category != null) 'category': category.toString().split('.').last,
        'trend_type': trendType,
        'include_details': includeDetails,
      };

      final response = await _client.get(
        '${AppConstants.apiPrefix}/receipts/statistics',
        queryParameters: queryParams,
      );

      if (response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? '获取统计数据失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  // 获取商家统计
  Future<Map<String, dynamic>> getMerchantStatistics({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        'limit': limit,
      };

      final response = await _client.get(
        '${AppConstants.apiPrefix}/receipts/merchant-statistics',
        queryParameters: queryParams,
      );

      if (response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? '获取商家统计数据失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }

  // 获取时段统计
  Future<Map<String, dynamic>> getTimeSlotStatistics({
    DateTime? startDate,
    DateTime? endDate,
    String interval = 'hour', // hour, weekday
  }) async {
    try {
      final queryParams = {
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        'interval': interval,
      };

      final response = await _client.get(
        '${AppConstants.apiPrefix}/receipts/time-slot-statistics',
        queryParameters: queryParams,
      );

      if (response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? '获取时段统计数据失败');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? '网络请求失败');
      }
      rethrow;
    }
  }
}
