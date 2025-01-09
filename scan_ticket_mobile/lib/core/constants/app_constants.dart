import 'package:flutter/foundation.dart';
import '../config/env_config.dart';

class AppConstants {
  // 应用名称
  static const String appName = 'ScanTicket';

  // API 相关
  static const String apiPrefix = '';  // 移除 /api/v1 前缀，因为服务器端已经包含了
  static String get baseUrl => EnvConfig.getBaseUrl();
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int defaultPageSize = 20;
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png'];

  // 缓存相关
  static const String cacheKey = 'scan_ticket_cache';
  static const Duration cacheDuration = Duration(hours: 1);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Map<String, Duration> cachePolicies = {
    'receipts': Duration(minutes: 5),
    'statistics': Duration(minutes: 15),
    'user_data': Duration(hours: 24),
  };

  // UI 相关
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultIconSize = 24.0;
  static const double defaultAvatarSize = 40.0;
  static const double defaultButtonHeight = 48.0;
  static const double defaultCardElevation = 2.0;

  // 动画相关
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // 错误消息
  static const String networkError = '网络连接失败，请检查网络设置';
  static const String serverError = '服务器错误，请稍后重试';
  static const String unknownError = '未知错误，请稍后重试';
  static const String timeoutError = '请求超时，请稍后重试';
  static const String authError = '认证失败，请重新登录';
  static const String validationError = '输入有误，请检查后重试';

  // 小票相关
  static const List<String> defaultTags = [
    '餐饮',
    '交通',
    '购物',
    '娱乐',
    '医疗',
    '其他',
  ];

  static const Map<String, String> receiptStatusText = {
    'pending': '待验证',
    'verified': '已验证',
    'invalid': '无效',
  };

  static const Map<String, String> receiptCategoryText = {
    'food': '餐饮',
    'transport': '交通',
    'shopping': '购物',
    'entertainment': '娱乐',
    'medical': '医疗',
    'other': '其他',
  };

  // 统计相关
  static const List<String> statisticsPeriods = [
    '今日',
    '本周',
    '本月',
    '今年',
    '自定义',
  ];

  static const List<String> statisticsMetrics = [
    '消费金额',
    '消费笔数',
    '平均消费',
    '最高消费',
    '最低消费',
  ];

  static const Map<String, String> trendTypes = {
    'daily': '按日',
    'weekly': '按周',
    'monthly': '按月',
  };

  // 日期格式
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm:ss';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String monthFormat = 'yyyy年MM月';
  static const String yearFormat = 'yyyy年';
}
