from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List
from ..services.oss_service import OssService

router = APIRouter()
oss_service = OssService()

class SignedUrlRequest(BaseModel):
    object_key: str

class BatchSignedUrlRequest(BaseModel):
    object_keys: List[str]

@router.post("/get_url")
async def get_signed_url(request: SignedUrlRequest):
    """获取单个文件的签名URL"""
    try:
        url = oss_service.get_signed_url(request.object_key)
        return {"url": url}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/get_batch_urls")
async def get_batch_signed_urls(request: BatchSignedUrlRequest):
    """批量获取文件的签名URL"""
    try:
        urls = oss_service.get_batch_signed_urls(request.object_keys)
        return {"urls": urls}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
