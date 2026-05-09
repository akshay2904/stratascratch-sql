-- ======================================================================
-- Find the number of wines each taster tasted within the variation
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10028
-- URL        : https://platform.stratascratch.com/coding/10028-find-the-number-of-wines-of-each-variety-that-has-been-tasted-by-each-taster
-- ======================================================================

/*
Find the number of wines each taster tasted within the variation.
Output the tester's name, variety, and the number of tastings.
Order records by taster name and the variety in ascending order and by the number of tasting in descending order.
*/

-- Tables:
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    taster_name,
    variety,
    COUNT(*) AS num_tastings
FROM winemag_p2
WHERE taster_name IS NOT NULL
  AND variety IS NOT NULL
GROUP BY taster_name, variety
ORDER BY taster_name ASC, variety ASC, num_tastings DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    taster_name,
    variety,
    COUNT(*) AS num_tastings
FROM (
    SELECT taster_name, variety
    FROM winemag_p2
    WHERE taster_name IS NOT NULL
      AND variety IS NOT NULL
) AS filtered
GROUP BY taster_name, variety
ORDER BY taster_name ASC, variety ASC, num_tastings DESC;
