# API 参考文档

## 基本信息
- 基础URL: `http://localhost:8000`
- API版本: v1
- 所有请求和响应均使用JSON格式

## 认证
目前使用简单的API密钥认证：
- 在请求头中添加 `X-API-Key`

## 通用响应格式
```json
{
    "code": 0,           // 0表示成功，非0表示错误
    "message": "成功",    // 响应消息
    "data": {}           // 响应数据
}
```

## 错误码
- 0: 成功
- 1000: 参数错误
- 2000: 业务错误
- 3000: 系统错误
- 4000: 认证错误

## API端点

### OSS相关

#### 获取上传签名
```
POST /api/v1/oss/signature
```

请求体：
```json
{
    "filename": "example.jpg",
    "content_type": "image/jpeg"
}
```

响应：
```json
{
    "code": 0,
    "message": "success",
    "data": {
        "signature": "xxx",
        "policy": "xxx",
        "key": "xxx",
        "ossAccessKeyId": "xxx",
        "host": "xxx",
        "callback": "xxx"
    }
}
```

#### 获取文件访问URL
```
GET /api/v1/oss/url
```

参数：
- `key`: 文件在OSS中的键值

响应：
```json
{
    "code": 0,
    "message": "success",
    "data": {
        "url": "https://xxx.com/xxx.jpg"
    }
}
```

#### 批量获取文件URL
```
POST /api/v1/oss/batch_urls
```

请求体：
```json
{
    "keys": ["file1.jpg", "file2.jpg"]
}
```

响应：
```json
{
    "code": 0,
    "message": "success",
    "data": {
        "urls": {
            "file1.jpg": "https://xxx.com/file1.jpg",
            "file2.jpg": "https://xxx.com/file2.jpg"
        }
    }
}
```

### AI服务相关

#### 文本分析
```
POST /api/v1/ai/analyze
```

请求体：
```json
{
    "text": "需要分析的文本",
    "model": "deepseek"  // 可选：deepseek, openai
}
```

响应：
```json
{
    "code": 0,
    "message": "success",
    "data": {
        "analysis": "分析结果"
    }
}
```

#### 流式文本分析
```
POST /api/v1/ai/analyze/stream
```

请求体：
```json
{
    "text": "需要分析的文本",
    "model": "deepseek"
}
```

响应：
Server-Sent Events (SSE) 格式的流式响应

## 限制说明

### 文件上传
- 最大文件大小：10MB
- 支持的文件类型：
  - 图片：jpg, jpeg, png
  - 文档：pdf

### API调用
- 速率限制：每分钟100次请求
- 并发限制：每个用户10个并发请求

## 错误处理
所有错误响应都遵循以下格式：
```json
{
    "code": 1000,
    "message": "错误描述",
    "data": null
}
```

## 最佳实践
1. 使用异步请求处理大文件上传
2. 对于AI分析，优先使用流式接口
3. 实现请求重试机制
4. 合理使用批量接口减少请求次数
