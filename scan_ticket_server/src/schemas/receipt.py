"""
小票相关的数据验证模型
"""
from typing import List, Optional
from datetime import datetime
from pydantic import BaseModel, Field, validator
from decimal import Decimal

from ..models.receipt import ReceiptStatus, ReceiptCategory

class ItemCreate(BaseModel):
    """创建商品项的请求模型"""
    name: str = Field(..., description="商品名称", min_length=1, max_length=100)
    quantity: float = Field(..., description="数量", gt=0)
    unit_price: float = Field(..., description="单价", ge=0)
    total: Optional[float] = Field(None, description="总价")
    unit: Optional[str] = Field(None, description="单位", max_length=10)

    @validator("total", pre=True, always=True)
    def calculate_total(cls, v, values):
        """如果未提供总价，则根据数量和单价计算"""
        if v is None and "quantity" in values and "unit_price" in values:
            return round(values["quantity"] * values["unit_price"], 2)
        return v

    class Config:
        json_schema_extra = {
            "example": {
                "name": "商品1",
                "quantity": 1,
                "unit_price": 10.00,
                "total": 10.00,
                "unit": "个"
            }
        }

class ReceiptCreate(BaseModel):
    """创建小票的请求模型"""
    image_url: str = Field(..., description="小票图片URL", max_length=255)
    merchant_name: str = Field(..., description="商家名称", min_length=1, max_length=100)
    merchant_address: Optional[str] = Field(None, description="商家地址", max_length=255)
    merchant_phone: Optional[str] = Field(None, description="商家电话", max_length=20)
    merchant_tax_number: Optional[str] = Field(None, description="商家税号", max_length=50)
    
    transaction_date: datetime = Field(..., description="交易日期")
    transaction_time: Optional[str] = Field(None, description="交易时间")
    total_amount: float = Field(..., description="总金额", gt=0)
    currency: str = Field("CNY", description="货币类型", max_length=3)
    payment_method: Optional[str] = Field(None, description="支付方式", max_length=20)
    
    category: Optional[ReceiptCategory] = Field(ReceiptCategory.OTHER, description="小票类别")
    items: List[ItemCreate] = Field(default_factory=list, description="商品清单")
    tags: List[str] = Field(default_factory=list, description="标签")

    @validator("total_amount")
    def validate_total_amount(cls, v):
        """验证总金额"""
        return round(float(v), 2)

    @validator("items")
    def validate_items_total(cls, v, values):
        """验证商品项总额是否与小票总额相符"""
        if not v:
            return v
        items_total = sum(item.total for item in v)
        total_amount = values.get("total_amount")
        if total_amount and abs(items_total - total_amount) > 0.01:
            raise ValueError("商品总额与小票总额不符")
        return v

    class Config:
        json_schema_extra = {
            "example": {
                "image_url": "https://example.com/receipt.jpg",
                "merchant_name": "示例商家",
                "transaction_date": "2025-01-10T00:00:00",
                "total_amount": 100.00,
                "items": [
                    {
                        "name": "商品1",
                        "quantity": 1,
                        "unit_price": 100.00,
                        "total": 100.00
                    }
                ]
            }
        }

class ReceiptUpdate(BaseModel):
    """更新小票的请求模型"""
    merchant_name: Optional[str] = Field(None, description="商家名称", min_length=1, max_length=100)
    merchant_address: Optional[str] = Field(None, description="商家地址", max_length=255)
    merchant_phone: Optional[str] = Field(None, description="商家电话", max_length=20)
    merchant_tax_number: Optional[str] = Field(None, description="商家税号", max_length=50)
    transaction_date: Optional[datetime] = Field(None, description="交易日期")
    transaction_time: Optional[str] = Field(None, description="交易时间")
    total_amount: Optional[float] = Field(None, description="总金额", gt=0)
    currency: Optional[str] = Field(None, description="货币类型", max_length=3)
    payment_method: Optional[str] = Field(None, description="支付方式", max_length=20)
    category: Optional[ReceiptCategory] = Field(None, description="小票类别")
    items: Optional[List[ItemCreate]] = Field(None, description="商品清单")
    tags: Optional[List[str]] = Field(None, description="标签")

    class Config:
        json_schema_extra = {
            "example": {
                "merchant_name": "更新后的商家名称",
                "total_amount": 150.00
            }
        }

class ReceiptResponse(BaseModel):
    """小票响应模型"""
    id: int
    image_url: str
    merchant_name: str
    merchant_address: Optional[str]
    merchant_phone: Optional[str]
    merchant_tax_number: Optional[str]
    transaction_date: datetime
    transaction_time: Optional[str]
    total_amount: float
    currency: str
    payment_method: Optional[str]
    status: ReceiptStatus
    category: ReceiptCategory
    items: List[ItemCreate]
    tags: List[str]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class ReceiptListResponse(BaseModel):
    """小票列表响应模型"""
    items: List[ReceiptResponse]
    total: int
    page: int
    page_size: int

    class Config:
        from_attributes = True

class ReceiptStatistics(BaseModel):
    """小票统计响应模型"""
    total_count: int
    total_amount: float
    by_category: List[dict]

    class Config:
        from_attributes = True
