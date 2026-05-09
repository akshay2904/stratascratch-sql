-- ======================================================================
-- 3rd Most Reported Health Issues
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9701
-- URL        : https://platform.stratascratch.com/coding/9701-3rd-most-reported-health-issues
-- ======================================================================

/*
Each record in the table represents a reported health issue, with each issue classified based on facility type and risk score, which are combined in the pe_description column.




Filter the dataset to include only businesses whose names contain "Cafe", "Tea", or "Juice", then identify the "facility type - risk score" classification that ranks 3rd in frequency. If multiple classifications are tied for 3rd place, include all of them.




Finally, return the names of the businesses that belong to the identified classification(s).
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH filtered AS (
    SELECT business_name, pe_description
    FROM inspections
    WHERE business_name ILIKE '%Cafe%'
       OR business_name ILIKE '%Tea%'
       OR business_name ILIKE '%Juice%'
),
freq AS (
    SELECT
        pe_description,
        COUNT(*) AS cnt,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM filtered
    GROUP BY pe_description
),
third_place AS (
    SELECT pe_description
    FROM freq
    WHERE rnk = 3
)
SELECT DISTINCT f.business_name
FROM filtered f
JOIN third_place t ON f.pe_description = t.pe_description
ORDER BY f.business_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH filtered AS (
    SELECT business_name, pe_description
    FROM inspections
    WHERE business_name ILIKE '%Cafe%'
       OR business_name ILIKE '%Tea%'
       OR business_name ILIKE '%Juice%'
),
freq AS (
    SELECT pe_description, COUNT(*) AS cnt
    FROM filtered
    GROUP BY pe_description
),
-- Find the 3rd highest distinct frequency value
third_cnt AS (
    SELECT cnt
    FROM (
        SELECT DISTINCT cnt
        FROM freq
        ORDER BY cnt DESC
        LIMIT 3
    ) ranked
    ORDER BY cnt ASC
    LIMIT 1
),
third_place AS (
    SELECT pe_description
    FROM freq
    WHERE cnt = (SELECT cnt FROM third_cnt)
)
SELECT DISTINCT business_name
FROM filtered
WHERE pe_description IN (SELECT pe_description FROM third_place)
ORDER BY business_name;
