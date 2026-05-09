-- ======================================================================
-- Find the country that has the most companies listed on Forbes
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Forbes
-- Access     : Premium
-- ID         : 9795
-- URL        : https://platform.stratascratch.com/coding/9795-find-the-country-that-has-the-most-companies-listed-on-forbes
-- ======================================================================

/*
Find the country that has the most companies listed on Forbes.

Output the country along with the number of companies.
*/

-- Tables:
--   forbes_global_2010_2014(assets double precision, company text, continent text, country text, industry text, marketvalue double precision, profits double precision, rank bigint, sales double precision, sector text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH country_counts AS (
    SELECT
        country,
        COUNT(*) AS num_companies,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM forbes_global_2010_2014
    GROUP BY country
)
SELECT country, num_companies
FROM country_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT country, COUNT(*) AS num_companies
FROM forbes_global_2010_2014
GROUP BY country
HAVING COUNT(*) = (
    SELECT MAX(company_count)
    FROM (
        SELECT COUNT(*) AS company_count
        FROM forbes_global_2010_2014
        GROUP BY country
    ) AS subq
);
