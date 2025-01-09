# ScanTicket 后端服务

ScanTicket是一个简单的票据扫描和分析服务，支持图片上传和AI分析。

## 主要功能

- 文件上传：支持图片上传到阿里云OSS
- AI分析：支持使用多个AI模型进行票据分析
- 实时响应：支持流式AI响应

## 快速开始

### 环境要求
- Python 3.9+
- pip

### 安装
```bash
# 克隆项目
git clone [项目地址]
cd scan_ticket_server

# 创建虚拟环境
python -m venv venv
.\venv\Scripts\activate  # Windows
source venv/bin/activate # Linux/Mac

# 安装依赖
pip install -r requirements.txt
```

### 配置
复制 `.env.example` 到 `.env` 并配置：
```env
OSS_ACCESS_KEY_ID=xxx
OSS_ACCESS_KEY_SECRET=xxx
OSS_BUCKET=xxx
OSS_ENDPOINT=xxx
OSS_CALLBACK_URL=xxx

OPENAI_API_KEY=xxx
DEEPSEEK_API_KEY=xxx
```

### 运行
```bash
uvicorn src.main:app --reload
```

访问 http://localhost:8000/docs 查看API文档

## 文档

- [开发指南](docs/development_guide.md)
- [API参考](docs/api_reference.md)

## 项目结构
```
src/
  ├── api/              # API路由
  ├── services/         # 业务服务
  ├── models/          # 数据模型
  ├── utils/           # 工具函数
  └── config/          # 配置文件
```

## 贡献
这是一个个人项目，欢迎提出建议和问题。

## 许可
MIT License
