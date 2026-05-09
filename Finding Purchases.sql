-- ======================================================================
-- Finding Purchases
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Free
-- ID         : 10553
-- URL        : https://platform.stratascratch.com/coding/10553-finding-purchases
-- ======================================================================

/*
Identify returning active users by finding users who made a repeat purchase within 7 days or less of their previous transaction, excluding same-day purchases. Output a list of these user_id.
*/

-- Tables:
--   amazon_transactions(created_at date, id bigint, item text, revenue bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_purchases AS (
    SELECT
        user_id,
        created_at::date AS purchase_date,
        LAG(created_at::date) OVER (PARTITION BY user_id ORDER BY created_at) AS prev_purchase_date
    FROM purchases
)
SELECT DISTINCT user_id
FROM ranked_purchases
WHERE purchase_date > prev_purchase_date  -- excludes same-day purchases
  AND purchase_date - prev_purchase_date <= 7;  -- within 7 days

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT p1.user_id
FROM purchases p1
JOIN purchases p2
    ON p1.user_id = p2.user_id
    -- p2 is a later transaction than p1, but not the same day
    AND p2.created_at::date > p1.created_at::date
    -- repeat purchase within 7 days of previous transaction
    AND p2.created_at::date - p1.created_at::date <= 7;
