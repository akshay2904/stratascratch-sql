-- ======================================================================
-- Population Density
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Deloitte
-- Access     : Premium
-- ID         : 10368
-- URL        : https://platform.stratascratch.com/coding/10368-population-density
-- ======================================================================

/*
You are working on a data analysis project at Deloitte where you need to analyze a dataset containing information

about various cities. Your task is to calculate the population density of these cities, rounded to the nearest integer, and identify the cities with the minimum and maximum densities.

The population density should be calculated as (Population / Area).




The output should contain 'city', 'country', 'density'.
*/

-- Tables:
--   cities_population(area double precision, city text, country text, population bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH density_calc AS (
    SELECT
        city,
        country,
        ROUND(population::numeric / area) AS density,
        MIN(ROUND(population::numeric / area)) OVER () AS min_density,
        MAX(ROUND(population::numeric / area)) OVER () AS max_density
    FROM cities
)
SELECT
    city,
    country,
    density
FROM density_calc
WHERE density = min_density
   OR density = max_density
ORDER BY density;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    city,
    country,
    ROUND(population::numeric / area) AS density
FROM cities
WHERE ROUND(population::numeric / area) = (
        SELECT MIN(ROUND(population::numeric / area)) FROM cities
    )
   OR ROUND(population::numeric / area) = (
        SELECT MAX(ROUND(population::numeric / area)) FROM cities
    )
ORDER BY density;
