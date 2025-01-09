"""
应用配置模块
"""
from pydantic_settings import BaseSettings
from typing import Optional, List

class Settings(BaseSettings):
    """
    应用配置类，使用pydantic管理环境变量
    """
    # OSS配置
    OSS_ACCESS_KEY_ID: str
    OSS_ACCESS_KEY_SECRET: str
    OSS_BUCKET: str
    OSS_ENDPOINT: str
    OSS_CALLBACK_URL: Optional[str] = None

    # API配置
    API_V1_PREFIX: str = "/api/v1"
    PROJECT_NAME: str = "ScanTicket API"
    DEBUG: bool = False
    HOST: str = "127.0.0.1"
    PORT: int = 8000
    
    # 数据库配置
    DB_HOST: str = "localhost"
    DB_PORT: int = 3306
    DB_USER: str = "root"
    DB_PASSWORD: str = "root"
    DB_NAME: str = "scan_ticket"
    DB_POOL_SIZE: int = 5
    DB_POOL_RECYCLE: int = 3600
    DB_ECHO: bool = False
    
    # CORS配置
    CORS_ORIGINS: List[str] = ["*"]  # 在生产环境中应该设置具体的域名
    CORS_CREDENTIALS: bool = True
    CORS_METHODS: List[str] = ["*"]
    CORS_HEADERS: List[str] = ["*"]

    class Config:
        env_file = ".env"
        case_sensitive = True
