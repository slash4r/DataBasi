SELECT
    c.name AS customer_name,
    o.order_id,
    o.order_status,
    o.total_amount AS total_order_amount,
    p.payment_method,
    p.amount AS payment_amount,
    pr.name AS product_name,
    pr.category AS product_category,
    pi.quantity AS ordered_quantity,
    IFNULL(pro.discount_percentage, 0) AS discount_applied,
    wh.location AS warehouse_location
FROM
    customers c
JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id
JOIN order_items pi ON o.order_id = pi.order_id
JOIN products pr ON pi.product_id = pr.product_id
LEFT JOIN (
    SELECT
        pro1.product_id,
        pro1.discount_percentage
    FROM
        promotions pro1
    WHERE
        pro1.valid_from <= CURDATE()
        AND pro1.valid_until >= CURDATE()
) AS pro ON pr.product_id = pro.product_id
JOIN inventory i ON pr.product_id = i.product_id
JOIN warehouses wh ON i.warehouse_id = wh.warehouse_id
WHERE
    c.status = 'active'
    AND o.order_status IN ('completed', 'shipped', 'delivered')
    AND p.payment_date IS NOT NULL
    AND pi.quantity > 0
    AND pr.stock_quantity > 0
    AND pr.price > 0
    AND (
        SELECT COUNT(*)
        FROM reviews r
        WHERE r.product_id = pr.product_id
        AND r.customer_id = c.customer_id
        AND r.rating > 3
    ) > 0
    AND (
        SELECT COUNT(*)
        FROM order_items oi2
        WHERE oi2.order_id = o.order_id
    ) >= 2
    AND c.created_at <= (
        SELECT MIN(o2.order_date)
        FROM orders o2
        WHERE o2.customer_id = c.customer_id
    )
ORDER BY
    o.order_id DESC,
    pr.name ASC;


