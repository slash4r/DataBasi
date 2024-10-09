import mysql.connector
from faker import Faker
from dotenv import load_dotenv
from datetime import date
import random
import os

# Load environment variables
load_dotenv()

# Connection settings
HOST = os.getenv('host')
USER = os.getenv('user')
PASSWORD = os.getenv('password')
DATABASE = os.getenv('database')

# Connect to the MySQL database
connection = mysql.connector.connect(
    host=HOST,
    user=USER,
    password=PASSWORD,
    database=DATABASE
)

cursor = connection.cursor()
fake = Faker()

# Insert data into customers
print("Inserting into customers...")
customer_insert_query = """
    INSERT INTO customers (name, email, status, created_at)
    VALUES (%s, %s, %s, %s)
"""
customers_data = [
    (fake.name(), fake.email(), random.choice(['active', 'inactive']), fake.date_this_decade())
    for _ in range(100000)  # Example: 100000 customers
]
cursor.executemany(customer_insert_query, customers_data)
connection.commit()
print("Inserted into customers.")

# Fetch customer_ids for foreign key relationships
cursor.execute("SELECT customer_id FROM customers")
customer_ids = [row[0] for row in cursor.fetchall()]

# Insert data into products
print("Inserting into products...")
product_insert_query = """
    INSERT INTO products (name, category, price, stock_quantity)
    VALUES (%s, %s, %s, %s)
"""
categories = ['electronics', 'books', 'furniture', 'clothing', 'toys']
products_data = [
    (fake.word(), random.choice(categories), round(random.uniform(10, 1000), 2), random.randint(0, 100))
    for _ in range(5000)  # Example: 5000 products
]
cursor.executemany(product_insert_query, products_data)
connection.commit()
print("Inserted into products.")

# Fetch product_ids for foreign key relationships
cursor.execute("SELECT product_id FROM products")
product_ids = [row[0] for row in cursor.fetchall()]

# Insert data into orders
print("Inserting into orders...")
order_insert_query = """
    INSERT INTO orders (customer_id, order_status, total_amount, order_date)
    VALUES (%s, %s, %s, %s)
"""
orders_data = [
    (random.choice(customer_ids), random.choice(['pending', 'shipped', 'delivered']), round(random.uniform(20, 2000), 2), fake.date_this_year())
    for _ in range(20000)  # Example: 20000 orders
]
cursor.executemany(order_insert_query, orders_data)
connection.commit()
print("Inserted into orders.")

# Fetch order_ids for foreign key relationships
cursor.execute("SELECT order_id FROM orders")
order_ids = [row[0] for row in cursor.fetchall()]

# Insert data into order_items
print("Inserting into order_items...")
order_items_insert_query = """
    INSERT INTO order_items (order_id, product_id, quantity, price)
    VALUES (%s, %s, %s, %s)
"""
order_items_data = [
    (random.choice(order_ids), random.choice(product_ids), random.randint(1, 5), round(random.uniform(10, 500), 2))
    for _ in range(50000)  # Example: 50000 order items
]
cursor.executemany(order_items_insert_query, order_items_data)
connection.commit()
print("Inserted into order_items.")

# Insert data into payments
print("Inserting into payments...")
payment_insert_query = """
    INSERT INTO payments (order_id, payment_method, payment_date, amount)
    VALUES (%s, %s, %s, %s)
"""
payment_methods = ['credit_card', 'paypal', 'bank_transfer', 'cash']
payments_data = [
    (random.choice(order_ids), random.choice(payment_methods), fake.date_this_year(), round(random.uniform(20, 2000), 2))
    for _ in range(15000)  # Example: 15000 payments
]
cursor.executemany(payment_insert_query, payments_data)
connection.commit()
print("Inserted into payments.")

# Insert data into reviews
print("Inserting into reviews...")
review_insert_query = """
    INSERT INTO reviews (customer_id, product_id, rating, review_date)
    VALUES (%s, %s, %s, %s)
"""
reviews_data = [
    (random.choice(customer_ids), random.choice(product_ids), random.randint(1, 5), fake.date_this_year())
    for _ in range(10000)  # Example: 10000 reviews
]
cursor.executemany(review_insert_query, reviews_data)
connection.commit()
print("Inserted into reviews.")

# Insert data into promotions
promo_insert_query = """
    INSERT INTO promotions (product_id, discount_percentage, valid_from, valid_until)
    VALUES (%s, %s, %s, %s)
"""

current_year_start = date(date.today().year, 1, 1)
current_year_end = date(date.today().year, 12, 31)

promotions_data = [
    (random.choice(product_ids), round(random.uniform(5, 50), 2),
     fake.date_between(start_date=current_year_start, end_date=current_year_end),
     fake.date_between(start_date=current_year_start, end_date=current_year_end))
    for _ in range(1000)
]

cursor.executemany(promo_insert_query, promotions_data)
connection.commit()
print("Inserted into promotions.")

# Insert data into warehouses
print("Inserting into warehouses...")
warehouse_insert_query = """
    INSERT INTO warehouses (location, capacity)
    VALUES (%s, %s)
"""
warehouses_data = [
    (fake.city(), random.randint(1000, 10000))
    for _ in range(100)  # Example: 100 warehouses
]
cursor.executemany(warehouse_insert_query, warehouses_data)
connection.commit()
print("Inserted into warehouses.")

# Fetch warehouse_ids for foreign key relationships
cursor.execute("SELECT warehouse_id FROM warehouses")
warehouse_ids = [row[0] for row in cursor.fetchall()]

# Insert data into inventory
print("Inserting into inventory...")
inventory_insert_query = """
    INSERT INTO inventory (product_id, warehouse_id, quantity)
    VALUES (%s, %s, %s)
"""
inventory_data = [
    (random.choice(product_ids), random.choice(warehouse_ids), random.randint(1, 100))
    for _ in range(5000)  # Example: 5000 inventory records
]
cursor.executemany(inventory_insert_query, inventory_data)
connection.commit()
print("Inserted into inventory.")

# Close the cursor and connection
cursor.close()
connection.close()

print("Data insertion complete.")
