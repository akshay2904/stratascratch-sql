-- ======================================================================
-- Cities With The Most Expensive Homes
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Zillow
-- Access     : Premium
-- ID         : 10315
-- URL        : https://platform.stratascratch.com/coding/10315-cities-with-the-most-expensive-homes
-- ======================================================================

/*
Write a query that identifies cities with higher than average home prices when compared to the national average. Output the city names.
*/

-- Tables:
--   zillow_transactions(city text, id bigint, mkt_price bigint, state text, street_address text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_avg AS (
    SELECT
        city,
        AVG(price) AS avg_city_price,
        -- Compute national average once using a window function over all rows
        AVG(AVG(price)) OVER () AS national_avg
    FROM home_sales
    GROUP BY city
)
SELECT city
FROM city_avg
WHERE avg_city_price > national_avg;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT city
FROM home_sales
GROUP BY city
HAVING AVG(price) > (
    SELECT AVG(price)
    FROM home_sales
);
