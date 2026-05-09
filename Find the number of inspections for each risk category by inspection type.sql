-- ======================================================================
-- Find the number of inspections for each risk category by inspection type
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Free
-- ID         : 10130
-- URL        : https://platform.stratascratch.com/coding/10130-find-the-number-of-inspections-for-each-risk-category-by-inspection-type
-- ======================================================================

/*
Find the number of inspections that resulted in each risk category per each inspection type.

Consider the records with no risk category value belongs to a separate category.

Output the result along with the corresponding inspection type and the corresponding total number of inspections per that type. The output should be pivoted, meaning that each risk category + total number should be a separate column.

Order the result based on the number of inspections per inspection type in descending order.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH base AS (
    SELECT
        inspection_type,
        -- Treat NULL or empty risk category as 'No Category'
        CASE 
            WHEN risk IS NULL OR TRIM(risk) = '' THEN 'No Category'
            ELSE risk
        END AS risk_category
    FROM food_inspections
),
counts AS (
    SELECT
        inspection_type,
        risk_category,
        COUNT(*) AS cnt,
        SUM(COUNT(*)) OVER (PARTITION BY inspection_type) AS total_inspections
    FROM base
    GROUP BY inspection_type, risk_category
)
SELECT
    inspection_type,
    SUM(CASE WHEN risk_category = 'Risk 1 (High)'   THEN cnt ELSE 0 END) AS "Risk 1 (High)",
    SUM(CASE WHEN risk_category = 'Risk 2 (Medium)' THEN cnt ELSE 0 END) AS "Risk 2 (Medium)",
    SUM(CASE WHEN risk_category = 'Risk 3 (Low)'    THEN cnt ELSE 0 END) AS "Risk 3 (Low)",
    SUM(CASE WHEN risk_category = 'No Category'     THEN cnt ELSE 0 END) AS "No Category",
    MAX(total_inspections) AS total_inspections
FROM counts
GROUP BY inspection_type
ORDER BY total_inspections DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    inspection_type,
    SUM(CASE 
            WHEN risk IS NULL OR TRIM(risk) = '' THEN 0
            WHEN risk = 'Risk 1 (High)' THEN 1 
            ELSE 0 
        END) AS "Risk 1 (High)",
    SUM(CASE 
            WHEN risk IS NULL OR TRIM(risk) = '' THEN 0
            WHEN risk = 'Risk 2 (Medium)' THEN 1 
            ELSE 0 
        END) AS "Risk 2 (Medium)",
    SUM(CASE 
            WHEN risk IS NULL OR TRIM(risk) = '' THEN 0
            WHEN risk = 'Risk 3 (Low)' THEN 1 
            ELSE 0 
        END) AS "Risk 3 (Low)",
    SUM(CASE 
            WHEN risk IS NULL OR TRIM(risk) = '' THEN 1 
            ELSE 0 
        END) AS "No Category",
    COUNT(*) AS total_inspections
FROM food_inspections
GROUP BY inspection_type
ORDER BY total_inspections DESC;
