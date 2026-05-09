-- ======================================================================
-- Consecutive Days
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Netflix, Salesforce
-- Access     : Free
-- ID         : 2054
-- URL        : https://platform.stratascratch.com/coding/2054-consecutive-days
-- ======================================================================

/*
Find all the users who were active for 3 consecutive days or more.
*/

-- Tables:
--   sf_events(account_id character varying, record_date date, user_id character varying)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes a table: user_activity(user_id, activity_date)
-- with one row per user per active day (dates are distinct per user)

WITH deduped AS (
    -- Remove duplicate dates per user
    SELECT DISTINCT user_id, activity_date
    FROM user_activity
),
grouped AS (
    -- Subtract a sequential row number from the date to get a "group key"
    -- Consecutive dates will share the same (user_id, grp) value
    SELECT
        user_id,
        activity_date,
        activity_date - ROW_NUMBER() OVER (
            PARTITION BY user_id ORDER BY activity_date
        )::integer * INTERVAL '1 day' AS grp
    FROM deduped
),
streaks AS (
    SELECT
        user_id,
        COUNT(*) AS consecutive_days
    FROM grouped
    GROUP BY user_id, grp
)
SELECT DISTINCT user_id
FROM streaks
WHERE consecutive_days >= 3
ORDER BY user_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- For each activity date, check if the next 2 days also exist for the same user
SELECT DISTINCT a1.user_id
FROM user_activity a1
WHERE EXISTS (
    SELECT 1
    FROM user_activity a2
    WHERE a2.user_id    = a1.user_id
      AND a2.activity_date = a1.activity_date + INTERVAL '1 day'
)
AND EXISTS (
    SELECT 1
    FROM user_activity a3
    WHERE a3.user_id    = a1.user_id
      AND a3.activity_date = a1.activity_date + INTERVAL '2 days'
)
ORDER BY user_id;
