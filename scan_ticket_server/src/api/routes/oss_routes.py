from fastapi import APIRouter, HTTPException
from ...models.oss import SignatureRequest, SignedUrlRequest, BatchSignedUrlRequest
from ...services.oss_service import OSSService

router = APIRouter(prefix="/oss", tags=["OSS"])

@router.post("/signature")
async def get_signature(request: SignatureRequest):
    """
    获取OSS上传签名
    """
    try:
        return await OSSService.get_signature(request)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/callback")
async def oss_callback(request: dict):
    """
    OSS上传回调接口
    """
    try:
        return await OSSService.handle_callback(request)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/signed-url")
async def get_signed_url(request: SignedUrlRequest):
    """
    获取单个文件的签名URL
    """
    try:
        return await OSSService.get_signed_url(request)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/batch-signed-urls")
async def get_batch_signed_urls(request: BatchSignedUrlRequest):
    """
    批量获取文件的签名URL
    """
    try:
        return await OSSService.get_batch_signed_urls(request)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
