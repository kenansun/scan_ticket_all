import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheService {
  static CacheService? _instance;
  late DefaultCacheManager _cacheManager;
  
  CacheService._();
  
  static CacheService get instance {
    _instance ??= CacheService._();
    return _instance!;
  }
  
  Future<void> init() async {
    final cacheDir = await getTemporaryDirectory();
    _cacheManager = DefaultCacheManager();
  }
  
  static String generateCacheKey(String prefix, Map<String, dynamic> params) {
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return '$prefix:${json.encode(sortedParams)}';
  }
  
  Future<void> cacheData(String key, dynamic data) async {
    final jsonString = json.encode(data);
    await _cacheManager.putFile(
      key,
      Uint8List.fromList(utf8.encode(jsonString)).buffer.asUint8List(),
      key: key,
      maxAge: const Duration(hours: 1),
    );
  }
  
  Future<T?> getCachedData<T>(String key, T Function(dynamic json) fromJson) async {
    try {
      final file = await _cacheManager.getFileFromCache(key);
      if (file == null) return null;
      
      final content = await file.file.readAsString();
      final json = jsonDecode(content);
      return fromJson(json);
    } catch (e) {
      return null;
    }
  }
  
  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
  
  Future<void> removeCachedItem(String key) async {
    await _cacheManager.removeFile(key);
  }
}
