# ScanTicket - 智能购物小票识别与翻译应用

## 项目概述
ScanTicket是一款基于Flutter开发的跨平台移动应用，通过结合DeepSeek和OpenAI大模型的能力，为用户提供智能的购物小票识别、信息提取和多语言翻译功能。应用支持多种登录方式，提供个性化的用户体验和全面的购物历史管理功能。

## 核心功能

### 用户系统
- 登录方式：
  - 手机号码登录（验证码）
  - 微信快捷登录
- 用户信息管理：
  - 个人头像
  - 用户昵称
  - 母语设置
  - 生日信息
  - 账户设置

### 小票识别与处理
- 智能识别购物小票
- 自动提取关键信息：
  - 商品名称和价格
  - 购买日期和时间
  - 商家信息
  - 总金额
- 多语言翻译支持
- 自定义备注功能

### 历史记录管理
- 多维度查询：
  - 地区筛选
  - 商品类别分类
  - 日期范围查询
- 数据展示：
  - 列表视图
  - 详情展示
  - 数据统计
- 自定义标签和备注
- 支持排序和筛选

### 分享与导出功能
- 消费记录分享：
  - 生成分享卡片
  - 支持微信分享
  - 自定义分享内容
  - 隐私保护选项
- 数据导出：
  - Excel格式导出
  - 自定义导出字段
  - 批量导出支持
  - 导出历史记录

### 智能建议系统（未来规划）
- 基于群体数据的智能分析：
  - 消费模式识别
  - 价格对比建议
  - 消费优化建议
- 个性化建议：
  - 基于用户画像
  - 考虑地域特征
  - 季节性建议
- 智能提醒：
  - 异常消费提醒
  - 预算管理建议
  - 省钱机会提示

## 技术栈
### 移动端
- 框架：Flutter
- 数据库：SQLite
- 状态管理：Provider/Riverpod

### 后端服务
- 大模型集成：
  - DeepSeek：中文场景优化
  - OpenAI：复杂语义理解
- 翻译服务：
  - 主要：DeepL API
  - 备选：Google Cloud Translation API
- 用户认证：
  - 手机号验证服务
  - 微信开放平台
- 数据分析：
  - 用户数据聚合分析
  - 智能建议算法

## 技术设计文档

### 状态管理方案
项目采用 Riverpod + BLoC 的混合状态管理方案：

#### Riverpod
- 用于管理全局状态和简单状态
- 处理异步操作和依赖注入
- 主要使用场景：
  - 用户会话管理
  - 应用配置
  - 主题设置
  - 简单的UI状态

```dart
// Riverpod Providers 示例
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
```

#### BLoC
- 用于处理复杂业务逻辑和多步骤操作
- 主要使用场景：
  - 小票扫描流程
  - 数据分析处理
  - 复杂表单处理
  - 多步骤操作流程

```dart
// BLoC 示例
class ReceiptScanBloc extends Bloc<ReceiptScanEvent, ReceiptScanState> {
  ReceiptScanBloc() : super(ReceiptScanInitial()) {
    on<StartScan>(_onStartScan);
    on<ProcessImage>(_onProcessImage);
    on<ExtractData>(_onExtractData);
  }
}
```

### 数据流设计

#### 1. 整体数据流架构
```
UI层 <-> BLoC/Provider层 <-> Repository层 <-> Service层 <-> 外部服务/本地存储
```

#### 2. 核心数据流

##### 2.1 小票识别流程
```dart
// 1. 数据模型
class Receipt {
  final String id;
  final String imageUrl;
  final List<ReceiptItem> items;
  final double totalAmount;
  final DateTime purchaseDate;
  final String merchantName;
  // ... 其他字段
}

// 2. Repository
abstract class ReceiptRepository {
  Future<Receipt> scanReceipt(File image);
  Future<List<Receipt>> getReceiptHistory();
  Future<void> saveReceipt(Receipt receipt);
}

// 3. Service 实现
class ReceiptService implements ReceiptRepository {
  final OCRService ocrService;
  final AIService aiService;
  final DatabaseService dbService;

  @override
  Future<Receipt> scanReceipt(File image) async {
    // OCR处理
    final ocrResult = await ocrService.processImage(image);
    
    // AI解析
    final parsedData = await aiService.parseReceiptData(ocrResult);
    
    // 保存数据
    final receipt = Receipt.fromParsedData(parsedData);
    await dbService.saveReceipt(receipt);
    
    return receipt;
  }
}

// 4. BLoC实现
class ReceiptScanBloc extends Bloc<ReceiptScanEvent, ReceiptScanState> {
  final ReceiptRepository repository;

  ReceiptScanBloc(this.repository) : super(ReceiptScanInitial()) {
    on<ScanReceiptEvent>(_onScanReceipt);
  }

  Future<void> _onScanReceipt(
    ScanReceiptEvent event,
    Emitter<ReceiptScanState> emit,
  ) async {
    emit(ReceiptScanLoading());
    try {
      final receipt = await repository.scanReceipt(event.image);
      emit(ReceiptScanSuccess(receipt));
    } catch (e) {
      emit(ReceiptScanFailure(e.toString()));
    }
  }
}
```

##### 2.2 用户数据流
```dart
// 1. 用户状态管理
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.read(authRepositoryProvider));
});

class UserNotifier extends StateNotifier<UserState> {
  final AuthRepository _authRepository;

  UserNotifier(this._authRepository) : super(const UserState.initial()) {
    _init();
  }

  Future<void> _init() async {
    final user = await _authRepository.getCurrentUser();
    state = user != null 
      ? UserState.authenticated(user)
      : const UserState.unauthenticated();
  }
}

// 2. 数据持久化
class AuthRepository {
  final AuthService _authService;
  final SecureStorage _secureStorage;

  Future<User?> getCurrentUser() async {
    final token = await _secureStorage.getToken();
    if (token == null) return null;
    return _authService.getUserProfile(token);
  }
}
```

##### 2.3 数据同步流程
```dart
class SyncService {
  final DatabaseService _dbService;
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  // 数据同步策略
  Future<void> syncData() async {
    if (!await _connectivityService.isConnected()) {
      return;
    }

    // 获取本地未同步数据
    final unsyncedData = await _dbService.getUnsyncedData();
    
    // 批量同步到服务器
    for (var data in unsyncedData) {
      try {
        await _apiService.sync(data);
        await _dbService.markAsSynced(data.id);
      } catch (e) {
        // 记录同步失败，稍后重试
        await _dbService.markSyncFailed(data.id, e.toString());
      }
    }
  }
}
```

#### 3. 数据缓存策略

##### 3.1 图片缓存
```dart
class ImageCacheService {
  final Cache _cache;
  
  Future<File> getCachedImage(String url) async {
    return await _cache.getFile(url, () async {
      final response = await http.get(Uri.parse(url));
      return response.bodyBytes;
    });
  }
}
```

##### 3.2 API响应缓存
```dart
class ApiCacheInterceptor extends Interceptor {
  final Cache _cache;
  
  @override
  Future onRequest(RequestOptions options) async {
    if (!options.method == 'GET') return options;
    
    final cacheKey = _generateCacheKey(options);
    final cachedResponse = await _cache.get(cacheKey);
    
    if (cachedResponse != null) {
      return Response(
        requestOptions: options,
        data: cachedResponse,
        statusCode: 200,
      );
    }
    
    return options;
  }
}
```

#### 4. 错误处理流
```dart
// 1. 异常定义
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

// 2. 错误处理中间件
class ErrorHandler {
  static Future<T> handle<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on NetworkException catch (e) {
      // 网络错误处理
      await _handleNetworkError(e);
      rethrow;
    } on ValidationException catch (e) {
      // 数据验证错误处理
      await _handleValidationError(e);
      rethrow;
    } catch (e) {
      // 未知错误处理
      await _handleUnknownError(e);
      rethrow;
    }
  }
}
```

#### 5. 数据验证流程
```dart
class ReceiptValidator {
  static ValidationResult validate(Receipt receipt) {
    return ValidationResult(
      isValid: _validateAmount(receipt.totalAmount) &&
               _validateItems(receipt.items) &&
               _validateDate(receipt.purchaseDate),
      errors: _collectErrors(receipt),
    );
  }
}

#### 6. 数据库Schema设计

##### 6.1 表结构设计

###### 用户表 (users)
```sql
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    phone_number TEXT UNIQUE,
    wechat_id TEXT UNIQUE,
    nickname TEXT NOT NULL,
    avatar_url TEXT,
    native_language TEXT NOT NULL,
    birthday DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

###### 小票表 (receipts)
```sql
CREATE TABLE receipts (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    
    -- 基本信息
    receipt_type TEXT NOT NULL CHECK(receipt_type IN (
        'retail',        -- 零售
        'restaurant',    -- 餐饮
        'transportation',-- 交通
        'service',       -- 服务
        'entertainment', -- 娱乐
        'medical',       -- 医疗
        'invoice',       -- 发票
        'other'         -- 其他
    )),
    
    -- 商家信息
    merchant_name TEXT NOT NULL,
    merchant_category TEXT,  -- 商家类别
    merchant_branch TEXT,    -- 分店信息
    merchant_address TEXT,
    merchant_phone TEXT,
    merchant_tax_number TEXT,
    
    -- 交易信息
    transaction_number TEXT,  -- 交易编号
    purchase_date TIMESTAMP NOT NULL,
    purchase_time TIME NOT NULL,
    
    -- 金额信息
    total_amount DECIMAL(10,2) NOT NULL,
    subtotal_amount DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    service_charge DECIMAL(10,2),  -- 服务费
    tips_amount DECIMAL(10,2),     -- 小费（餐饮）
    currency TEXT NOT NULL,
    
    -- 支付信息
    payment_method TEXT CHECK(payment_method IN (
        'cash',
        'credit_card',
        'debit_card',
        'mobile_payment',
        'other'
    )),
    payment_status TEXT,
    
    -- 发票特定信息
    invoice_type TEXT,          -- 发票类型
    invoice_number TEXT,        -- 发票号码
    tax_rate DECIMAL(5,2),      -- 税率
    
    -- 位置信息
    location TEXT,
    location_lat DECIMAL(10,8),
    location_lng DECIMAL(10,8),
    
    -- 图片信息
    image_url TEXT,
    image_hash TEXT,
    image_quality REAL,
    
    -- 处理信息
    ocr_text TEXT,
    ocr_confidence REAL,
    language_detected TEXT,    -- 检测到的语言
    
    -- 状态信息
    status TEXT NOT NULL,
    sync_status TEXT NOT NULL,
    processing_attempts INTEGER DEFAULT 0,
    last_error TEXT,
    
    -- 统计信息
    notes_count INTEGER DEFAULT 0,
    items_count INTEGER DEFAULT 0,
    
    -- 时间戳
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id)
);

###### 商品表 (receipt_items)
```sql
CREATE TABLE receipt_items (
    id TEXT PRIMARY KEY,
    receipt_id TEXT NOT NULL,
    
    -- 商品基本信息
    name TEXT NOT NULL,
    original_name TEXT,
    description TEXT,
    
    -- 数量和单位
    quantity DECIMAL(10,3) NOT NULL,
    unit TEXT,
    
    -- 价格信息
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    discount_rate DECIMAL(5,2),
    
    -- 税费信息
    tax_rate DECIMAL(5,2),
    tax_amount DECIMAL(10,2),
    
    -- 商品属性
    sku TEXT,
    barcode TEXT,
    specifications TEXT,
    
    -- 位置信息
    position_x INTEGER,
    position_y INTEGER,
    line_number INTEGER,
    
    -- OCR相关
    ocr_confidence REAL,
    needs_review BOOLEAN DEFAULT FALSE,
    
    -- 时间戳
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (receipt_id) REFERENCES receipts(id),
    FOREIGN KEY (category_id) REFERENCES item_categories(id)
);

###### 商品分类表 (item_categories)
```sql
CREATE TABLE item_categories (
    id TEXT PRIMARY KEY,
    receipt_type TEXT NOT NULL,
    category_name TEXT NOT NULL,
    parent_category_id TEXT,
    FOREIGN KEY (parent_category_id) REFERENCES item_categories(id)
);

###### 标签表 (tags)
```sql
CREATE TABLE tags (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    name TEXT NOT NULL,
    color TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

###### 小票标签关联表 (receipt_tags)
```sql
CREATE TABLE receipt_tags (
    receipt_id TEXT NOT NULL,
    tag_id TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (receipt_id, tag_id),
    FOREIGN KEY (receipt_id) REFERENCES receipts(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

###### 翻译缓存表 (translation_cache)
```sql
CREATE TABLE translation_cache (
    id TEXT PRIMARY KEY,
    original_text TEXT NOT NULL,
    translated_text TEXT NOT NULL,
    source_language TEXT NOT NULL,
    target_language TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(original_text, source_language, target_language)
);

###### AI解析结果表 (ai_extraction_results)
```sql
CREATE TABLE ai_extraction_results (
    id TEXT PRIMARY KEY,
    receipt_id TEXT NOT NULL,
    
    -- 原始解析结果
    raw_json TEXT NOT NULL,           -- 大模型返回的原始JSON
    parsed_at TIMESTAMP NOT NULL,     -- 解析时间
    model_name TEXT NOT NULL,         -- 使用的模型名称
    model_version TEXT,               -- 模型版本
    
    -- 解析置信度
    merchant_confidence REAL,         -- 商家信息置信度
    items_confidence REAL,            -- 商品信息置信度
    total_confidence REAL,            -- 总体置信度
    
    -- 解析状态
    status TEXT NOT NULL CHECK(status IN (
        'pending',          -- 等待处理
        'processing',       -- 处理中
        'processed',        -- 处理完成
        'failed',          -- 处理失败
        'needs_review'     -- 需要人工审核
    )),
    
    -- 处理信息
    processing_duration INTEGER,      -- 处理耗时（毫秒）
    error_message TEXT,              -- 错误信息
    review_notes TEXT,               -- 人工审核备注
    
    -- 统计信息
    token_count INTEGER,             -- 使用的token数量
    retry_count INTEGER DEFAULT 0,    -- 重试次数
    
    -- 时间戳
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (receipt_id) REFERENCES receipts(id)
);

###### AI解析修正记录表 (ai_extraction_corrections)
```sql
CREATE TABLE ai_extraction_corrections (
    id TEXT PRIMARY KEY,
    extraction_id TEXT NOT NULL,
    
    -- 修正信息
    field_path TEXT NOT NULL,         -- JSON路径，指向被修正的字段
    original_value TEXT NOT NULL,     -- 原始值
    corrected_value TEXT NOT NULL,    -- 修正后的值
    correction_type TEXT NOT NULL CHECK(correction_type IN (
        'manual',           -- 人工修正
        'auto',            -- 自动修正
        'system'           -- 系统修正
    )),
    
    -- 修正元数据
    confidence_before REAL,           -- 修正前置信度
    confidence_after REAL,            -- 修正后置信度
    correction_reason TEXT,           -- 修正原因
    
    -- 时间戳
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    corrected_by TEXT,               -- 修正人（用户ID或系统ID）
    
    FOREIGN KEY (extraction_id) REFERENCES ai_extraction_results(id)
);

##### 6.2 索引设计
```sql
-- 小票表索引
CREATE INDEX idx_receipts_user_purchase_date ON receipts(user_id, purchase_date);
CREATE INDEX idx_receipts_merchant ON receipts(merchant_name, merchant_branch);
CREATE INDEX idx_receipts_location ON receipts(location);
CREATE INDEX idx_receipts_status ON receipts(status, sync_status);
CREATE INDEX idx_receipts_amount ON receipts(total_amount);
CREATE INDEX idx_receipts_image_hash ON receipts(image_hash);
CREATE INDEX idx_receipts_date_time ON receipts(purchase_date, purchase_time);

-- 商品表索引
CREATE INDEX idx_receipt_items_receipt ON receipt_items(receipt_id);
CREATE INDEX idx_receipt_items_category ON receipt_items(category_id);
CREATE INDEX idx_receipt_items_name ON receipt_items(name);

-- 标签索引
CREATE INDEX idx_tags_user_id ON tags(user_id);
CREATE INDEX idx_receipt_tags_tag_id ON receipt_tags(tag_id);

-- 翻译缓存索引
CREATE INDEX idx_translation_cache_text ON translation_cache(original_text, source_language, target_language);

-- AI解析结果索引
CREATE INDEX idx_ai_results_receipt ON ai_extraction_results(receipt_id);
CREATE INDEX idx_ai_results_status ON ai_extraction_results(status);
CREATE INDEX idx_ai_results_model ON ai_extraction_results(model_name, model_version);

-- AI解析修正记录索引
CREATE INDEX idx_corrections_extraction ON ai_extraction_corrections(extraction_id);
CREATE INDEX idx_corrections_type ON ai_extraction_corrections(correction_type);

##### 6.3 数据访问示例
```dart
class ReceiptRepository {
  final Database _db;
  
  // 插入新小票
  Future<String> insertReceipt(Receipt receipt) async {
    final id = await _db.insert('receipts', receipt.toMap());
    return id.toString();
  }
  
  // 获取用户的所有小票
  Future<List<Receipt>> getUserReceipts(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? receiptType,
    String? merchantName,
  }) async {
    var query = '''
      SELECT r.*, COUNT(ri.id) as items_count
      FROM receipts r
      LEFT JOIN receipt_items ri ON r.id = ri.receipt_id
      WHERE r.user_id = ?
    ''';
    
    final args = [userId];
    
    if (startDate != null) {
      query += ' AND r.purchase_date >= ?';
      args.add(startDate.toIso8601String());
    }
    
    if (endDate != null) {
      query += ' AND r.purchase_date <= ?';
      args.add(endDate.toIso8601String());
    }
    
    if (receiptType != null) {
      query += ' AND r.receipt_type = ?';
      args.add(receiptType);
    }
    
    if (merchantName != null) {
      query += ' AND r.merchant_name LIKE ?';
      args.add('%$merchantName%');
    }
    
    query += ' GROUP BY r.id ORDER BY r.purchase_date DESC';
    
    final results = await _db.rawQuery(query, args);
    return results.map((row) => Receipt.fromMap(row)).toList();
  }
}

class AIExtractionRepository {
  final Database _db;
  
  // 保存AI解析结果
  Future<String> saveExtractionResult({
    required String receiptId,
    required String rawJson,
    required String modelName,
    required Map<String, double> confidence,
  }) async {
    return await _db.transaction((txn) async {
      final id = await txn.insert(
        'ai_extraction_results',
        {
          'receipt_id': receiptId,
          'raw_json': rawJson,
          'model_name': modelName,
          'parsed_at': DateTime.now().toIso8601String(),
          'merchant_confidence': confidence['merchant'],
          'items_confidence': confidence['items'],
          'total_confidence': confidence['total'],
          'status': 'processed',
        },
      );
      
      // 更新小票状态
      await txn.update(
        'receipts',
        {'status': 'processed'},
        where: 'id = ?',
        whereArgs: [receiptId],
      );
      
      return id.toString();
    });
  }
  
  // 获取需要人工审核的解析结果
  Future<List<Map<String, dynamic>>> getResultsNeedingReview() async {
    return await _db.query(
      'ai_extraction_results',
      where: 'status = ?',
      whereArgs: ['needs_review'],
      orderBy: 'created_at DESC',
    );
  }
  
  // 记录修正
  Future<void> recordCorrection({
    required String extractionId,
    required String fieldPath,
    required String originalValue,
    required String correctedValue,
    required String correctionType,
    String? correctedBy,
  }) async {
    await _db.insert(
      'ai_extraction_corrections',
      {
        'extraction_id': extractionId,
        'field_path': fieldPath,
        'original_value': originalValue,
        'corrected_value': correctedValue,
        'correction_type': correctionType,
        'corrected_by': correctedBy,
      },
    );
  }
  
  // 获取修正历史
  Future<List<Map<String, dynamic>>> getCorrectionHistory(
    String extractionId,
  ) async {
    return await _db.query(
      'ai_extraction_corrections',
      where: 'extraction_id = ?',
      whereArgs: [extractionId],
      orderBy: 'created_at DESC',
    );
  }
  
  // 获取模型性能统计
  Future<Map<String, dynamic>> getModelPerformanceStats(
    String modelName,
    {DateTime? startDate, DateTime? endDate}
  ) async {
    var query = '''
      SELECT 
        COUNT(*) as total_processed,
        AVG(merchant_confidence) as avg_merchant_confidence,
        AVG(items_confidence) as avg_items_confidence,
        AVG(total_confidence) as avg_total_confidence,
        AVG(processing_duration) as avg_processing_time,
        SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) as failure_count,
        SUM(CASE WHEN status = 'needs_review' THEN 1 ELSE 0 END) as review_count
      FROM ai_extraction_results
      WHERE model_name = ?
    ''';
    
    final args = [modelName];
    
    if (startDate != null) {
      query += ' AND created_at >= ?';
      args.add(startDate.toIso8601String());
    }
    
    if (endDate != null) {
      query += ' AND created_at <= ?';
      args.add(endDate.toIso8601String());
    }
    
    final results = await _db.rawQuery(query, args);
    return results.first;
  }
}

## 错误处理策略

### 1. 错误分类

#### 1.1 用户输入错误 (4xx)
```dart
enum UserInputError {
  // 验证错误
  INVALID_PHONE_NUMBER,     // 手机号格式错误
  INVALID_VERIFICATION_CODE,// 验证码错误
  INVALID_IMAGE_FORMAT,     // 图片格式错误
  IMAGE_TOO_LARGE,         // 图片太大
  
  // 权限错误
  UNAUTHORIZED,            // 未登录
  TOKEN_EXPIRED,          // Token过期
  PERMISSION_DENIED,      // 权限不足
  
  // 业务规则错误
  DUPLICATE_RECEIPT,      // 重复的小票
  INVALID_DATE_RANGE,     // 无效的日期范围
  QUOTA_EXCEEDED         // 超出配额
}
```

#### 1.2 系统错误 (5xx)
```dart
enum SystemError {
  // 服务错误
  SERVICE_UNAVAILABLE,    // 服务不可用
  DATABASE_ERROR,        // 数据库错误
  CACHE_ERROR,          // 缓存错误
  
  // AI服务错误
  OCR_SERVICE_ERROR,    // OCR服务错误
  AI_MODEL_ERROR,       // AI模型错误
  TRANSLATION_ERROR,    // 翻译服务错误
  
  // 网络错误
  NETWORK_TIMEOUT,      // 网络超时
  CONNECTION_ERROR,     // 连接错误
  API_ERROR            // API调用错误
}
```

#### 1.3 业务错误
```dart
enum BusinessError {
  // OCR错误
  OCR_LOW_CONFIDENCE,   // OCR置信度低
  OCR_NO_TEXT_DETECTED, // 未检测到文字
  OCR_WRONG_ORIENTATION,// 图片方向错误
  
  // AI解析错误
  PARSING_FAILED,      // 解析失败
  INVALID_AMOUNT,      // 金额无效
  MISSING_REQUIRED_INFO,// 缺少必要信息
  
  // 数据处理错误
  DATA_INCONSISTENCY,  // 数据不一致
  VALIDATION_FAILED,   // 验证失败
  PROCESSING_TIMEOUT   // 处理超时
}
```

### 2. 错误处理策略

#### 2.1 全局错误处理
```dart
class GlobalErrorHandler {
  static Future<void> handleError(
    dynamic error,
    StackTrace stackTrace,
  ) async {
    if (error is NetworkException) {
      await _handleNetworkError(error);
    } else if (error is ServiceException) {
      await _handleServiceError(error);
    } else if (error is BusinessException) {
      await _handleBusinessError(error);
    } else {
      await _handleUnknownError(error, stackTrace);
    }
  }
  
  static Future<void> _handleNetworkError(NetworkException error) async {
    // 1. 日志记录
    await LogService.logError(
      'NetworkError',
      error.toString(),
      severity: ErrorSeverity.HIGH
    );
    
    // 2. 重试策略
    if (error.isRetryable) {
      await RetryPolicy.execute(
        maxAttempts: 3,
        delayBetweenAttempts: Duration(seconds: 1)
      );
    }
    
    // 3. 用户提示
    ToastService.show(
      message: '网络连接不稳定，请稍后重试',
      type: ToastType.ERROR
    );
  }
  
  static Future<void> _handleServiceError(ServiceException error) async {
    // 1. 错误上报
    await ErrorReportingService.report(
      error,
      level: ErrorLevel.ERROR,
      metadata: {
        'service': error.serviceName,
        'operation': error.operation
      }
    );
    
    // 2. 服务降级
    await ServiceDegradationManager.degrade(
      service: error.serviceName,
      duration: Duration(minutes: 5)
    );
    
    // 3. 用户提示
    DialogService.showError(
      title: '服务暂时不可用',
      message: '我们正在努力修复，请稍后重试'
    );
  }
}
```

#### 2.2 OCR错误处理
```dart
class OCRErrorHandler {
  static Future<void> handleOCRError(OCRException error) async {
    switch (error.type) {
      case OCRErrorType.LOW_CONFIDENCE:
        // 1. 图像增强重试
        await _retryWithImageEnhancement(error.image);
        break;
        
      case OCRErrorType.NO_TEXT_DETECTED:
        // 1. 检查图片质量
        final quality = await ImageQualityChecker.check(error.image);
        if (quality.isLow) {
          UserPromptService.showImageQualityTips();
        }
        break;
        
      case OCRErrorType.WRONG_ORIENTATION:
        // 1. 自动旋转图片
        final rotatedImage = await ImageProcessor.autoRotate(error.image);
        // 2. 重新识别
        await OCRService.recognize(rotatedImage);
        break;
    }
  }
  
  static Future<void> _retryWithImageEnhancement(File image) async {
    // 1. 图像预处理
    final enhancedImage = await ImageProcessor.enhance(
      image,
      operations: [
        ImageOperation.DENOISE,
        ImageOperation.CONTRAST_ADJUSTMENT,
        ImageOperation.SHARPENING
      ]
    );
    
    // 2. 重新识别
    await OCRService.recognize(
      enhancedImage,
      options: OCROptions(
        enhanceMode: true,
        multipleAttempts: true
      )
    );
  }
}
```

#### 2.3 AI解析错误处理
```dart
class AIParsingErrorHandler {
  static Future<void> handleParsingError(ParsingException error) async {
    switch (error.type) {
      case ParsingErrorType.MISSING_REQUIRED_INFO:
        // 1. 记录缺失字段
        await _logMissingFields(error.missingFields);
        // 2. 尝试其他模型
        await _retryWithDifferentModel(error.text);
        break;
        
      case ParsingErrorType.INVALID_AMOUNT:
        // 1. 数字识别修正
        await _correctNumberRecognition(error.text);
        break;
        
      case ParsingErrorType.PROCESSING_TIMEOUT:
        // 1. 任务分段处理
        await _processInChunks(error.text);
        break;
    }
  }
  
  static Future<void> _retryWithDifferentModel(String text) async {
    // 1. 模型回退策略
    final models = ['gpt-4', 'deepseek', 'fallback-model'];
    
    for (final model in models) {
      try {
        await AIService.parse(
          text,
          model: model,
          timeout: Duration(seconds: 30)
        );
        break;
      } catch (e) {
        continue;
      }
    }
  }
}
```

#### 2.4 数据验证错误处理
```dart
class ValidationErrorHandler {
  static Future<void> handleValidationError(ValidationException error) async {
    // 1. 收集所有验证错误
    final validationErrors = error.errors.map((e) => {
      'field': e.field,
      'value': e.value,
      'constraint': e.constraint,
      'message': e.message
    }).toList();
    
    // 2. 错误分类处理
    for (final error in validationErrors) {
      switch (error['constraint']) {
        case 'required':
          await _handleRequiredFieldError(error);
          break;
        case 'format':
          await _handleFormatError(error);
          break;
        case 'range':
          await _handleRangeError(error);
          break;
      }
    }
    
    // 3. 用户反馈
    FormErrorPresenter.show(validationErrors);
  }
  
  static Future<void> _handleRequiredFieldError(Map<String, dynamic> error) async {
    // 1. 高亮必填字段
    FormHelper.highlightField(
      error['field'],
      type: HighlightType.REQUIRED
    );
    
    // 2. 显示提示信息
    FieldHelper.showTooltip(
      error['field'],
      message: '此字段为必填项'
    );
  }
}
```

### 3. 错误恢复策略

#### 3.1 自动重试策略
```dart
class RetryPolicy {
  static Future<T> execute<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;
    
    while (attempts < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts == maxAttempts) rethrow;
        
        // 指数退避
        await Future.delayed(delay);
        delay *= backoffMultiplier;
      }
    }
    
    throw MaxRetryExceededException();
  }
}
```

#### 3.2 数据恢复策略
```dart
class DataRecoveryStrategy {
  static Future<void> recover(ProcessingException error) async {
    // 1. 保存处理状态
    await SavePointManager.saveState(error.context);
    
    // 2. 回滚到最近的有效状态
    await TransactionManager.rollback(
      error.transactionId,
      savePoint: error.lastValidState
    );
    
    // 3. 恢复处理
    await ProcessingManager.resume(
      error.context,
      startFrom: error.lastValidState
    );
  }
}
```

### 4. 错误监控和分析

#### 4.1 错误日志记录
```dart
class ErrorLogger {
  static Future<void> logError({
    required String type,
    required String message,
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
    ErrorSeverity severity = ErrorSeverity.NORMAL,
  }) async {
    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'type': type,
      'message': message,
      'context': context,
      'stackTrace': stackTrace?.toString(),
      'severity': severity.toString(),
      'environment': Environment.current,
      'version': AppInfo.version,
    };
    
    // 1. 本地日志
    await LocalLogStorage.write(logEntry);
    
    // 2. 远程日志
    if (severity >= ErrorSeverity.HIGH) {
      await RemoteLogService.send(logEntry);
    }
    
    // 3. 错误分析
    await ErrorAnalytics.track(logEntry);
  }
}
```

#### 4.2 错误统计和分析
```dart
class ErrorAnalytics {
  static Future<Map<String, dynamic>> analyze(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // 1. 收集错误数据
    final errors = await ErrorLogger.query(
      startDate: startDate,
      endDate: endDate
    );
    
    // 2. 错误分类统计
    final statistics = {
      'total_errors': errors.length,
      'by_type': _groupByType(errors),
      'by_severity': _groupBySeverity(errors),
      'error_rate': _calculateErrorRate(errors),
      'common_patterns': _findCommonPatterns(errors),
    };
    
    // 3. 生成报告
    return {
      'summary': statistics,
      'recommendations': _generateRecommendations(statistics),
      'trends': _analyzeTrends(errors),
    };
  }
}
```

## 国际化支持

### 1. 多语言支持

#### 1.1 语言配置
```dart
class LocaleConfig {
  // 支持的语言列表
  static const supportedLocales = [
    Locale('zh', 'CN'), // 简体中文
    Locale('en', 'US'), // 美式英语
    Locale('ja', 'JP'), // 日语
    Locale('ko', 'KR'), // 韩语
    Locale('zh', 'TW'), // 繁体中文
  ];
  
  // 默认语言
  static const fallbackLocale = Locale('en', 'US');
  
  // 语言名称映射
  static const languageNames = {
    'zh_CN': '简体中文',
    'en_US': 'English',
    'ja_JP': '日本語',
    'ko_KR': '한국어',
    'zh_TW': '繁體中文',
  };
}
```

#### 1.2 翻译管理
```dart
class TranslationManager {
  static final Map<String, Map<String, String>> _translations = {
    'zh_CN': {
      'app_name': '扫票通',
      'receipt_scan': '扫描小票',
      'history': '历史记录',
      // ... 其他翻译键值对
    },
    'en_US': {
      'app_name': 'ScanTicket',
      'receipt_scan': 'Scan Receipt',
      'history': 'History',
      // ... 其他翻译键值对
    }
  };
  
  // 动态加载翻译文件
  static Future<void> loadTranslations(String locale) async {
    final file = await rootBundle.loadString(
      'assets/translations/$locale.json'
    );
    _translations[locale] = json.decode(file);
  }
  
  // 获取翻译
  static String translate(String key, String locale) {
    return _translations[locale]?[key] ?? key;
  }
}
```

#### 1.3 自动翻译服务
```dart
class AutoTranslationService {
  static Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    TranslationContext? context,
  }) async {
    // 1. 检查缓存
    final cached = await TranslationCache.get(
      text,
      sourceLanguage,
      targetLanguage
    );
    if (cached != null) return cached;
    
    // 2. 调用翻译API
    final translation = await DeepLAPI.translate(
      text: text,
      source: sourceLanguage,
      target: targetLanguage,
      context: context
    );
    
    // 3. 缓存结果
    await TranslationCache.store(
      text,
      translation,
      sourceLanguage,
      targetLanguage
    );
    
    return translation;
  }
}
```

### 2. 货币处理

#### 2.1 货币配置
```dart
class CurrencyConfig {
  // 支持的货币
  static const supportedCurrencies = {
    'CNY': {
      'symbol': '¥',
      'name': 'Chinese Yuan',
      'decimals': 2,
      'format': '¥#,##0.00'
    },
    'USD': {
      'symbol': '$',
      'name': 'US Dollar',
      'decimals': 2,
      'format': '$#,##0.00'
    },
    'JPY': {
      'symbol': '¥',
      'name': 'Japanese Yen',
      'decimals': 0,
      'format': '¥#,##0'
    },
    // ... 其他货币
  };
}
```

#### 2.2 货币转换
```dart
class CurrencyConverter {
  static Future<double> convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
    DateTime? rateDate,
  }) async {
    if (fromCurrency == toCurrency) return amount;
    
    // 1. 获取汇率
    final rate = await ExchangeRateService.getRate(
      fromCurrency,
      toCurrency,
      date: rateDate
    );
    
    // 2. 转换
    final converted = amount * rate;
    
    // 3. 根据目标货币进行舍入
    return _roundByCurrency(
      converted,
      toCurrency
    );
  }
  
  static double _roundByCurrency(double amount, String currency) {
    final decimals = CurrencyConfig.supportedCurrencies[currency]?['decimals'] ?? 2;
    final factor = pow(10, decimals);
    return (amount * factor).round() / factor;
  }
}
```

#### 2.3 货币格式化
```dart
class CurrencyFormatter {
  static String format({
    required double amount,
    required String currency,
    String? locale,
  }) {
    final currencyConfig = CurrencyConfig.supportedCurrencies[currency];
    if (currencyConfig == null) return amount.toString();
    
    final numberFormat = NumberFormat(
      currencyConfig['format'],
      locale ?? 'en_US'
    );
    
    return numberFormat.format(amount);
  }
  
  static double? parse({
    required String text,
    required String currency,
    String? locale,
  }) {
    try {
      final currencyConfig = CurrencyConfig.supportedCurrencies[currency];
      if (currencyConfig == null) return null;
      
      // 移除货币符号和空格
      final cleanText = text.replaceAll(currencyConfig['symbol'], '')
                           .replaceAll(' ', '');
      
      final numberFormat = NumberFormat(
        currencyConfig['format'],
        locale ?? 'en_US'
      );
      
      return numberFormat.parse(cleanText).toDouble();
    } catch (e) {
      return null;
    }
  }
}
```

### 3. 时区处理

#### 3.1 时区配置
```dart
class TimeZoneConfig {
  // 支持的时区
  static const supportedTimeZones = {
    'Asia/Shanghai': {
      'name': '中国标准时间',
      'offset': '+08:00',
      'abbreviation': 'CST'
    },
    'America/New_York': {
      'name': '美东时间',
      'offset': '-05:00',
      'abbreviation': 'EST'
    },
    // ... 其他时区
  };
  
  // 获取默认时区
  static String getDefaultTimeZone() {
    return Platform.localeName.startsWith('zh') 
      ? 'Asia/Shanghai' 
      : 'UTC';
  }
}
```

#### 3.2 时间转换
```dart
class TimeConverter {
  static DateTime convertToLocal(DateTime utcTime, String timeZone) {
    final location = getLocation(timeZone);
    return TZDateTime.from(utcTime, location);
  }
  
  static DateTime convertToUTC(DateTime localTime, String timeZone) {
    final location = getLocation(timeZone);
    final localDateTime = TZDateTime.from(localTime, location);
    return localDateTime.toUtc();
  }
  
  static String format({
    required DateTime dateTime,
    required String timeZone,
    String? format,
    String? locale,
  }) {
    final localTime = convertToLocal(dateTime, timeZone);
    final formatter = DateFormat(
      format ?? 'yyyy-MM-dd HH:mm:ss',
      locale ?? 'en_US'
    );
    return formatter.format(localTime);
  }
}
```

### 4. 本地化最佳实践

#### 4.1 本地化Provider
```dart
class LocalizationProvider extends ChangeNotifier {
  Locale _currentLocale;
  String _currentTimeZone;
  String _currentCurrency;
  
  LocalizationProvider({
    Locale? locale,
    String? timeZone,
    String? currency,
  }) : 
    _currentLocale = locale ?? LocaleConfig.fallbackLocale,
    _currentTimeZone = timeZone ?? TimeZoneConfig.getDefaultTimeZone(),
    _currentCurrency = currency ?? 'USD';
  
  // Getters
  Locale get locale => _currentLocale;
  String get timeZone => _currentTimeZone;
  String get currency => _currentCurrency;
  
  // 更新语言
  Future<void> updateLocale(Locale newLocale) async {
    if (!LocaleConfig.supportedLocales.contains(newLocale)) return;
    
    _currentLocale = newLocale;
    await TranslationManager.loadTranslations(
      '${newLocale.languageCode}_${newLocale.countryCode}'
    );
    notifyListeners();
  }
  
  // 更新时区
  void updateTimeZone(String newTimeZone) {
    if (!TimeZoneConfig.supportedTimeZones.containsKey(newTimeZone)) return;
    
    _currentTimeZone = newTimeZone;
    notifyListeners();
  }
  
  // 更新货币
  void updateCurrency(String newCurrency) {
    if (!CurrencyConfig.supportedCurrencies.containsKey(newCurrency)) return;
    
    _currentCurrency = newCurrency;
    notifyListeners();
  }
}
```

#### 4.2 本地化组件
```dart
class LocalizedText extends StatelessWidget {
  final String translationKey;
  final Map<String, String>? params;
  
  const LocalizedText(
    this.translationKey, {
    this.params,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    var text = TranslationManager.translate(
      translationKey,
      '${locale.languageCode}_${locale.countryCode}'
    );
    
    if (params != null) {
      params!.forEach((key, value) {
        text = text.replaceAll('{$key}', value);
      });
    }
    
    return Text(text);
  }
}

class LocalizedCurrency extends StatelessWidget {
  final double amount;
  final String? currency;
  
  const LocalizedCurrency({
    required this.amount,
    this.currency,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final localizationProvider = context.watch<LocalizationProvider>();
    final formattedAmount = CurrencyFormatter.format(
      amount: amount,
      currency: currency ?? localizationProvider.currency,
      locale: localizationProvider.locale.toString(),
    );
    
    return Text(formattedAmount);
  }
}
```

#### 4.3 本地化存储
```dart
class LocalizationStorage {
  static const String _localeKey = 'app_locale';
  static const String _timeZoneKey = 'app_timezone';
  static const String _currencyKey = 'app_currency';
  
  // 保存设置
  static Future<void> saveSettings({
    Locale? locale,
    String? timeZone,
    String? currency,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (locale != null) {
      await prefs.setString(_localeKey, locale.toString());
    }
    
    if (timeZone != null) {
      await prefs.setString(_timeZoneKey, timeZone);
    }
    
    if (currency != null) {
      await prefs.setString(_currencyKey, currency);
    }
  }
  
  // 加载设置
  static Future<LocalizationSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final localeStr = prefs.getString(_localeKey);
    final timeZone = prefs.getString(_timeZoneKey);
    final currency = prefs.getString(_currencyKey);
    
    return LocalizationSettings(
      locale: localeStr != null ? Locale(localeStr) : null,
      timeZone: timeZone,
      currency: currency,
    );
  }
}
```

#### 4.4 使用示例
```dart
void main() async {
  // 1. 初始化本地化设置
  final settings = await LocalizationStorage.loadSettings();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocalizationProvider(
            locale: settings.locale,
            timeZone: settings.timeZone,
            currency: settings.currency,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizationProvider = context.watch<LocalizationProvider>();
    
    return MaterialApp(
      locale: localizationProvider.locale,
      supportedLocales: LocaleConfig.supportedLocales,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomePage(),
    );
  }
}
```

## API接口设计

### 1. OCR服务接口

#### 1.1 图片识别
```http
POST /api/v1/ocr/recognize
Content-Type: multipart/form-data

Request:
{
    "image": File,                    // 小票图片文件
    "options": {
        "enhance": boolean,           // 是否进行图像增强
        "language": string,           // 识别语言，例如："zh-CN", "en-US"
        "detect_orientation": boolean // 是否自动检测方向
    }
}

Response:
{
    "status": "success",
    "data": {
        "text": string,              // 识别出的完整文本
        "confidence": number,         // 整体置信度
        "duration_ms": number,        // 处理耗时
        "blocks": [{                  // 文本块列表
            "text": string,           // 块文本
            "confidence": number,     // 块置信度
            "bounds": {               // 位置信息
                "top": number,
                "left": number,
                "width": number,
                "height": number
            }
        }]
    }
}
```

#### 1.2 图像预处理
```http
POST /api/v1/ocr/preprocess
Content-Type: multipart/form-data

Request:
{
    "image": File,
    "operations": [{
        "type": string,              // 预处理类型：enhance/rotate/crop/denoise
        "params": object             // 操作参数
    }]
}

Response:
{
    "status": "success",
    "data": {
        "processed_image": string,    // Base64编码的处理后图片
        "operations_log": [{          // 处理日志
            "type": string,
            "success": boolean,
            "message": string
        }]
    }
}
```

### 2. AI解析服务接口

#### 2.1 小票信息提取
```http
POST /api/v1/ai/extract
Content-Type: application/json

Request:
{
    "ocr_result": string,           // OCR识别文本
    "receipt_image": string,        // Base64编码的图片（可选）
    "options": {
        "model": string,            // 使用的模型：gpt-4/deepseek等
        "language": string,         // 目标语言
        "extract_items": boolean,   // 是否提取商品项
        "confidence_threshold": number // 置信度阈值
    }
}

Response:
{
    "status": "success",
    "data": {
        "merchant": {
            "name": string,
            "address": string,
            "phone": string,
            "tax_number": string,
            "confidence": number
        },
        "transaction": {
            "date": string,
            "time": string,
            "total": number,
            "currency": string,
            "payment_method": string,
            "confidence": number
        },
        "items": [{
            "name": string,
            "quantity": number,
            "unit_price": number,
            "total_price": number,
            "confidence": number
        }],
        "metadata": {
            "model_version": string,
            "processing_time": number,
            "token_count": number
        }
    }
}
```

#### 2.2 解析结果修正
```http
POST /api/v1/ai/correct
Content-Type: application/json

Request:
{
    "extraction_id": string,
    "corrections": [{
        "field_path": string,      // 例如: "merchant.name" 或 "items[0].price"
        "original_value": string,
        "corrected_value": string,
        "correction_type": string,  // manual/auto/system
        "reason": string
    }]
}

Response:
{
    "status": "success",
    "data": {
        "updated_fields": number,
        "confidence_delta": number
    }
}
```

### 3. 翻译服务接口

#### 3.1 文本翻译
```http
POST /api/v1/translation/translate
Content-Type: application/json

Request:
{
    "text": string,
    "source_language": string,     // 源语言，例如："zh-CN"
    "target_language": string,     // 目标语言，例如："en-US"
    "context": {                   // 上下文信息（可选）
        "domain": string,          // 领域：receipt/product/general
        "category": string         // 商品类别
    }
}

Response:
{
    "status": "success",
    "data": {
        "translated_text": string,
        "confidence": number,
        "alternatives": [string],  // 其他可能的翻译
        "from_cache": boolean      // 是否来自缓存
    }
}
```

#### 3.2 批量翻译
```http
POST /api/v1/translation/batch
Content-Type: application/json

Request:
{
    "items": [{
        "id": string,
        "text": string,
        "context": object
    }],
    "source_language": string,
    "target_language": string
}

Response:
{
    "status": "success",
    "data": {
        "translations": [{
            "id": string,
            "translated_text": string,
            "confidence": number
        }],
        "statistics": {
            "total": number,
            "success": number,
            "from_cache": number
        }
    }
}
```

### 4. 用户认证接口

#### 4.1 手机号登录
```http
POST /api/v1/auth/phone/login
Content-Type: application/json

Request:
{
    "phone": string,
    "code": string,           // 验证码
    "device_info": {
        "device_id": string,
        "platform": string,
        "app_version": string
    }
}

Response:
{
    "status": "success",
    "data": {
        "token": string,
        "refresh_token": string,
        "expires_in": number,
        "user": {
            "id": string,
            "nickname": string,
            "avatar": string,
            "settings": object
        }
    }
}
```

#### 4.2 微信登录
```http
POST /api/v1/auth/wechat/login
Content-Type: application/json

Request:
{
    "code": string,           // 微信授权码
    "device_info": {
        "device_id": string,
        "platform": string,
        "app_version": string
    }
}

Response:
{
    "status": "success",
    "data": {
        "token": string,
        "refresh_token": string,
        "expires_in": number,
        "user": {
            "id": string,
            "nickname": string,
            "avatar": string,
            "wechat_info": {
                "openid": string,
                "unionid": string
            }
        }
    }
}
```

### 5. 错误响应格式
```http
{
    "status": "error",
    "error": {
        "code": string,       // 错误代码
        "message": string,    // 错误消息
        "details": object,    // 详细信息
        "request_id": string  // 请求ID，用于追踪
    }
}
```

### 6. API使用示例

```dart
class ReceiptService {
  final Dio _dio;
  
  // 识别并解析小票
  Future<ReceiptData> processReceipt(File image) async {
    try {
      // 1. OCR识别
      final ocrResult = await _dio.post(
        '/api/v1/ocr/recognize',
        data: FormData.fromMap({
          'image': await MultipartFile.fromFile(image.path),
          'options': {
            'enhance': true,
            'language': 'zh-CN'
          }
        })
      );
      
      // 2. AI解析
      final extractionResult = await _dio.post(
        '/api/v1/ai/extract',
        data: {
          'ocr_result': ocrResult.data['data']['text'],
          'options': {
            'model': 'gpt-4',
            'extract_items': true
          }
        }
      );
      
      // 3. 翻译商品名称（如果需要）
      final itemNames = extractionResult.data['data']['items']
          .map((item) => item['name'])
          .toList();
          
      final translations = await _dio.post(
        '/api/v1/translation/batch',
        data: {
          'items': itemNames.map((name) => {
            'id': name,
            'text': name,
            'context': {'domain': 'product'}
          }).toList(),
          'source_language': 'zh-CN',
          'target_language': 'en-US'
        }
      );
      
      // 4. 合并结果
      return ReceiptData.fromJson({
        ...extractionResult.data['data'],
        'translations': translations.data['data']
      });
      
    } catch (e) {
      throw ReceiptProcessingException(e.toString());
    }
  }
}
```

[原有的其他内容保持不变...]

## MVP开发规划

### 第一阶段：核心功能（必须实现）

#### 1. 基础功能
- [x] 小票拍照/图片上传
- [x] OCR文字识别
- [x] 基本信息提取（商家、日期、金额）
- [x] 数据本地存储

#### 2. 用户功能
- [x] 简单的用户注册/登录（手机号）
- [x] 历史记录查看
- [x] 基础数据导出

#### 3. 多语言基础支持
- [x] 支持中文和英文界面
- [x] 基础翻译功能（小票文字翻译）
- [x] 简单的翻译编辑功能

#### 4. 数据结构
```sql
-- 核心表结构
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    phone TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE receipts (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    image_path TEXT NOT NULL,
    merchant_name TEXT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    currency TEXT NOT NULL,
    receipt_date DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE receipt_items (
    id TEXT PRIMARY KEY,
    receipt_id TEXT NOT NULL,
    name TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    quantity INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (receipt_id) REFERENCES receipts(id)
);

CREATE TABLE translations (
    id TEXT PRIMARY KEY,
    item_id TEXT NOT NULL,
    original_text TEXT NOT NULL,
    translated_text TEXT NOT NULL,
    language TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES receipt_items(id)
);
```

### 第二阶段：增强功能（后期优化）

#### 1. 高级OCR功能
- [ ] 图像预处理优化
- [ ] 多种票据格式支持
- [ ] OCR准确率提升
- [ ] 自动旋转和裁剪

#### 2. 用户功能增强
- [ ] 微信登录集成
- [ ] 数据云同步
- [ ] 数据分析报表
- [ ] 消费统计图表

#### 3. 多语言增强
- [ ] 支持更多语言（日语、韩语等）
- [ ] 翻译优化系统
- [ ] 用户翻译反馈收集
- [ ] 自动语言检测

#### 4. AI增强
- [ ] 智能分类系统
- [ ] 消费模式分析
- [ ] 智能推荐
- [ ] 异常检测

### 技术栈选择

#### 前端（Flutter）
```yaml
dependencies:
  flutter:
    sdk: flutter
  # 必需依赖
  camera: ^0.10.5       # 相机功能
  image_picker: ^1.0.4  # 图片选择
  sqflite: ^2.3.0      # 本地数据库
  http: ^1.1.0         # 网络请求
  shared_preferences: ^2.2.2  # 本地存储
  
  # 后期添加
  charts_flutter: ^0.12.0  # 统计图表
  firebase_core: ^2.24.2   # Firebase集成
  cloud_firestore: ^4.13.6 # 云数据库
```

#### 后端（Node.js）
```json
{
  "dependencies": {
    // 必需依赖
    "express": "^4.18.2",
    "mysql2": "^3.6.5",
    "jsonwebtoken": "^9.0.2",
    "multer": "^1.4.5-lts.1",
    
    // 后期添加
    "firebase-admin": "^11.11.1",
    "tensorflow": "^2.15.0",
    "bull": "^4.12.0"
  }
}
```

### API接口（优先级排序）

#### 必需接口
```typescript
// 1. 用户认证
POST /api/auth/login          // 手机号登录
POST /api/auth/verify        // 验证码验证

// 2. 小票处理
POST /api/receipts/upload    // 上传小票图片
POST /api/receipts/ocr       // OCR识别
GET  /api/receipts          // 获取小票列表
GET  /api/receipts/:id      // 获取小票详情

// 3. 翻译
POST /api/translate         // 文本翻译
PUT  /api/translate/:id     // 更新翻译
```

#### 后期接口
```typescript
// 1. 社交登录
POST /api/auth/wechat      // 微信登录
POST /api/auth/google      // Google登录

// 2. 数据分析
GET  /api/stats/spending   // 消费统计
GET  /api/stats/category   // 分类统计
GET  /api/stats/trends     // 趋势分析

// 3. AI功能
POST /api/ai/categorize    // 智能分类
POST /api/ai/recommend     // 智能推荐
GET  /api/ai/insights     // 消费洞察
```

### 开发时间线

#### 第一阶段（8周）
1. 周1-2：基础架构搭建
   - 项目初始化
   - 数据库设计
   - 基础API实现

2. 周3-4：OCR功能
   - 相机集成
   - OCR服务对接
   - 基础信息提取

3. 周5-6：用户功能
   - 用户注册登录
   - 历史记录
   - 基础UI实现

4. 周7-8：多语言支持
   - 界面国际化
   - 基础翻译功能
   - 测试和优化

#### 第二阶段（按需规划）
1. OCR优化（4周）
2. 社交功能（3周）
3. 数据分析（4周）
4. AI功能（6周）

### 部署架构

#### MVP阶段
```
Client App (Flutter) 
    ↓ ↑
API Server (Node.js + Express)
    ↓ ↑
MySQL Database
```

#### 后期架构
```
Client App (Flutter)
    ↓ ↑
Load Balancer
    ↓ ↑
API Servers Cluster
    ↓ ↑
Cache Layer (Redis)
    ↓ ↑
Database Cluster (MySQL)
    ↓ ↑
AI/ML Services
```

[原有的其他内容保持不变...]

## 实现步骤

### 1. 项目初始化（2天）

#### 1.1 前端项目
```bash
# 创建Flutter项目
flutter create scan_ticket
cd scan_ticket

# 添加必要依赖到pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  camera: ^0.10.5
  image_picker: ^1.0.4
  sqflite: ^2.3.0
  http: ^1.1.0
  shared_preferences: ^2.2.2
  flutter_localizations:
    sdk: flutter
```

#### 1.2 后端项目
```bash
# 创建Node.js项目
mkdir scan-ticket-server
cd scan-ticket-server
npm init -y

# 安装必要依赖
npm install express mysql2 jsonwebtoken multer
npm install typescript ts-node @types/node @types/express --save-dev
```

#### 1.3 数据库初始化
```sql
-- 创建数据库
CREATE DATABASE scan_ticket CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建核心表
USE scan_ticket;

CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    phone VARCHAR(20) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE receipts (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    merchant_name VARCHAR(255) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    receipt_date DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE receipt_items (
    id VARCHAR(36) PRIMARY KEY,
    receipt_id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    quantity INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (receipt_id) REFERENCES receipts(id)
);

CREATE TABLE translations (
    id VARCHAR(36) PRIMARY KEY,
    item_id VARCHAR(36) NOT NULL,
    original_text TEXT NOT NULL,
    translated_text TEXT NOT NULL,
    language VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES receipt_items(id)
);
```

### 2. 基础功能实现（2周）

#### 2.1 相机与图片处理（3天）
1. 实现相机页面
```dart
// lib/pages/camera_page.dart
class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraPreview(_controller),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera),
      ),
    );
  }
  
  Future<void> _takePicture() async {
    // 实现拍照逻辑
  }
}
```

2. 图片选择功能
```dart
// lib/services/image_service.dart
class ImageService {
  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
```

#### 2.2 OCR服务集成（4天）
1. OCR服务接口
```typescript
// server/src/services/ocr.service.ts
interface OcrResult {
  merchantName: string;
  date: string;
  totalAmount: number;
  items: Array<{
    name: string;
    amount: number;
    quantity?: number;
  }>;
}

class OcrService {
  async processImage(imageBuffer: Buffer): Promise<OcrResult> {
    // 实现OCR逻辑
  }
}
```

2. OCR结果处理
```dart
// lib/services/ocr_service.dart
class OcrService {
  static Future<OcrResult> processReceipt(File image) async {
    final bytes = await image.readAsBytes();
    final response = await http.post(
      Uri.parse('$apiUrl/ocr'),
      body: bytes,
    );
    return OcrResult.fromJson(jsonDecode(response.body));
  }
}
```

#### 2.3 数据存储（3天）
1. 数据库服务
```typescript
// server/src/services/database.service.ts
class DatabaseService {
  async saveReceipt(userId: string, receipt: Receipt): Promise<string> {
    // 实现保存小票信息的逻辑
  }
  
  async getReceipts(userId: string): Promise<Receipt[]> {
    // 实现获取小票列表的逻辑
  }
}
```

2. 本地数据缓存
```dart
// lib/services/storage_service.dart
class StorageService {
  static Future<void> saveReceipt(Receipt receipt) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('receipts', receipt.toMap());
  }
  
  static Future<List<Receipt>> getReceipts() async {
    final db = await DatabaseHelper.instance.database;
    final receipts = await db.query('receipts');
    return receipts.map((e) => Receipt.fromMap(e)).toList();
  }
}
```

### 3. 用户功能实现（1周）

#### 3.1 用户认证（3天）
1. 登录接口
```typescript
// server/src/controllers/auth.controller.ts
class AuthController {
  async login(req: Request, res: Response) {
    const { phone } = req.body;
    // 实现登录逻辑
  }
  
  async verify(req: Request, res: Response) {
    const { phone, code } = req.body;
    // 实现验证码验证逻辑
  }
}
```

2. 登录页面
```dart
// lib/pages/login_page.dart
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: '手机号',
            ),
          ),
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: '验证码',
            ),
          ),
          ElevatedButton(
            onPressed: _login,
            child: Text('登录'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _login() async {
    // 实现登录逻辑
  }
}
```

#### 3.2 历史记录（2天）
1. 历史记录页面
```dart
// lib/pages/history_page.dart
class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Receipt>>(
        future: StorageService.getReceipts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final receipt = snapshot.data![index];
              return ReceiptCard(receipt: receipt);
            },
          );
        },
      ),
    );
  }
}
```

### 4. 多语言支持实现（1周）

#### 4.1 界面国际化（2天）
1. 语言配置
```dart
// lib/l10n/app_localizations.dart
class AppLocalizations {
  static const supportedLocales = [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
  ];
  
  static String get appName {
    // 返回对应语言的应用名称
  }
  
  // 其他翻译文本
}
```

#### 4.2 翻译功能（3天）
1. 翻译服务
```typescript
// server/src/services/translation.service.ts
class TranslationService {
  async translate(text: string, targetLanguage: string): Promise<string> {
    // 实现翻译逻辑
  }
  
  async updateTranslation(id: string, newText: string): Promise<void> {
    // 实现更新翻译的逻辑
  }
}
```

2. 翻译管理
```dart
// lib/services/translation_service.dart
class TranslationService {
  static Future<String> translate(String text, String targetLanguage) async {
    final response = await http.post(
      Uri.parse('$apiUrl/translate'),
      body: {
        'text': text,
        'target': targetLanguage,
      },
    );
    return jsonDecode(response.body)['translation'];
  }
  
  static Future<void> updateTranslation(String id, String newText) async {
    await http.put(
      Uri.parse('$apiUrl/translate/$id'),
      body: {'text': newText},
    );
  }
}
```

### 5. 测试与优化（1周）

#### 5.1 单元测试（2天）
```dart
// test/services/ocr_service_test.dart
void main() {
  group('OCR Service Tests', () {
    test('should process receipt image correctly', () async {
      // 测试OCR功能
    });
  });
}
```

#### 5.2 集成测试（2天）
```typescript
// server/test/integration/receipt.test.ts
describe('Receipt API', () {
  it('should create new receipt', async () => {
    // 测试创建小票接口
  });
  
  it('should get receipt list', async () => {
    // 测试获取小票列表接口
  });
});
```

#### 5.3 性能优化（3天）
1. 图片压缩
2. 数据库索引优化
3. 缓存策略实现

### 6. 部署准备

#### 6.1 服务器配置
```bash
# 安装依赖
npm install pm2 -g

# 启动服务
pm2 start dist/index.js --name scan-ticket-api
```

#### 6.2 数据库备份策略
```sql
-- 创建备份用户
CREATE USER 'backup_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER ON *.* TO 'backup_user'@'localhost';
```

[原有的其他内容保持不变...]
