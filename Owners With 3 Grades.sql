-- ======================================================================
-- Owners With 3 Grades
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tripadvisor, City of Los Angeles
-- Access     : Premium
-- ID         : 9710
-- URL        : https://platform.stratascratch.com/coding/9710-owners-with-3-grades
-- ======================================================================

/*
Find the owners who have at least one facility with all 3 grades.
*/

-- Tables:
--   la_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assuming tables: owners(owner_id, ...) and facilities(facility_id, owner_id, grade)
-- Grades are assumed to be 'A', 'B', 'C' (or 1, 2, 3)

WITH facility_grades AS (
    SELECT
        owner_id,
        facility_id,
        COUNT(DISTINCT grade) AS grade_count
    FROM facilities
    GROUP BY owner_id, facility_id
)
SELECT DISTINCT owner_id
FROM facility_grades
WHERE grade_count = 3;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT owner_id
FROM facilities
GROUP BY owner_id, facility_id
HAVING COUNT(DISTINCT grade) = 3;
