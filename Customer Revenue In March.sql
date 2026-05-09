-- ======================================================================
-- Customer Revenue In March
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon, Meta
-- Access     : Premium
-- ID         : 9782
-- URL        : https://platform.stratascratch.com/coding/9782-customer-revenue-in-march
-- ======================================================================

/*
Calculate the total revenue from each customer in March 2019. Include only customers who were active in March 2019. An active user is a customer who made at least one transaction in March 2019.




Output the revenue along with the customer id and sort the results based on the revenue in descending order.
*/

-- Tables:
--   orders(cust_id bigint, id bigint, order_date date, order_details text, total_order_cost bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH march_transactions AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue
    FROM transactions
    WHERE created_at >= '2019-03-01'
      AND created_at < '2019-04-01'
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_revenue AS revenue
FROM march_transactions
ORDER BY revenue DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer_id,
    SUM(revenue) AS revenue
FROM transactions
WHERE created_at >= '2019-03-01'
  AND created_at < '2019-04-01'
GROUP BY customer_id
HAVING COUNT(*) >= 1  -- ensures at least one transaction in March 2019 (active customer)
ORDER BY revenue DESC;
