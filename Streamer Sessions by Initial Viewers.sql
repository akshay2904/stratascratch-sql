-- ======================================================================
-- Streamer Sessions by Initial Viewers
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Twitch
-- Access     : Premium
-- ID         : 2012
-- URL        : https://platform.stratascratch.com/coding/2012-viewers-turned-streamers
-- ======================================================================

/*
Return the number of streamer sessions for each user whose very first session was as a viewer.




Include the user ID and count of streamer sessions for users whose earliest session (by session_start) was a 'viewer' session, regardless of whether they ever had a streamer session later. Sort the results by streamer session count in descending order, then by user ID in ascending order.
*/

-- Tables:
--   twitch_sessions(session_end timestamp without time zone, session_id bigint, session_start timestamp without time zone, session_type text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH session_ranked AS (
    SELECT
        user_id,
        session_type,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY session_start) AS rn
    FROM sessions
),
first_session_viewers AS (
    SELECT user_id
    FROM session_ranked
    WHERE rn = 1 AND session_type = 'viewer'
),
streamer_counts AS (
    SELECT
        user_id,
        COUNT(*) FILTER (WHERE session_type = 'streamer') AS streamer_session_count
    FROM sessions
    GROUP BY user_id
)
SELECT
    f.user_id,
    COALESCE(s.streamer_session_count, 0) AS streamer_session_count
FROM first_session_viewers f
LEFT JOIN streamer_counts s ON f.user_id = s.user_id
ORDER BY streamer_session_count DESC, f.user_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.user_id,
    COUNT(s2.session_type) AS streamer_session_count
FROM (
    -- Get users whose earliest session was as a viewer
    SELECT user_id
    FROM sessions
    WHERE session_start = (
        SELECT MIN(session_start)
        FROM sessions s_inner
        WHERE s_inner.user_id = sessions.user_id
    )
    AND session_type = 'viewer'
) u
LEFT JOIN sessions s2
    ON u.user_id = s2.user_id
    AND s2.session_type = 'streamer'
GROUP BY u.user_id
ORDER BY streamer_session_count DESC, u.user_id ASC;
