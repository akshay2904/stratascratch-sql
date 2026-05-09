-- ======================================================================
-- Frequent Customers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon, Apple
-- Access     : Premium
-- ID         : 9893
-- URL        : https://platform.stratascratch.com/coding/9893-duplicate-orders
-- ======================================================================

/*
Find customers who appear in the orders table more than three times.
*/

-- Tables:
--   orders(cust_id bigint, id bigint, order_date date, order_details text, total_order_cost bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH customer_order_counts AS (
    SELECT
        customer_id,
        COUNT(*) OVER (PARTITION BY customer_id) AS order_count
    FROM orders
),
distinct_customers AS (
    SELECT DISTINCT customer_id, order_count
    FROM customer_order_counts
)
SELECT customer_id, order_count
FROM distinct_customers
WHERE order_count > 3
ORDER BY order_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 3
ORDER BY order_count DESC;
