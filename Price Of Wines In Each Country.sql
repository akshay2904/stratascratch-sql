-- ======================================================================
-- Price Of Wines In Each Country
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10029
-- URL        : https://platform.stratascratch.com/coding/10029-price-of-wines-in-each-country
-- ======================================================================

/*
Find the minimum, average, and maximum price of all wines per country. Assume all wines listed across both datasets are unique. Output the country name along with the corresponding minimum, maximum, and average prices.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH all_wines AS (
    SELECT country, price FROM winemag_p1
    UNION ALL
    SELECT country, price FROM winemag_p2
)
SELECT
    country,
    MIN(price)  AS min_price,
    MAX(price)  AS max_price,
    AVG(price)  AS avg_price
FROM all_wines
WHERE country IS NOT NULL
  AND price IS NOT NULL
GROUP BY country
ORDER BY country;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    country,
    MIN(price)  AS min_price,
    MAX(price)  AS max_price,
    AVG(price)  AS avg_price
FROM (
    SELECT country, price FROM winemag_p1
    UNION ALL
    SELECT country, price FROM winemag_p2
) combined
WHERE country IS NOT NULL
  AND price IS NOT NULL
GROUP BY country
ORDER BY country;
