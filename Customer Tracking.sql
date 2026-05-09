-- ======================================================================
-- Customer Tracking
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Shopify, Amazon
-- Access     : Premium
-- ID         : 2136
-- URL        : https://platform.stratascratch.com/coding/2136-customer-tracking
-- ======================================================================

/*
Given users' session logs, calculate how many hours each user was active in total across all recorded sessions.




Note: The session starts when state=1 and ends when state=0.
*/

-- Tables:
--   cust_tracking(cust_id text, state bigint, timestamp timestamp without time zone)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ordered_logs AS (
    SELECT
        user_id,
        state,
        timestamp,
        LEAD(timestamp) OVER (PARTITION BY user_id ORDER BY timestamp) AS next_timestamp
    FROM session_logs
)
SELECT
    user_id,
    -- Sum durations where state=1 (session start) paired with next event (state=0, session end)
    ROUND(
        SUM(EXTRACT(EPOCH FROM (next_timestamp - timestamp)) / 3600.0), 2
    ) AS total_active_hours
FROM ordered_logs
WHERE state = 1
  AND next_timestamp IS NOT NULL
GROUP BY user_id
ORDER BY user_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    s.user_id,
    ROUND(
        SUM(
            EXTRACT(EPOCH FROM (
                -- For each session start, find the immediately following session end
                (SELECT e.timestamp
                 FROM session_logs e
                 WHERE e.user_id = s.user_id
                   AND e.state = 0
                   AND e.timestamp > s.timestamp
                 ORDER BY e.timestamp ASC
                 LIMIT 1)
                - s.timestamp
            )) / 3600.0
        ), 2
    ) AS total_active_hours
FROM session_logs s
WHERE s.state = 1
GROUP BY s.user_id
ORDER BY s.user_id;
