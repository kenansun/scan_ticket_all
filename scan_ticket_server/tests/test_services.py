"""
服务层测试
"""
import pytest
from datetime import datetime

from src.services.receipt_service import ReceiptService
from src.models.receipt import ReceiptStatus, ReceiptCategory
from src.core.exceptions import ReceiptException
from .factories import ReceiptFactory, ItemFactory

@pytest.mark.service
class TestReceiptService:
    @pytest.mark.asyncio
    async def test_create_receipt(self, db_session):
        """测试创建小票"""
        service = ReceiptService(db_session)
        receipt_data = {
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow(),
            "items": [
                {
                    "name": "测试商品",
                    "quantity": 1,
                    "unit_price": 100.00,
                    "total": 100.00
                }
            ]
        }
        
        receipt = await service.create_receipt(receipt_data)
        assert receipt.id is not None
        assert receipt.status == ReceiptStatus.PENDING
        assert len(receipt.items) == 1
        
    @pytest.mark.asyncio
    async def test_get_receipt(self, db_session):
        """测试获取小票"""
        service = ReceiptService(db_session)
        receipt_data = {
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow()
        }
        
        created = await service.create_receipt(receipt_data)
        found = await service.get_receipt(created.id)
        
        assert found is not None
        assert found.id == created.id
        
    @pytest.mark.asyncio
    async def test_list_receipts(self, db_session):
        """测试获取小票列表"""
        service = ReceiptService(db_session)
        # 创建测试数据
        for i in range(5):
            await service.create_receipt({
                "image_url": f"http://test.com/image{i}.jpg",
                "merchant_name": "测试商家",
                "total_amount": 100.00,
                "transaction_date": datetime.utcnow(),
                "category": ReceiptCategory.FOOD
            })
        
        result = await service.list_receipts(
            merchant_name="测试",
            category=ReceiptCategory.FOOD,
            page=1,
            page_size=10
        )
        
        assert result["total"] == 5
        assert len(result["items"]) == 5
        
    @pytest.mark.asyncio
    async def test_update_receipt(self, db_session):
        """测试更新小票"""
        service = ReceiptService(db_session)
        receipt = await service.create_receipt({
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow()
        })
        
        updated = await service.update_receipt(receipt.id, {
            "merchant_name": "新商家名称",
            "status": ReceiptStatus.COMPLETED
        })
        
        assert updated.merchant_name == "新商家名称"
        assert updated.status == ReceiptStatus.COMPLETED
        
    @pytest.mark.asyncio
    async def test_delete_receipt(self, db_session):
        """测试删除小票"""
        service = ReceiptService(db_session)
        receipt = await service.create_receipt({
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow()
        })
        
        success = await service.delete_receipt(receipt.id)
        assert success is True
        
        # 确认已删除
        with pytest.raises(ReceiptException.NotFound):
            await service.get_receipt(receipt.id)
            
    @pytest.mark.asyncio
    async def test_analyze_receipt(self, db_session):
        """测试分析小票"""
        service = ReceiptService(db_session)
        receipt = await service.create_receipt({
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow()
        })
        
        analyzed = await service.analyze_receipt(receipt.id)
        assert analyzed.status in [ReceiptStatus.COMPLETED, ReceiptStatus.FAILED]
