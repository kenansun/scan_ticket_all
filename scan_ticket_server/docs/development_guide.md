# ScanTicket 后端开发指南

## 快速开始

### 环境要求
- Python 3.9+
- pip 包管理器

### 本地开发环境设置
1. 克隆项目
```bash
git clone [项目地址]
cd scan_ticket_server
```

2. 创建虚拟环境
```bash
python -m venv venv
# Windows
.\venv\Scripts\activate
# Linux/Mac
source venv/bin/activate
```

3. 安装依赖
```bash
pip install -r requirements.txt
```

4. 配置环境变量
复制 `.env.example` 到 `.env` 并填写必要的配置：
```env
# OSS配置
OSS_ACCESS_KEY_ID=your_key_id
OSS_ACCESS_KEY_SECRET=your_key_secret
OSS_BUCKET=your_bucket
OSS_ENDPOINT=your_endpoint
OSS_CALLBACK_URL=your_callback_url

# AI服务配置
OPENAI_API_KEY=your_openai_key
DEEPSEEK_API_KEY=your_deepseek_key
```

5. 启动开发服务器
```bash
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

## 项目结构
```
src/
  ├── api/              # API路由和控制器
  │   └── routes/       # 路由定义
  ├── services/         # 业务逻辑服务
  │   ├── ai/          # AI服务集成
  │   └── oss/         # OSS服务
  ├── models/          # 数据模型
  ├── utils/           # 工具函数
  └── config/          # 配置文件
```

## 主要功能模块

### OSS服务
处理文件上传和访问：
- 生成上传签名
- 处理回调
- 获取文件访问URL

```python
# 示例：获取文件签名URL
from src.services.oss_service import OSSService

url = await OSSService.get_signed_url(object_key="receipts/example.jpg")
```

### AI服务
支持多个AI模型的文本处理：
- OpenAI集成
- DeepSeek集成
- 支持流式响应

```python
# 示例：使用DeepSeek处理文本
from src.services.ai import DeepseekService, DeepseekConfig

config = DeepseekConfig(
    api_key="your_key",
    model_name="deepseek-chat"
)
service = DeepseekService(config)
response = await service.generate("分析这张小票")
```

## 开发规范

### 代码风格
- 使用4空格缩进
- 使用类型提示
- 添加文档字符串
- 遵循PEP 8规范

### 错误处理
使用自定义异常类：
```python
from src.utils.exceptions import BusinessError

if not valid:
    raise BusinessError("Invalid input")
```

### 日志记录
使用统一的日志工具：
```python
from src.utils.logger import log_info, log_error

log_info("Processing request", {"request_id": id})
```

## 测试
目前使用手动测试，主要通过FastAPI的自动文档进行API测试：
- 访问 http://localhost:8000/docs 进行API测试
- 使用Postman或其他工具进行集成测试

## 部署
简单的部署方式：
1. 安装依赖
2. 配置环境变量
3. 使用uvicorn运行：
```bash
uvicorn src.main:app --host 0.0.0.0 --port 8000
```

## 常见问题

### OSS上传失败
- 检查OSS配置是否正确
- 确认文件大小是否超过限制（当前限制10MB）
- 查看日志获取详细错误信息

### AI服务响应慢
- 检查网络连接
- 确认API密钥是否有效
- 考虑使用流式响应模式

## 注意事项
- 不要提交 `.env` 文件
- 保护好API密钥
- 定期查看日志
- 注意文件上传大小限制
