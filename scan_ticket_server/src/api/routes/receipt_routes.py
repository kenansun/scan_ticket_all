"""
小票相关的 API 路由
"""
from typing import Optional
from datetime import date
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession

from ...database import get_db
from ...services.receipt_service import ReceiptService
from ...schemas.receipt import (
    ReceiptCreate,
    ReceiptUpdate,
    ReceiptResponse,
    ReceiptListResponse,
    ReceiptStatistics
)
from ...models.receipt import ReceiptStatus, ReceiptCategory

router = APIRouter(prefix="/receipts", tags=["receipts"])

@router.post("/", response_model=ReceiptResponse)
async def create_receipt(
    receipt: ReceiptCreate,
    db: AsyncSession = Depends(get_db)
):
    """创建小票"""
    service = ReceiptService(db)
    try:
        receipt = await service.create_receipt(receipt.dict())
        return receipt
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/{receipt_id}", response_model=ReceiptResponse)
async def get_receipt(
    receipt_id: int,
    db: AsyncSession = Depends(get_db)
):
    """获取小票详情"""
    service = ReceiptService(db)
    receipt = await service.get_receipt(receipt_id)
    if not receipt:
        raise HTTPException(status_code=404, detail="小票不存在")
    return receipt

@router.get("/", response_model=ReceiptListResponse)
async def list_receipts(
    merchant_name: Optional[str] = None,
    category: Optional[ReceiptCategory] = None,
    status: Optional[ReceiptStatus] = None,
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: AsyncSession = Depends(get_db)
):
    """获取小票列表"""
    service = ReceiptService(db)
    result = await service.list_receipts(
        merchant_name=merchant_name,
        category=category,
        status=status,
        start_date=start_date,
        end_date=end_date,
        page=page,
        page_size=page_size
    )
    return result

@router.put("/{receipt_id}", response_model=ReceiptResponse)
async def update_receipt(
    receipt_id: int,
    receipt: ReceiptUpdate,
    db: AsyncSession = Depends(get_db)
):
    """更新小票"""
    service = ReceiptService(db)
    updated_receipt = await service.update_receipt(receipt_id, receipt.dict(exclude_unset=True))
    if not updated_receipt:
        raise HTTPException(status_code=404, detail="小票不存在")
    return updated_receipt

@router.delete("/{receipt_id}")
async def delete_receipt(
    receipt_id: int,
    db: AsyncSession = Depends(get_db)
):
    """删除小票"""
    service = ReceiptService(db)
    success = await service.delete_receipt(receipt_id)
    if not success:
        raise HTTPException(status_code=404, detail="小票不存在")
    return {"message": "删除成功"}

@router.post("/{receipt_id}/analyze", response_model=ReceiptResponse)
async def analyze_receipt(
    receipt_id: int,
    db: AsyncSession = Depends(get_db)
):
    """分析小票"""
    service = ReceiptService(db)
    try:
        receipt = await service.analyze_receipt(receipt_id)
        if not receipt:
            raise HTTPException(status_code=404, detail="小票不存在")
        return receipt
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/statistics", response_model=ReceiptStatistics)
async def get_statistics(
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    category: Optional[ReceiptCategory] = None,
    db: AsyncSession = Depends(get_db)
):
    """获取统计信息"""
    service = ReceiptService(db)
    return await service.get_statistics(
        start_date=start_date,
        end_date=end_date,
        category=category
    )
