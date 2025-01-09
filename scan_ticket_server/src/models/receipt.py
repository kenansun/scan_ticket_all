"""
小票数据模型
"""

from datetime import datetime
from typing import List, Optional
from enum import Enum
from sqlalchemy import Column, Integer, String, Float, DateTime, Date, Time, Enum as SQLEnum, ForeignKey, Table
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class ReceiptStatus(str, Enum):
    """小票状态"""
    PENDING = "pending"  # 待处理
    PROCESSING = "processing"  # 处理中
    COMPLETED = "completed"  # 已完成
    FAILED = "failed"  # 处理失败

class ReceiptCategory(str, Enum):
    """小票类别"""
    FOOD = "food"  # 餐饮
    SHOPPING = "shopping"  # 购物
    TRANSPORT = "transport"  # 交通
    ENTERTAINMENT = "entertainment"  # 娱乐
    MEDICAL = "medical"  # 医疗
    EDUCATION = "education"  # 教育
    OTHER = "other"  # 其他

# 小票-标签关联表
receipt_tags = Table(
    'receipt_tags',
    Base.metadata,
    Column('receipt_id', Integer, ForeignKey('receipts.id'), primary_key=True),
    Column('tag', String(50), primary_key=True)
)

class Item(Base):
    """商品项"""
    __tablename__ = 'receipt_items'
    
    id: Mapped[int] = mapped_column(primary_key=True)
    receipt_id: Mapped[int] = mapped_column(ForeignKey('receipts.id'))
    name: Mapped[str] = mapped_column(String(100))
    quantity: Mapped[float] = mapped_column(Float)
    unit_price: Mapped[float] = mapped_column(Float)
    total: Mapped[float] = mapped_column(Float)
    unit: Mapped[Optional[str]] = mapped_column(String(10), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    
    receipt = relationship("Receipt", back_populates="items")

class Receipt(Base):
    """小票模型"""
    __tablename__ = 'receipts'
    
    # 基本信息
    id: Mapped[int] = mapped_column(primary_key=True)
    image_url: Mapped[str] = mapped_column(String(255))
    status: Mapped[ReceiptStatus] = mapped_column(SQLEnum(ReceiptStatus))
    category: Mapped[Optional[ReceiptCategory]] = mapped_column(SQLEnum(ReceiptCategory), nullable=True)
    
    # 商家信息
    merchant_name: Mapped[str] = mapped_column(String(100))
    merchant_address: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    merchant_phone: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    merchant_tax_number: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    
    # 交易信息
    transaction_date: Mapped[datetime] = mapped_column(Date)
    transaction_time: Mapped[Optional[datetime]] = mapped_column(Time, nullable=True)
    total_amount: Mapped[float] = mapped_column(Float)
    currency: Mapped[str] = mapped_column(String(3), default="CNY")
    payment_method: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    
    # 商品清单
    items: Mapped[List[Item]] = relationship("Item", back_populates="receipt", cascade="all, delete-orphan")
    
    # 标签
    tags: Mapped[List[str]] = relationship(secondary=receipt_tags)
    
    # 元数据
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime, 
        default=datetime.utcnow, 
        onupdate=datetime.utcnow
    )
