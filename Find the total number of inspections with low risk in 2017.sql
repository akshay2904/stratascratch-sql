-- ======================================================================
-- Find the total number of inspections with low risk in 2017
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9705
-- URL        : https://platform.stratascratch.com/coding/9705-find-the-total-number-of-inspections-with-low-risk-in-2017
-- ======================================================================

/*
Find the total number of inspections with low risk in 2017.
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT COUNT(*) AS total_low_risk_inspections
FROM inspections
WHERE risk = 'Low'
  AND EXTRACT(YEAR FROM inspection_date) = 2017;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT COUNT(*) AS total_low_risk_inspections
FROM (
    SELECT *
    FROM inspections
    WHERE risk = 'Low'
      AND inspection_date >= '2017-01-01'
      AND inspection_date < '2018-01-01'
) AS low_risk_2017;
