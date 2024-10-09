USE `task-02`;

-- delete indexes
DROP INDEX idx_opt_clients_status ON opt_clients;
DROP INDEX idx_opt_clients_email ON opt_clients;
DROP INDEX idx_opt_products_product_category ON opt_products;
DROP INDEX idx_opt_orders_order_date ON opt_orders;


-- Bad SELECT query
EXPLAIN ANALYZE SELECT
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
EXPLAIN ANALYZE WITH filtered_clients AS (
    -- active and 'example.com' clients
    SELECT
        id,
        surname,
        email,
        status
    FROM
        opt_clients
    WHERE
        status = 'active'
        AND email LIKE '%@example.com'
),
filtered_orders AS (
    -- orders from 2023-01-01
    SELECT
        o.order_id,
        o.order_date,
        o.client_id,
        o.product_id
    FROM
        opt_orders o
    JOIN
        filtered_clients fc ON o.client_id = fc.id
    WHERE
        o.order_date >= '2023-01-01'
),
filtered_products_category1 AS (
    -- select products belonging to Category1
    SELECT
        product_id,
        product_name,
        product_category
    FROM
        opt_products
    WHERE
        product_category = 'Category1'
),
filtered_products_category2 AS (
    -- select products belonging to Category2
    SELECT
        product_id,
        product_name,
        product_category
    FROM
        opt_products
    WHERE
        product_category = 'Category2'
),
filtered_products_category3 AS (
    -- select products belonging to Category3
    SELECT
        product_id,
        product_name,
        product_category
    FROM
        opt_products
    WHERE
        product_category = 'Category3'
),
joined_data AS (
    -- join everything following this stupid logic
    SELECT
        fo1.order_date AS order_date_1,
        fc.surname AS client_surname,
        fc.email AS client_email,
        fc.status AS client_status,
        p1.product_name AS product_name_1,
        p1.product_category AS product_category_1,
        fo2.order_date AS order_date_2,
        p2.product_name AS product_name_2,
        p2.product_category AS product_category_2,
        fo3.order_date AS order_date_3,
        p3.product_name AS product_name_3,
        p3.product_category AS product_category_3
    FROM filtered_orders fo1
    JOIN filtered_clients fc ON fo1.client_id = fc.id
    JOIN filtered_products_category1 p1 ON fo1.product_id = p1.product_id
    JOIN filtered_orders fo2 ON fo2.client_id = fc.id
    JOIN filtered_products_category2 p2 ON fo2.product_id = p2.product_id
    JOIN filtered_orders fo3 ON fo3.client_id = fc.id
    JOIN filtered_products_category3 p3 ON fo3.product_id = p3.product_id
)
SELECT
    jd.client_surname,
    jd.client_email,
    jd.product_name_1 AS product_name,
    jd.product_category_1 AS product_category,
    jd.order_date_1 AS order_date,
    jd.client_status,
    jd.client_surname AS client_surname_2,
    jd.client_email AS client_email_2,
    jd.product_name_2 AS product_name_2,
    jd.product_category_2 AS product_category_2,
    jd.order_date_2 AS order_date_2
FROM
    joined_data jd
ORDER BY
    jd.order_date_1 DESC;
