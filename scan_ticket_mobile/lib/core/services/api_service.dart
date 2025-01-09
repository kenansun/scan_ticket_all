import 'package:dio/dio.dart';
import '../utils/http_client.dart';
import '../constants/app_constants.dart';
import '../../data/models/receipt.dart';

class ApiService {
  final Dio _client = HttpClient.instance;

  // OSS 相关
  Future<String> uploadImage(String filePath) async {
    try {
      // 1. 获取签名
      final signResponse = await _client.post(
        '/api/v1/oss/signature',  
        data: {
          'fileName': filePath.split('/').last,
          'fileType': 'image/jpeg',
        },
      );

      if (signResponse.statusCode != 200) {
        throw Exception('获取上传签名失败');
      }

      final signData = signResponse.data;
      
      // 2. 构建表单数据
      final formData = FormData.fromMap({
        'key': '${signData['dir']}${filePath.split('/').last}',
        'policy': signData['policy'],
        'OSSAccessKeyId': signData['accessId'],
        'success_action_status': '200',
        'signature': signData['signature'],
        'x-oss-object-acl': 'public-read',  
        'file': await MultipartFile.fromFile(filePath),
      });

      // 3. 上传到OSS
      final uploadResponse = await Dio().post(
        signData['host'],
        data: formData,
      );

      if (uploadResponse.statusCode == 200) {
        final url = '${signData['host']}/${signData['dir']}${filePath.split('/').last}';
        print('上传成功: $url');
        return url;
      } else {
        throw Exception('上传失败');
      }
    } catch (e) {
      print('上传失败: $e');
      if (e is DioException) {
        print('请求URL: ${e.requestOptions.uri}');
        print('响应数据: ${e.response?.data}');
      }
      rethrow;
    }
  }

  // AI 分析相关
  Future<Map<String, dynamic>> analyzeReceipt(String imageUrl) async {
    try {
      print('发送AI分析请求 - URL: $imageUrl');
      
      final response = await _client.post(
        '/api/v1/ai/analyze',  
        data: {
          'image_url': imageUrl,
          'options': {
            'language': 'zh_CN',
            'detect_orientation': true
          }
        },
      );

      print('AI分析响应: ${response.data}');
      
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception('响应数据格式错误');
        }
      } else {
        throw Exception('分析失败: ${response.statusCode}');
      }
    } catch (e) {
      print('AI分析请求失败: $e');
      if (e is DioException) {
        print('请求URL: ${e.requestOptions.uri}');
        print('请求数据: ${e.requestOptions.data}');
        print('响应状态: ${e.response?.statusCode}');
        print('响应数据: ${e.response?.data}');
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
        '/api/v1/receipts',
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
        '/api/v1/receipts/$id',
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
        '/api/v1/receipts/$id',
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
        '/api/v1/receipts/$id/status',
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
        '/api/v1/receipts/$id/tags',
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
        '/api/v1/receipts/$id',
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
        '/api/v1/receipts/statistics',
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
        '/api/v1/receipts/merchant-statistics',
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
        '/api/v1/receipts/time-slot-statistics',
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
