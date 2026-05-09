-- ======================================================================
-- 10% Monthly Sales Increase
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 2157
-- URL        : https://platform.stratascratch.com/coding/2157-10-monthly-sales-increase
-- ======================================================================

/*
You have been asked to compare sales of the current month, May, to those of the previous month, April.




The company requested that you only display products whose sales (UNITS SOLD * PRICE) have increased by more than 10% from the previous month to the current month.




Your output should include the product id and the percentage growth in sales.
*/

-- Tables:
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_sales AS (
    SELECT
        product_id,
        SUM(CASE WHEN EXTRACT(MONTH FROM date) = 4 THEN units_sold * price ELSE 0 END) AS april_sales,
        SUM(CASE WHEN EXTRACT(MONTH FROM date) = 5 THEN units_sold * price ELSE 0 END) AS may_sales
    FROM sales
    GROUP BY product_id
)
SELECT
    product_id,
    ROUND(((may_sales - april_sales) / NULLIF(april_sales, 0)) * 100, 2) AS percentage_growth
FROM monthly_sales
WHERE april_sales > 0
  AND ((may_sales - april_sales) / april_sales) * 100 > 10
ORDER BY percentage_growth DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    april.product_id,
    ROUND(((may_sales - april_sales) / april_sales) * 100, 2) AS percentage_growth
FROM
    (
        SELECT product_id, SUM(units_sold * price) AS april_sales
        FROM sales
        WHERE EXTRACT(MONTH FROM date) = 4
        GROUP BY product_id
    ) AS april
JOIN
    (
        SELECT product_id, SUM(units_sold * price) AS may_sales
        FROM sales
        WHERE EXTRACT(MONTH FROM date) = 5
        GROUP BY product_id
    ) AS may
    ON april.product_id = may.product_id
WHERE ((may_sales - april_sales) / april_sales) * 100 > 10
ORDER BY percentage_growth DESC;
