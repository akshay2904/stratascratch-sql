-- ======================================================================
-- Find the most popular sector in the Forbes list
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Forbes
-- Access     : Premium
-- ID         : 9796
-- URL        : https://platform.stratascratch.com/coding/9796-find-the-most-popular-sector-in-the-forbes-list
-- ======================================================================

/*
Find the most popular sector from the Forbes list based on the number of companies in each sector.
Output the sector along with the number of companies.
*/

-- Tables:
--   forbes_global_2010_2014(assets double precision, company text, continent text, country text, industry text, marketvalue double precision, profits double precision, rank bigint, sales double precision, sector text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH sector_counts AS (
    SELECT 
        sector,
        COUNT(*) AS num_companies,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM forbes_global_2010_2014
    WHERE sector IS NOT NULL
    GROUP BY sector
)
SELECT 
    sector,
    num_companies
FROM sector_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    sector,
    COUNT(*) AS num_companies
FROM forbes_global_2010_2014
WHERE sector IS NOT NULL
GROUP BY sector
HAVING COUNT(*) = (
    SELECT MAX(sector_count)
    FROM (
        SELECT COUNT(*) AS sector_count
        FROM forbes_global_2010_2014
        WHERE sector IS NOT NULL
        GROUP BY sector
    ) AS sub
);
