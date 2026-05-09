-- ======================================================================
-- Find all provinces which produced more wines in 'winemag_p1' than they did in 'winemag_p2'
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10038
-- URL        : https://platform.stratascratch.com/coding/10038-find-all-provinces-which-produced-more-wines-in-winemag_p1-than-they-did-in-winemag_p2
-- ======================================================================

/*
Find all provinces which produced more wines in 'winemag_p1' than they did in 'winemag_p2'.
Output the province and the corresponding wine count.
Order records by the wine count in descending order.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH p1_counts AS (
    SELECT province, COUNT(*) AS p1_count
    FROM winemag_p1
    GROUP BY province
),
p2_counts AS (
    SELECT province, COUNT(*) AS p2_count
    FROM winemag_p2
    GROUP BY province
)
SELECT 
    p1.province,
    p1.p1_count AS wine_count
FROM p1_counts p1
LEFT JOIN p2_counts p2 ON p1.province = p2.province
WHERE p1.p1_count > COALESCE(p2.p2_count, 0)
ORDER BY p1.p1_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    province,
    COUNT(*) AS wine_count
FROM winemag_p1
GROUP BY province
HAVING COUNT(*) > (
    SELECT COUNT(*)
    FROM winemag_p2
    WHERE winemag_p2.province = winemag_p1.province
)
ORDER BY wine_count DESC;
