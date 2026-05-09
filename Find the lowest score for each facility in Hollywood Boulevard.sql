-- ======================================================================
-- Find the lowest score for each facility in Hollywood Boulevard
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco, City of Los Angeles, Tripadvisor
-- Access     : Premium
-- ID         : 10180
-- URL        : https://platform.stratascratch.com/coding/10180-find-the-lowest-score-for-each-facility-in-hollywood-boulevard
-- ======================================================================

/*
Find the lowest score per each facility in Hollywood Boulevard.
Output the result along with the corresponding facility name.
Order the result based on the lowest score in descending order and the facility name in the ascending order.
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        facility_name,
        score,
        ROW_NUMBER() OVER (PARTITION BY facility_name ORDER BY score ASC) AS rn
    FROM los_angeles_restaurant_health_inspections
    WHERE facility_address ILIKE '%hollywood blvd%'
)
SELECT facility_name, score AS lowest_score
FROM ranked
WHERE rn = 1
ORDER BY lowest_score DESC, facility_name ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    facility_name,
    MIN(score) AS lowest_score
FROM los_angeles_restaurant_health_inspections
WHERE facility_address ILIKE '%hollywood blvd%'
GROUP BY facility_name
ORDER BY lowest_score DESC, facility_name ASC;
