import oss2
import time
from datetime import datetime, timedelta
from config import OSS_ACCESS_KEY_ID, OSS_ACCESS_KEY_SECRET, OSS_BUCKET, OSS_ENDPOINT

class OssService:
    def __init__(self):
        self.auth = oss2.Auth(OSS_ACCESS_KEY_ID, OSS_ACCESS_KEY_SECRET)
        self.bucket = oss2.Bucket(self.auth, OSS_ENDPOINT, OSS_BUCKET)
    
    def get_signed_url(self, object_key: str, expires: int = 3600) -> str:
        """
        获取文件的签名URL
        :param object_key: OSS中的文件路径
        :param expires: URL有效期（秒），默认1小时
        :return: 签名URL
        """
        try:
            # 生成签名URL
            url = self.bucket.sign_url('GET', object_key, expires)
            return url
        except Exception as e:
            print(f"Error generating signed URL: {e}")
            raise

    def get_batch_signed_urls(self, object_keys: list[str], expires: int = 3600) -> dict:
        """
        批量获取文件的签名URL
        :param object_keys: OSS文件路径列表
        :param expires: URL有效期（秒），默认1小时
        :return: 文件路径到签名URL的映射
        """
        try:
            urls = {}
            for key in object_keys:
                urls[key] = self.get_signed_url(key, expires)
            return urls
        except Exception as e:
            print(f"Error generating batch signed URLs: {e}")
            raise
