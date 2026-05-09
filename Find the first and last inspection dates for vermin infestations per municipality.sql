-- ======================================================================
-- Find the first and last inspection dates for vermin infestations per municipality
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9732
-- URL        : https://platform.stratascratch.com/coding/9732-find-the-first-and-last-inspection-dates-for-vermin-infestations-per-municipality
-- ======================================================================

/*
Find the first and last inspections for vermin infestations per municipality.

Output the result along with the business postal code.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT DISTINCT
    municipality,
    postal_code,
    FIRST_VALUE(inspection_date) OVER (
        PARTITION BY municipality ORDER BY inspection_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_inspection,
    FIRST_VALUE(inspection_date) OVER (
        PARTITION BY municipality ORDER BY inspection_date DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_inspection
FROM inspections
WHERE LOWER(violation_description) LIKE '%vermin%'
   OR LOWER(violation_description) LIKE '%infestation%';

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    i.municipality,
    i.postal_code,
    agg.first_inspection,
    agg.last_inspection
FROM (
    SELECT
        municipality,
        MIN(inspection_date) AS first_inspection,
        MAX(inspection_date) AS last_inspection
    FROM inspections
    WHERE LOWER(violation_description) LIKE '%vermin%'
       OR LOWER(violation_description) LIKE '%infestation%'
    GROUP BY municipality
) agg
JOIN inspections i
    ON i.municipality = agg.municipality
   AND (
       i.inspection_date = agg.first_inspection
       OR i.inspection_date = agg.last_inspection
   )
WHERE LOWER(i.violation_description) LIKE '%vermin%'
   OR LOWER(i.violation_description) LIKE '%infestation%'
GROUP BY i.municipality, i.postal_code, agg.first_inspection, agg.last_inspection;
