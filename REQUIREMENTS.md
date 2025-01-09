# ScanTicket 项目需求文档

## 1. 项目概述
ScanTicket 是一个智能票据识别和管理系统，能够通过图片识别的方式提取各类票据信息，并进行结构化存储和管理。系统支持多种类型的票据，包括传统小票、外卖订单截图和购物订单截图等。

## 2. 核心功能需求

### 2.1 图片识别功能
- 支持通过图片URL获取票据图片
- 使用大模型进行图片内容识别
- 智能识别不同类型的票据（小票/外卖订单/购物订单）
- 将识别结果转换为结构化JSON数据

### 2.2 智能分析功能
#### 2.2.1 餐饮消费智能分析
- 根据消费时间自动判断用餐类型
  - 早餐：05:00-10:00
  - 午餐：10:00-15:00
  - 晚餐：15:00-22:00
  - 夜宵：22:00-05:00
- 智能估算就餐人数
  - 基于餐具费数量推测
  - 根据套餐数量判断
  - 分析每人平均消费

#### 2.2.2 数据验证
- 自动核对订单金额
  - 验证商品明细总和
  - 计算优惠后金额
  - 核对实付金额
- 异常标记
  - 标记计算不一致项
  - 提供差异原因分析

### 2.3 数据库结构设计

#### users表（users）
```sql
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
)
```

#### 基础订单表（orders）
```sql
CREATE TABLE orders (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    order_type TEXT NOT NULL,      -- 'receipt', 'takeout', 'shopping'
    merchant_name TEXT NOT NULL,    -- 商家名称
    platform TEXT,                  -- 平台名称
    total_amount REAL NOT NULL,     -- 总金额
    actual_paid REAL NOT NULL,      -- 实付金额
    discount_amount REAL,           -- 优惠金额
    currency TEXT NOT NULL DEFAULT 'CNY',
    order_date TEXT NOT NULL,       -- ISO8601格式
    order_time TEXT NOT NULL,       -- HH:mm:ss
    order_status TEXT NOT NULL DEFAULT 'pending',  -- pending, completed, failed
    payment_method TEXT,            -- 支付方式
    payment_status TEXT,            -- 支付状态
    source_image_url TEXT,          -- 原始图片URL
    source_image_path TEXT,         -- 本地存储路径
    raw_text_content TEXT,          -- 原始识别文本
    recognition_status TEXT NOT NULL DEFAULT 'pending',  -- pending, processing, completed, failed
    error_message TEXT,             -- 错误信息
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
)
```

#### 订单项目表（order_items）
```sql
CREATE TABLE order_items (
    id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    name TEXT NOT NULL,             -- 商品名称
    specification TEXT,             -- 规格
    quantity REAL NOT NULL,         -- 数量
    unit_price REAL NOT NULL,       -- 单价
    amount REAL NOT NULL,           -- 小计金额
    category TEXT,                  -- 商品分类
    item_index INTEGER NOT NULL,    -- 商品在票据中的顺序
    is_valid BOOLEAN DEFAULT true,  -- 是否有效
    created_at TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
)
```

#### 餐饮订单扩展表（dining_orders）
```sql
CREATE TABLE dining_orders (
    order_id TEXT PRIMARY KEY,
    meal_type TEXT NOT NULL,        -- 'breakfast', 'lunch', 'dinner', 'midnight'
    estimated_diners INTEGER,        -- 估算就餐人数
    tableware_count INTEGER,         -- 餐具数量
    set_meal_count INTEGER,          -- 套餐数量
    per_person_cost REAL,           -- 人均消费
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
)
```

#### 订单处理日志表（order_processing_logs）
```sql
CREATE TABLE order_processing_logs (
    id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    action TEXT NOT NULL,           -- 处理动作
    status TEXT NOT NULL,           -- 状态
    message TEXT,                   -- 日志信息
    created_at TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
)
```

## 3. 技术规范

### 3.1 数据格式规范
- 日期时间格式：ISO8601
- 金额格式：数字格式，保留两位小数
- 文本内容：UTF-8编码

### 3.2 API响应格式
```json
{
    "success": boolean,
    "data": object,
    "error": {
        "code": string,
        "message": string
    }
}
```

## 4. 未来规划
*以下功能作为备选需求，待后续讨论*

1. 购物场景分析
   - 购物时段分析
   - 购物类型识别
   - 购物习惯分析

2. 消费行为分析
   - 消费周期识别
   - 消费能力评估
   - 消费倾向分析

3. 商家分析系统
   - 商家类型识别
   - 商家评级系统
   - 商家关联分析

4. 预算管理
   - 支出预警机制
   - 智能预算建议
   - 节约建议生成

5. 发票报销
   - 发票有效性验证
   - 报销规则匹配
   - 报销材料准备

## 5. 更新日志

### 2025-01-08
- 初始化需求文档
- 定义基本数据库结构
- 确定核心功能需求
- 添加未来规划章节

## 6. 实现步骤

### 第一阶段：基础架构搭建
1. 数据库初始化
   - 创建核心数据表（orders, order_items, dining_orders）
   - 实现数据库迁移机制
   - 编写基础的CRUD操作

2. 图片处理服务
   - 实现图片URL获取功能
   - 设置图片存储服务（使用已有的OSS服务）
   - 图片预处理（压缩、格式转换等）

3. AI接口集成
   - 设计与大模型的交互prompt
   - 实现图片识别API调用
   - 处理识别结果的解析和存储

### 第二阶段：核心功能实现
4. 票据信息提取
   - 实现基础信息提取（商家、金额、日期等）
   - 开发商品明细解析功能
   - 处理不同类型票据的特殊字段

5. 智能分析功能
   - 实现用餐时间判断逻辑
   - 开发就餐人数估算算法
   - 实现金额验证和异常检测

6. 数据存储和管理
   - 实现结构化数据存储
   - 开发数据验证和清洗功能
   - 实现数据更新和维护机制

### 第三阶段：接口和优化
7. API开发
   - 设计RESTful API接口
   - 实现数据查询和统计接口
   - 开发批量处理接口

8. 性能优化
   - 优化识别速度
   - 实现缓存机制
   - 优化数据库查询

9. 异常处理
   - 完善错误处理机制
   - 添加日志记录
   - 实现失败重试机制

### 第四阶段：测试和部署
10. 测试
    - 单元测试编写
    - 集成测试
    - 性能测试
    - 边界情况测试

11. 部署准备
    - 环境配置文档
    - 部署脚本编写
    - 监控机制建立

12. 上线和维护
    - 生产环境部署
    - 监控告警配置
    - 问题跟踪和修复

### 优先级说明
- P0（必须完成）：步骤1-6
- P1（重要）：步骤7-9
- P2（建议）：步骤10-12

### 时间估算
- 第一阶段：1-2周
- 第二阶段：2-3周
- 第三阶段：1-2周
- 第四阶段：1周

### 风险评估
1. 技术风险
   - 大模型识别准确率不足
   - 处理特殊票据格式的挑战
   - 性能瓶颈

2. 解决方案
   - 持续优化prompt
   - 建立异常处理机制
   - 实现渐进式功能发布
