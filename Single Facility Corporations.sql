-- ======================================================================
-- Single Facility Corporations
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9694
-- URL        : https://platform.stratascratch.com/coding/9694-single-facility-corporations
-- ======================================================================

/*
Find all owners which have only a single facility. Output the owner_name and order the results alphabetically.
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH facility_counts AS (
    SELECT 
        owner_name,
        COUNT(*) OVER (PARTITION BY owner_name) AS facility_count
    FROM facilities
)
SELECT DISTINCT owner_name
FROM facility_counts
WHERE facility_count = 1
ORDER BY owner_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT owner_name
FROM facilities
GROUP BY owner_name
HAVING COUNT(*) = 1
ORDER BY owner_name;
