from typing import Any, Dict, Generator
import openai
from openai import AsyncOpenAI
from .base import BaseAIService, AIModelConfig, AIResponse
from ...utils.logger import log_error, log_info

class OpenAIConfig(AIModelConfig):
    """
    OpenAI模型配置
    """
    organization: str = None

    class Config:
        extra = "allow"  # 允许额外字段

class OpenAIService(BaseAIService):
    """
    OpenAI服务实现
    """
    def __init__(self, config: OpenAIConfig):
        super().__init__(config)
        self.client = AsyncOpenAI(
            api_key=config.api_key,
            organization=config.organization,
            base_url=config.api_base
        )

    async def generate(self, prompt: str, **kwargs) -> AIResponse:
        """
        生成AI响应
        
        Args:
            prompt: 输入提示
            **kwargs: 其他参数
            
        Returns:
            AIResponse: AI响应对象
        """
        try:
            response = await self.client.chat.completions.create(
                model=self.config.model_name,
                messages=[{"role": "user", "content": prompt}],
                **kwargs
            )
            
            log_info("OpenAI API call successful", {"prompt_length": len(prompt)})
            
            return AIResponse(
                content=response.choices[0].message.content,
                raw_response=response.dict(),
                usage=response.usage.dict(),
                model_name=self.config.model_name
            )
        except Exception as e:
            log_error(e, {"prompt": prompt, "kwargs": kwargs})
            raise

    async def generate_stream(self, prompt: str, **kwargs) -> Generator[str, None, None]:
        """
        生成流式AI响应
        
        Args:
            prompt: 输入提示
            **kwargs: 其他参数
            
        Yields:
            str: 响应片段
        """
        try:
            stream = await self.client.chat.completions.create(
                model=self.config.model_name,
                messages=[{"role": "user", "content": prompt}],
                stream=True,
                **kwargs
            )
            
            async for chunk in stream:
                if chunk.choices[0].delta.content:
                    yield chunk.choices[0].delta.content
        except Exception as e:
            log_error(e, {"prompt": prompt, "kwargs": kwargs})
            raise
