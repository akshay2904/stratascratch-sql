-- ======================================================================
-- Common Friends Script
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 10365
-- URL        : https://platform.stratascratch.com/coding/10365-common-friends-script
-- ======================================================================

/*
You are analyzing a social network dataset at Google. Your task is to find mutual friends between two users, Karl and Hans. There is only one user named Karl and one named Hans in the dataset.




The output should contain 'user_id' and 'user_name' columns.
*/

-- Tables:
--   users(user_id bigint, user_name text)
--   friends(friend_id bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH karl_id AS (
    SELECT user_id FROM users WHERE user_name = 'Karl'
),
hans_id AS (
    SELECT user_id FROM users WHERE user_name = 'Hans'
),
-- Get all friends of Karl
karl_friends AS (
    SELECT 
        CASE WHEN user1_id = (SELECT user_id FROM karl_id) THEN user2_id
             ELSE user1_id END AS friend_id
    FROM friendship
    WHERE user1_id = (SELECT user_id FROM karl_id)
       OR user2_id = (SELECT user_id FROM karl_id)
),
-- Get all friends of Hans
hans_friends AS (
    SELECT 
        CASE WHEN user1_id = (SELECT user_id FROM hans_id) THEN user2_id
             ELSE user1_id END AS friend_id
    FROM friendship
    WHERE user1_id = (SELECT user_id FROM hans_id)
       OR user2_id = (SELECT user_id FROM hans_id)
)
-- Intersect to find mutual friends, then join for names
SELECT u.user_id, u.user_name
FROM users u
JOIN karl_friends kf ON u.user_id = kf.friend_id
JOIN hans_friends hf ON u.user_id = hf.friend_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT u.user_id, u.user_name
FROM users u
WHERE u.user_id IN (
    -- Friends of Karl
    SELECT CASE WHEN user1_id = (SELECT user_id FROM users WHERE user_name = 'Karl')
                THEN user2_id ELSE user1_id END
    FROM friendship
    WHERE user1_id = (SELECT user_id FROM users WHERE user_name = 'Karl')
       OR user2_id = (SELECT user_id FROM users WHERE user_name = 'Karl')
)
AND u.user_id IN (
    -- Friends of Hans
    SELECT CASE WHEN user1_id = (SELECT user_id FROM users WHERE user_name = 'Hans')
                THEN user2_id ELSE user1_id END
    FROM friendship
    WHERE user1_id = (SELECT user_id FROM users WHERE user_name = 'Hans')
       OR user2_id = (SELECT user_id FROM users WHERE user_name = 'Hans')
);
