"""
数据库初始化和管理
"""
import logging
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError

from ..config.settings import Settings
from ..models.receipt import Base
from .exceptions import DatabaseException

logger = logging.getLogger(__name__)
settings = Settings()

# 创建异步数据库引擎
DATABASE_URL = f"mysql+aiomysql://{settings.DB_USER}:{settings.DB_PASSWORD}@{settings.DB_HOST}:{settings.DB_PORT}/{settings.DB_NAME}"
engine = create_async_engine(DATABASE_URL, echo=settings.DEBUG)

# 创建异步会话工厂
AsyncSessionLocal = sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False,
)

async def init_database():
    """
    初始化数据库
    - 创建所有表
    - 创建初始数据
    """
    try:
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.create_all)
            logger.info("Database tables created successfully")
    except SQLAlchemyError as e:
        logger.error(f"Failed to initialize database: {str(e)}")
        raise DatabaseException(f"Database initialization failed: {str(e)}")

async def get_db():
    """
    获取数据库会话的依赖函数
    使用示例：
    ```
    @router.get("/items")
    async def get_items(db: AsyncSession = Depends(get_db)):
        ...
    ```
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except SQLAlchemyError as e:
            await session.rollback()
            logger.error(f"Database operation failed: {str(e)}")
            raise DatabaseException(str(e))
        except Exception as e:
            await session.rollback()
            logger.error(f"Operation failed: {str(e)}")
            raise
        finally:
            await session.close()

async def cleanup_database():
    """
    清理数据库连接
    在应用关闭时调用
    """
    try:
        await engine.dispose()
        logger.info("Database connections closed")
    except Exception as e:
        logger.error(f"Failed to cleanup database: {str(e)}")
        raise DatabaseException(f"Database cleanup failed: {str(e)}")
