"""
API 测试
"""
import pytest
from datetime import datetime
from httpx import AsyncClient

from src.models.receipt import ReceiptStatus, ReceiptCategory

@pytest.mark.api
class TestReceiptAPI:
    @pytest.mark.asyncio
    async def test_create_receipt(self, client: AsyncClient):
        """测试创建小票 API"""
        response = await client.post("/api/v1/receipts/", json={
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow().isoformat(),
            "items": [
                {
                    "name": "测试商品",
                    "quantity": 1,
                    "unit_price": 100.00,
                    "total": 100.00
                }
            ]
        })
        
        assert response.status_code == 200
        data = response.json()
        assert data["merchant_name"] == "测试商家"
        assert data["status"] == ReceiptStatus.PENDING.value
        
    @pytest.mark.asyncio
    async def test_get_receipt(self, client: AsyncClient):
        """测试获取小票 API"""
        # 先创建一个小票
        create_response = await client.post("/api/v1/receipts/", json={
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow().isoformat()
        })
        receipt_id = create_response.json()["id"]
        
        # 获取小票
        response = await client.get(f"/api/v1/receipts/{receipt_id}")
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == receipt_id
        
    @pytest.mark.asyncio
    async def test_list_receipts(self, client: AsyncClient):
        """测试获取小票列表 API"""
        # 创建测试数据
        for i in range(3):
            await client.post("/api/v1/receipts/", json={
                "image_url": f"http://test.com/image{i}.jpg",
                "merchant_name": "测试商家",
                "total_amount": 100.00,
                "transaction_date": datetime.utcnow().isoformat(),
                "category": ReceiptCategory.FOOD.value
            })
        
        # 获取列表
        response = await client.get("/api/v1/receipts/", params={
            "merchant_name": "测试",
            "category": ReceiptCategory.FOOD.value,
            "page": 1,
            "page_size": 10
        })
        
        assert response.status_code == 200
        data = response.json()
        assert len(data["items"]) == 3
        
    @pytest.mark.asyncio
    async def test_update_receipt(self, client: AsyncClient):
        """测试更新小票 API"""
        # 先创建一个小票
        create_response = await client.post("/api/v1/receipts/", json={
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow().isoformat()
        })
        receipt_id = create_response.json()["id"]
        
        # 更新小票
        response = await client.put(f"/api/v1/receipts/{receipt_id}", json={
            "merchant_name": "新商家名称",
            "status": ReceiptStatus.COMPLETED.value
        })
        
        assert response.status_code == 200
        data = response.json()
        assert data["merchant_name"] == "新商家名称"
        assert data["status"] == ReceiptStatus.COMPLETED.value
        
    @pytest.mark.asyncio
    async def test_delete_receipt(self, client: AsyncClient):
        """测试删除小票 API"""
        # 先创建一个小票
        create_response = await client.post("/api/v1/receipts/", json={
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow().isoformat()
        })
        receipt_id = create_response.json()["id"]
        
        # 删除小票
        response = await client.delete(f"/api/v1/receipts/{receipt_id}")
        assert response.status_code == 200
        
        # 确认已删除
        get_response = await client.get(f"/api/v1/receipts/{receipt_id}")
        assert get_response.status_code == 404
        
    @pytest.mark.asyncio
    async def test_analyze_receipt(self, client: AsyncClient):
        """测试分析小票 API"""
        # 先创建一个小票
        create_response = await client.post("/api/v1/receipts/", json={
            "image_url": "http://test.com/image.jpg",
            "merchant_name": "测试商家",
            "total_amount": 100.00,
            "transaction_date": datetime.utcnow().isoformat()
        })
        receipt_id = create_response.json()["id"]
        
        # 分析小票
        response = await client.post(f"/api/v1/receipts/{receipt_id}/analyze")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] in [ReceiptStatus.COMPLETED.value, ReceiptStatus.FAILED.value]
