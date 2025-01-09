from pydantic_settings import BaseSettings
from typing import Optional

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
    
    # CORS配置
    CORS_ORIGINS: list = ["*"]  # 在生产环境中应该设置具体的域名
    CORS_CREDENTIALS: bool = True
    CORS_METHODS: list = ["*"]
    CORS_HEADERS: list = ["*"]

    class Config:
        env_file = ".env"
        case_sensitive = True
