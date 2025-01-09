from abc import ABC, abstractmethod
from typing import Any, Dict, Optional
from pydantic import BaseModel

class AIModelConfig(BaseModel):
    """
    AI模型配置基类
    """
    model_name: str
    api_key: str
    api_base: Optional[str] = None
    timeout: int = 30

class AIResponse(BaseModel):
    """
    AI响应结构
    """
    content: str
    raw_response: Dict[str, Any]
    usage: Dict[str, int]
    model_name: str

class BaseAIService(ABC):
    """
    AI服务基类
    """
    def __init__(self, config: AIModelConfig):
        self.config = config
        self._validate_config()

    @abstractmethod
    async def generate(self, prompt: str, **kwargs) -> AIResponse:
        """
        生成AI响应
        
        Args:
            prompt: 输入提示
            **kwargs: 其他参数
            
        Returns:
            AIResponse: AI响应对象
        """
        pass

    @abstractmethod
    async def generate_stream(self, prompt: str, **kwargs):
        """
        生成流式AI响应
        
        Args:
            prompt: 输入提示
            **kwargs: 其他参数
            
        Yields:
            str: 响应片段
        """
        pass

    def _validate_config(self):
        """
        验证配置
        """
        if not self.config.api_key:
            raise ValueError("API key is required")
