-- ======================================================================
-- Find all users that have more than 3 friends
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 9810
-- URL        : https://platform.stratascratch.com/coding/9810-find-all-uses-that-have-more-than-3-friends
-- ======================================================================

/*
Find all users that have more than 3 friends.
*/

-- Tables:
--   google_friends_network(friend_id bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH friend_counts AS (
    SELECT
        user_id,
        COUNT(*) AS friend_count
    FROM friends
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.username,
    fc.friend_count
FROM users u
JOIN friend_counts fc ON u.user_id = fc.user_id
WHERE fc.friend_count > 3
ORDER BY fc.friend_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.user_id,
    u.username,
    COUNT(f.friend_id) AS friend_count
FROM users u
JOIN friends f ON u.user_id = f.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(f.friend_id) > 3
ORDER BY friend_count DESC;
