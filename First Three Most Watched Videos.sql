-- ======================================================================
-- First Three Most Watched Videos
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Netflix, Google
-- Access     : Premium
-- ID         : 2133
-- URL        : https://platform.stratascratch.com/coding/2133-first-three-most-watched-videos
-- ======================================================================

/*
After a new user creates an account and starts watching videos, the user ID, video ID, and date watched are captured in the database. Find the top 3 videos most users have watched as their first 3 videos. Output the video ID and the number of times it has been watched as the users' first 3 videos.




In the event of a tie, output all the videos in the top 3 that users watched as their first 3 videos.
*/

-- Tables:
--   videos_watched(user_id text, video_id text, watched_at timestamp without time zone)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_watches AS (
    -- Rank each user's videos by watch date to find their first 3
    SELECT
        user_id,
        video_id,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY watched_at) AS watch_rank
    FROM user_video_logs
),
first_3_videos AS (
    -- Keep only the first 3 videos per user
    SELECT video_id
    FROM ranked_watches
    WHERE watch_rank <= 3
),
video_counts AS (
    -- Count how many users watched each video as one of their first 3
    SELECT
        video_id,
        COUNT(*) AS watch_count
    FROM first_3_videos
    GROUP BY video_id
),
ranked_videos AS (
    -- Rank videos by watch count to handle ties
    SELECT
        video_id,
        watch_count,
        DENSE_RANK() OVER (ORDER BY watch_count DESC) AS rnk
    FROM video_counts
)
SELECT
    video_id,
    watch_count
FROM ranked_videos
WHERE rnk <= 3
ORDER BY watch_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    video_id,
    COUNT(*) AS watch_count
FROM (
    -- Get only the first 3 videos watched per user using a correlated subquery
    SELECT u1.user_id, u1.video_id, u1.watched_at
    FROM user_video_logs u1
    WHERE (
        SELECT COUNT(*)
        FROM user_video_logs u2
        WHERE u2.user_id = u1.user_id
          AND u2.watched_at < u1.watched_at
    ) < 3  -- fewer than 3 videos watched before this one means it's in the first 3
) first_3
GROUP BY video_id
HAVING COUNT(*) >= (
    -- Find the minimum count that qualifies as top 3 (handling ties)
    SELECT MIN(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM (
            SELECT u1.user_id, u1.video_id
            FROM user_video_logs u1
            WHERE (
                SELECT COUNT(*)
                FROM user_video_logs u2
                WHERE u2.user_id = u1.user_id
                  AND u2.watched_at < u1.watched_at
            ) < 3
        ) sub
        GROUP BY video_id
        ORDER BY COUNT(*) DESC
        LIMIT 3
    ) top3_counts
)
ORDER BY watch_count DESC;
