-- ======================================================================
-- Revenue Over Time
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 10314
-- URL        : https://platform.stratascratch.com/coding/10314-revenue-over-time
-- ======================================================================

/*
Find the 3-month rolling average of total revenue from purchases given a table with users, their purchase amount, and date purchased. Do not include returns which are represented by negative purchase values. Output the year-month (YYYY-MM) and 3-month rolling average of revenue, sorted from earliest month to latest month.




A 3-month rolling average is defined by calculating the average total revenue from all user purchases for the current month and previous two months. The first two months will not be a true 3-month rolling average since we are not given data from last year. Assume each month has at least one purchase.
*/

-- Tables:
--   amazon_purchases(created_at date, purchase_amt bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        TO_CHAR(date_purchased, 'YYYY-MM') AS year_month,
        DATE_TRUNC('month', date_purchased) AS month_start,
        SUM(purchase_amt) AS total_revenue
    FROM purchases
    WHERE purchase_amt > 0  -- exclude returns (negative values)
    GROUP BY 1, 2
)
SELECT
    year_month,
    ROUND(
        AVG(total_revenue) OVER (
            ORDER BY month_start
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS rolling_3mo_avg_revenue
FROM monthly_revenue
ORDER BY month_start;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        TO_CHAR(date_purchased, 'YYYY-MM') AS year_month,
        DATE_TRUNC('month', date_purchased) AS month_start,
        SUM(purchase_amt) AS total_revenue
    FROM purchases
    WHERE purchase_amt > 0  -- exclude returns (negative values)
    GROUP BY 1, 2
)
SELECT
    m1.year_month,
    -- average revenue across current month and up to 2 prior months
    ROUND(
        (
            SELECT AVG(m2.total_revenue)
            FROM monthly_revenue m2
            WHERE m2.month_start >= (m1.month_start - INTERVAL '2 months')
              AND m2.month_start <= m1.month_start
        ), 2
    ) AS rolling_3mo_avg_revenue
FROM monthly_revenue m1
ORDER BY m1.month_start;
