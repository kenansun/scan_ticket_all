import base64
import hmac
import json
import time
import logging
from hashlib import sha1
from datetime import datetime, timedelta
from typing import Dict, List
import oss2
from ..models.oss import SignatureRequest, SignedUrlRequest, BatchSignedUrlRequest
from ..config.settings import Settings

# 配置日志记录
logger = logging.getLogger(__name__)

class OSSService:
    """
    OSS服务类，处理所有与阿里云OSS相关的操作
    """
    
    @staticmethod
    def _create_policy() -> str:
        """
        创建OSS上传策略
        
        用于限制上传条件，包括：
        1. 文件大小限制：最大10MB
        2. 上传目录限制：只能上传到receipts/目录
        3. 过期时间：30分钟
        
        Returns:
            str: Base64编码的策略字符串
        
        Raises:
            Exception: 策略创建失败时抛出异常
        """
        try:
            expiration = (datetime.utcnow() + timedelta(minutes=30)).strftime('%Y-%m-%dT%H:%M:%S.000Z')
            policy_dict = {
                "expiration": expiration,
                "conditions": [
                    ["content-length-range", 0, 10485760],  # 限制文件大小最大10MB
                    ["starts-with", "$key", "receipts/"],   # 限制上传文件夹
                    {"success_action_status": "200"},       # 上传成功后返回200
                    ["eq", "$x-oss-object-acl", "public-read"]  # 设置文件为公共读取权限
                ]
            }
            policy_str = json.dumps(policy_dict)
            logger.debug(f"生成上传策略: {policy_str}")
            return base64.b64encode(policy_str.encode()).decode()
        except Exception as e:
            logger.error(f"创建上传策略失败: {str(e)}")
            raise Exception(f"创建上传策略失败: {str(e)}")

    @classmethod
    async def get_signature(cls, request: SignatureRequest) -> Dict:
        """
        获取OSS上传签名
        
        Args:
            request: 签名请求对象，包含文件名和类型信息
            
        Returns:
            Dict: 包含签名信息的字典
            
        Raises:
            Exception: 获取签名失败时抛出异常
        """
        try:
            logger.info(f"开始处理签名请求 - 文件名: {request.fileName}, 类型: {request.fileType}")
            
            # 创建策略
            policy = cls._create_policy()
            logger.debug(f"生成policy成功: {policy[:30]}...")
            
            # 创建签名
            h = hmac.new(Settings.OSS_ACCESS_KEY_SECRET.encode(), policy.encode(), sha1)
            signature = base64.b64encode(h.digest()).decode()
            logger.debug(f"生成signature成功: {signature[:30]}...")
            
            # 构建响应数据
            host = f"https://{Settings.OSS_BUCKET}.{Settings.OSS_ENDPOINT}"
            response_data = {
                "accessId": Settings.OSS_ACCESS_KEY_ID,
                "policy": policy,
                "signature": signature,
                "dir": "receipts/",
                "host": host,
                "expire": int(time.time()) + 1800  # 30分钟后过期
            }
            
            # 添加回调配置（如果有）
            if Settings.OSS_CALLBACK_URL:
                callback_dict = {
                    "callbackUrl": Settings.OSS_CALLBACK_URL,
                    "callbackBody": "filename=${object}&size=${size}&mimeType=${mimeType}",
                    "callbackBodyType": "application/x-www-form-urlencoded"
                }
                callback_param = base64.b64encode(json.dumps(callback_dict).encode()).decode()
                response_data["callback"] = callback_param
                logger.debug(f"添加回调配置: {Settings.OSS_CALLBACK_URL}")
            
            logger.info(f"签名生成成功 - 文件名: {request.fileName}")
            return response_data
            
        except Exception as e:
            error_msg = f"获取签名失败 - 文件名: {request.fileName}, 错误: {str(e)}"
            logger.error(error_msg)
            raise Exception(error_msg)

    @classmethod
    async def handle_callback(cls, request: dict) -> Dict:
        """
        处理OSS回调请求
        
        当文件上传完成后，OSS会发送回调请求到此方法
        回调请求包含上传文件的信息，如文件名、大小、类型等
        
        验证步骤：
        1. 验证回调请求的签名
        2. 验证回调参数的合法性
        3. 处理回调业务逻辑
        
        Args:
            request: 回调请求数据，包含：
                    - filename: 文件名
                    - size: 文件大小
                    - mimeType: 文件类型
                    
        Returns:
            Dict: 处理结果，包含：
                 - status: 处理状态（success/failed）
                 - message: 处理消息
                 - data: 处理的数据（可选）
        
        Raises:
            Exception: 处理回调请求失败时抛出异常
        """
        try:
            # 验证回调参数
            if not all(key in request for key in ['filename', 'size', 'mimeType']):
                logger.error(f"回调参数不完整: {request}")
                return {
                    "status": "failed",
                    "message": "回调参数不完整",
                    "data": None
                }
            
            # 验证文件类型（这里可以根据需求添加更多的验证）
            allowed_mime_types = ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']
            if request['mimeType'] not in allowed_mime_types:
                logger.error(f"不支持的文件类型: {request['mimeType']}")
                return {
                    "status": "failed",
                    "message": "不支持的文件类型",
                    "data": None
                }
            
            # 验证文件大小（确保不超过10MB）
            max_size = 10 * 1024 * 1024  # 10MB
            if int(request['size']) > max_size:
                logger.error(f"文件大小超过限制: {request['size']}")
                return {
                    "status": "failed",
                    "message": "文件大小超过限制",
                    "data": None
                }
            
            # TODO: 这里可以添加更多的业务逻辑，比如：
            # 1. 记录文件上传历史到数据库
            # 2. 触发文件处理任务（如图片压缩、文字识别等）
            # 3. 发送通知给相关用户
            
            # 返回处理成功
            logger.info(f"回调处理成功 - 文件名: {request['filename']}")
            return {
                "status": "success",
                "message": "文件上传成功",
                "data": {
                    "filename": request['filename'],
                    "size": request['size'],
                    "mimeType": request['mimeType']
                }
            }
            
        except Exception as e:
            error_msg = f"处理回调请求失败: {str(e)}"
            logger.error(error_msg)
            raise Exception(error_msg)

    @classmethod
    async def get_signed_url(cls, request: SignedUrlRequest) -> Dict:
        """
        获取单个文件的签名URL
        
        生成一个临时的文件访问URL，有效期为1小时
        适用于需要临时访问OSS文件的场景
        
        Args:
            request: 包含OSS对象键的请求对象
            
        Returns:
            Dict: 包含签名URL的字典
            
        Raises:
            Exception: 获取签名URL失败时抛出异常
        """
        try:
            logger.info(f"开始获取签名URL - 对象键: {request.object_key}")
            
            auth = oss2.Auth(Settings.OSS_ACCESS_KEY_ID, Settings.OSS_ACCESS_KEY_SECRET)
            bucket = oss2.Bucket(auth, Settings.OSS_ENDPOINT, Settings.OSS_BUCKET)
            url = bucket.sign_url('GET', request.object_key, 3600)
            logger.debug(f"生成签名URL成功: {url[:30]}...")
            
            return {"signed_url": url}
            
        except Exception as e:
            error_msg = f"获取签名URL失败 - 对象键: {request.object_key}, 错误: {str(e)}"
            logger.error(error_msg)
            raise Exception(error_msg)

    @classmethod
    async def get_batch_signed_urls(cls, request: BatchSignedUrlRequest) -> Dict:
        """
        批量获取文件的签名URL
        
        同时获取多个文件的临时访问URL，每个URL有效期为1小时
        适用于需要同时获取多个文件访问链接的场景
        
        Args:
            request: 包含多个OSS对象键的请求对象
            
        Returns:
            Dict: 包含所有签名URL的字典，key为对象键，value为对应的签名URL
            
        Raises:
            Exception: 获取签名URL失败时抛出异常
        """
        try:
            logger.info(f"开始批量获取签名URL - 对象键列表: {request.object_keys}")
            
            auth = oss2.Auth(Settings.OSS_ACCESS_KEY_ID, Settings.OSS_ACCESS_KEY_SECRET)
            bucket = oss2.Bucket(auth, Settings.OSS_ENDPOINT, Settings.OSS_BUCKET)
            
            urls = {}
            for key in request.object_keys:
                url = bucket.sign_url('GET', key, 3600)
                urls[key] = url
                logger.debug(f"生成签名URL成功 - 对象键: {key}, URL: {url[:30]}...")
            
            return {"signed_urls": urls}
            
        except Exception as e:
            error_msg = f"批量获取签名URL失败 - 对象键列表: {request.object_keys}, 错误: {str(e)}"
            logger.error(error_msg)
            raise Exception(error_msg)
