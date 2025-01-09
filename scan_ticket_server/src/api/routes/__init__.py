"""
API 路由模块
"""
from fastapi import APIRouter
from .ai_routes import router as ai_router
from .oss_routes import router as oss_router
from .receipt_routes import router as receipt_router

# 创建主路由
router = APIRouter()

# 注册子路由
router.include_router(ai_router, prefix="/ai", tags=["ai"])
router.include_router(oss_router, prefix="/oss", tags=["oss"])
router.include_router(receipt_router, prefix="/receipts", tags=["receipts"])
