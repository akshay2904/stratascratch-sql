-- ======================================================================
-- First Day Retention Rate
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 2090
-- URL        : https://platform.stratascratch.com/coding/2090-first-day-retention-rate
-- ======================================================================

/*
Calculate the first-day retention rate of a group of video game players. The first-day retention occurs when a player logs in 1 day after their first-ever log-in.

Return the proportion of players who meet this definition divided by the total number of players.
*/

-- Tables:
--   players_logins(login_date date, player_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes table: activity(player_id, event_date, ...)
-- First-day retention = players who logged in the day after their first login / total players

WITH first_login AS (
    SELECT
        player_id,
        MIN(event_date) AS first_date
    FROM activity
    GROUP BY player_id
),
retained AS (
    SELECT
        f.player_id,
        -- Check if any login exists exactly 1 day after first login
        MAX(CASE WHEN a.event_date = f.first_date + INTERVAL '1 day' THEN 1 ELSE 0 END) AS came_back
    FROM first_login f
    LEFT JOIN activity a
        ON f.player_id = a.player_id
    GROUP BY f.player_id
)
SELECT
    ROUND(
        SUM(came_back)::NUMERIC / COUNT(*),
        2
    ) AS first_day_retention_rate
FROM retained;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        -- Count players who returned the day after their first login
        (SELECT COUNT(DISTINCT a.player_id)
         FROM activity a
         WHERE a.event_date = (
             SELECT MIN(a2.event_date) + INTERVAL '1 day'
             FROM activity a2
             WHERE a2.player_id = a.player_id
         ))::NUMERIC
        /
        -- Total number of distinct players
        (SELECT COUNT(DISTINCT player_id) FROM activity),
        2
    ) AS first_day_retention_rate;
