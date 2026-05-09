-- ======================================================================
-- Liked' Posts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10088
-- URL        : https://platform.stratascratch.com/coding/10088-liked-posts
-- ======================================================================

/*
Find the number of posts which were reacted to with a like and include basketball keyword in it.
*/

-- Tables:
--   facebook_reactions(date_day bigint, friend bigint, post_id bigint, poster bigint, reaction text)
--   facebook_posts(post_date date, post_id bigint, post_keywords text, post_text text, poster bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH liked_posts AS (
    SELECT DISTINCT post_id
    FROM reactions
    WHERE reaction = 'like'
),
basketball_posts AS (
    SELECT DISTINCT id
    FROM posts
    WHERE post_keywords ILIKE '%basketball%'
)
SELECT COUNT(*) AS num_posts
FROM liked_posts lp
JOIN basketball_posts bp ON lp.post_id = bp.id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT COUNT(DISTINCT p.id) AS num_posts
FROM posts p
WHERE p.post_keywords ILIKE '%basketball%'
  AND p.id IN (
      SELECT post_id
      FROM reactions
      WHERE reaction = 'like'
  );
