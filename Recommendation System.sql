-- ======================================================================
-- Recommendation System
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2081
-- URL        : https://platform.stratascratch.com/coding/2081-recommendation-system
-- ======================================================================

/*
You are given the list of Facebook friends and the list of Facebook pages that users follow. Your task is to create a new recommendation system for Facebook. For each Facebook user, find pages that this user doesn't follow but at least one of their friends does. Output the user ID and the ID of the page that should be recommended to this user.
*/

-- Tables:
--   users_friends(friend_id bigint, user_id bigint)
--   users_pages(page_id bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Use CTEs to clearly separate friend relationships and page follows,
-- then find pages friends follow that the user does not

WITH friend_pairs AS (
    -- Normalize friendships so each pair appears in both directions
    SELECT user1 AS user_id, user2 AS friend_id FROM friends
    UNION ALL
    SELECT user2 AS user_id, user1 AS friend_id FROM friends
),
friend_pages AS (
    -- Pages that at least one friend follows
    SELECT DISTINCT fp.user_id, pl.page_id
    FROM friend_pairs fp
    JOIN page_follows pl ON fp.friend_id = pl.user_id
)
SELECT
    fp.user_id,
    fp.page_id
FROM friend_pages fp
WHERE NOT EXISTS (
    -- Exclude pages the user already follows
    SELECT 1
    FROM page_follows pf
    WHERE pf.user_id = fp.user_id
      AND pf.page_id = fp.page_id
)
ORDER BY fp.user_id, fp.page_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT
    u.user_id,
    friend_page.page_id
FROM (
    -- All users derived from the friends table
    SELECT user1 AS user_id FROM friends
    UNION
    SELECT user2 AS user_id FROM friends
) u
JOIN (
    -- For each friend relationship, get pages the friend follows
    SELECT f.user1 AS user_id, pf.page_id
    FROM friends f
    JOIN page_follows pf ON pf.user_id = f.user2
    UNION ALL
    SELECT f.user2 AS user_id, pf.page_id
    FROM friends f
    JOIN page_follows pf ON pf.user_id = f.user1
) friend_page ON friend_page.user_id = u.user_id
WHERE friend_page.page_id NOT IN (
    -- Exclude pages the user already follows
    SELECT page_id
    FROM page_follows
    WHERE user_id = u.user_id
)
ORDER BY u.user_id, friend_page.page_id;
