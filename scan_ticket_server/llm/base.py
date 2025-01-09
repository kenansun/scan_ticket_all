from abc import ABC, abstractmethod
from typing import Dict, Any, Optional, List
from dataclasses import dataclass

@dataclass
class LLMResponse:
    """Large Language Model response structure"""
    content: str
    raw_response: Dict[str, Any]
    usage: Dict[str, int]
    model_name: str

@dataclass
class LLMConfig:
    """Configuration for LLM models"""
    model_name: str
    temperature: float = 0.7
    max_tokens: int = 2000
    top_p: float = 1.0
    frequency_penalty: float = 0.0
    presence_penalty: float = 0.0
    stop_sequences: Optional[List[str]] = None
    custom_parameters: Optional[Dict[str, Any]] = None

class BaseLLM(ABC):
    """Base abstract class for LLM implementations"""
    
    def __init__(self, config: LLMConfig):
        self.config = config
        self._validate_config()
    
    @abstractmethod
    async def generate(self, prompt: str, **kwargs) -> LLMResponse:
        """Generate response from LLM"""
        pass
    
    @abstractmethod
    async def generate_stream(self, prompt: str, **kwargs):
        """Generate streaming response from LLM"""
        pass
    
    def _validate_config(self):
        """Validate the configuration"""
        if not self.config.model_name:
            raise ValueError("Model name must be specified")
        if not 0 <= self.config.temperature <= 2:
            raise ValueError("Temperature must be between 0 and 2")
        if self.config.max_tokens <= 0:
            raise ValueError("Max tokens must be positive")
