-- ======================================================================
-- Facilities With Lots Of Inspections
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9711
-- URL        : https://platform.stratascratch.com/coding/9711-facilities-with-lots-of-inspections
-- ======================================================================

/*
Find the facility that got the highest number of inspections in 2017 compared to other years. Compare the number of inspections per year and output only facilities that had the number of inspections greater in 2017 than in any other year.
Each row in the dataset represents an inspection. Base your solution on the facility name and activity date fields.
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH yearly_counts AS (
    SELECT
        facility_name,
        EXTRACT(YEAR FROM activity_date) AS inspection_year,
        COUNT(*) AS num_inspections
    FROM inspections
    GROUP BY facility_name, EXTRACT(YEAR FROM activity_date)
),
ranked AS (
    SELECT
        facility_name,
        inspection_year,
        num_inspections,
        -- Max inspections in any year OTHER than 2017
        MAX(CASE WHEN inspection_year <> 2017 THEN num_inspections END)
            OVER (PARTITION BY facility_name) AS max_other_years
    FROM yearly_counts
)
SELECT
    facility_name,
    num_inspections AS inspections_2017
FROM ranked
WHERE inspection_year = 2017
  AND num_inspections > COALESCE(max_other_years, 0);

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    facility_name,
    COUNT(*) AS inspections_2017
FROM inspections
WHERE EXTRACT(YEAR FROM activity_date) = 2017
GROUP BY facility_name
HAVING COUNT(*) > ALL (
    -- Count of inspections for the same facility in every other year
    SELECT COUNT(*)
    FROM inspections i2
    WHERE i2.facility_name = inspections.facility_name
      AND EXTRACT(YEAR FROM i2.activity_date) <> 2017
    GROUP BY EXTRACT(YEAR FROM i2.activity_date)
);
