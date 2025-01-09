from dotenv import load_dotenv
import os

load_dotenv()

print("OSS Configuration:")
print(f"OSS_ACCESS_KEY_ID: {os.getenv('OSS_ACCESS_KEY_ID')}")
print(f"OSS_ACCESS_KEY_SECRET: {os.getenv('OSS_ACCESS_KEY_SECRET')}")
print(f"OSS_BUCKET: {os.getenv('OSS_BUCKET')}")
print(f"OSS_ENDPOINT: {os.getenv('OSS_ENDPOINT')}")
print(f"OSS_CALLBACK_URL: {os.getenv('OSS_CALLBACK_URL')}")
