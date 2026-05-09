-- ======================================================================
-- Highest Number Of Orders
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Walmart, Amazon
-- Access     : Premium
-- ID         : 9909
-- URL        : https://platform.stratascratch.com/coding/9909-highest-number-of-orders
-- ======================================================================

/*
Find the customer who has placed the highest number of orders. Output the id of the customer along with the corresponding number of orders.
*/

-- Tables:
--   orders(cust_id bigint, id bigint, order_date date, order_details text, total_order_cost bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH order_counts AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id, order_count
FROM order_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM orders
        GROUP BY customer_id
    ) AS sub
);
