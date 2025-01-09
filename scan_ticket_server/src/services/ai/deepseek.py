from typing import Any, Dict, Generator
import httpx
from .base import BaseAIService, AIModelConfig, AIResponse
from ...utils.logger import log_error, log_info

class DeepseekConfig(AIModelConfig):
    """
    Deepseek模型配置
    """
    class Config:
        extra = "allow"  # 允许额外字段

class DeepseekService(BaseAIService):
    """
    Deepseek服务实现
    """
    def __init__(self, config: DeepseekConfig):
        super().__init__(config)
        self.client = httpx.AsyncClient(
            base_url=self.config.api_base or "https://api.deepseek.com/v1",
            timeout=self.config.timeout
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
            response = await self.client.post(
                "/chat/completions",
                json={
                    "model": self.config.model_name,
                    "messages": [{"role": "user", "content": prompt}],
                    **kwargs
                },
                headers={"Authorization": f"Bearer {self.config.api_key}"}
            )
            response.raise_for_status()
            data = response.json()
            
            log_info("Deepseek API call successful", {"prompt_length": len(prompt)})
            
            return AIResponse(
                content=data["choices"][0]["message"]["content"],
                raw_response=data,
                usage=data["usage"],
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
            async with self.client.stream(
                "POST",
                "/chat/completions",
                json={
                    "model": self.config.model_name,
                    "messages": [{"role": "user", "content": prompt}],
                    "stream": True,
                    **kwargs
                },
                headers={"Authorization": f"Bearer {self.config.api_key}"}
            ) as response:
                response.raise_for_status()
                async for line in response.aiter_lines():
                    if line.strip():
                        data = line.lstrip("data: ").strip()
                        if data != "[DONE]":
                            chunk = data["choices"][0]["delta"].get("content", "")
                            if chunk:
                                yield chunk
        except Exception as e:
            log_error(e, {"prompt": prompt, "kwargs": kwargs})
            raise

    async def close(self):
        """
        关闭客户端连接
        """
        await self.client.aclose()
