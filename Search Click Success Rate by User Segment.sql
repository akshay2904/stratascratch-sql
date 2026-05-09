-- ======================================================================
-- Search Click Success Rate by User Segment
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Microsoft
-- Access     : Premium
-- ID         : 10566
-- URL        : https://platform.stratascratch.com/coding/10566-search-click-success-rate-by-user-segment
-- ======================================================================

/*
Calculate the search success rate for new users versus existing users. A successful search is one where the first click event occurs within 30 seconds of the search event.




Group all users into two segments:

•  new (registered within the last 30 days covered by the dataset — that is, on or after 30 days before the most recent date in the dataset)

•  existing (registered earlier).




Return one row per user segment with total searches, successful searches, and success rate.
*/

-- Tables:
--   search_events(event_id bigint, event_timestamp timestamp without time zone, event_type text, query text, session_id text, user_id bigint)
--   accounts(country text, registration_date date, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH max_date AS (
    -- Find the most recent date in the dataset
    SELECT MAX(event_time::date) AS max_dt FROM events
),
user_segments AS (
    -- Classify users as new or existing based on registration date
    SELECT
        u.user_id,
        CASE
            WHEN u.registration_date >= (max_date.max_dt - INTERVAL '29 days')
            THEN 'new'
            ELSE 'existing'
        END AS user_segment
    FROM users u
    CROSS JOIN max_date
),
search_events AS (
    -- Get all search events with their timestamps
    SELECT
        e.event_id,
        e.user_id,
        e.event_time AS search_time,
        e.session_id
    FROM events e
    WHERE e.event_type = 'search'
),
first_click_after_search AS (
    -- For each search, find the earliest click event in the same session
    -- that occurs after the search, using a window function approach
    SELECT
        s.event_id   AS search_event_id,
        s.user_id,
        s.search_time,
        MIN(c.event_time) AS first_click_time
    FROM search_events s
    LEFT JOIN events c
        ON  c.user_id    = s.user_id
        AND c.session_id = s.session_id
        AND c.event_type = 'click'
        AND c.event_time  > s.search_time
        AND c.event_time <= s.search_time + INTERVAL '30 seconds'
    GROUP BY s.event_id, s.user_id, s.search_time
),
search_results AS (
    -- Tag each search as successful (1) or not (0)
    SELECT
        f.user_id,
        CASE WHEN f.first_click_time IS NOT NULL THEN 1 ELSE 0 END AS is_success
    FROM first_click_after_search f
)
SELECT
    us.user_segment,
    COUNT(*)                                          AS total_searches,
    SUM(sr.is_success)                                AS successful_searches,
    ROUND(
        SUM(sr.is_success)::numeric / COUNT(*) * 100, 2
    )                                                 AS success_rate_pct
FROM search_results sr
JOIN user_segments us ON us.user_id = sr.user_id
GROUP BY us.user_segment
ORDER BY us.user_segment;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    user_segment,
    COUNT(*)                                              AS total_searches,
    SUM(is_success)                                       AS successful_searches,
    ROUND(SUM(is_success)::numeric / COUNT(*) * 100, 2)  AS success_rate_pct
FROM (
    -- Tag each search event as successful or not
    SELECT
        s.event_id,
        s.user_id,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM events c
                WHERE c.user_id    = s.user_id
                  AND c.session_id = s.session_id
                  AND c.event_type = 'click'
                  AND c.event_time  > s.event_time
                  AND c.event_time <= s.event_time + INTERVAL '30 seconds'
            ) THEN 1
            ELSE 0
        END AS is_success,
        -- Classify user segment inline
        CASE
            WHEN u.registration_date >= (
                SELECT MAX(event_time::date) - INTERVAL '29 days'
                FROM events
            )
            THEN 'new'
            ELSE 'existing'
        END AS user_segment
    FROM events s
    JOIN users u ON u.user_id = s.user_id
    WHERE s.event_type = 'search'
) tagged_searches
GROUP BY user_segment
ORDER BY user_segment;
