-- ======================================================================
-- Find the continent with the highest number of companies
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Forbes
-- Access     : Premium
-- ID         : 9804
-- URL        : https://platform.stratascratch.com/coding/9804-find-continents-that-have-the-highest-number-of-companies
-- ======================================================================

/*
Find the continet with the highest number of companies.

Output the continent along with the corresponding number of companies.
*/

-- Tables:
--   forbes_global_2010_2014(assets double precision, company text, continent text, country text, industry text, marketvalue double precision, profits double precision, rank bigint, sales double precision, sector text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH continent_counts AS (
    SELECT
        continent,
        COUNT(*) AS num_companies,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM countries
    GROUP BY continent
)
SELECT
    continent,
    num_companies
FROM continent_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    continent,
    COUNT(*) AS num_companies
FROM countries
GROUP BY continent
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM countries
        GROUP BY continent
    ) sub
);
