-- ======================================================================
-- Monthly Percentage Difference
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Amazon
-- Access     : Free
-- ID         : 10319
-- URL        : https://platform.stratascratch.com/coding/10319-monthly-percentage-difference
-- ======================================================================

/*
Given a table of purchases by date, calculate the month-over-month percentage change in revenue. The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year.

The percentage change column will be populated from the 2nd month forward and can be calculated as ((this month's revenue - last month's revenue) / last month's revenue)*100.
*/

-- Tables:
--   sf_transactions(created_at date, id bigint, purchase_id bigint, value bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        TO_CHAR(created_at, 'YYYY-MM') AS year_month,
        SUM(value) AS revenue
    FROM purchases
    GROUP BY TO_CHAR(created_at, 'YYYY-MM')
)
SELECT
    year_month,
    ROUND(
        ((revenue - LAG(revenue) OVER (ORDER BY year_month))
        / LAG(revenue) OVER (ORDER BY year_month)) * 100,
    2) AS revenue_change
FROM monthly_revenue
ORDER BY year_month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        TO_CHAR(created_at, 'YYYY-MM') AS year_month,
        SUM(value) AS revenue
    FROM purchases
    GROUP BY TO_CHAR(created_at, 'YYYY-MM')
)
SELECT
    curr.year_month,
    ROUND(
        ((curr.revenue - prev.revenue) / prev.revenue) * 100,
    2) AS revenue_change
FROM monthly_revenue curr
-- self-join to get the previous month by converting year_month back to a date
LEFT JOIN monthly_revenue prev
    ON TO_CHAR(
        TO_DATE(curr.year_month, 'YYYY-MM') - INTERVAL '1 month',
        'YYYY-MM'
       ) = prev.year_month
ORDER BY curr.year_month;
