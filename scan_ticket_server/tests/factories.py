"""
测试数据工厂
"""
import factory
from datetime import datetime, timedelta
from src.models.receipt import Receipt, Item, ReceiptStatus, ReceiptCategory

class ItemFactory(factory.Factory):
    """商品项工厂"""
    class Meta:
        model = Item

    name = factory.Sequence(lambda n: f"测试商品 {n}")
    quantity = factory.Faker("pyfloat", min_value=1, max_value=10, right_digits=2)
    unit_price = factory.Faker("pyfloat", min_value=10, max_value=1000, right_digits=2)
    total = factory.LazyAttribute(lambda obj: obj.quantity * obj.unit_price)
    unit = factory.Iterator(["个", "件", "kg", "盒"])

class ReceiptFactory(factory.Factory):
    """小票工厂"""
    class Meta:
        model = Receipt

    image_url = factory.Faker("url")
    merchant_name = factory.Faker("company")
    merchant_address = factory.Faker("address")
    merchant_phone = factory.Faker("phone_number")
    merchant_tax_number = factory.Sequence(lambda n: f"税号{n}")
    
    transaction_date = factory.Faker("date_time_this_year")
    total_amount = factory.Faker("pyfloat", min_value=100, max_value=10000, right_digits=2)
    currency = "CNY"
    payment_method = factory.Iterator(["现金", "支付宝", "微信支付", "银行卡"])
    
    status = factory.Iterator([status for status in ReceiptStatus])
    category = factory.Iterator([category for category in ReceiptCategory])
    
    created_at = factory.LazyFunction(datetime.utcnow)
    updated_at = factory.LazyFunction(datetime.utcnow)

    @factory.post_generation
    def items(self, create, extracted, **kwargs):
        """生成关联的商品项"""
        if not create:
            return

        if extracted:
            for item in extracted:
                self.items.append(item)
        else:
            # 默认生成1-5个商品项
            num_items = factory.random.randint(1, 5)
            self.items = [ItemFactory() for _ in range(num_items)]
            # 更新总金额
            self.total_amount = sum(item.total for item in self.items)
