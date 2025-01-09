# Windsurf AI 规则配置指南

## 概述

`.windsurfrules` 是 Windsurf AI 的规则配置文件，用于定义 AI 助手的行为模式和开发规范。本文档详细说明了如何配置和使用这些规则。

## 文件结构

项目中的规则文件：
- `windsurfrules.md`: 全局规则配置
- `windsurfrules.backend.md`: 后端开发规范
- `windsurfrules.mobile.md`: 移动端开发规范
- `windsurfrules.reference.md`: 参考文档

## AI 助手配置

### 专业领域定义
```yaml
expertise:
  languages:
    - Python
    - FastAPI
    - TypeScript
    - React Native
  frameworks:
    - FastAPI
    - React Native
    - Shadcn UI
    - Tailwind CSS
  practices:
    - 最佳实践
    - 代码可读性
    - 安全性
    - 性能优化
```

### 开发原则
- 代码可读性优先于性能优化
- 完整的功能实现
- 包含所有必要的导入
- 保持简洁的沟通
- 在不确定时明确承认，避免猜测

### 指导方式
- 通过示例进行指导
- 解释概念和方法
- 专注于教学而不是直接提供解决方案
- 使用相关示例说明概念

## 代码管理规范

### 内容变更
- 不删除未经编辑的内容
- 避免使用概括性描述替代代码
- 删除内容前需确认
- 以更新和添加为主，谨慎删除

### 代码格式
```yaml
formatting:
  indent: 4  # Python使用4空格，前端使用2空格
  line_length: 120
  quotes: single  # 前端代码使用单引号
  string_format: f-strings  # Python使用f-strings
```

### 文档标准
- 使用Markdown格式
- 清晰的标题层级
- 适当的空行和缩进
- 代码块指定语言
- 统一的链接语法

## 项目规范

### 后端开发
- FastAPI最佳实践
- RESTful API设计
- 异步处理
- 错误处理
- 日志记录
- 配置管理

### 移动端开发
- React Native组件设计
- 状态管理
- 导航结构
- UI/UX规范
- 性能优化

## AI 工具集成

### 代码生成
```yaml
code_generation:
  templates: true
  documentation: true
  tests: true
  error_handling: true
```

### 代码分析
```yaml
code_analysis:
  linting: true
  type_checking: true
  security_scan: true
  performance_check: true
```

## 安全规范

### 数据安全
- 输入验证
- 数据加密
- 安全存储
- 访问控制

### API安全
- 认证授权
- 请求验证
- 错误处理
- 日志记录

## 性能优化

### 代码优化
```yaml
optimization:
  caching: true
  lazy_loading: true
  bundle_size: true
  memory_management: true
```

### 监控指标
- 响应时间
- 资源使用
- 错误率
- 用户体验

## 使用指南

### 规则继承
- 全局规则可被特定领域规则覆盖
- 特定规则优先级高于全局规则
- 规则可以组合使用

### 规则更新
- 定期审查和更新规则
- 记录规则变更
- 确保团队了解新规则
- 验证规则效果

## 最佳实践

### 规则管理
- 保持规则简单明确
- 避免过度约束
- 关注实际需求
- 适时调整规则

### 团队协作
- 共享规则理解
- 统一开发标准
- 促进知识分享
- 持续改进流程
