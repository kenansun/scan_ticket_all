"""
数据库连接模块
"""
import logging
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError

from .config.settings import Settings
from .models.receipt import Base
from .core.exceptions import DatabaseException

logger = logging.getLogger(__name__)
settings = Settings()

# 创建异步数据库引擎
DATABASE_URL = f"mysql+aiomysql://{settings.DB_USER}:{settings.DB_PASSWORD}@{settings.DB_HOST}:{settings.DB_PORT}/{settings.DB_NAME}"
engine = create_async_engine(
    DATABASE_URL,
    echo=settings.DEBUG,
    pool_size=settings.DB_POOL_SIZE,
    pool_recycle=settings.DB_POOL_RECYCLE
)

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
            logger.info("数据库表创建成功")
    except SQLAlchemyError as e:
        logger.error(f"数据库初始化失败: {str(e)}")
        raise DatabaseException(f"数据库初始化失败: {str(e)}")

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
            logger.error(f"数据库操作失败: {str(e)}")
            raise DatabaseException(str(e))
        except Exception as e:
            await session.rollback()
            logger.error(f"操作失败: {str(e)}")
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
        logger.info("数据库连接已关闭")
    except Exception as e:
        logger.error(f"数据库清理失败: {str(e)}")
        raise DatabaseException(f"数据库清理失败: {str(e)}")
