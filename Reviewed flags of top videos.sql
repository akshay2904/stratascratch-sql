-- ======================================================================
-- Reviewed flags of top videos
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Premium
-- ID         : 2103
-- URL        : https://platform.stratascratch.com/coding/2103-reviewed-flags-of-top-videos
-- ======================================================================

/*
For the video (or videos) that received the most user flags, how many of these flags were reviewed by YouTube? Output the video ID and the corresponding number of reviewed flags.  Ignore flags that do not have a corresponding flag_id.
*/

-- Tables:
--   user_flags(flag_id text, user_firstname text, user_lastname text, video_id text)
--   flag_review(flag_id text, reviewed_by_yt boolean, reviewed_date date, reviewed_outcome text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH flag_counts AS (
    SELECT
        video_id,
        COUNT(*) AS total_flags,
        SUM(CASE WHEN reviewed_by_yt = TRUE THEN 1 ELSE 0 END) AS reviewed_flags,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM user_flags
    WHERE flag_id IS NOT NULL
    GROUP BY video_id
)
SELECT
    video_id,
    reviewed_flags
FROM flag_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    video_id,
    SUM(CASE WHEN reviewed_by_yt = TRUE THEN 1 ELSE 0 END) AS reviewed_flags
FROM user_flags
WHERE flag_id IS NOT NULL
GROUP BY video_id
HAVING COUNT(*) = (
    SELECT MAX(flag_count)
    FROM (
        SELECT COUNT(*) AS flag_count
        FROM user_flags
        WHERE flag_id IS NOT NULL
        GROUP BY video_id
    ) sub
);
