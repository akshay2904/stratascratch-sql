-- ======================================================================
-- Most Checkins
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Yelp
-- Access     : Premium
-- ID         : 10053
-- URL        : https://platform.stratascratch.com/coding/10053-most-checkins
-- ======================================================================

/*
Find the top 5 businesses with the most check-ins.
Output the business id along with the number of check-ins.
*/

-- Tables:
--   yelp_checkin(business_id text, checkins bigint, hour text, weekday text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH checkin_counts AS (
    SELECT 
        business_id,
        COUNT(*) AS checkin_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM checkins
    GROUP BY business_id
)
SELECT 
    business_id,
    checkin_count
FROM checkin_counts
WHERE rnk <= 5
ORDER BY checkin_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    business_id,
    COUNT(*) AS checkin_count
FROM checkins
GROUP BY business_id
ORDER BY checkin_count DESC
LIMIT 5;
