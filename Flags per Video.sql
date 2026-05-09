-- ======================================================================
-- Flags per Video
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Netflix, Google
-- Access     : Free
-- ID         : 2102
-- URL        : https://platform.stratascratch.com/coding/2102-flags-per-video
-- ======================================================================

/*
For each video, find how many unique users flagged it. A unique user can be identified using the combination of their first name and last name. Do not consider rows in which there is no flag ID.
*/

-- Tables:
--   user_flags(flag_id text, user_firstname text, user_lastname text, video_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    video_id,
    COUNT(DISTINCT CONCAT(user_firstname, '-', user_lastname)) AS num_unique_users
FROM user_flags
WHERE flag_id IS NOT NULL
GROUP BY video_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    video_id,
    COUNT(*) AS num_unique_users
FROM (
    SELECT
        video_id,
        user_firstname,
        user_lastname
    FROM user_flags
    WHERE flag_id IS NOT NULL
    GROUP BY video_id, user_firstname, user_lastname
) unique_users
GROUP BY video_id;
