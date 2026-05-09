-- ======================================================================
-- Find the number of Bodegas outside of Spain that produce wines with the blackberry taste
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10031
-- URL        : https://platform.stratascratch.com/coding/10031-find-the-number-of-bodegas-outside-of-spain-by-the-country-and-region-that-produces-wines-with-the-blackberry-taste
-- ======================================================================

/*
Find the number of Bodegas (wineries with "bodega" pattern inside the name) outside of Spain that produce wines with the blackberry taste (description contains blackberry string). Group the count by country and region.
Output the country, region along with the number of bodegas.
Order records by the number of bodegas in descending order.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH bodega_blackberry AS (
    SELECT DISTINCT
        w.country,
        w.region_1 AS region,
        w.winery
    FROM wines w
    WHERE LOWER(w.winery) LIKE '%bodega%'
      AND w.country <> 'Spain'
      AND LOWER(w.description) LIKE '%blackberry%'
      AND w.country IS NOT NULL
      AND w.region_1 IS NOT NULL
)
SELECT
    country,
    region,
    COUNT(*) AS num_bodegas
FROM bodega_blackberry
GROUP BY country, region
ORDER BY num_bodegas DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    country,
    region_1 AS region,
    COUNT(DISTINCT winery) AS num_bodegas
FROM wines
WHERE LOWER(winery) LIKE '%bodega%'
  AND country <> 'Spain'
  AND LOWER(description) LIKE '%blackberry%'
  AND country IS NOT NULL
  AND region_1 IS NOT NULL
GROUP BY country, region_1
ORDER BY num_bodegas DESC;
