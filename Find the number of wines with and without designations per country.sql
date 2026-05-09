-- ======================================================================
-- Find the number of wines with and without designations per country
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10035
-- URL        : https://platform.stratascratch.com/coding/10035-find-the-number-of-wines-with-and-without-designations-per-country
-- ======================================================================

/*
Find the number of wines with and without designations per country.
Output the country along with the total without designations, total with designations, and the final total of both.
*/

-- Tables:
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    country,
    COUNT(*) FILTER (WHERE designation IS NULL OR designation = '')    AS total_without_designation,
    COUNT(*) FILTER (WHERE designation IS NOT NULL AND designation <> '') AS total_with_designation,
    COUNT(*) AS final_total
FROM winemag_p1
GROUP BY country
ORDER BY country;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    country,
    SUM(CASE WHEN designation IS NULL OR designation = '' THEN 1 ELSE 0 END)    AS total_without_designation,
    SUM(CASE WHEN designation IS NOT NULL AND designation <> '' THEN 1 ELSE 0 END) AS total_with_designation,
    COUNT(*) AS final_total
FROM winemag_p1
GROUP BY country
ORDER BY country;
