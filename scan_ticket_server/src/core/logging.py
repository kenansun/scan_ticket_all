"""
日志配置模块
"""
import sys
import logging
import json
from datetime import datetime
from pathlib import Path
from logging.handlers import RotatingFileHandler
from typing import Any, Dict, Optional

from fastapi import Request, Response
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.types import Message

from ..config.settings import Settings

settings = Settings()

# 配置日志格式
LOG_FORMAT = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
JSON_LOG_FORMAT = {
    "timestamp": "%(asctime)s",
    "level": "%(levelname)s",
    "logger": "%(name)s",
    "message": "%(message)s"
}

def setup_logging():
    """
    设置日志系统
    """
    # 创建日志目录
    log_dir = Path("logs")
    log_dir.mkdir(exist_ok=True)

    # 创建根日志记录器
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.INFO if not settings.DEBUG else logging.DEBUG)

    # 控制台处理器
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(logging.Formatter(LOG_FORMAT))
    root_logger.addHandler(console_handler)

    # 文件处理器 - 常规日志
    file_handler = RotatingFileHandler(
        log_dir / "app.log",
        maxBytes=10_000_000,  # 10MB
        backupCount=5,
        encoding="utf-8"
    )
    file_handler.setFormatter(logging.Formatter(LOG_FORMAT))
    root_logger.addHandler(file_handler)

    # 文件处理器 - 错误日志
    error_handler = RotatingFileHandler(
        log_dir / "error.log",
        maxBytes=10_000_000,  # 10MB
        backupCount=5,
        encoding="utf-8"
    )
    error_handler.setLevel(logging.ERROR)
    error_handler.setFormatter(logging.Formatter(LOG_FORMAT))
    root_logger.addHandler(error_handler)

    # 文件处理器 - JSON格式访问日志
    access_handler = RotatingFileHandler(
        log_dir / "access.log",
        maxBytes=10_000_000,  # 10MB
        backupCount=5,
        encoding="utf-8"
    )
    
    class JsonFormatter(logging.Formatter):
        def format(self, record):
            log_data = {
                "timestamp": self.formatTime(record),
                "level": record.levelname,
                "logger": record.name,
                "message": record.getMessage()
            }
            if hasattr(record, "request_id"):
                log_data["request_id"] = record.request_id
            if hasattr(record, "extra"):
                log_data.update(record.extra)
            return json.dumps(log_data, ensure_ascii=False)

    access_handler.setFormatter(JsonFormatter())
    logging.getLogger("access").addHandler(access_handler)

    return root_logger

class RequestLoggingMiddleware(BaseHTTPMiddleware):
    """
    请求日志中间件
    记录每个请求的详细信息，包括：
    - 请求ID
    - 请求方法和URL
    - 客户端IP
    - 请求头
    - 响应状态码
    - 处理时间
    """
    async def set_body(self, request: Request):
        """读取并重置请求体"""
        receive_ = await request._receive()

        async def receive() -> Message:
            return receive_

        request._receive = receive

    async def __call__(self, request: Request, call_next) -> Response:
        # 生成请求ID
        request_id = f"{datetime.utcnow().timestamp()}-{id(request)}"
        
        # 获取访问日志记录器
        logger = logging.getLogger("access")
        
        # 记录请求开始
        start_time = datetime.utcnow()
        
        # 收集请求信息
        request_info = {
            "request_id": request_id,
            "method": request.method,
            "url": str(request.url),
            "client_ip": request.client.host,
            "headers": dict(request.headers),
        }

        # 如果是POST/PUT请求，记录请求体
        if request.method in ["POST", "PUT"]:
            await self.set_body(request)
            try:
                body = await request.json()
                request_info["body"] = body
            except:
                pass

        response = None
        try:
            # 处理请求
            response = await call_next(request)
            
            # 计算处理时间
            process_time = (datetime.utcnow() - start_time).total_seconds()
            
            # 记录响应信息
            log_data = {
                **request_info,
                "status_code": response.status_code,
                "process_time": process_time,
            }
            
            # 根据状态码决定日志级别
            if response.status_code >= 500:
                logger.error("Request failed", extra=log_data)
            elif response.status_code >= 400:
                logger.warning("Request error", extra=log_data)
            else:
                logger.info("Request completed", extra=log_data)
                
            # 添加请求ID到响应头
            response.headers["X-Request-ID"] = request_id
            
            return response
            
        except Exception as e:
            # 记录异常信息
            process_time = (datetime.utcnow() - start_time).total_seconds()
            log_data = {
                **request_info,
                "error": str(e),
                "process_time": process_time,
            }
            logger.error("Request failed with exception", extra=log_data, exc_info=True)
            raise
