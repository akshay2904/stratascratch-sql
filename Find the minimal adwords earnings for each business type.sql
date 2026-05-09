-- ======================================================================
-- Find the minimal adwords earnings for each business type
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 9811
-- URL        : https://platform.stratascratch.com/coding/9811-find-the-minimal-adwords-earnings-for-each-business-type
-- ======================================================================

/*
Find the minimal adwords earnings for each business type.

Output the business type along with the minimal earning.
*/

-- Tables:
--   google_adwords_earnings(adwords_earnings bigint, business_name text, business_type text, n_employees bigint, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    business_type,
    MIN(adwords_earnings) AS min_adwords_earnings
FROM twitter_ads
GROUP BY business_type;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    t1.business_type,
    t1.adwords_earnings
FROM twitter_ads t1
WHERE t1.adwords_earnings = (
    SELECT MIN(t2.adwords_earnings)
    FROM twitter_ads t2
    WHERE t2.business_type = t1.business_type
)
GROUP BY t1.business_type, t1.adwords_earnings;
