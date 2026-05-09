-- ======================================================================
-- Find industries with the highest number of companies
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Forbes
-- Access     : Premium
-- ID         : 9797
-- URL        : https://platform.stratascratch.com/coding/9797-find-industries-with-the-highest-number-of-companies
-- ======================================================================

/*
Find industries with the highest number of companies.
Output the industry along with the number of companies.
Sort records based on the number of companies in descending order.
*/

-- Tables:
--   forbes_global_2010_2014(assets double precision, company text, continent text, country text, industry text, marketvalue double precision, profits double precision, rank bigint, sales double precision, sector text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

SELECT 
    industry,
    COUNT(*) AS number_of_companies
FROM companies
GROUP BY industry
ORDER BY number_of_companies DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    industry,
    (SELECT COUNT(*) FROM companies c2 WHERE c2.industry = c1.industry) AS number_of_companies
FROM companies c1
GROUP BY industry
ORDER BY number_of_companies DESC;
