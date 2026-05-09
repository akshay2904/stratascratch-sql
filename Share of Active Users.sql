-- ======================================================================
-- Share of Active Users
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Free
-- ID         : 2005
-- URL        : https://platform.stratascratch.com/coding/2005-share-of-active-users
-- ======================================================================

/*
Calculate the percentage of users who are both from the US and have an 'open' status, as indicated in the fb_active_users table.
*/

-- Tables:
--   fb_active_users(country text, name text, status text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH stats AS (
    SELECT
        COUNT(*) AS total_users,
        -- Single pass: count users matching both conditions
        SUM(CASE WHEN country = 'USA' AND status = 'open' THEN 1 ELSE 0 END) AS matching_users
    FROM fb_active_users
)
SELECT
    ROUND(
        (matching_users::NUMERIC / NULLIF(total_users, 0)) * 100,
        2
    ) AS pct_us_open_users
FROM stats;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        (
            (SELECT COUNT(*) FROM fb_active_users WHERE country = 'USA' AND status = 'open')::NUMERIC
            /
            NULLIF((SELECT COUNT(*) FROM fb_active_users), 0)
        ) * 100,
        2
    ) AS pct_us_open_users;
