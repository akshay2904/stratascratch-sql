-- ======================================================================
-- Find the 80th percentile of hours studied
-- ======================================================================
-- Difficulty : Medium
-- Companies  : General Assembly, Kaplan, Google
-- Access     : Premium
-- ID         : 9611
-- URL        : https://platform.stratascratch.com/coding/9611-find-the-80th-percentile-of-hours-studied
-- ======================================================================

/*
Find the 80th percentile of hours studied. Output hours studied value at specified percentile.
*/

-- Tables:
--   sat_scores(average_sat double precision, hrs_studied double precision, id bigint, love double precision, sat_math double precision, sat_verbal double precision, sat_writing double precision, school text, student_id double precision, teacher text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY hours_studied) AS percentile_80
FROM students;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT hours_studied AS percentile_80
FROM (
    SELECT 
        hours_studied,
        -- Calculate the row number and total count manually
        ROW_NUMBER() OVER (ORDER BY hours_studied) AS rn,
        COUNT(*) OVER () AS total_count
    FROM students
) ranked
WHERE rn = CEIL(0.80 * total_count)
ORDER BY hours_studied
LIMIT 1;
