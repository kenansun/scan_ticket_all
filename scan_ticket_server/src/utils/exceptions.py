from fastapi import HTTPException
from typing import Any, Dict, Optional

class APIError(HTTPException):
    """
    API错误基类
    """
    def __init__(
        self,
        status_code: int,
        detail: Any = None,
        headers: Optional[Dict[str, str]] = None,
    ) -> None:
        super().__init__(status_code=status_code, detail=detail, headers=headers)

class ValidationError(APIError):
    """
    输入验证错误
    """
    def __init__(self, detail: str) -> None:
        super().__init__(status_code=422, detail=detail)

class AuthenticationError(APIError):
    """
    认证错误
    """
    def __init__(self, detail: str = "Authentication failed") -> None:
        super().__init__(status_code=401, detail=detail)

class AuthorizationError(APIError):
    """
    授权错误
    """
    def __init__(self, detail: str = "Permission denied") -> None:
        super().__init__(status_code=403, detail=detail)

class NotFoundError(APIError):
    """
    资源不存在错误
    """
    def __init__(self, detail: str = "Resource not found") -> None:
        super().__init__(status_code=404, detail=detail)

class BusinessError(APIError):
    """
    业务逻辑错误
    """
    def __init__(self, detail: str) -> None:
        super().__init__(status_code=400, detail=detail)
