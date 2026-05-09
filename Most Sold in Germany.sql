-- ======================================================================
-- Most Sold in Germany
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Shopify
-- Access     : Premium
-- ID         : 2118
-- URL        : https://platform.stratascratch.com/coding/2118-most-sold-in-germany
-- ======================================================================

/*
Find the product with the most orders from users in Germany. Output the market name of the product or products in case of a tie.
*/

-- Tables:
--   shopify_orders(carrier_id double precision, created_at timestamp without time zone, order_amount bigint, order_id bigint, payment_method text, resp_employee_id bigint, shop_id bigint, total_items bigint, user_id bigint)
--   shopify_users(city text, country text, first_name text, id bigint, last_name text, username text)
--   dim_product(market_name text, prod_brand text, prod_sku_id text, prod_sku_name text)
--   map_product_order(order_id bigint, product_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH order_counts AS (
    SELECT
        p.market_name,
        COUNT(o.order_id) AS order_count,
        RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS rnk
    FROM orders o
    JOIN users u ON o.user_id = u.id
    JOIN products p ON o.product_id = p.id
    WHERE u.country = 'Germany'
    GROUP BY p.market_name
)
SELECT market_name
FROM order_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT p.market_name
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id
WHERE u.country = 'Germany'
GROUP BY p.market_name
HAVING COUNT(o.order_id) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(o2.order_id) AS order_count
        FROM orders o2
        JOIN users u2 ON o2.user_id = u2.id
        JOIN products p2 ON o2.product_id = p2.id
        WHERE u2.country = 'Germany'
        GROUP BY p2.market_name
    ) sub
);
