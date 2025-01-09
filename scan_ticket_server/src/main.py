from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config.settings import Settings
from .api.routes import oss_routes

def create_app() -> FastAPI:
    """
    创建FastAPI应用实例
    """
    settings = Settings()
    
    app = FastAPI(
        title=settings.PROJECT_NAME,
        debug=settings.DEBUG,
    )

    # 配置CORS
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.CORS_ORIGINS,
        allow_credentials=settings.CORS_CREDENTIALS,
        allow_methods=settings.CORS_METHODS,
        allow_headers=settings.CORS_HEADERS,
    )

    # 注册路由
    app.include_router(
        oss_routes.router,
        prefix=settings.API_V1_PREFIX
    )

    return app

app = create_app()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
