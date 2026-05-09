-- ======================================================================
-- Daily Interactions By Users Count
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 9779
-- URL        : https://platform.stratascratch.com/coding/9779-daily-interactions-by-users-count
-- ======================================================================

/*
Find the number of interactions along with the number of people involved with them on a given day. Be aware that user1 and user2 columns represent user ids. Output the date along with the number of interactions and people. Order results based on the date in ascending order and the number of people in descending order.
*/

-- Tables:
--   facebook_user_interactions(day bigint, user1 bigint, user2 bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_interactions AS (
    SELECT
        date,
        COUNT(*) AS num_interactions,
        -- Count distinct users appearing as either user1 or user2
        COUNT(DISTINCT user1) + COUNT(DISTINCT user2) -
            COUNT(DISTINCT CASE WHEN user1 IN (SELECT user2 FROM facebook_interactions fi2 WHERE fi2.date = fi.date) THEN user1 END) AS num_people
    FROM facebook_interactions fi
    GROUP BY date
),
daily_people AS (
    SELECT
        date,
        COUNT(*) AS num_interactions,
        COUNT(DISTINCT user_id) AS num_people
    FROM (
        SELECT date, user1 AS user_id FROM facebook_interactions
        UNION
        SELECT date, user2 AS user_id FROM facebook_interactions
    ) all_users
    GROUP BY date
)
SELECT
    dp.date,
    dp.num_interactions,
    dp.num_people
FROM daily_people dp
JOIN (
    SELECT date, COUNT(*) AS num_interactions
    FROM facebook_interactions
    GROUP BY date
) ic ON dp.date = ic.date
ORDER BY dp.date ASC, dp.num_people DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    i.date,
    COUNT(*) AS num_interactions,
    COUNT(DISTINCT u.user_id) AS num_people
FROM facebook_interactions i
JOIN (
    SELECT date, user1 AS user_id FROM facebook_interactions
    UNION
    SELECT date, user2 AS user_id FROM facebook_interactions
) u ON i.date = u.date
GROUP BY i.date
ORDER BY i.date ASC, num_people DESC;
