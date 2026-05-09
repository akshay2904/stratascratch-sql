-- ======================================================================
-- Find the variance and the standard deviation of scores that have grade A

-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9708
-- URL        : https://platform.stratascratch.com/coding/9708-find-the-variance-and-the-standard-deviation-of-scores-that-have-grade-a
-- ======================================================================

/*
Find the variance of scores that have grade A using the formula AVG((X_i - mean_x) ^ 2).
Output the result along with the corresponding standard deviation.
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH grade_a AS (
    SELECT 
        score,
        AVG(score) OVER () AS mean_score
    FROM grads
    WHERE grade = 'A'
),
variance_calc AS (
    SELECT
        AVG(POWER(score - mean_score, 2)) AS variance
    FROM grade_a
)
SELECT
    variance,
    SQRT(variance) AS standard_deviation
FROM variance_calc;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    AVG(POWER(score - (SELECT AVG(score) FROM grads WHERE grade = 'A'), 2)) AS variance,
    SQRT(AVG(POWER(score - (SELECT AVG(score) FROM grads WHERE grade = 'A'), 2))) AS standard_deviation
FROM grads
WHERE grade = 'A';
