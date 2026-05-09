-- ======================================================================
-- Find The Most Profitable Location
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Uber, Noom
-- Access     : Premium
-- ID         : 2033
-- URL        : https://platform.stratascratch.com/coding/2033-find-the-most-profitable-location
-- ======================================================================

/*
Find the most profitable location. Write a query that calculates the average signup duration in days and the average transaction amount for each location. Then, calculate the ratio of average transaction amount to average duration.




Your output should include the location, average signup duration (in days), average transaction amount, and the ratio. Sort the results by ratio in descending order.
*/

-- Tables:
--   signups(location text, plan_id bigint, signup_id bigint, signup_start_date date, signup_stop_date date)
--   transactions(amt double precision, signup_id bigint, transaction_id bigint, transaction_start_date date)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH location_metrics AS (
    SELECT
        u.location,
        AVG(u.end_date - u.start_date)          AS avg_duration_days,
        AVG(t.amount)                            AS avg_transaction_amount
    FROM users u
    JOIN transactions t ON u.user_id = t.user_id
    GROUP BY u.location
)
SELECT
    location,
    avg_duration_days,
    avg_transaction_amount,
    avg_transaction_amount / NULLIF(avg_duration_days, 0) AS ratio
FROM location_metrics
ORDER BY ratio DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.location,
    AVG(u.end_date - u.start_date)                                        AS avg_duration_days,
    AVG(t.amount)                                                          AS avg_transaction_amount,
    AVG(t.amount) / NULLIF(AVG(u.end_date - u.start_date), 0)            AS ratio
FROM users u
JOIN transactions t ON u.user_id = t.user_id
GROUP BY u.location
ORDER BY ratio DESC;
