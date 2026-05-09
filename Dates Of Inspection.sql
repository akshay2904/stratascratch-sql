-- ======================================================================
-- Dates Of Inspection
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9714
-- URL        : https://platform.stratascratch.com/coding/9714-dates-of-inspection
-- ======================================================================

/*
Find the latest inspection date for the most sanitary restaurant(s). Assume the most sanitary restaurant is the one with the highest number of points received in any inspection (not just the last one). Only businesses with 'restaurant' in the name should be considered in your analysis.




Output the corresponding facility name, inspection score, latest inspection date, previous inspection date, and the difference between the latest and previous inspection dates.




Order the records based on the latest inspection date in ascending order.
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH restaurant_inspections AS (
    -- Filter only restaurants
    SELECT 
        facility_name,
        score,
        date,
        -- Get the max score ever received per facility
        MAX(score) OVER (PARTITION BY facility_name) AS max_score_ever,
        -- Rank inspections by date to find latest and previous
        ROW_NUMBER() OVER (PARTITION BY facility_name ORDER BY date DESC) AS rn,
        LAG(date) OVER (PARTITION BY facility_name ORDER BY date) AS prev_date
    FROM inspections
    WHERE LOWER(facility_name) LIKE '%restaurant%'
),
max_score AS (
    -- Find the highest score across all restaurants
    SELECT MAX(max_score_ever) AS global_max
    FROM restaurant_inspections
),
most_sanitary AS (
    -- Get latest inspection row for top-scoring restaurants
    SELECT 
        ri.facility_name,
        ri.score,
        ri.date AS latest_date,
        ri.prev_date AS previous_date
    FROM restaurant_inspections ri
    JOIN max_score ms ON ri.max_score_ever = ms.global_max
    WHERE ri.rn = 1  -- latest inspection per facility
)
SELECT 
    facility_name,
    score AS inspection_score,
    latest_date,
    previous_date,
    (latest_date - previous_date) AS date_difference
FROM most_sanitary
ORDER BY latest_date ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH restaurant_only AS (
    SELECT *
    FROM inspections
    WHERE LOWER(facility_name) LIKE '%restaurant%'
),
max_score_per_facility AS (
    -- Highest score ever per facility
    SELECT facility_name, MAX(score) AS best_score
    FROM restaurant_only
    GROUP BY facility_name
),
global_max AS (
    -- The overall highest score among all restaurants
    SELECT MAX(best_score) AS top_score
    FROM max_score_per_facility
),
top_facilities AS (
    -- Facilities whose best score equals the global max
    SELECT msf.facility_name
    FROM max_score_per_facility msf
    JOIN global_max gm ON msf.best_score = gm.top_score
),
latest_per_facility AS (
    -- Latest inspection date per top facility
    SELECT ro.facility_name, MAX(ro.date) AS latest_date
    FROM restaurant_only ro
    JOIN top_facilities tf ON ro.facility_name = tf.facility_name
    GROUP BY ro.facility_name
),
previous_per_facility AS (
    -- Second latest inspection date per top facility
    SELECT ro.facility_name, MAX(ro.date) AS previous_date
    FROM restaurant_only ro
    JOIN latest_per_facility lf ON ro.facility_name = lf.facility_name
    WHERE ro.date < lf.latest_date
    GROUP BY ro.facility_name
)
SELECT 
    lf.facility_name,
    ro.score AS inspection_score,
    lf.latest_date,
    pf.previous_date,
    (lf.latest_date - pf.previous_date) AS date_difference
FROM latest_per_facility lf
JOIN restaurant_only ro 
    ON ro.facility_name = lf.facility_name 
    AND ro.date = lf.latest_date
LEFT JOIN previous_per_facility pf 
    ON pf.facility_name = lf.facility_name
ORDER BY lf.latest_date ASC;
