-- ======================================================================
-- Find all businesses whose lowest and highest inspection scores are different
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9731
-- URL        : https://platform.stratascratch.com/coding/9731-find-all-businesses-whose-lowest-and-highest-inspection-scores-are-different
-- ======================================================================

/*
Find all businesses whose lowest and highest inspection scores are different.

Output the corresponding business name and the lowest and highest scores of each business. HINT: you can assume there are no different businesses that share the same business name

Order the result based on the business name in ascending order.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH score_stats AS (
    SELECT
        business_name,
        MIN(score) OVER (PARTITION BY business_name) AS min_score,
        MAX(score) OVER (PARTITION BY business_name) AS max_score
    FROM sf_restaurant_health_violations
    WHERE score IS NOT NULL
)
SELECT DISTINCT
    business_name,
    min_score,
    max_score
FROM score_stats
WHERE min_score <> max_score
ORDER BY business_name ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    business_name,
    MIN(score) AS min_score,
    MAX(score) AS max_score
FROM sf_restaurant_health_violations
WHERE score IS NOT NULL
GROUP BY business_name
HAVING MIN(score) <> MAX(score)
ORDER BY business_name ASC;
