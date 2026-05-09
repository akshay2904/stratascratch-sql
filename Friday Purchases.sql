-- ======================================================================
-- Friday Purchases
-- ======================================================================
-- Difficulty : Hard
-- Companies  : IBM
-- Access     : Premium
-- ID         : 10358
-- URL        : https://platform.stratascratch.com/coding/10358-friday-purchases
-- ======================================================================

/*
IBM is working on a new feature to analyze user purchasing behavior for all Fridays in the first quarter of the year. In this question first quarter is defined as first 13 weeks. For each Friday separately, calculate the average amount users have spent per order. The output should contain the week number of that Friday and average amount spent.
*/

-- Tables:
--   user_purchases(amount_spent double precision, date date, day_name text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH friday_orders AS (
    SELECT
        -- Calculate week number (1-13) within the year for Fridays in Q1
        EXTRACT(WEEK FROM date)::INT AS week_number,
        amount
    FROM user_purchases
    WHERE EXTRACT(DOW FROM date) = 5  -- 5 = Friday in PostgreSQL (0=Sunday)
      AND EXTRACT(WEEK FROM date) <= 13
)
SELECT
    week_number,
    AVG(amount) AS average_amount
FROM friday_orders
GROUP BY week_number
ORDER BY week_number;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(WEEK FROM date)::INT AS week_number,
    AVG(amount) AS average_amount
FROM user_purchases
WHERE
    -- Filter only Fridays
    TO_CHAR(date, 'Day') LIKE 'Friday%'
    -- Filter only first 13 weeks (first quarter by week definition)
    AND EXTRACT(WEEK FROM date) <= 13
GROUP BY EXTRACT(WEEK FROM date)::INT
ORDER BY week_number;
