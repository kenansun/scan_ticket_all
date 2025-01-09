from pydantic import BaseModel, Field
from typing import List

class SignatureRequest(BaseModel):
    """
    OSS签名请求模型
    
    用于客户端请求OSS上传签名时提供必要的文件信息
    """
    fileName: str = Field(..., description="文件名，例如：receipt.jpg")
    fileType: str = Field(..., description="文件MIME类型，例如：image/jpeg")

    class Config:
        json_schema_extra = {
            "example": {
                "fileName": "receipt.jpg",
                "fileType": "image/jpeg"
            }
        }

class SignedUrlRequest(BaseModel):
    """
    获取签名URL请求模型
    
    用于获取OSS文件的临时访问URL
    object_key需要包含完整的OSS对象路径，例如：receipts/receipt.jpg
    """
    object_key: str = Field(..., description="OSS对象键（完整的文件路径）")

    class Config:
        json_schema_extra = {
            "example": {
                "object_key": "receipts/receipt.jpg"
            }
        }

class BatchSignedUrlRequest(BaseModel):
    """
    批量获取签名URL请求模型
    
    用于同时获取多个OSS文件的临时访问URL
    每个object_key都需要包含完整的OSS对象路径
    """
    object_keys: List[str] = Field(..., description="OSS对象键列表（每个都是完整的文件路径）")

    class Config:
        json_schema_extra = {
            "example": {
                "object_keys": ["receipts/receipt1.jpg", "receipts/receipt2.jpg"]
            }
        }
