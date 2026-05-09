-- ======================================================================
-- Find The Best Day For Trading AAPL Stock
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Forbes
-- Access     : Premium
-- ID         : 9601
-- URL        : https://platform.stratascratch.com/coding/9601-find-the-best-day-for-trading-aapl-stock
-- ======================================================================

/*
Find which calendar day of the month (e.g. the 6th, 17th, 25th, etc.) tends to be the best for trading AAPL stock across all months in the dataset. The best day is the one with highest positive difference between average closing price and average opening price. Output the result along with the average opening and closing prices.
*/

-- Tables:
--   aapl_historical_stock_price(close double precision, date date, high double precision, id bigint, low double precision, month bigint, open double precision, volume bigint, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_diff AS (
    SELECT
        EXTRACT(DAY FROM date)::INT AS day_of_month,
        AVG(open)  AS avg_open,
        AVG(close) AS avg_close,
        AVG(close - open) AS avg_diff
    FROM aapl_historical_stock_price
    GROUP BY EXTRACT(DAY FROM date)::INT
),
ranked AS (
    SELECT
        day_of_month,
        avg_open,
        avg_close,
        avg_diff,
        RANK() OVER (ORDER BY avg_diff DESC) AS rnk
    FROM daily_diff
)
SELECT
    day_of_month,
    ROUND(avg_open::NUMERIC,  2) AS avg_opening_price,
    ROUND(avg_close::NUMERIC, 2) AS avg_closing_price,
    ROUND(avg_diff::NUMERIC,  2) AS avg_close_minus_open
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(DAY FROM date)::INT          AS day_of_month,
    ROUND(AVG(open)::NUMERIC,  2)        AS avg_opening_price,
    ROUND(AVG(close)::NUMERIC, 2)        AS avg_closing_price,
    ROUND(AVG(close - open)::NUMERIC, 2) AS avg_close_minus_open
FROM aapl_historical_stock_price
GROUP BY EXTRACT(DAY FROM date)::INT
HAVING AVG(close - open) = (
    -- find the maximum average difference across all days of month
    SELECT MAX(avg_diff)
    FROM (
        SELECT AVG(close - open) AS avg_diff
        FROM aapl_historical_stock_price
        GROUP BY EXTRACT(DAY FROM date)::INT
    ) sub
);
