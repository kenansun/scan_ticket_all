"""
AI相关路由
"""

from fastapi import APIRouter, HTTPException
from fastapi.logger import logger
from pydantic import BaseModel, Field
from typing import Optional, Dict, Any
from enum import Enum

class Language(str, Enum):
    """支持的语言"""
    CHINESE = "zh_CN"
    ENGLISH = "en_US"

class AnalyzeOptions(BaseModel):
    """分析选项"""
    language: Language = Field(
        default=Language.CHINESE,
        description="识别语言，支持中文和英文"
    )

class AnalyzeRequest(BaseModel):
    """小票分析请求"""
    image_url: str = Field(
        ...,  # 必填字段
        description="小票图片的URL地址",
        example="https://example.com/receipt.jpg"
    )
    options: Optional[AnalyzeOptions] = Field(
        default=None,
        description="分析选项，可选"
    )

    class Config:
        json_schema_extra = {
            "example": {
                "image_url": "https://example.com/receipt.jpg",
                "options": {
                    "language": "zh_CN"
                }
            }
        }

# 创建路由器
router = APIRouter(tags=["AI"])

@router.post("/analyze", response_model=Dict[str, Any])
async def analyze_receipt(request: AnalyzeRequest):
    """
    分析小票图片
    
    接收一个图片URL，分析小票内容，返回结构化数据。
    支持的功能：
    - 自动识别商家信息
    - 提取交易金额和日期
    - 解析商品明细
    - 多语言支持
    
    注意：
    - 图片URL必须是可公开访问的
    - 建议图片分辨率不低于300DPI
    - 支持JPG和PNG格式
    """
    try:
        # TODO: 实现小票分析逻辑
        return {
            "merchant": {
                "name": "示例商家",
                "address": "示例地址",
                "phone": "12345678900"
            },
            "transaction": {
                "date": "2025-01-10",
                "total": 100.00,
                "currency": "CNY"
            },
            "items": [
                {
                    "name": "示例商品1",
                    "quantity": 1,
                    "unit_price": 50.00,
                    "total": 50.00
                },
                {
                    "name": "示例商品2",
                    "quantity": 1,
                    "unit_price": 50.00,
                    "total": 50.00
                }
            ]
        }
    except Exception as e:
        logger.error(f"小票分析失败: {str(e)}")
        raise HTTPException(status_code=500, detail="小票分析失败")
