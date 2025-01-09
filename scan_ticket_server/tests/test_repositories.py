"""
仓储层测试
"""
import pytest
from datetime import datetime, timedelta

from src.repositories.receipt_repository import ReceiptRepository
from src.models.receipt import ReceiptStatus, ReceiptCategory
from .factories import ReceiptFactory, ItemFactory

@pytest.mark.repository
class TestReceiptRepository:
    @pytest.mark.asyncio
    async def test_create_receipt(self, db_session):
        """测试创建小票"""
        repository = ReceiptRepository(db_session)
        receipt_data = ReceiptFactory.build()
        receipt_dict = {
            "image_url": receipt_data.image_url,
            "merchant_name": receipt_data.merchant_name,
            "total_amount": receipt_data.total_amount,
            "transaction_date": receipt_data.transaction_date,
            "status": ReceiptStatus.PENDING,
            "items": [
                {
                    "name": "测试商品1",
                    "quantity": 2,
                    "unit_price": 100,
                    "total": 200
                }
            ]
        }
        
        receipt = await repository.create(receipt_dict)
        assert receipt.id is not None
        assert receipt.merchant_name == receipt_data.merchant_name
        assert receipt.status == ReceiptStatus.PENDING
        assert len(receipt.items) == 1
        
    @pytest.mark.asyncio
    async def test_get_receipt_by_id(self, db_session):
        """测试根据ID获取小票"""
        repository = ReceiptRepository(db_session)
        receipt_data = ReceiptFactory.build()
        receipt = await repository.create({
            "image_url": receipt_data.image_url,
            "merchant_name": receipt_data.merchant_name,
            "total_amount": receipt_data.total_amount,
            "transaction_date": receipt_data.transaction_date,
            "status": ReceiptStatus.PENDING
        })
        
        found_receipt = await repository.get_by_id(receipt.id)
        assert found_receipt is not None
        assert found_receipt.id == receipt.id
        
    @pytest.mark.asyncio
    async def test_list_receipts(self, db_session):
        """测试获取小票列表"""
        repository = ReceiptRepository(db_session)
        # 创建测试数据
        receipts_data = [
            {
                "image_url": f"http://test.com/{i}",
                "merchant_name": f"商家{i}",
                "total_amount": 100 * i,
                "transaction_date": datetime.utcnow(),
                "status": ReceiptStatus.PENDING,
                "category": ReceiptCategory.FOOD
            }
            for i in range(5)
        ]
        
        for data in receipts_data:
            await repository.create(data)
        
        # 测试列表查询
        results = await repository.list_receipts(
            merchant_name="商家",
            category=ReceiptCategory.FOOD,
            status=ReceiptStatus.PENDING
        )
        
        assert len(results) == 5
        
    @pytest.mark.asyncio
    async def test_update_receipt(self, db_session):
        """测试更新小票"""
        repository = ReceiptRepository(db_session)
        receipt_data = ReceiptFactory.build()
        receipt = await repository.create({
            "image_url": receipt_data.image_url,
            "merchant_name": receipt_data.merchant_name,
            "total_amount": receipt_data.total_amount,
            "transaction_date": receipt_data.transaction_date,
            "status": ReceiptStatus.PENDING
        })
        
        # 更新数据
        updated = await repository.update(receipt.id, {
            "merchant_name": "新商家名称",
            "status": ReceiptStatus.COMPLETED
        })
        
        assert updated.merchant_name == "新商家名称"
        assert updated.status == ReceiptStatus.COMPLETED
        
    @pytest.mark.asyncio
    async def test_delete_receipt(self, db_session):
        """测试删除小票"""
        repository = ReceiptRepository(db_session)
        receipt_data = ReceiptFactory.build()
        receipt = await repository.create({
            "image_url": receipt_data.image_url,
            "merchant_name": receipt_data.merchant_name,
            "total_amount": receipt_data.total_amount,
            "transaction_date": receipt_data.transaction_date,
            "status": ReceiptStatus.PENDING
        })
        
        success = await repository.delete(receipt.id)
        assert success is True
        
        # 确认已删除
        deleted_receipt = await repository.get_by_id(receipt.id)
        assert deleted_receipt is None
