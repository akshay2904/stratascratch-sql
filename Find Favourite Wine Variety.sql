-- ======================================================================
-- Find Favourite Wine Variety
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10037
-- URL        : https://platform.stratascratch.com/coding/10037-find-favourite-wine-variety
-- ======================================================================

/*
Find each taster's favorite wine variety.

A favorite variety is the variety each taster has reviewed the most times. If a taster has multiple varieties tied for the highest review count, return all of them.

Output the taster's name along with the wine variety.
*/

-- Tables:
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH variety_counts AS (
    SELECT
        taster_name,
        variety,
        COUNT(*) AS review_count,
        RANK() OVER (PARTITION BY taster_name ORDER BY COUNT(*) DESC) AS rnk
    FROM winemag_p1
    WHERE taster_name IS NOT NULL
      AND variety IS NOT NULL
    GROUP BY taster_name, variety
)
SELECT
    taster_name,
    variety
FROM variety_counts
WHERE rnk = 1
ORDER BY taster_name, variety;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH variety_counts AS (
    SELECT
        taster_name,
        variety,
        COUNT(*) AS review_count
    FROM winemag_p1
    WHERE taster_name IS NOT NULL
      AND variety IS NOT NULL
    GROUP BY taster_name, variety
),
max_counts AS (
    SELECT
        taster_name,
        MAX(review_count) AS max_review_count
    FROM variety_counts
    GROUP BY taster_name
)
SELECT
    vc.taster_name,
    vc.variety
FROM variety_counts vc
JOIN max_counts mc
    ON vc.taster_name = mc.taster_name
   AND vc.review_count = mc.max_review_count
ORDER BY vc.taster_name, vc.variety;
