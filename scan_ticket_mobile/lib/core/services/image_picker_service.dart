import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'oss_upload_service.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final OssUploadService _ossUploadService = OssUploadService();

  // 从相册选择图片
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        print('Image picked from gallery: ${image.path}');
        print('Image exists: ${await File(image.path).exists()}');
        print('Image size: ${await File(image.path).length()} bytes');
        
        // 上传到OSS并返回URL
        return await _ossUploadService.uploadFile(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      rethrow;
    }
  }

  // 拍照
  Future<String?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (photo != null) {
        print('Photo taken: ${photo.path}');
        print('Photo exists: ${await File(photo.path).exists()}');
        print('Photo size: ${await File(photo.path).length()} bytes');
        
        // 上传到OSS并返回URL
        return await _ossUploadService.uploadFile(photo.path);
      }
      return null;
    } catch (e) {
      print('Error taking photo: $e');
      rethrow;
    }
  }

  // 清理临时文件
  Future<void> cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();
      
      for (var file in files) {
        if (file is File && 
            (file.path.endsWith('.jpg') || 
             file.path.endsWith('.jpeg') || 
             file.path.endsWith('.png'))) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error cleaning up temp files: $e');
    }
  }
}
