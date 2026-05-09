-- ======================================================================
-- Finding User Purchases
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Free
-- ID         : 10322
-- URL        : https://platform.stratascratch.com/coding/10322-finding-user-purchases
-- ======================================================================

/*
Identify returning active users by finding users who made a second purchase within 1 to 7 days after their first purchase. Ignore same-day purchases. Output a list of these user_ids.
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
        created_at,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS purchase_rank
    FROM purchases
),
first_purchase AS (
    SELECT user_id, created_at AS first_date
    FROM ranked_purchases
    WHERE purchase_rank = 1
),
second_purchase AS (
    SELECT user_id, created_at AS second_date
    FROM ranked_purchases
    WHERE purchase_rank = 2
)
SELECT f.user_id
FROM first_purchase f
JOIN second_purchase s ON f.user_id = s.user_id
-- Strictly between 1 and 7 days after first purchase (exclude same-day)
WHERE (s.second_date::date - f.first_date::date) BETWEEN 1 AND 7;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT p1.user_id
FROM purchases p1
JOIN purchases p2
    ON p1.user_id = p2.user_id
   -- Ensure p2 is strictly after p1 (no same-day)
   AND p2.created_at::date > p1.created_at::date
   -- Within 7 days
   AND (p2.created_at::date - p1.created_at::date) <= 7
WHERE
    -- p1 must be the first purchase (no earlier purchase exists)
    NOT EXISTS (
        SELECT 1
        FROM purchases p0
        WHERE p0.user_id = p1.user_id
          AND p0.created_at::date < p1.created_at::date
    )
    -- p2 must be the earliest purchase after p1 (the true second purchase)
    AND NOT EXISTS (
        SELECT 1
        FROM purchases p_mid
        WHERE p_mid.user_id = p1.user_id
          AND p_mid.created_at::date > p1.created_at::date
          AND p_mid.created_at::date < p2.created_at::date
    );
