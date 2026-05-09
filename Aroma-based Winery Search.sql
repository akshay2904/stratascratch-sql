-- ======================================================================
-- Aroma-based Winery Search.
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10026
-- URL        : https://platform.stratascratch.com/coding/10026-find-all-wineries-which-produce-wines-by-possessing-aromas-of-plum-cherry-rose-or-hazelnut
-- ======================================================================

/*
Find wineries producing wines with aromas of plum, cherry, rose, or hazelnut (singular form only). To make things simpler, exclude any wine descriptions that contain the plural forms (ex. cherries).
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH aroma_wines AS (
    SELECT DISTINCT winery
    FROM winemag_p1
    WHERE 
        description ILIKE '%plum%'
        OR description ILIKE '%cherry%'
        OR description ILIKE '%rose%'
        OR description ILIKE '%hazelnut%'
),
excluded_wineries AS (
    SELECT DISTINCT winery
    FROM winemag_p1
    WHERE 
        description ILIKE '%plums%'
        OR description ILIKE '%cherries%'
        OR description ILIKE '%roses%'
        OR description ILIKE '%hazelnuts%'
)
SELECT aw.winery
FROM aroma_wines aw
WHERE aw.winery NOT IN (SELECT winery FROM excluded_wineries);

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT winery
FROM winemag_p1
WHERE (
    description ILIKE '%plum%'
    OR description ILIKE '%cherry%'
    OR description ILIKE '%rose%'
    OR description ILIKE '%hazelnut%'
)
AND description NOT ILIKE '%plums%'
AND description NOT ILIKE '%cherries%'
AND description NOT ILIKE '%roses%'
AND description NOT ILIKE '%hazelnuts%';
