USE `task-02`;

-- get info about all indexes in the database
SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,  -- column's position in the index (1 for first column, etc.)
    NON_UNIQUE,
    INDEX_TYPE
FROM
    information_schema.statistics
WHERE TABLE_NAME LIKE 'opt_%';


-- Bad SELECT query

SELECT
    c1.surname AS client_surname,
    c1.email AS client_email,
    p1.product_name AS product_name,
    p1.product_category AS product_category,
    o1.order_date AS order_date,
    c1.status AS client_status,
    c2.surname AS client_surname_2,
    c2.email AS client_email_2,
    p2.product_name AS product_name_2,
    p2.product_category AS product_category_2,
    o2.order_date AS order_date_2
FROM
    opt_orders o1
    JOIN opt_clients c1 ON o1.client_id = c1.id
    JOIN opt_products p1 ON o1.product_id = p1.product_id
    JOIN opt_orders o2 ON o2.client_id = c1.id
    JOIN opt_clients c2 ON o2.client_id = c2.id
    JOIN opt_products p2 ON o2.product_id = p2.product_id
    JOIN opt_orders o3 ON o3.client_id = c1.id
    JOIN opt_clients c3 ON o3.client_id = c3.id
    JOIN opt_products p3 ON o3.product_id = p3.product_id
WHERE
    c1.status = 'active'
    AND c1.email IN (
        SELECT email
        FROM opt_clients
        WHERE email LIKE '%@example.com'
    )
    AND p1.product_category = 'Category1'
    AND p2.product_category = 'Category2'
    AND p3.product_category = 'Category3'
    AND o1.order_date >= '2023-01-01'
    AND o2.order_date >= '2023-01-01'
    AND o3.order_date >= '2023-01-01'
ORDER BY
    o1.order_date DESC,
    o2.order_date DESC,
    o3.order_date DESC;

-- Good SELECT query
-- add indexes to the tables
CREATE INDEX idx_opt_clients_status
    ON opt_clients(status);

CREATE INDEX idx_opt_clients_email
    ON opt_clients(email);

CREATE INDEX idx_opt_products_product_category
    ON opt_products(product_category);

CREATE INDEX idx_opt_orders_order_date
    ON opt_orders(order_date);

-- rewrite the query
WITH status_email AS (
    SELECT
        o.order_id,
        o.order_date,
        o.product_id,
        c.surname,
        c.email,
        c.status
    FROM
        opt_orders o
        JOIN opt_clients c ON o.client_id = c.id
    WHERE
        c.status = 'active' AND
        c.email LIKE '%@example.com' AND
        o.order_date >= '2023-01-01'
),
products AS (
    SELECT
        product_id,
        product_name,
        product_category
    FROM
        opt_products
    WHERE
        product_category IN ('Category1', 'Category2', 'Category3')
)
SELECT
    se.surname AS client_surname,
    se.email AS client_email,
    p.product_name AS product_name,
    p.product_category AS product_category,
    se.order_date AS order_date,
    se.status AS client_status,
    se.surname AS client_surname_2,
    se.email AS client_email_2,
    p.product_name AS product_name_2,
    p.product_category AS product_category_2,
    se.order_date AS order_date_2
FROM
    status_email se
    JOIN products p ON se.product_id = p.product_id
ORDER BY se.order_date DESC;


