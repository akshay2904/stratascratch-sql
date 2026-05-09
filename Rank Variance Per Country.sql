-- ======================================================================
-- Rank Variance Per Country
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Free
-- ID         : 2007
-- URL        : https://platform.stratascratch.com/coding/2007-rank-variance-per-country
-- ======================================================================

/*
Compare the total number of comments made by users in each country during December 2019 and January 2020.




For each month, rank countries by their total number of comments in descending order. Countries with the same total should share the same rank, and the next rank should increase by one (without skipping numbers).




Return the names of the countries whose rank improved from December to January (that is, their rank number became smaller).
*/

-- Tables:
--   fb_comments_count(created_at date, number_of_comments bigint, user_id bigint)
--   fb_active_users(country text, name text, status text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_counts AS (
    SELECT
        u.country,
        DATE_TRUNC('month', c.created_at) AS month,
        COUNT(*) AS total_comments
    FROM comments c
    JOIN users u ON c.user_id = u.id
    WHERE c.created_at >= '2019-12-01'
      AND c.created_at  < '2020-02-01'
    GROUP BY u.country, DATE_TRUNC('month', c.created_at)
),
ranked AS (
    SELECT
        country,
        month,
        total_comments,
        DENSE_RANK() OVER (PARTITION BY month ORDER BY total_comments DESC) AS rnk
    FROM monthly_counts
)
SELECT DISTINCT r_jan.country
FROM ranked r_dec
JOIN ranked r_jan
    ON r_dec.country = r_jan.country
   AND r_dec.month   = '2019-12-01'
   AND r_jan.month   = '2020-01-01'
WHERE r_jan.rnk < r_dec.rnk;  -- smaller rank number = improved position

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT dec_ranked.country
FROM (
    -- December 2019 counts and ranks
    SELECT
        country,
        total_comments,
        (
            SELECT COUNT(DISTINCT t2.total_comments)
            FROM (
                SELECT u2.country, COUNT(*) AS total_comments
                FROM comments c2
                JOIN users u2 ON c2.user_id = u2.id
                WHERE c2.created_at >= '2019-12-01'
                  AND c2.created_at  < '2020-01-01'
                GROUP BY u2.country
            ) t2
            WHERE t2.total_comments > t1.total_comments
        ) + 1 AS rnk
    FROM (
        SELECT u.country, COUNT(*) AS total_comments
        FROM comments c
        JOIN users u ON c.user_id = u.id
        WHERE c.created_at >= '2019-12-01'
          AND c.created_at  < '2020-01-01'
        GROUP BY u.country
    ) t1
) dec_ranked
JOIN (
    -- January 2020 counts and ranks
    SELECT
        country,
        total_comments,
        (
            SELECT COUNT(DISTINCT t4.total_comments)
            FROM (
                SELECT u4.country, COUNT(*) AS total_comments
                FROM comments c4
                JOIN users u4 ON c4.user_id = u4.id
                WHERE c4.created_at >= '2020-01-01'
                  AND c4.created_at  < '2020-02-01'
                GROUP BY u4.country
            ) t4
            WHERE t4.total_comments > t3.total_comments
        ) + 1 AS rnk
    FROM (
        SELECT u3.country, COUNT(*) AS total_comments
        FROM comments c3
        JOIN users u3 ON c3.user_id = u3.id
        WHERE c3.created_at >= '2020-01-01'
          AND c3.created_at  < '2020-02-01'
        GROUP BY u3.country
    ) t3
) jan_ranked
    ON dec_ranked.country = jan_ranked.country
WHERE jan_ranked.rnk < dec_ranked.rnk;  -- rank improved (lower number = better)
