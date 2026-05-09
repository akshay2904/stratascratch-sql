-- ======================================================================
-- Find countries that are in winemag_p1 dataset but not in winemag_p2
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10147
-- URL        : https://platform.stratascratch.com/coding/10147-find-countries-that-are-in-winemag_p1-dataset-but-not-in-winemag_p2
-- ======================================================================

/*
Find countries that are in winemag_p1 dataset but not in winemag_p2.
Output distinct country names.
Order records by the country in ascending order.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT DISTINCT w1.country
FROM winemag_p1 w1
WHERE w1.country IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM winemag_p2 w2
      WHERE w2.country = w1.country
  )
ORDER BY w1.country ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT country
FROM winemag_p1
WHERE country IS NOT NULL
  AND country NOT IN (
      SELECT DISTINCT country
      FROM winemag_p2
      WHERE country IS NOT NULL
  )
ORDER BY country ASC;
