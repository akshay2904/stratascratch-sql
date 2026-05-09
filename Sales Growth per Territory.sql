-- ======================================================================
-- Sales Growth per Territory
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Shopify, Amazon
-- Access     : Premium
-- ID         : 2111
-- URL        : https://platform.stratascratch.com/coding/2111-sales-growth-per-territory
-- ======================================================================

/*
Write a query to return Territory and corresponding Sales Growth. Compare growth between periods Q4-2021 vs Q3-2021.

If Territory (say T123) has Sales worth $100 in Q3-2021 and Sales worth $110 in Q4-2021, then the Sales Growth will be 10% [ i.e. = ((110 - 100)/100) * 100 ]

Output the ID of the Territory and the Sales Growth. Only output these territories that had any sales in both quarters.
*/

-- Tables:
--   fct_customer_sales(cust_id text, order_date date, order_id text, order_value bigint, prod_sku_id text)
--   map_customer_territory(cust_id text, territory_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH quarterly_sales AS (
    SELECT
        territory_id,
        SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 3 AND EXTRACT(YEAR FROM order_date) = 2021 THEN sales END) AS q3_sales,
        SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 4 AND EXTRACT(YEAR FROM order_date) = 2021 THEN sales END) AS q4_sales
    FROM sales
    WHERE EXTRACT(YEAR FROM order_date) = 2021
      AND EXTRACT(QUARTER FROM order_date) IN (3, 4)
    GROUP BY territory_id
)
SELECT
    territory_id,
    ROUND(((q4_sales - q3_sales) / q3_sales) * 100, 2) AS sales_growth
FROM quarterly_sales
-- Only territories with sales in BOTH quarters
WHERE q3_sales IS NOT NULL
  AND q4_sales IS NOT NULL
  AND q3_sales <> 0;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    q4.territory_id,
    ROUND(((q4.q4_sales - q3.q3_sales) / q3.q3_sales) * 100, 2) AS sales_growth
FROM
    -- Q4 2021 sales per territory
    (
        SELECT
            territory_id,
            SUM(sales) AS q4_sales
        FROM sales
        WHERE EXTRACT(QUARTER FROM order_date) = 4
          AND EXTRACT(YEAR FROM order_date) = 2021
        GROUP BY territory_id
        HAVING SUM(sales) > 0
    ) q4
    INNER JOIN
    -- Q3 2021 sales per territory
    (
        SELECT
            territory_id,
            SUM(sales) AS q3_sales
        FROM sales
        WHERE EXTRACT(QUARTER FROM order_date) = 3
          AND EXTRACT(YEAR FROM order_date) = 2021
        GROUP BY territory_id
        HAVING SUM(sales) > 0
    ) q3
    ON q4.territory_id = q3.territory_id;
