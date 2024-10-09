-- Adding indexes on commonly used columns to improve performance
CREATE INDEX idx_customers_status ON customers(status);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_status ON orders(order_status);
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_products_product_id ON products(product_id);
CREATE INDEX idx_promotions_product_id ON promotions(product_id);
CREATE INDEX idx_reviews_product_id_customer_id ON reviews(product_id, customer_id);  -- composite index
CREATE INDEX idx_inventory_product_id ON inventory(product_id);
CREATE INDEX idx_warehouses_warehouse_id ON warehouses(warehouse_id);


-- delete all this indexes
DROP INDEX idx_customers_status ON customers;
DROP INDEX idx_orders_order_status ON orders;
DROP INDEX idx_warehouses_warehouse_id ON warehouses;
DROP INDEX idx_products_product_id ON products;
DROP INDEX idx_inventory_product_id ON inventory;
DROP INDEX idx_order_items_order_id ON order_items;
DROP INDEX idx_reviews_product_id_customer_id ON reviews;
DROP INDEX idx_promotions_product_id ON promotions;
DROP INDEX idx_orders_customer_id ON orders;
DROP INDEX idx_payments_order_id ON payments;
