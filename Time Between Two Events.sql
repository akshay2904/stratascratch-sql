-- ======================================================================
-- Time Between Two Events
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 9784
-- URL        : https://platform.stratascratch.com/coding/9784-time-between-two-events
-- ======================================================================

/*
Meta/Facebook's web logs capture every action from users starting from page loading to page scrolling. Find the user with the least amount of time between a page load and their scroll down. Your output should include the user id, page load time, scroll down time, and time between the two events in seconds.
*/

-- Tables:
--   facebook_web_log(action text, timestamp timestamp without time zone, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH page_loads AS (
    SELECT
        user_id,
        timestamp AS load_time,
        -- Get the next scroll_down timestamp for this user after this page load
        LEAD(timestamp) OVER (PARTITION BY user_id ORDER BY timestamp) AS scroll_time,
        action
    FROM facebook_web_log
),
load_scroll_pairs AS (
    SELECT
        user_id,
        load_time,
        scroll_time,
        EXTRACT(EPOCH FROM (scroll_time - load_time)) AS time_diff_seconds
    FROM page_loads
    WHERE action = 'page_load'
      AND scroll_time IS NOT NULL
)
SELECT
    user_id,
    load_time AS page_load_time,
    scroll_time AS scroll_down_time,
    time_diff_seconds
FROM load_scroll_pairs
ORDER BY time_diff_seconds ASC
LIMIT 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    pl.user_id,
    pl.timestamp AS page_load_time,
    sd.timestamp AS scroll_down_time,
    EXTRACT(EPOCH FROM (sd.timestamp - pl.timestamp)) AS time_diff_seconds
FROM facebook_web_log pl
JOIN facebook_web_log sd
    ON pl.user_id = sd.user_id
   AND sd.action = 'scroll_down'
   AND sd.timestamp > pl.timestamp
WHERE pl.action = 'page_load'
  -- Ensure no other scroll_down exists closer in time for this pair
  AND NOT EXISTS (
      SELECT 1
      FROM facebook_web_log sd2
      WHERE sd2.user_id = pl.user_id
        AND sd2.action = 'scroll_down'
        AND sd2.timestamp > pl.timestamp
        AND sd2.timestamp < sd.timestamp
  )
ORDER BY time_diff_seconds ASC
LIMIT 1;
