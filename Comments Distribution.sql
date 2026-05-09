-- ======================================================================
-- Comments Distribution
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10297
-- URL        : https://platform.stratascratch.com/coding/10297-comments-distribution
-- ======================================================================

/*
Write a query to calculate the distribution of comments by the count of users that joined Meta/Facebook between 2018 and 2020, for the month of January 2020.




The output should contain a count of comments and the corresponding number of users that made that number of comments in Jan-2020. For example, you'll be counting how many users made 1 comment, 2 comments, 3 comments, 4 comments, etc in Jan-2020. Your left column in the output will be the number of comments while your right column in the output will be the number of users. Sort the output from the least number of comments to highest.




To add some complexity, there might be a bug where an user post is dated before the user join date. You'll want to remove these posts from the result.
*/

-- Tables:
--   fb_users(city_id bigint, device bigint, id bigint, joined_at date, name text)
--   fb_comments(body text, created_at date, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH eligible_users AS (
    -- Users who joined Meta/Facebook between 2018 and 2020
    SELECT user_id, joined_at
    FROM users
    WHERE EXTRACT(YEAR FROM joined_at) BETWEEN 2018 AND 2020
),
valid_comments AS (
    -- Comments made in Jan 2020, excluding posts dated before the user's join date
    SELECT 
        fb.user_id,
        fb.body,
        fb.created_at
    FROM fb_comments fb
    INNER JOIN eligible_users eu 
        ON fb.user_id = eu.user_id
    WHERE fb.created_at >= eu.joined_at                          -- remove bug: post before join
      AND DATE_TRUNC('month', fb.created_at) = '2020-01-01'     -- only Jan 2020
),
user_comment_counts AS (
    -- Count comments per user in Jan 2020
    SELECT 
        user_id,
        COUNT(*) AS comment_count
    FROM valid_comments
    GROUP BY user_id
)
SELECT 
    comment_count   AS number_of_comments,
    COUNT(user_id)  AS number_of_users
FROM user_comment_counts
GROUP BY comment_count
ORDER BY comment_count ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    comment_count       AS number_of_comments,
    COUNT(user_id)      AS number_of_users
FROM (
    -- Count valid comments per eligible user in Jan 2020
    SELECT 
        fb.user_id,
        COUNT(*) AS comment_count
    FROM fb_comments fb
    INNER JOIN users u 
        ON fb.user_id = u.user_id
    WHERE 
        -- User joined between 2018 and 2020
        EXTRACT(YEAR FROM u.joined_at) BETWEEN 2018 AND 2020
        -- Comment was not posted before user joined (remove buggy records)
        AND fb.created_at >= u.joined_at
        -- Comment was made in January 2020
        AND fb.created_at >= '2020-01-01'
        AND fb.created_at  < '2020-02-01'
    GROUP BY fb.user_id
) AS user_counts
GROUP BY comment_count
ORDER BY comment_count ASC;
