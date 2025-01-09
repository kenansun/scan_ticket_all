import base64
import hmac
import json
import time
from hashlib import sha1
from datetime import datetime, timedelta
from typing import Dict, List
import oss2
from ..models.oss import SignatureRequest, SignedUrlRequest, BatchSignedUrlRequest
from ..config.settings import Settings

class OSSService:
    """
    OSS服务类，处理所有与阿里云OSS相关的操作
    """
    
    @staticmethod
    def _create_policy() -> str:
        """
        创建上传策略
        
        Returns:
            str: Base64编码的策略字符串
        """
        expiration = (datetime.utcnow() + timedelta(minutes=30)).strftime('%Y-%m-%dT%H:%M:%S.000Z')
        policy_dict = {
            "expiration": expiration,
            "conditions": [
                ["content-length-range", 0, 10485760],  # 限制文件大小最大10MB
                ["starts-with", "$key", "receipts/"],   # 限制上传文件夹
                {"success_action_status": "200"}        # 上传成功后返回200
            ]
        }
        return base64.b64encode(json.dumps(policy_dict).encode()).decode()

    @staticmethod
    def _create_signature(policy_encode: str) -> str:
        """
        创建签名
        
        Args:
            policy_encode: Base64编码的策略字符串
            
        Returns:
            str: 签名字符串
        """
        h = hmac.new(Settings.OSS_ACCESS_KEY_SECRET.encode(), policy_encode.encode(), sha1)
        return base64.b64encode(h.digest()).decode()

    @classmethod
    async def get_signature(cls, request: SignatureRequest) -> Dict:
        """
        获取OSS上传签名
        
        Args:
            request: 签名请求对象
            
        Returns:
            Dict: 包含签名信息的字典
        """
        policy = cls._create_policy()
        signature = cls._create_signature(policy)
        
        response_data = {
            "accessId": Settings.OSS_ACCESS_KEY_ID,
            "policy": policy,
            "signature": signature,
            "dir": "receipts/",
            "host": f"https://{Settings.OSS_BUCKET}.{Settings.OSS_ENDPOINT}",
            "expire": int(time.time()) + 1800  # 30分钟后过期
        }
        
        if Settings.OSS_CALLBACK_URL:
            callback_dict = {
                "callbackUrl": Settings.OSS_CALLBACK_URL,
                "callbackBody": "filename=${object}&size=${size}&mimeType=${mimeType}",
                "callbackBodyType": "application/x-www-form-urlencoded"
            }
            callback_param = base64.b64encode(json.dumps(callback_dict).encode()).decode()
            response_data["callback"] = callback_param
        
        return response_data

    @classmethod
    async def handle_callback(cls, request: dict) -> Dict:
        """
        处理OSS回调请求
        
        Args:
            request: 回调请求数据
            
        Returns:
            Dict: 处理结果
        """
        # TODO: 实现回调验证和处理逻辑
        return {"status": "success"}

    @classmethod
    async def get_signed_url(cls, request: SignedUrlRequest) -> Dict:
        """
        获取单个文件的签名URL
        
        Args:
            request: 签名URL请求对象
            
        Returns:
            Dict: 包含签名URL的字典
        """
        auth = oss2.Auth(Settings.OSS_ACCESS_KEY_ID, Settings.OSS_ACCESS_KEY_SECRET)
        bucket = oss2.Bucket(auth, Settings.OSS_ENDPOINT, Settings.OSS_BUCKET)
        url = bucket.sign_url('GET', request.object_key, 3600)
        return {"signed_url": url}

    @classmethod
    async def get_batch_signed_urls(cls, request: BatchSignedUrlRequest) -> Dict:
        """
        批量获取文件的签名URL
        
        Args:
            request: 批量签名URL请求对象
            
        Returns:
            Dict: 包含签名URL列表的字典
        """
        auth = oss2.Auth(Settings.OSS_ACCESS_KEY_ID, Settings.OSS_ACCESS_KEY_SECRET)
        bucket = oss2.Bucket(auth, Settings.OSS_ENDPOINT, Settings.OSS_BUCKET)
        
        urls = {}
        for key in request.object_keys:
            urls[key] = bucket.sign_url('GET', key, 3600)
        
        return {"signed_urls": urls}
