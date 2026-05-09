-- ======================================================================
-- Find the number of complaints that ended in a violation
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9733
-- URL        : https://platform.stratascratch.com/coding/9733-find-the-number-of-complaints-that-ended-in-a-violation
-- ======================================================================

/*
Find the number of complaints that ended in a violation.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT COUNT(*) AS violation_complaint_count
FROM complaints
WHERE result = 'Violation';

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT SUM(complaint_count) AS violation_complaint_count
FROM (
    SELECT COUNT(*) AS complaint_count
    FROM complaints
    WHERE result = 'Violation'
    GROUP BY result
) AS sub;
