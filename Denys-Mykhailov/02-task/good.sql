USE `task-02`;

WITH ActivePromotions AS (
    SELECT
        product_id,
        discount_percentage
    FROM promotions
    WHERE valid_from <= CURDATE()
    AND valid_until >= CURDATE()
),
CustomerReviews AS (
    SELECT
        product_id,
        customer_id,
        COUNT(*) AS positive_reviews_count
    FROM reviews
    WHERE rating > 3
    GROUP BY product_id, customer_id
),
CustomerOrders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_status,
        o.total_amount,
        o.order_date,
        p.payment_method,
        p.amount AS payment_amount
    FROM orders o
    JOIN payments p ON o.order_id = p.order_id
    WHERE o.order_status IN ('completed', 'shipped', 'delivered')
    AND p.payment_date IS NOT NULL
)
SELECT
    c.name AS customer_name,
    c.status AS customer_status,
    cr.positive_reviews_count,
    co.order_id,
    co.order_status,
    co.total_amount AS total_order_amount,
    co.payment_method,
    co.payment_amount,
    pr.name AS product_name,
    pr.category AS product_category,
    pr.stock_quantity,
    oi.quantity AS ordered_quantity,
    IFNULL(ap.discount_percentage, 0) AS discount_applied,
    wh.location AS warehouse_location
FROM
    customers c
JOIN CustomerOrders co ON c.customer_id = co.customer_id
JOIN order_items oi ON co.order_id = oi.order_id
JOIN products pr ON oi.product_id = pr.product_id
LEFT JOIN ActivePromotions ap ON pr.product_id = ap.product_id
LEFT JOIN CustomerReviews cr ON cr.product_id = pr.product_id AND cr.customer_id = c.customer_id
JOIN inventory i ON pr.product_id = i.product_id
JOIN warehouses wh ON i.warehouse_id = wh.warehouse_id
WHERE
    c.status = 'active'
#     AND cr.positive_reviews_count > 0 -- ensuring the customer left a positive review
    AND pr.stock_quantity > 0
    AND oi.quantity > 0
ORDER BY
    co.order_id DESC,
    pr.name ASC;


