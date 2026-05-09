-- ======================================================================
-- Three Purchases
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 2095
-- URL        : https://platform.stratascratch.com/coding/2095-three-purchases
-- ======================================================================

/*
List the IDs of customers who made at least 3 orders in both 2020 and 2021.
*/

-- Tables:
--   amazon_orders(id bigint, order_date date, order_total double precision, user_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH yearly_counts AS (
    SELECT
        customer_id,
        EXTRACT(YEAR FROM order_date) AS order_year,
        COUNT(*) AS order_count
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) IN (2020, 2021)
    GROUP BY customer_id, EXTRACT(YEAR FROM order_date)
)
SELECT customer_id
FROM yearly_counts
WHERE order_year IN (2020, 2021)
  AND order_count >= 3
GROUP BY customer_id
HAVING COUNT(DISTINCT order_year) = 2; -- must qualify in BOTH years

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT customer_id
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2020
GROUP BY customer_id
HAVING COUNT(*) >= 3

INTERSECT

SELECT customer_id
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2021
GROUP BY customer_id
HAVING COUNT(*) >= 3;
