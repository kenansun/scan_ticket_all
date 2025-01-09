"""
主应用模块
"""
import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from .config.settings import Settings
from .api.routes import router as api_router
from .core.database import init_database, cleanup_database
from .core.exceptions import BaseAPIException
from .core.logging import setup_logging, RequestLoggingMiddleware

# 设置日志
logger = setup_logging()

@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    应用生命周期管理
    """
    # 启动事件
    logger.info("正在初始化应用...")
    await init_database()
    logger.info("应用启动完成")
    
    yield
    
    # 关闭事件
    logger.info("正在关闭应用...")
    await cleanup_database()
    logger.info("应用关闭完成")

def create_app() -> FastAPI:
    """
    创建FastAPI应用实例
    """
    settings = Settings()
    
    app = FastAPI(
        title=settings.PROJECT_NAME,
        description="小票扫描与分析服务API",
        version="1.0.0",
        docs_url="/docs",
        redoc_url="/redoc",
        openapi_url="/openapi.json",
        lifespan=lifespan
    )

    # 配置中间件
    app.add_middleware(RequestLoggingMiddleware)
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.CORS_ORIGINS,
        allow_credentials=settings.CORS_CREDENTIALS,
        allow_methods=settings.CORS_METHODS,
        allow_headers=settings.CORS_HEADERS,
    )

    # 注册路由
    app.include_router(api_router, prefix=settings.API_V1_PREFIX)

    # 全局异常处理
    @app.exception_handler(BaseAPIException)
    async def api_exception_handler(request: Request, exc: BaseAPIException):
        logger.error(f"API异常: {exc.detail}", extra={
            "url": str(request.url),
            "method": request.method,
            "status_code": exc.status_code
        })
        return JSONResponse(
            status_code=exc.status_code,
            content={"detail": exc.detail}
        )

    @app.exception_handler(Exception)
    async def global_exception_handler(request: Request, exc: Exception):
        logger.error(f"未处理的异常: {str(exc)}", exc_info=True, extra={
            "url": str(request.url),
            "method": request.method
        })
        return JSONResponse(
            status_code=500,
            content={"detail": "Internal server error"}
        )

    return app

app = create_app()

if __name__ == "__main__":
    import uvicorn
    settings = Settings()
    uvicorn.run(
        "src.main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.DEBUG
    )
