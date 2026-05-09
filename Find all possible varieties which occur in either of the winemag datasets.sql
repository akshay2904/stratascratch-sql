-- ======================================================================
-- Find all possible varieties which occur in either of the winemag datasets
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Free
-- ID         : 10025
-- URL        : https://platform.stratascratch.com/coding/10025-find-all-possible-varieties-which-occur-in-either-of-the-winemag-datasets
-- ======================================================================

/*
Find all possible varieties which occur in either of the winemag datasets.

Output unique variety values only.

Sort records based on the variety in ascending order.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT variety
FROM (
    SELECT variety FROM winemag_p1
    UNION
    SELECT variety FROM winemag_p2
) combined
WHERE variety IS NOT NULL
ORDER BY variety ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT variety
FROM (
    SELECT variety FROM winemag_p1
    WHERE variety IS NOT NULL
    GROUP BY variety

    UNION ALL

    SELECT variety FROM winemag_p2
    WHERE variety IS NOT NULL
    GROUP BY variety
) all_varieties
GROUP BY variety
ORDER BY variety ASC;
