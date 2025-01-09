import os
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

# OSS配置
OSS_ACCESS_KEY_ID = os.getenv('OSS_ACCESS_KEY_ID')
OSS_ACCESS_KEY_SECRET = os.getenv('OSS_ACCESS_KEY_SECRET')
OSS_BUCKET = os.getenv('OSS_BUCKET')
OSS_ENDPOINT = os.getenv('OSS_ENDPOINT')
OSS_CALLBACK_URL = os.getenv('OSS_CALLBACK_URL')

# 服务器配置
HOST = os.getenv('HOST', '0.0.0.0')
PORT = int(os.getenv('PORT', 8000))
DEBUG = os.getenv('DEBUG', 'False').lower() == 'true'
