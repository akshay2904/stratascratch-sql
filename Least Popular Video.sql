-- ======================================================================
-- Least Popular Video
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tiktok
-- Access     : Premium
-- ID         : 2161
-- URL        : https://platform.stratascratch.com/coding/2161-least-popular-video
-- ======================================================================

/*
You have been asked to find the least popular video based on how many users have watched it.




Consider that a user can watch a video multiple times. Only the unique user views are counted.




In the case of a tie, output all the video ids of the least popular video(s).
*/

-- Tables:
--   videos_watched(user_id text, video_id text, watched_at timestamp without time zone)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH unique_views AS (
    -- Count distinct users per video
    SELECT video_id, COUNT(DISTINCT user_id) AS unique_viewers
    FROM views
    GROUP BY video_id
),
ranked AS (
    SELECT video_id,
           unique_viewers,
           RANK() OVER (ORDER BY unique_viewers ASC) AS rnk
    FROM unique_views
)
SELECT video_id
FROM ranked
WHERE rnk = 1
ORDER BY video_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT video_id
FROM (
    SELECT video_id, COUNT(DISTINCT user_id) AS unique_viewers
    FROM views
    GROUP BY video_id
) video_counts
WHERE unique_viewers = (
    -- Find the minimum unique viewer count across all videos
    SELECT MIN(unique_viewers)
    FROM (
        SELECT COUNT(DISTINCT user_id) AS unique_viewers
        FROM views
        GROUP BY video_id
    ) min_counts
)
ORDER BY video_id;
