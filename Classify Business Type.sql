-- ======================================================================
-- Classify Business Type
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9726
-- URL        : https://platform.stratascratch.com/coding/9726-classify-business-type
-- ======================================================================

/*
Classify each business as either a restaurant, cafe, school, or other.




•	A restaurant should have the word 'restaurant' in the business name. This includes common international or accented variants, such as “restaurante”, “restauranté”, etc.

•	A cafe should have either 'cafe', 'café', or 'coffee' in the business name.

•	A school should have the word 'school' in the business name.

•	All other businesses should be classified as 'other'.

•   Ensure each business name appears only once in the final output. If multiple records exist for the same business, retain only one unique instance.




The final output should include only the distinct business names and their corresponding classifications.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH distinct_businesses AS (
    SELECT DISTINCT business_name
    FROM businesses
)
SELECT
    business_name,
    CASE
        WHEN business_name ~* 'restauran[t][eé]?'  THEN 'restaurant'
        WHEN business_name ~* 'caf[eé]|coffee'     THEN 'cafe'
        WHEN business_name ~* 'school'              THEN 'school'
        ELSE 'other'
    END AS classification
FROM distinct_businesses
ORDER BY business_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    business_name,
    CASE
        WHEN LOWER(business_name) LIKE '%restaurant%'
          OR LOWER(business_name) LIKE '%restaurante%'
          OR LOWER(business_name) LIKE '%restauranté%'
        THEN 'restaurant'
        WHEN LOWER(business_name) LIKE '%cafe%'
          OR LOWER(business_name) LIKE '%café%'
          OR LOWER(business_name) LIKE '%coffee%'
        THEN 'cafe'
        WHEN LOWER(business_name) LIKE '%school%'
        THEN 'school'
        ELSE 'other'
    END AS classification
FROM (
    SELECT business_name
    FROM businesses
    GROUP BY business_name  -- deduplication via GROUP BY
) AS unique_businesses
ORDER BY business_name;
