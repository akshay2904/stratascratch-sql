-- ======================================================================
-- Most Lucrative Products
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2119
-- URL        : https://platform.stratascratch.com/coding/2119-most-lucrative-products
-- ======================================================================

/*
You have been asked to find the 5 most lucrative products (including ties) in terms of total revenue for the first half of 2022 (from January to June inclusive).




Output their IDs and the total revenue. There may be more than 5 rows in the output since you are including ties.
*/

-- Tables:
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH revenue_by_product AS (
    SELECT
        product_id,
        SUM(quantity * unit_price) AS total_revenue
    FROM sales
    WHERE order_date >= '2022-01-01'
      AND order_date <= '2022-06-30'
    GROUP BY product_id
),
ranked AS (
    SELECT
        product_id,
        total_revenue,
        DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS rnk
    FROM revenue_by_product
)
SELECT
    product_id,
    total_revenue
FROM ranked
WHERE rnk <= 5
ORDER BY total_revenue DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    product_id,
    SUM(quantity * unit_price) AS total_revenue
FROM sales
WHERE order_date >= '2022-01-01'
  AND order_date <= '2022-06-30'
GROUP BY product_id
HAVING SUM(quantity * unit_price) >= (
    -- Find the minimum revenue among the top 5 distinct revenue values
    SELECT MIN(rev) FROM (
        SELECT SUM(quantity * unit_price) AS rev
        FROM sales
        WHERE order_date >= '2022-01-01'
          AND order_date <= '2022-06-30'
        GROUP BY product_id
        ORDER BY rev DESC
        LIMIT 5
    ) AS top5
)
ORDER BY total_revenue DESC;
