-- ======================================================================
-- Find the number of violations that each school had
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9727
-- URL        : https://platform.stratascratch.com/coding/9727-find-the-number-of-violations-that-each-school-had
-- ======================================================================

/*
Find the number of violations that each school had. Any inspection is considered a violation if its risk category is not null.
Output the corresponding business name along with the result.
Order the result based on the number of violations in descending order.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    business_name,
    COUNT(*) AS number_of_violations
FROM inspections
WHERE risk_category IS NOT NULL
GROUP BY business_name
ORDER BY number_of_violations DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    business_name,
    (
        SELECT COUNT(*)
        FROM inspections i2
        WHERE i2.business_name = i1.business_name
          AND i2.risk_category IS NOT NULL
    ) AS number_of_violations
FROM inspections i1
WHERE risk_category IS NOT NULL
GROUP BY business_name
ORDER BY number_of_violations DESC;
