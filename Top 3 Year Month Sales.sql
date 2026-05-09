-- ======================================================================
-- Top 3 Year Month Sales
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Deloitte
-- Access     : Premium
-- ID         : 2162
-- URL        : https://platform.stratascratch.com/coding/2162-top-3-year-month-sales
-- ======================================================================

/*
The sales team wants to find out which months had the highest sales. Based on the sales data provided, you must determine the top three year-month combinations for sales.




Your output should include the top three monthly sales in the format YYYY-MM as well as the corresponding total monthly sales.
*/

-- Tables:
--   fct_customer_sales(cust_id text, order_date date, order_id text, order_value bigint, prod_sku_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_sales AS (
    SELECT
        TO_CHAR(sale_date, 'YYYY-MM') AS year_month,
        SUM(sale_amount) AS total_sales,
        RANK() OVER (ORDER BY SUM(sale_amount) DESC) AS sales_rank
    FROM sales
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT
    year_month,
    total_sales
FROM monthly_sales
WHERE sales_rank <= 3
ORDER BY total_sales DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS year_month,
    SUM(sale_amount) AS total_sales
FROM sales
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY total_sales DESC
LIMIT 3;
