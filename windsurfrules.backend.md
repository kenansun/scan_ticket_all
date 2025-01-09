## 后端开发规范

### 开发理念
- 代码可读性优先于性能优化
- 采用循序渐进的开发方法
- 使用实际案例来展示功能
- 在不确定时明确承认，避免猜测
- 完整的功能实现
- 包含所有必要的导入
- 保持简洁的沟通

### 代码变更原则
- 不删除未经编辑的内容
- 避免使用概括性描述替代代码
- 删除内容前需确认
- 以更新和添加为主，谨慎删除

### 架构规范

#### 项目结构
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

### API 设计规范

#### RESTful API
- 使用标准HTTP方法（GET, POST, PUT, DELETE）
- 统一的响应格式
- 版本控制（/api/v1/...）
- 正确使用状态码
- 资源命名使用复数形式（/users, /files）

#### API 响应格式
```json
{
    "code": 0,           // 0表示成功，非0表示错误
    "message": "成功",    // 响应消息
    "data": {}           // 响应数据
}
```

#### 错误码规范
- 0: 成功
- 1000: 参数错误
- 2000: 业务错误
- 3000: 系统错误
- 4000: 认证错误

### AI 服务集成规范

#### 基础接口
```python
class BaseAIService(ABC):
    @abstractmethod
    async def generate(self, prompt: str, **kwargs) -> AIResponse:
        pass

    @abstractmethod
    async def generate_stream(self, prompt: str, **kwargs):
        pass
```

#### AI响应格式
```python
class AIResponse(BaseModel):
    content: str
    raw_response: Dict[str, Any]
    usage: Dict[str, int]
    model_name: str
```

#### 配置管理
```python
class AIModelConfig(BaseModel):
    model_name: str
    api_key: str
    api_base: Optional[str] = None
    timeout: int = 30
```

### OSS服务规范

#### 上传签名
- 支持文件类型限制
- 文件大小限制（默认10MB）
- 自动生成文件路径
- 支持回调配置

#### 文件访问
- 支持签名URL
- URL有效期配置
- 支持批量获取
- 访问权限控制

### 错误处理规范

#### 异常类型
```python
class BusinessError(Exception):
    """业务逻辑错误"""
    pass

class ValidationError(Exception):
    """数据验证错误"""
    pass

class AuthenticationError(Exception):
    """认证相关错误"""
    pass
```

#### 错误处理流程
- 使用自定义异常类
- 统一的错误处理中间件
- 错误信息国际化
- 详细的错误日志

### 日志规范

#### 日志工具
```python
from src.utils.logger import log_info, log_error

# 信息日志
log_info("Processing request", {"request_id": id})

# 错误日志
log_error(e, {"prompt": prompt, "kwargs": kwargs})
```

#### 日志内容
- 时间戳
- 日志级别
- 事件描述
- 上下文信息
- 错误堆栈（如果有）

### 配置管理规范

#### 环境变量
- 使用.env文件
- 不同环境配置分离
- 敏感信息加密
- 配置验证

#### Pydantic配置
```python
class Settings(BaseSettings):
    # OSS配置
    oss_access_key_id: str
    oss_access_key_secret: str
    oss_bucket: str
    oss_endpoint: str
    oss_callback_url: str

    # AI配置
    openai_api_key: str
    deepseek_api_key: str

    class Config:
        env_file = ".env"
```

### 开发工具规范

#### 代码格式化
- 使用black进行格式化
- 4空格缩进
- 最大行长度120字符
- 使用类型提示

#### 代码检查
- 使用flake8
- 使用mypy进行类型检查
- 使用pylint进行代码质量检查

### 测试规范

#### 测试工具
- pytest作为测试框架
- pytest-asyncio支持异步测试
- pytest-cov检查测试覆盖率

#### 测试范围
- 单元测试：服务层
- 集成测试：API接口
- 性能测试：关键接口

### 部署规范

#### 环境要求
- Python 3.9+
- 虚拟环境隔离
- 使用requirements.txt管理依赖

#### 启动配置
```bash
uvicorn src.main:app --host 0.0.0.0 --port 8000 --workers 4
```

### 文档规范

#### 代码文档
- 模块级文档
- 类和函数文档字符串
- 复杂逻辑说明
- 参数和返回值说明

#### API文档
- 使用FastAPI自动文档
- 详细的接口说明
- 请求和响应示例
- 错误码说明
