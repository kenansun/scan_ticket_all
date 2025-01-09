import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_constants.dart';
import '../network/api_client.dart';

class ImageUploadService {
  final ApiClient _apiClient;
  final ImagePicker _imagePicker;

  ImageUploadService({
    ApiClient? apiClient,
    ImagePicker? imagePicker,
  })  : _apiClient = apiClient ?? ApiClient(),
        _imagePicker = imagePicker ?? ImagePicker();

  // 从相册选择图片
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  // 拍照获取图片
  Future<File?> takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (photo != null) {
      return File(photo.path);
    }
    return null;
  }

  // 获取OSS上传签名
  Future<Map<String, dynamic>> _getOssSignature() async {
    try {
      final response = await _apiClient.get('${AppConstants.apiPrefix}/oss/signature');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get OSS signature: $e');
    }
  }

  // 上传图片到OSS
  Future<String> uploadImage(File imageFile) async {
    try {
      // 1. 获取OSS签名信息
      final ossSignature = await _getOssSignature();
      
      // 2. 构建OSS上传请求
      final formData = FormData.fromMap({
        'OSSAccessKeyId': ossSignature['accessKeyId'],
        'policy': ossSignature['policy'],
        'signature': ossSignature['signature'],
        'key': ossSignature['key'],
        'success_action_status': '200',
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: ossSignature['key'],
        ),
      });

      // 3. 上传到OSS
      final response = await Dio().post(
        ossSignature['host'],
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        // 返回完整的图片URL
        return '${ossSignature['host']}/${ossSignature['key']}';
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
