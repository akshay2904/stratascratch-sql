-- ======================================================================
-- Daily Post Removal Ratio
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10562
-- URL        : https://platform.stratascratch.com/coding/10562-daily-post-removal-ratio
-- ======================================================================

/*
Calculate the daily ratio of posts removed by reviewers to posts reported by users. For each date in the dataset range, count unique posts reported (multiple reports of the same post count as one) and how many of those were removed the same day.




For dates with reported posts but no removals, show zero for removal metrics. Calculate removal ratio as removed posts divided by reported posts. Output the date, number of reported posts, number of removed posts, and the removal ratio.
*/

-- Tables:
--   user_actions(action text, date date, details text, post_id bigint, user_id bigint)
--   post_removals(post_id bigint, reason text, removal_date date)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH reported AS (
    -- Count distinct posts reported per day
    SELECT
        DATE(reported_at) AS report_date,
        COUNT(DISTINCT post_id) AS reported_posts
    FROM reports
    GROUP BY DATE(reported_at)
),
removed AS (
    -- Count distinct posts removed per day
    SELECT
        DATE(removed_at) AS remove_date,
        COUNT(DISTINCT post_id) AS removed_posts
    FROM post_removals
    GROUP BY DATE(removed_at)
),
joined AS (
    SELECT
        r.report_date AS date,
        r.reported_posts,
        -- Only count removals that match a reported post on the same day
        COUNT(DISTINCT CASE
            WHEN pr.post_id IS NOT NULL THEN rp.post_id
        END) AS removed_posts
    FROM reported r
    -- Join back to individual reported posts to match with removals on same day
    LEFT JOIN (
        SELECT DISTINCT DATE(reported_at) AS report_date, post_id
        FROM reports
    ) rp ON rp.report_date = r.report_date
    LEFT JOIN post_removals pr
        ON pr.post_id = rp.post_id
        AND DATE(pr.removed_at) = r.report_date
    GROUP BY r.report_date, r.reported_posts
)
SELECT
    date,
    reported_posts,
    removed_posts,
    ROUND(removed_posts::NUMERIC / reported_posts, 4) AS removal_ratio
FROM joined
ORDER BY date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    sub.report_date                                         AS date,
    sub.reported_posts,
    sub.removed_posts,
    ROUND(sub.removed_posts::NUMERIC / sub.reported_posts, 4) AS removal_ratio
FROM (
    SELECT
        DATE(r.reported_at) AS report_date,
        -- Distinct reported posts per day
        COUNT(DISTINCT r.post_id) AS reported_posts,
        -- Distinct reported posts that were also removed on the same day
        COUNT(DISTINCT CASE
            WHEN EXISTS (
                SELECT 1
                FROM post_removals pr
                WHERE pr.post_id = r.post_id
                  AND DATE(pr.removed_at) = DATE(r.reported_at)
            ) THEN r.post_id
            ELSE NULL
        END) AS removed_posts
    FROM reports r
    GROUP BY DATE(r.reported_at)
) sub
ORDER BY sub.report_date;
