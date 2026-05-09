-- ======================================================================
-- Same Brand Purchases
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2071
-- URL        : https://platform.stratascratch.com/coding/2071-customers-with-specific-brands
-- ======================================================================

/*
The marketing department is aiming its next promotion at customers who have purchased products from two particular brands: Fort West and Golden.




You have been asked to prepare a list of customers who purchased products from both brands.
*/

-- Tables:
--   online_products(brand_name text, is_low_fat text, is_recyclable text, product_category bigint, product_class text, product_family text, product_id bigint)
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH brand_purchases AS (
    SELECT DISTINCT
        o.customer_id,
        p.brand
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE p.brand IN ('Fort West', 'Golden')
),
customer_brand_count AS (
    SELECT
        customer_id,
        COUNT(DISTINCT brand) AS brand_count
    FROM brand_purchases
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM customers c
JOIN customer_brand_count cbc ON c.customer_id = cbc.customer_id
WHERE cbc.brand_count = 2;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM customers c
WHERE c.customer_id IN (
    -- Customers who bought Fort West
    SELECT DISTINCT o.customer_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE p.brand = 'Fort West'
)
AND c.customer_id IN (
    -- Customers who bought Golden
    SELECT DISTINCT o.customer_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE p.brand = 'Golden'
);
