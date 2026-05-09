-- ======================================================================
-- Spam Posts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10134
-- URL        : https://platform.stratascratch.com/coding/10134-spam-posts
-- ======================================================================

/*
Calculate the percentage of spam posts in all viewed posts by day. A post is considered a spam if a string "spam" is inside keywords of the post. Note that the facebook_posts table stores all posts posted by users. The facebook_post_views table is an action table denoting if a user has viewed a post.
*/

-- Tables:
--   facebook_posts(post_date date, post_id bigint, post_keywords text, post_text text, poster bigint)
--   facebook_post_views(post_id bigint, viewer_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_stats AS (
    SELECT
        fpv.viewed_date,
        COUNT(*) AS total_viewed,
        COUNT(*) FILTER (WHERE fp.keywords ILIKE '%spam%') AS spam_count
    FROM facebook_post_views fpv
    JOIN facebook_posts fp
        ON fpv.post_id = fp.post_id
    GROUP BY fpv.viewed_date
)
SELECT
    viewed_date,
    ROUND(100.0 * spam_count / NULLIF(total_viewed, 0), 2) AS spam_percentage
FROM daily_stats
ORDER BY viewed_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    fpv.viewed_date,
    ROUND(
        100.0 *
        SUM(CASE WHEN fp.keywords ILIKE '%spam%' THEN 1 ELSE 0 END)
        /
        NULLIF(COUNT(*), 0),
        2
    ) AS spam_percentage
FROM facebook_post_views fpv
JOIN facebook_posts fp
    ON fpv.post_id = fp.post_id
GROUP BY fpv.viewed_date
ORDER BY fpv.viewed_date;
