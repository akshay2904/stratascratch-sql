-- ======================================================================
-- Top 3 Wineries In The World
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10042
-- URL        : https://platform.stratascratch.com/coding/10042-top-3-wineries-in-the-world
-- ======================================================================

/*
Find the top 3 wineries in each country based on the average points earned. In case there is a tie, order the wineries by winery name in ascending order. Output the country along with the best, second best, and third best wineries. If there is no second winery (NULL value) output 'No second winery' and if there is no third winery output 'No third winery'. For outputting wineries format them like this: "winery (avg_points)"
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH winery_avg AS (
    SELECT 
        country,
        winery,
        ROUND(AVG(points)::numeric, 2) AS avg_points
    FROM winemag_p1
    WHERE country IS NOT NULL AND winery IS NOT NULL
    GROUP BY country, winery
),
ranked AS (
    SELECT 
        country,
        winery,
        avg_points,
        RANK() OVER (PARTITION BY country ORDER BY avg_points DESC, winery ASC) AS rnk
    FROM winery_avg
),
pivoted AS (
    SELECT
        country,
        MAX(CASE WHEN rnk = 1 THEN winery || ' (' || avg_points || ')' END) AS best,
        MAX(CASE WHEN rnk = 2 THEN winery || ' (' || avg_points || ')' END) AS second_best,
        MAX(CASE WHEN rnk = 3 THEN winery || ' (' || avg_points || ')' END) AS third_best
    FROM ranked
    WHERE rnk <= 3
    GROUP BY country
)
SELECT
    country,
    best,
    COALESCE(second_best, 'No second winery') AS second_best,
    COALESCE(third_best, 'No third winery')  AS third_best
FROM pivoted
ORDER BY country;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH winery_avg AS (
    SELECT 
        country,
        winery,
        ROUND(AVG(points)::numeric, 2) AS avg_points
    FROM winemag_p1
    WHERE country IS NOT NULL AND winery IS NOT NULL
    GROUP BY country, winery
),
-- Assign rank manually using correlated subquery counting
ranked AS (
    SELECT
        w.country,
        w.winery,
        w.avg_points,
        -- Count how many wineries have strictly higher avg_points in same country,
        -- then add count of wineries with same avg_points but alphabetically before (for tie-breaking)
        (
            SELECT COUNT(*)
            FROM winery_avg w2
            WHERE w2.country = w.country
              AND (
                  w2.avg_points > w.avg_points
                  OR (w2.avg_points = w.avg_points AND w2.winery < w.winery)
              )
        ) + 1 AS rnk
    FROM winery_avg w
),
pivoted AS (
    SELECT
        country,
        MAX(CASE WHEN rnk = 1 THEN winery || ' (' || avg_points || ')' END) AS best,
        MAX(CASE WHEN rnk = 2 THEN winery || ' (' || avg_points || ')' END) AS second_best,
        MAX(CASE WHEN rnk = 3 THEN winery || ' (' || avg_points || ')' END) AS third_best
    FROM ranked
    WHERE rnk <= 3
    GROUP BY country
)
SELECT
    country,
    best,
    COALESCE(second_best, 'No second winery') AS second_best,
    COALESCE(third_best, 'No third winery')  AS third_best
FROM pivoted
ORDER BY country;
