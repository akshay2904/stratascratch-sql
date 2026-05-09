-- ======================================================================
-- Find the first and last times the maximum score was awarded
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9712
-- URL        : https://platform.stratascratch.com/coding/9712-find-the-first-and-last-times-the-maximum-score-was-awarded
-- ======================================================================

/*
Find the first and last times the maximum score was awarded
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH score_stats AS (
    SELECT
        MAX(score) AS max_score
    FROM scores
),
ranked AS (
    SELECT
        s.score,
        s.awarded_at,
        MIN(s.awarded_at) OVER () AS first_time,
        MAX(s.awarded_at) OVER () AS last_time
    FROM scores s
    JOIN score_stats ss ON s.score = ss.max_score
)
SELECT DISTINCT
    score         AS max_score,
    first_time    AS first_awarded,
    last_time     AS last_awarded
FROM ranked;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    score                   AS max_score,
    MIN(awarded_at)         AS first_awarded,
    MAX(awarded_at)         AS last_awarded
FROM scores
WHERE score = (
    SELECT MAX(score)
    FROM scores
)
GROUP BY score;
