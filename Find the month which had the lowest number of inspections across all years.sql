-- ======================================================================
-- Find the month which had the lowest number of inspections across all years
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9706
-- URL        : https://platform.stratascratch.com/coding/9706-find-the-month-which-had-the-lowest-number-of-inspections-for-fish-markets-across-all-years
-- ======================================================================

/*
Find the month which had the lowest number of inspections across all years.
Output the number of inspections along with the month.
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_counts AS (
    SELECT
        EXTRACT(MONTH FROM inspection_date) AS month,
        COUNT(*) AS num_inspections,
        RANK() OVER (ORDER BY COUNT(*)) AS rnk
    FROM
        inspections
    GROUP BY
        EXTRACT(MONTH FROM inspection_date)
)
SELECT
    month,
    num_inspections
FROM
    monthly_counts
WHERE
    rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(MONTH FROM inspection_date) AS month,
    COUNT(*) AS num_inspections
FROM
    inspections
GROUP BY
    EXTRACT(MONTH FROM inspection_date)
HAVING
    COUNT(*) = (
        SELECT MIN(monthly_total)
        FROM (
            SELECT COUNT(*) AS monthly_total
            FROM inspections
            GROUP BY EXTRACT(MONTH FROM inspection_date)
        ) AS sub
    );
