from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import oss2
import base64
import hmac
import json
import time
from hashlib import sha1
from datetime import datetime, timedelta
from dotenv import load_dotenv
import os

# 加载环境变量
load_dotenv()

app = FastAPI()

# 配置CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 在生产环境中应该设置具体的域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# OSS配置
OSS_ACCESS_KEY_ID = os.getenv('OSS_ACCESS_KEY_ID')
OSS_ACCESS_KEY_SECRET = os.getenv('OSS_ACCESS_KEY_SECRET')
OSS_BUCKET = os.getenv('OSS_BUCKET')
OSS_ENDPOINT = os.getenv('OSS_ENDPOINT')
OSS_CALLBACK_URL = os.getenv('OSS_CALLBACK_URL')

class SignatureRequest(BaseModel):
    fileName: str
    fileType: str

class SignedUrlRequest(BaseModel):
    object_key: str

class BatchSignedUrlRequest(BaseModel):
    object_keys: list[str]

def create_policy():
    """创建上传策略"""
    expiration = (datetime.utcnow() + timedelta(minutes=30)).strftime('%Y-%m-%dT%H:%M:%S.000Z')
    policy_dict = {
        "expiration": expiration,
        "conditions": [
            ["content-length-range", 0, 10485760],  # 限制文件大小最大10MB
            ["starts-with", "$key", "receipts/"],   # 限制上传文件夹
            {"success_action_status": "200"}        # 上传成功后返回200
        ]
    }
    policy_encode = base64.b64encode(json.dumps(policy_dict).encode()).decode()
    return policy_encode

def create_signature(policy_encode):
    """创建签名"""
    h = hmac.new(OSS_ACCESS_KEY_SECRET.encode(), policy_encode.encode(), sha1)
    sign = base64.b64encode(h.digest()).decode()
    return sign

@app.post("/oss/signature")
async def get_signature(request: SignatureRequest):
    try:
        # 生成策略
        policy = create_policy()
        
        # 生成签名
        signature = create_signature(policy)
        
        # 构建返回数据
        response_data = {
            "accessId": OSS_ACCESS_KEY_ID,
            "policy": policy,
            "signature": signature,
            "dir": "receipts/",
            "host": f"https://{OSS_BUCKET}.{OSS_ENDPOINT}",
            "expire": int(time.time()) + 1800  # 30分钟后过期
        }
        
        # 如果配置了回调
        if OSS_CALLBACK_URL:
            callback_dict = {
                "callbackUrl": OSS_CALLBACK_URL,
                "callbackBody": "filename=${object}&size=${size}&mimeType=${mimeType}",
                "callbackBodyType": "application/x-www-form-urlencoded"
            }
            callback_param = base64.b64encode(json.dumps(callback_dict).encode()).decode()
            response_data["callback"] = callback_param
        
        return response_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/oss/callback")
async def oss_callback(request: dict):
    """OSS上传回调接口"""
    # 验证回调签名
    # 处理回调逻辑
    return {"success": True}

@app.post("/oss/get_url")
async def get_signed_url(request: SignedUrlRequest):
    """获取单个文件的签名URL"""
    try:
        auth = oss2.Auth(OSS_ACCESS_KEY_ID, OSS_ACCESS_KEY_SECRET)
        bucket = oss2.Bucket(auth, OSS_ENDPOINT, OSS_BUCKET)
        # 生成一个小时有效的签名URL
        url = bucket.sign_url('GET', request.object_key, 3600)
        return {"url": url}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/oss/get_batch_urls")
async def get_batch_signed_urls(request: BatchSignedUrlRequest):
    """批量获取文件的签名URL"""
    try:
        auth = oss2.Auth(OSS_ACCESS_KEY_ID, OSS_ACCESS_KEY_SECRET)
        bucket = oss2.Bucket(auth, OSS_ENDPOINT, OSS_BUCKET)
        urls = {}
        for key in request.object_keys:
            urls[key] = bucket.sign_url('GET', key, 3600)
        return {"urls": urls}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host=os.getenv('HOST', '0.0.0.0'),
        port=int(os.getenv('PORT', 8000)),
        reload=os.getenv('DEBUG', 'False').lower() == 'true'
    )
