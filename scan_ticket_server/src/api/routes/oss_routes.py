"""
OSS相关路由
"""

from fastapi import APIRouter, HTTPException
from fastapi.logger import logger
from src.models.oss import SignatureRequest, SignedUrlRequest, BatchSignedUrlRequest
from src.services.oss_service import OSSService

# 创建路由器，指定标签
router = APIRouter(tags=["OSS"])

@router.post("/signature",
    response_model=dict,
    summary="获取OSS上传签名",
    description="获取用于直传文件到OSS的签名信息",
    response_description="签名信息，包含accessId、policy、signature等"
)
async def get_signature(request: SignatureRequest):
    """获取OSS上传签名"""
    try:
        oss_service = OSSService()
        return await oss_service.get_signature(request)
    except Exception as e:
        logger.error(f"获取签名失败: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="获取签名失败，请稍后重试"
        )

@router.post("/callback",
    response_model=dict,
    summary="OSS上传回调",
    description="处理OSS上传完成后的回调请求",
    response_description="回调处理结果"
)
async def oss_callback(request: dict):
    """处理OSS上传回调"""
    try:
        oss_service = OSSService()
        return await oss_service.handle_callback(request)
    except Exception as e:
        logger.error(f"处理回调失败: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="处理回调失败，请稍后重试"
        )

@router.post("/url",
    response_model=dict,
    summary="获取文件访问URL",
    description="获取OSS文件的临时访问URL",
    response_description="包含文件访问URL的响应"
)
async def get_signed_url(request: SignedUrlRequest):
    """获取文件的签名URL"""
    try:
        oss_service = OSSService()
        return await oss_service.get_signed_url(request)
    except Exception as e:
        logger.error(f"获取URL失败: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="获取URL失败，请稍后重试"
        )

@router.post("/batch-urls",
    response_model=dict,
    summary="批量获取文件访问URL",
    description="批量获取多个OSS文件的临时访问URL",
    response_description="包含多个文件访问URL的响应"
)
async def get_batch_signed_urls(request: BatchSignedUrlRequest):
    """批量获取文件的签名URL"""
    try:
        oss_service = OSSService()
        return await oss_service.get_batch_signed_urls(request)
    except Exception as e:
        logger.error(f"批量获取URL失败: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="批量获取URL失败，请稍后重试"
        )
