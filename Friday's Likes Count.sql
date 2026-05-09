-- ======================================================================
-- Friday's Likes Count
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10364
-- URL        : https://platform.stratascratch.com/coding/10364-fridays-likes-count
-- ======================================================================

/*
You have access to Facebook’s database, which contains tables related to user interactions. Your task is to calculate the total number of likes from friends for each date that falls on a Friday.




A like should only be counted if the user who liked the post is a friend of the user who made the post, and the like occurred on or after the post was created.




The output should contain two different columns: 'date' and 'likes'.
*/

-- Tables:
--   user_posts(date_posted date, post_id bigint, user_name text)
--   friendships(user_name1 text, user_name2 text)
--   likes(date_liked date, post_id bigint, user_name text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assuming tables:
-- posts(post_id, user_id, created_at)
-- likes(like_id, post_id, user_id, created_at)
-- friends(user1_id, user2_id)  -- friendship is bidirectional

WITH friday_likes AS (
    SELECT
        l.created_at::date AS like_date,
        COUNT(*) AS likes
    FROM likes l
    JOIN posts p
        ON l.post_id = p.post_id
        -- Like must occur on or after post creation
        AND l.created_at >= p.created_at
    JOIN friends f
        -- Check friendship in both directions (bidirectional relationship)
        ON (f.user1_id = p.user_id AND f.user2_id = l.user_id)
        OR (f.user1_id = l.user_id AND f.user2_id = p.user_id)
    -- Only count likes that fall on a Friday (DOW = 5 in PostgreSQL)
    WHERE EXTRACT(DOW FROM l.created_at) = 5
    GROUP BY l.created_at::date
)
SELECT
    like_date AS date,
    likes
FROM friday_likes
ORDER BY like_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    l.created_at::date AS date,
    COUNT(*) AS likes
FROM likes l,
     posts p,
     friends f
WHERE
    -- Join likes to their posts
    l.post_id = p.post_id
    -- Like must be on or after post creation date
    AND l.created_at >= p.created_at
    -- The liker must be a friend of the post author (check both directions)
    AND (
        (f.user1_id = p.user_id AND f.user2_id = l.user_id)
        OR
        (f.user1_id = l.user_id AND f.user2_id = p.user_id)
    )
    -- Only Fridays
    AND TO_CHAR(l.created_at, 'Day') LIKE 'Friday%'
GROUP BY
    l.created_at::date
ORDER BY
    l.created_at::date;
