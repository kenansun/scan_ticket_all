"""
小票数据访问层
"""
from typing import List, Optional, Dict
from datetime import datetime, date
from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from ..models.receipt import Receipt, Item, ReceiptStatus, ReceiptCategory

class ReceiptRepository:
    def __init__(self, session: AsyncSession):
        self.session = session
    
    async def create(self, receipt_data: Dict) -> Receipt:
        """创建小票记录"""
        # 创建商品项
        items = [
            Item(
                name=item["name"],
                quantity=item["quantity"],
                unit_price=item["unit_price"],
                total=item["total"],
                unit=item.get("unit")
            )
            for item in receipt_data.pop("items", [])
        ]
        
        # 创建小票
        receipt = Receipt(
            **receipt_data,
            items=items
        )
        
        self.session.add(receipt)
        await self.session.flush()
        return receipt

    async def get_by_id(self, receipt_id: int) -> Optional[Receipt]:
        """根据ID获取小票"""
        query = select(Receipt).options(
            selectinload(Receipt.items)
        ).where(Receipt.id == receipt_id)
        
        result = await self.session.execute(query)
        return result.scalar_one_or_none()

    async def list_receipts(
        self,
        merchant_name: Optional[str] = None,
        category: Optional[ReceiptCategory] = None,
        status: Optional[ReceiptStatus] = None,
        start_date: Optional[date] = None,
        end_date: Optional[date] = None,
        offset: int = 0,
        limit: int = 20
    ) -> List[Receipt]:
        """获取小票列表"""
        query = select(Receipt).options(selectinload(Receipt.items))
        
        # 添加过滤条件
        filters = []
        if merchant_name:
            filters.append(Receipt.merchant_name.ilike(f"%{merchant_name}%"))
        if category:
            filters.append(Receipt.category == category)
        if status:
            filters.append(Receipt.status == status)
        if start_date:
            filters.append(Receipt.transaction_date >= start_date)
        if end_date:
            filters.append(Receipt.transaction_date <= end_date)
            
        if filters:
            query = query.where(and_(*filters))
            
        # 添加排序和分页
        query = query.order_by(Receipt.transaction_date.desc())
        query = query.offset(offset).limit(limit)
        
        result = await self.session.execute(query)
        return result.scalars().all()

    async def update(self, receipt_id: int, receipt_data: Dict) -> Optional[Receipt]:
        """更新小票信息"""
        receipt = await self.get_by_id(receipt_id)
        if not receipt:
            return None
            
        # 更新商品项
        if "items" in receipt_data:
            # 删除现有商品项
            await self.session.execute(
                select(Item).where(Item.receipt_id == receipt_id)
            )
            
            # 添加新商品项
            new_items = [
                Item(
                    name=item["name"],
                    quantity=item["quantity"],
                    unit_price=item["unit_price"],
                    total=item["total"],
                    unit=item.get("unit")
                )
                for item in receipt_data.pop("items")
            ]
            receipt.items = new_items
            
        # 更新小票信息
        for key, value in receipt_data.items():
            setattr(receipt, key, value)
            
        receipt.updated_at = datetime.utcnow()
        await self.session.flush()
        
        return receipt

    async def delete(self, receipt_id: int) -> bool:
        """删除小票"""
        receipt = await self.get_by_id(receipt_id)
        if not receipt:
            return False
            
        await self.session.delete(receipt)
        await self.session.flush()
        return True

    async def get_statistics(
        self,
        start_date: Optional[date] = None,
        end_date: Optional[date] = None,
        category: Optional[ReceiptCategory] = None
    ) -> Dict:
        """获取统计信息"""
        query = select(
            Receipt.category,
            func.count(Receipt.id).label("count"),
            func.sum(Receipt.total_amount).label("total")
        )
        
        # 添加过滤条件
        filters = []
        if start_date:
            filters.append(Receipt.transaction_date >= start_date)
        if end_date:
            filters.append(Receipt.transaction_date <= end_date)
        if category:
            filters.append(Receipt.category == category)
            
        if filters:
            query = query.where(and_(*filters))
            
        query = query.group_by(Receipt.category)
        
        result = await self.session.execute(query)
        stats = result.all()
        
        return {
            "total_count": sum(r.count for r in stats),
            "total_amount": sum(r.total for r in stats),
            "by_category": [
                {
                    "category": r.category,
                    "count": r.count,
                    "total": r.total
                }
                for r in stats
            ]
        }
