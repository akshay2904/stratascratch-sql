-- ======================================================================
-- Spotify Penetration Analysis
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Spotify
-- Access     : Premium
-- ID         : 10369
-- URL        : https://platform.stratascratch.com/coding/10369-spotify-penetration-analysis
-- ======================================================================

/*
Market penetration is an important metric for understanding Spotify's performance and growth potential in different regions.

You are part of the analytics team at Spotify and are tasked with calculating the active user penetration rate in specific countries.




For this task, 'active_users' are defined based on the  following criterias:




last_active_date: The user must have interacted with Spotify within the last 30 days.

•    sessions: The user must have engaged with Spotify for at least 5 sessions.

•    listening_hours: The user must have spent at least 10 hours listening on Spotify.




Based on the condition above, calculate the active 'user_penetration_rate' by using the following formula.




•    Active User Penetration Rate = (Number of Active Spotify Users in the Country / Total users in the Country)




Total Population of the country is based on both active and non-active users.

​

The output should contain 'country' and 'active_user_penetration_rate' rounded to 2 decimals.




Let's assume the current_day is 2024-01-31.
*/

-- Tables:
--   penetration_analysis(country text, last_active_date date, listening_hours bigint, sessions bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH user_activity AS (
    SELECT
        country,
        -- Flag active users in a single pass
        COUNT(*) AS total_users,
        COUNT(*) FILTER (
            WHERE last_active_date >= DATE '2024-01-31' - INTERVAL '30 days'
              AND sessions >= 5
              AND listening_hours >= 10
        ) AS active_users
    FROM spotify_users
    GROUP BY country
)
SELECT
    country,
    ROUND(active_users::NUMERIC / total_users, 2) AS active_user_penetration_rate
FROM user_activity
ORDER BY country;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    t.country,
    ROUND(
        CAST(a.active_user_count AS NUMERIC) / CAST(t.total_user_count AS NUMERIC),
        2
    ) AS active_user_penetration_rate
FROM
    -- Total users per country
    (
        SELECT country, COUNT(*) AS total_user_count
        FROM spotify_users
        GROUP BY country
    ) t
JOIN
    -- Active users per country
    (
        SELECT country, COUNT(*) AS active_user_count
        FROM spotify_users
        WHERE last_active_date >= DATE '2024-01-31' - INTERVAL '30 days'
          AND sessions >= 5
          AND listening_hours >= 10
        GROUP BY country
    ) a
    ON t.country = a.country
ORDER BY t.country;
