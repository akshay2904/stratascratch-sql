-- ======================================================================
-- Find the average number of friends a user has
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Premium
-- ID         : 9822
-- URL        : https://platform.stratascratch.com/coding/9822-find-the-average-number-of-friends-a-user-has
-- ======================================================================

/*
Find the average number of friends a user has.
*/

-- Tables:
--   google_friends_network(friend_id bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes a "friendships" table where each friendship is stored once (undirected)
-- or a "friends" table with columns: user_id, friend_id

WITH friend_counts AS (
    SELECT
        user_id,
        COUNT(friend_id) AS num_friends
    FROM friends
    GROUP BY user_id
)
SELECT
    ROUND(AVG(num_friends), 2) AS avg_friends_per_user
FROM friend_counts;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Count friends per user first, then average those counts
SELECT
    ROUND(
        (SELECT SUM(friend_count)
         FROM (
             SELECT COUNT(friend_id) AS friend_count
             FROM friends
             GROUP BY user_id
         ) AS per_user_counts)
        /
        NULLIF(
            (SELECT COUNT(DISTINCT user_id) FROM friends),
            0
        )::NUMERIC,
        2
    ) AS avg_friends_per_user;
