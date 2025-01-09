"""
小票服务层
"""
from typing import List, Optional, Dict
from datetime import datetime, date
from sqlalchemy.ext.asyncio import AsyncSession

from ..repositories.receipt_repository import ReceiptRepository
from ..models.receipt import Receipt, ReceiptStatus, ReceiptCategory

class ReceiptService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.repository = ReceiptRepository(session)
    
    async def create_receipt(self, receipt_data: Dict) -> Receipt:
        """
        创建小票记录
        - 验证数据
        - 设置默认值
        - 保存到数据库
        """
        # 设置默认值
        receipt_data.setdefault("status", ReceiptStatus.PENDING)
        receipt_data.setdefault("category", ReceiptCategory.OTHER)
        receipt_data.setdefault("currency", "CNY")
        
        # 创建记录
        receipt = await self.repository.create(receipt_data)
        await self.session.commit()
        return receipt
    
    async def get_receipt(self, receipt_id: int) -> Optional[Receipt]:
        """获取小票详情"""
        return await self.repository.get_by_id(receipt_id)
    
    async def list_receipts(
        self,
        merchant_name: Optional[str] = None,
        category: Optional[ReceiptCategory] = None,
        status: Optional[ReceiptStatus] = None,
        start_date: Optional[date] = None,
        end_date: Optional[date] = None,
        page: int = 1,
        page_size: int = 20
    ) -> Dict:
        """
        获取小票列表
        - 支持按商家名称搜索
        - 支持按类别和状态筛选
        - 支持按日期范围筛选
        - 支持分页
        """
        offset = (page - 1) * page_size
        
        receipts = await self.repository.list_receipts(
            merchant_name=merchant_name,
            category=category,
            status=status,
            start_date=start_date,
            end_date=end_date,
            offset=offset,
            limit=page_size
        )
        
        return {
            "items": receipts,
            "page": page,
            "page_size": page_size,
            "total": len(receipts)  # TODO: 添加总数查询
        }
    
    async def update_receipt(self, receipt_id: int, receipt_data: Dict) -> Optional[Receipt]:
        """
        更新小票信息
        - 验证数据
        - 更新数据库
        """
        receipt = await self.repository.update(receipt_id, receipt_data)
        if receipt:
            await self.session.commit()
        return receipt
    
    async def delete_receipt(self, receipt_id: int) -> bool:
        """删除小票"""
        success = await self.repository.delete(receipt_id)
        if success:
            await self.session.commit()
        return success
    
    async def analyze_receipt(self, receipt_id: int) -> Optional[Receipt]:
        """
        分析小票
        - 更新状态为处理中
        - 调用 AI 服务进行分析
        - 更新分析结果
        """
        receipt = await self.repository.get_by_id(receipt_id)
        if not receipt:
            return None
            
        try:
            # 更新状态为处理中
            receipt = await self.repository.update(
                receipt_id,
                {"status": ReceiptStatus.PROCESSING}
            )
            await self.session.commit()
            
            # TODO: 调用 AI 服务进行分析
            # result = await ai_service.analyze_receipt(receipt.image_url)
            
            # 更新分析结果
            receipt = await self.repository.update(
                receipt_id,
                {
                    "status": ReceiptStatus.COMPLETED,
                    # "items": result.items,
                    # "merchant_name": result.merchant_name,
                    # "total_amount": result.total_amount,
                }
            )
            await self.session.commit()
            
            return receipt
            
        except Exception as e:
            # 更新状态为失败
            await self.repository.update(
                receipt_id,
                {"status": ReceiptStatus.FAILED}
            )
            await self.session.commit()
            raise
    
    async def get_statistics(
        self,
        start_date: Optional[date] = None,
        end_date: Optional[date] = None,
        category: Optional[ReceiptCategory] = None
    ) -> Dict:
        """获取统计信息"""
        return await self.repository.get_statistics(
            start_date=start_date,
            end_date=end_date,
            category=category
        )
