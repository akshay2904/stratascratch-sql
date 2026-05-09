-- ======================================================================
-- Make the friends network symmetric
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Free
-- ID         : 9813
-- URL        : https://platform.stratascratch.com/coding/9813-make-the-friends-network-symmetric
-- ======================================================================

/*
Make the friends network symmetric.

For example, if 0 and 1 are friends, have the output contain both 0 and 1 under 1 and 0 respectively.
*/

-- Tables:
--   google_friends_network(friend_id bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH symmetric AS (
    SELECT user1, user2 FROM friends
    UNION
    SELECT user2, user1 FROM friends
)
SELECT user1, user2
FROM symmetric
ORDER BY user1, user2;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT user1, user2 FROM friends
UNION
SELECT user2 AS user1, user1 AS user2 FROM friends
ORDER BY user1, user2;
