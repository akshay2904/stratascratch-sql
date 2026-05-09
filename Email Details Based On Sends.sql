-- ======================================================================
-- Email Details Based On Sends
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 10086
-- URL        : https://platform.stratascratch.com/coding/10086-email-details-based-on-sends
-- ======================================================================

/*
Find all records from days when the number of distinct users receiving emails was greater than the number of distinct users sending emails
*/

-- Tables:
--   google_gmail_emails(day bigint, from_user text, id bigint, to_user text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_stats AS (
    SELECT
        DATE(time) AS day,
        COUNT(DISTINCT to_user)   AS distinct_receivers,
        COUNT(DISTINCT from_user) AS distinct_senders
    FROM emails
    GROUP BY DATE(time)
),
qualifying_days AS (
    SELECT day
    FROM daily_stats
    WHERE distinct_receivers > distinct_senders
)
SELECT e.*
FROM emails e
JOIN qualifying_days q
    ON DATE(e.time) = q.day;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT *
FROM emails
WHERE DATE(time) IN (
    SELECT DATE(time)
    FROM emails
    GROUP BY DATE(time)
    HAVING COUNT(DISTINCT to_user) > COUNT(DISTINCT from_user)
);
