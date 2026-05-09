-- ======================================================================
-- Inspections Per Risk Category
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9729
-- URL        : https://platform.stratascratch.com/coding/9729-inspections-per-risk-category
-- ======================================================================

/*
Count the number of inspections per each risk category.
Categorize records with null values under the 'No Risk' category.

Sort the result based on the number of inspections in descending order.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    COALESCE(risk, 'No Risk') AS risk_category,
    COUNT(*) AS number_of_inspections
FROM food_inspections
GROUP BY risk_category
ORDER BY number_of_inspections DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    risk_category,
    COUNT(*) AS number_of_inspections
FROM (
    SELECT
        CASE
            WHEN risk IS NULL THEN 'No Risk'
            ELSE risk
        END AS risk_category
    FROM food_inspections
) AS categorized
GROUP BY risk_category
ORDER BY number_of_inspections DESC;
