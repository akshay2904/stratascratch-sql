-- ======================================================================
-- Most Popular Client For  Calls
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Apple, Microsoft
-- Access     : Premium
-- ID         : 2029
-- URL        : https://platform.stratascratch.com/coding/2029-the-most-popular-client_id-among-users-using-video-and-voice-calls
-- ======================================================================

/*
Select the most popular client_id based on the number of users who individually have at least 50% of their events from the following list: 'video call received', 'video call sent', 'voice call received', 'voice call sent'.
*/

-- Tables:
--   fact_events(client_id text, customer_id text, event_id bigint, event_type text, id bigint, time_id date, user_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH user_event_stats AS (
    SELECT
        client_id,
        user_id,
        -- Count events that are call-related
        COUNT(*) FILTER (WHERE event_type IN (
            'video call received', 'video call sent',
            'voice call received', 'voice call sent'
        )) AS call_events,
        COUNT(*) AS total_events
    FROM events
    GROUP BY client_id, user_id
),
qualifying_users AS (
    SELECT
        client_id,
        COUNT(*) AS qualifying_user_count
    FROM user_event_stats
    WHERE call_events * 1.0 / total_events >= 0.5  -- at least 50% are call events
    GROUP BY client_id
),
ranked AS (
    SELECT
        client_id,
        qualifying_user_count,
        RANK() OVER (ORDER BY qualifying_user_count DESC) AS rnk
    FROM qualifying_users
)
SELECT client_id
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT client_id
FROM (
    SELECT
        client_id,
        COUNT(*) AS qualifying_user_count
    FROM (
        -- Identify users where call events make up >= 50% of their total events
        SELECT
            client_id,
            user_id,
            SUM(CASE WHEN event_type IN (
                    'video call received', 'video call sent',
                    'voice call received', 'voice call sent'
                ) THEN 1 ELSE 0 END) AS call_events,
            COUNT(*) AS total_events
        FROM events
        GROUP BY client_id, user_id
        HAVING
            SUM(CASE WHEN event_type IN (
                    'video call received', 'video call sent',
                    'voice call received', 'voice call sent'
                ) THEN 1 ELSE 0 END) * 1.0 / COUNT(*) >= 0.5
    ) AS qualified_users
    GROUP BY client_id
) AS client_counts
WHERE qualifying_user_count = (
    -- Find the maximum qualifying user count across all clients
    SELECT MAX(qualifying_user_count)
    FROM (
        SELECT
            client_id,
            COUNT(*) AS qualifying_user_count
        FROM (
            SELECT
                client_id,
                user_id
            FROM events
            GROUP BY client_id, user_id
            HAVING
                SUM(CASE WHEN event_type IN (
                        'video call received', 'video call sent',
                        'voice call received', 'voice call sent'
                    ) THEN 1 ELSE 0 END) * 1.0 / COUNT(*) >= 0.5
        ) AS q
        GROUP BY client_id
    ) AS counts
);
