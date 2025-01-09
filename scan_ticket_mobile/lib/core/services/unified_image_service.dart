import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'oss_upload_service.dart';
import '../services/log_service.dart';

class UnifiedImageService {
  final ImagePicker _picker = ImagePicker();
  final OssUploadService _ossUploadService = OssUploadService();
  final _logger = LogService();

  static const _imageQuality = 85;
  static const _maxWidth = 1920.0;
  static const _maxHeight = 1920.0;

  // 统一的图片获取方法
  Future<String?> getImage({required ImageSource source}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: _imageQuality,
        maxWidth: _maxWidth,
        maxHeight: _maxHeight,
      );

      if (image == null) {
        _logger.info('No image selected/captured');
        return null;
      }

      _logger.info(
        'Image ${source == ImageSource.gallery ? "picked" : "captured"}: ${image.path}',
      );

      // 验证文件
      final file = File(image.path);
      if (!await file.exists()) {
        throw Exception('File not found: ${image.path}');
      }

      final fileSize = await file.length();
      _logger.info('File size: $fileSize bytes');

      // 验证文件类型
      final mimeType = lookupMimeType(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        throw Exception('Invalid file type: $mimeType');
      }

      // 上传到OSS
      return await _ossUploadService.uploadFile(image.path);
    } catch (e, stackTrace) {
      _logger.error(
        'Error processing image',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // 从相册选择图片
  Future<String?> pickImageFromGallery() async {
    return getImage(source: ImageSource.gallery);
  }

  // 拍照
  Future<String?> takePhoto() async {
    return getImage(source: ImageSource.camera);
  }

  // 清理临时文件
  Future<void> cleanupTempFiles() async {
    try {
      final tempDir = Directory.systemTemp;
      if (await tempDir.exists()) {
        await for (var entity in tempDir.list()) {
          if (entity is File) {
            final mimeType = lookupMimeType(entity.path);
            if (mimeType != null && mimeType.startsWith('image/')) {
              try {
                await entity.delete();
                _logger.info('Deleted temp file: ${entity.path}');
              } catch (e) {
                _logger.warning('Failed to delete temp file: ${entity.path} - ${e.toString()}');
              }
            }
          }
        }
      }
    } catch (e, stackTrace) {
      _logger.error('Error cleaning up temp files', error: e, stackTrace: stackTrace);
    }
  }
}
