"""
自定义异常类
"""
from fastapi import HTTPException, status

class BaseAPIException(HTTPException):
    """基础API异常"""
    def __init__(
        self,
        status_code: int,
        detail: str = None,
        headers: dict = None
    ):
        super().__init__(status_code=status_code, detail=detail, headers=headers)

class NotFoundException(BaseAPIException):
    """资源不存在异常"""
    def __init__(self, detail: str = "Resource not found"):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail=detail)

class ValidationException(BaseAPIException):
    """数据验证异常"""
    def __init__(self, detail: str = "Validation error"):
        super().__init__(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=detail)

class DatabaseException(BaseAPIException):
    """数据库操作异常"""
    def __init__(self, detail: str = "Database operation failed"):
        super().__init__(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=detail)

class ReceiptException:
    """小票相关异常"""
    class NotFound(NotFoundException):
        def __init__(self, receipt_id: int):
            super().__init__(f"Receipt with id {receipt_id} not found")
    
    class InvalidData(ValidationException):
        def __init__(self, detail: str = "Invalid receipt data"):
            super().__init__(detail)
    
    class AnalysisFailed(BaseAPIException):
        def __init__(self, detail: str = "Receipt analysis failed"):
            super().__init__(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=detail
            )
