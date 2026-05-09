-- ======================================================================
-- Sales Percentage Week's Beginning and End
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2165
-- URL        : https://platform.stratascratch.com/coding/2165-sales-percentage-weeks-beginning-and-end
-- ======================================================================

/*
The sales department has given you the sales figures for the first two months of 2023.




You've been tasked with determining the percentage of weekly sales on the first and last day of every week. Consider Sunday as last day of week and Monday as first day of week.




In your output, include the week number, percentage sales for the first day of the week, and percentage sales for the last day of the week. Both proportions should be rounded to the nearest whole number.
*/

-- Tables:
--   early_sales(invoicedate date, invoiceno bigint, quantity bigint, stockcode character varying, unitprice double precision)


-- Write your SQL solution below:

Looking at this problem, I need to:
1. Calculate total sales per week
2. Find sales on Monday (first day) and Sunday (last day) of each week
3. Calculate percentages of weekly sales for those days

I'll assume a table structure like: `sales(sale_date DATE, amount NUMERIC)` or similar with daily sales data.

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH weekly_sales AS (
    SELECT
        EXTRACT(WEEK FROM sale_date)::INT AS week_number,
        EXTRACT(DOW FROM sale_date) AS day_of_week, -- 0=Sunday, 1=Monday
        SUM(amount) AS daily_sales,
        SUM(SUM(amount)) OVER (PARTITION BY EXTRACT(WEEK FROM sale_date)) AS total_weekly_sales
    FROM sales
    GROUP BY EXTRACT(WEEK FROM sale_date), EXTRACT(DOW FROM sale_date)
)
SELECT
    week_number,
    ROUND(100.0 * SUM(CASE WHEN day_of_week = 1 THEN daily_sales ELSE 0 END) / total_weekly_sales) AS first_day_percentage,
    ROUND(100.0 * SUM(CASE WHEN day_of_week = 0 THEN daily_sales ELSE 0 END) / total_weekly_sales) AS last_day_percentage
FROM weekly_sales
GROUP BY week_number, total_weekly_sales
ORDER BY week_number;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    w.week_number,
    ROUND(100.0 * COALESCE(mon.monday_sales, 0) / w.total_weekly_sales) AS first_day_percentage,
    ROUND(100.0 * COALESCE(sun.sunday_sales, 0) / w.total_weekly_sales) AS last_day_percentage
FROM (
    -- Total sales per week
    SELECT
        EXTRACT(WEEK FROM sale_date)::INT AS week_number,
        SUM(amount) AS total_weekly_sales
    FROM sales
    GROUP BY EXTRACT(WEEK FROM sale_date)
) w
LEFT JOIN (
    -- Sales on Mondays (first day of week)
    SELECT
        EXTRACT(WEEK FROM sale_date)::INT AS week_number,
        SUM(amount) AS monday_sales
    FROM sales
    WHERE EXTRACT(DOW FROM sale_date) = 1
    GROUP BY EXTRACT(WEEK FROM sale_date)
) mon ON w.week_number = mon.week_number
LEFT JOIN (
    -- Sales on Sundays (last day of week)
    SELECT
        EXTRACT(WEEK FROM sale_date)::INT AS week_number,
        SUM(amount) AS sunday_sales
    FROM sales
    WHERE EXTRACT(DOW FROM sale_date) = 0
    GROUP BY EXTRACT(WEEK FROM sale_date)
) sun ON w.week_number = sun.week_number
ORDER BY w.week_number;
