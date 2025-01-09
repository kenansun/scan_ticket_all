import logging
import sys
from typing import Any
from fastapi.logger import logger as fastapi_logger

def setup_logger(name: str = __name__) -> logging.Logger:
    """
    设置日志记录器
    
    Args:
        name: 日志记录器名称
        
    Returns:
        logging.Logger: 配置好的日志记录器
    """
    logger = logging.getLogger(name)
    
    # 设置日志级别
    logger.setLevel(logging.INFO)
    
    # 创建控制台处理器
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.INFO)
    
    # 设置日志格式
    formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    console_handler.setFormatter(formatter)
    
    # 添加处理器
    logger.addHandler(console_handler)
    
    return logger

# 创建全局日志记录器
logger = setup_logger()

def log_error(error: Exception, context: dict[str, Any] = None) -> None:
    """
    记录错误日志
    
    Args:
        error: 错误对象
        context: 错误上下文信息
    """
    error_data = {
        "error_type": type(error).__name__,
        "error_message": str(error),
        "context": context or {}
    }
    logger.error(f"Error occurred: {error_data}")

def log_info(message: str, data: dict[str, Any] = None) -> None:
    """
    记录信息日志
    
    Args:
        message: 日志消息
        data: 相关数据
    """
    log_data = {
        "message": message,
        "data": data or {}
    }
    logger.info(f"Info: {log_data}")

def log_warning(message: str, data: dict[str, Any] = None) -> None:
    """
    记录警告日志
    
    Args:
        message: 警告消息
        data: 相关数据
    """
    log_data = {
        "message": message,
        "data": data or {}
    }
    logger.warning(f"Warning: {log_data}")

# 配置FastAPI日志
fastapi_logger.handlers = logger.handlers
