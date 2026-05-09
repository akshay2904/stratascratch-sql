-- ======================================================================
-- Common Friends Friend
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Premium
-- ID         : 9821
-- URL        : https://platform.stratascratch.com/coding/9821-common-friends-friend
-- ======================================================================

/*
Find the number of a user's friends' friend who are also the user's friend. Output the user id along with the count.
*/

-- Tables:
--   google_friends_network(friend_id bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assume table: friendship(user1_id, user2_id) where each friendship stored once
-- We treat friendships as undirected by unioning both directions

WITH edges AS (
    -- Normalize to directed edges so we can look up friends easily
    SELECT user1_id AS user_id, user2_id AS friend_id FROM friendship
    UNION ALL
    SELECT user2_id AS user_id, user1_id AS friend_id FROM friendship
),
friend_of_friend AS (
    -- For each user, find friends-of-friends (via one hop)
    SELECT
        e1.user_id,
        e2.friend_id AS fof
    FROM edges e1
    JOIN edges e2
        ON e1.friend_id = e2.user_id
    WHERE e2.friend_id != e1.user_id  -- exclude the user themselves
)
SELECT
    fof.user_id,
    COUNT(*) AS mutual_friend_count
FROM friend_of_friend fof
-- Keep only friend-of-friends who are ALSO direct friends of the user
JOIN edges e
    ON fof.user_id = e.user_id
    AND fof.fof    = e.friend_id
GROUP BY fof.user_id
ORDER BY fof.user_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    f1.user_id,
    COUNT(*) AS mutual_friend_count
FROM (
    -- All directed friendships
    SELECT user1_id AS user_id, user2_id AS friend_id FROM friendship
    UNION ALL
    SELECT user2_id AS user_id, user1_id AS friend_id FROM friendship
) f1
WHERE f1.friend_id IN (
    -- Friends of friends: people reachable in two hops from f1.user_id
    SELECT f3.friend_id
    FROM (
        SELECT user1_id AS user_id, user2_id AS friend_id FROM friendship
        UNION ALL
        SELECT user2_id AS user_id, user1_id AS friend_id FROM friendship
    ) f2
    JOIN (
        SELECT user1_id AS user_id, user2_id AS friend_id FROM friendship
        UNION ALL
        SELECT user2_id AS user_id, user1_id AS friend_id FROM friendship
    ) f3
        ON f2.friend_id = f3.user_id
    WHERE f2.user_id = f1.user_id
      AND f3.friend_id != f1.user_id  -- exclude the user themselves
)
GROUP BY f1.user_id
ORDER BY f1.user_id;
