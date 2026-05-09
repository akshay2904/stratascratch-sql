-- ======================================================================
-- Number Of Inspections By Zip
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9734
-- URL        : https://platform.stratascratch.com/coding/9734-number-of-inspections-by-zip
-- ======================================================================

/*
Find the number of inspections that happened in the municipality with postal code 94102 during January, May or November in each year.
Output the count of each month separately.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    COUNT(*) AS inspection_count
FROM sf_restaurant_health_violations
WHERE zip_code = '94102'
  AND EXTRACT(MONTH FROM date) IN (1, 5, 11)
GROUP BY
    EXTRACT(YEAR FROM date),
    EXTRACT(MONTH FROM date)
ORDER BY year, month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    year,
    month,
    COUNT(*) AS inspection_count
FROM (
    SELECT
        date,
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(MONTH FROM date) AS month
    FROM sf_restaurant_health_violations
    WHERE zip_code = '94102'
) subq
WHERE month IN (1, 5, 11)
GROUP BY year, month
ORDER BY year, month;
