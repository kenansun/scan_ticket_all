from pydantic import BaseModel, Field
from typing import List

class SignatureRequest(BaseModel):
    """
    OSS签名请求模型
    """
    fileName: str = Field(..., description="文件名")
    fileType: str = Field(..., description="文件类型")

    class Config:
        schema_extra = {
            "example": {
                "fileName": "receipt.jpg",
                "fileType": "image/jpeg"
            }
        }

class SignedUrlRequest(BaseModel):
    """
    获取签名URL请求模型
    """
    object_key: str = Field(..., description="OSS对象键")

    class Config:
        schema_extra = {
            "example": {
                "object_key": "receipts/receipt.jpg"
            }
        }

class BatchSignedUrlRequest(BaseModel):
    """
    批量获取签名URL请求模型
    """
    object_keys: List[str] = Field(..., description="OSS对象键列表")

    class Config:
        schema_extra = {
            "example": {
                "object_keys": ["receipts/receipt1.jpg", "receipts/receipt2.jpg"]
            }
        }
