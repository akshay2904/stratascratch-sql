-- ======================================================================
-- Find all wines from the winemag_p2 dataset which are produced in countries that have the highest sum of points in the winemag_p1 dataset
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10040
-- URL        : https://platform.stratascratch.com/coding/10040-find-all-wines-from-the-winemag_p2-dataset-which-are-produced-in-countries-that-have-the-highest-sum-of-points-in-the-winemag_p1-dataset
-- ======================================================================

/*
Find all wines from the winemag_p2 dataset which are produced in the country that have the highest sum of points in the winemag_p1 dataset.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH country_points AS (
    SELECT country, SUM(points) AS total_points
    FROM winemag_p1
    WHERE country IS NOT NULL
    GROUP BY country
),
top_country AS (
    SELECT country
    FROM country_points
    ORDER BY total_points DESC
    LIMIT 1
)
SELECT p2.*
FROM winemag_p2 p2
JOIN top_country tc ON p2.country = tc.country;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT *
FROM winemag_p2
WHERE country = (
    SELECT country
    FROM winemag_p1
    WHERE country IS NOT NULL
    GROUP BY country
    ORDER BY SUM(points) DESC
    LIMIT 1
);
