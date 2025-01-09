import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../constants/app_constants.dart';
import '../services/log_service.dart';

class OssUploadService {
  final Dio _dio = Dio(BaseOptions(
    // 设置更合理的超时时间
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    validateStatus: (status) => status! < 500,
  ))
    ..interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ))
    ..interceptors.add(
      RetryInterceptor(
        dio: Dio(),
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryableExtraStatuses: {408, 429}, // 添加额外的需要重试的状态码
      ),
    )
    ..httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );

  final _logger = LogService();
  static const _tag = '[OssUpload]';

  // 创建一个新的Dio实例用于OSS上传
  Dio _createOssDio() {
    return Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
    ))
      ..interceptors.add(
        RetryInterceptor(
          dio: Dio(),
          retries: 3,
          retryDelays: const [
            Duration(seconds: 1),
            Duration(seconds: 2),
            Duration(seconds: 3),
          ],
          retryableExtraStatuses: {408, 429},
        ),
      )
      ..httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        },
      );
  }

  // 获取服务器签名
  Future<Map<String, dynamic>> _getSignature(String fileName, String fileType) async {
    try {
      final url = '${AppConstants.baseUrl}/api/v1/oss/signature';
      _logger.info('Getting signature from: $url', tag: _tag);
      
      final response = await _dio.post(
        url,
        data: {
          'fileName': fileName,
          'fileType': fileType,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      _logger.debug('''
Signature Response:
uri: $url
statusCode: ${response.statusCode}
headers: ${response.headers}
Response Data: ${response.data}
''', tag: _tag);
      
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw Exception('Failed to get signature: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.error('Error getting signature', error: e, stackTrace: stackTrace, tag: _tag);
      rethrow;
    }
  }

  // 复制文件到应用目录
  Future<File> _copyToAppDir(String filePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(filePath);
      final targetPath = path.join(appDir.path, fileName);
      
      _logger.info('Copying file to app directory: $targetPath', tag: _tag);
      
      // 复制文件
      return await File(filePath).copy(targetPath);
    } catch (e) {
      _logger.error('Error copying file', error: e, tag: _tag);
      rethrow;
    }
  }

  // 上传文件到OSS
  Future<String> uploadFile(String filePath) async {
    try {
      // 首先复制文件到应用目录
      final File file = await _copyToAppDir(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: ${file.path}');
      }

      // 获取文件信息
      final String fileName = path.basename(file.path);
      final String? mimeType = lookupMimeType(file.path);
      
      if (mimeType == null) {
        throw Exception('Could not determine file type');
      }

      // 获取签名
      final signatureData = await _getSignature(fileName, mimeType);
      if (!signatureData.containsKey('host') || !signatureData.containsKey('dir')) {
        throw Exception('Invalid signature response: missing host or dir');
      }

      final String key = '${signatureData['dir']}$fileName';
      final String uploadUrl = signatureData['host'].toString();
      
      _logger.info('''
Preparing OSS upload:
URL: $uploadUrl
Key: $key
File: ${file.path}
Size: ${await file.length()} bytes
''', tag: _tag);

      // 准备表单数据
      final formData = FormData.fromMap({
        'key': key,
        'policy': signatureData['policy'],
        'OSSAccessKeyId': signatureData['accessId'],
        'success_action_status': '200',
        'signature': signatureData['signature'],
        'file': MultipartFileRecreatable.fromFileSync(
          file.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      // 使用新的Dio实例上传到OSS
      final ossDio = _createOssDio();
      final response = await ossDio.post(
        uploadUrl,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Accept': '*/*',
            'Host': Uri.parse(uploadUrl).host,
            'User-Agent': 'ScanTicket/1.0',
            'Connection': 'keep-alive',
          },
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      _logger.debug('''
Upload Response:
URL: $uploadUrl
Status: ${response.statusCode}
Headers: ${response.headers}
Data: ${response.data}
''', tag: _tag);
      
      if (response.statusCode == 200) {
        final url = '$uploadUrl/$key';
        _logger.info('Upload successful: $url', tag: _tag);
        return url;
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.error('Upload error', error: e, stackTrace: stackTrace, tag: _tag);
      rethrow;
    }
  }
}
