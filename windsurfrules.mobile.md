## Flutter 移动端开发规范

### 架构规范

#### 项目结构
```
lib/
  ├── core/              # 核心功能和工具
  │   ├── constants/     # 常量定义
  │   ├── utils/         # 工具类
  │   └── extensions/    # 扩展方法
  ├── data/              # 数据层
  │   ├── models/        # 数据模型
  │   ├── repositories/  # 数据仓库
  │   └── providers/     # 数据提供者
  ├── features/          # 功能模块
  │   ├── auth/          # 认证模块
  │   ├── receipt_scan/  # 小票扫描
  │   └── history/       # 历史记录
  ├── ui/                # UI组件
  │   ├── widgets/       # 通用组件
  │   ├── screens/       # 页面
  │   └── themes/        # 主题
  └── main.dart          # 入口文件
```

### 开发理念
- 优先考虑代码可读性，其次是性能
- 采用渐进式开发方法
- 使用示例模式进行功能演示
- 在不确定时承认不确定性，而不是猜测

### 状态管理规范

#### Riverpod 使用规范
- 全局状态使用 StateNotifierProvider
- 简单状态使用 StateProvider
- 异步数据使用 FutureProvider 或 StreamProvider
- Provider 命名必须以 Provider 结尾

```dart
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) => ...);
final themeProvider = StateProvider<ThemeMode>((ref) => ...);
```

#### BLoC 使用规范
- 复杂业务逻辑使用 BLoC
- Event 和 State 必须是不可变的
- BLoC 类名必须以 Bloc 结尾
- Event 类名必须以 Event 结尾
- State 类名必须以 State 结尾

### 代码变更规范
- 永远不要删除未经编辑的内容
- 避免使用"[文件其余部分保持不变]"这样的概括
- 在删除任何内容前寻求确认
- 专注于更新和添加而不是删除

### 代码风格规范

#### 命名规范
- 类名：大驼峰（PascalCase）
- 变量和方法：小驼峰（camelCase）
- 常量：全大写下划线（SCREAMING_SNAKE_CASE）
- 私有成员：下划线前缀

#### 文件命名
- 全小写，使用下划线分隔
- 遵循功能描述：`user_repository.dart`，`home_screen.dart`

### UI开发规范

#### Widget 规范
- 优先使用 StatelessWidget
- Widget 必须有文档注释
- 复杂 Widget 应拆分为小组件
- 使用 const 构造函数
- 实现响应式设计，移动优先
- 使用统一的间距比例
- 实现组件复用策略

#### 主题规范
- 使用主题系统管理样式
- 颜色定义在 theme 中
- 文字样式使用 TextTheme
- 支持深色模式

#### 性能优化
- 实现代码分割
- 图片和资源包优化
- 实现缓存策略
- 懒加载优化
- 正确使用键值属性

### 错误处理规范

#### 异常处理
- 自定义异常类和消息层次结构
- 开发环境保留完整堆栈跟踪
- 实现优雅的降级UI
- 实现错误监控
- 用户友好的错误消息
- 会话状态管理
- 标准化的错误格式
- 重试逻辑
- 网络错误处理

#### 日志记录
- 结构化的日志格式
- 请求ID追踪
- 合适的日志级别
- 不记录敏感信息

### 性能优化规范

#### 图片处理
- 使用适当的图片格式
- 实现图片缓存
- 延迟加载
- 合理的图片压缩

#### 列表优化
- 使用 ListView.builder
- 实现分页加载
- 合理使用 const Widget

### 数据存储规范

#### SQLite 使用规范
- 使用事务处理
- 正确的索引设计
- 异步操作
- 定期优化

#### 缓存策略
- 实现内存缓存
- 磁盘缓存策略
- 缓存失效机制

### 安全规范

#### 数据安全
- 敏感数据加密存储
- 使用安全的加密算法
- 实现数据备份机制

#### 用户认证
- 安全的 Token 管理
- 生物认证集成
- 会话管理

### 测试规范

#### 单元测试
- 业务逻辑测试
- Repository 测试
- Provider 测试

#### Widget 测试
- 基本渲染测试
- 交互测试
- 主题测试

#### 集成测试
- 完整流程测试
- 性能测试
- 用户场景测试

### 文档规范

#### 代码文档
- 类和公共方法必须有文档注释
- 复杂逻辑需要行内注释
- 示例代码

#### API文档
- API 接口文档
- 错误码说明
- 示例请求响应

### 版本控制

#### Git规范
- 分支命名规范
- Commit 信息规范
- 代码审查流程

### 发布规范

#### 打包发布
- 版本号管理
- 混淆规则
- 签名管理

#### 应用更新
- 增量更新
- 强制更新策略
- 更新提示
