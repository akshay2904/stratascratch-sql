-- ======================================================================
-- Find industries with the highest market value in Asia
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Forbes
-- Access     : Premium
-- ID         : 9799
-- URL        : https://platform.stratascratch.com/coding/9799-find-industries-with-the-highest-market-value-in-asia
-- ======================================================================

/*
Find industries with the highest market value in Asia.
Output the industry along with the corresponding total market value.
*/

-- Tables:
--   forbes_global_2010_2014(assets double precision, company text, continent text, country text, industry text, marketvalue double precision, profits double precision, rank bigint, sales double precision, sector text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH asia_totals AS (
    SELECT
        industry,
        SUM(marketcap) AS total_market_value,
        RANK() OVER (ORDER BY SUM(marketcap) DESC) AS rnk
    FROM forbes_global_2010_2014
    WHERE continent = 'Asia'
    GROUP BY industry
)
SELECT
    industry,
    total_market_value
FROM asia_totals
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    industry,
    SUM(marketcap) AS total_market_value
FROM forbes_global_2010_2014
WHERE continent = 'Asia'
GROUP BY industry
HAVING SUM(marketcap) = (
    SELECT MAX(industry_total)
    FROM (
        SELECT SUM(marketcap) AS industry_total
        FROM forbes_global_2010_2014
        WHERE continent = 'Asia'
        GROUP BY industry
    ) AS sub
);
