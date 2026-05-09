-- ======================================================================
-- Popularity Percentage
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10284
-- URL        : https://platform.stratascratch.com/coding/10284-popularity-percentage
-- ======================================================================

/*
Find the popularity percentage for each user on Meta/Facebook. The dataset contains two columns, user1 and user2, which represent pairs of friends. Each row indicates a mutual friendship between user1 and user2, meaning both users are friends with each other. A user's popularity percentage is calculated as the total number of friends they have (counting connections from both user1 and user2 columns) divided by the total number of unique users on the platform. Multiply this value by 100 to express it as a percentage.




Output each user along with their calculated popularity percentage. The results should be ordered by user ID in ascending order.
*/

-- Tables:
--   facebook_friends(user1 bigint, user2 bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH all_users AS (
    -- Collect every unique user from both columns
    SELECT user1 AS user_id FROM friends
    UNION
    SELECT user2 AS user_id FROM friends
),
all_connections AS (
    -- Flatten bidirectional friendships into one column
    SELECT user1 AS user_id FROM friends
    UNION ALL
    SELECT user2 AS user_id FROM friends
),
friend_counts AS (
    SELECT user_id, COUNT(*) AS friend_count
    FROM all_connections
    GROUP BY user_id
),
total_users AS (
    SELECT COUNT(*) AS total FROM all_users
)
SELECT
    fc.user_id,
    ROUND((fc.friend_count * 100.0 / t.total), 2) AS popularity_percentage
FROM friend_counts fc
CROSS JOIN total_users t
ORDER BY fc.user_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.user_id,
    ROUND(
        COUNT(f.user_id) * 100.0 /
        (SELECT COUNT(DISTINCT uid)
         FROM (
             SELECT user1 AS uid FROM friends
             UNION
             SELECT user2 AS uid FROM friends
         ) all_unique_users),
        2
    ) AS popularity_percentage
FROM (
    -- All unique users
    SELECT user1 AS user_id FROM friends
    UNION
    SELECT user2 AS user_id FROM friends
) u
-- Join all connections to count friends per user
LEFT JOIN (
    SELECT user1 AS user_id FROM friends
    UNION ALL
    SELECT user2 AS user_id FROM friends
) f ON u.user_id = f.user_id
GROUP BY u.user_id
ORDER BY u.user_id ASC;
