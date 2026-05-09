-- ======================================================================
-- Find Students At Median Writing
-- ======================================================================
-- Difficulty : Medium
-- Companies  : General Assembly, Kaplan, Google
-- Access     : Premium
-- ID         : 9610
-- URL        : https://platform.stratascratch.com/coding/9610-find-students-with-a-median-writing-score
-- ======================================================================

/*
Identify the IDs of students who scored exactly at the median for the SAT writing section.
*/

-- Tables:
--   sat_scores(average_sat double precision, hrs_studied double precision, id bigint, love double precision, sat_math double precision, sat_verbal double precision, sat_writing double precision, school text, student_id double precision, teacher text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        student_id,
        sat_writing,
        COUNT(*) OVER () AS total,
        ROW_NUMBER() OVER (ORDER BY sat_writing) AS rn_asc,
        ROW_NUMBER() OVER (ORDER BY sat_writing DESC) AS rn_desc
    FROM students
),
median_val AS (
    -- Median: average of middle value(s); here we find scores where position qualifies as median
    SELECT AVG(sat_writing) AS median_score
    FROM ranked
    WHERE rn_asc IN (total / 2 + 1, (total + 1) / 2 + (total % 2))
       OR (total % 2 = 1 AND rn_asc = (total + 1) / 2)
),
-- Simpler: use PERCENTILE_CONT for true median
median_clean AS (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sat_writing) AS median_score
    FROM students
)
SELECT s.student_id
FROM students s
JOIN median_clean m
  ON s.sat_writing = m.median_score;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT student_id
FROM students
WHERE sat_writing = (
    -- Compute median as average of the lower-middle and upper-middle values
    SELECT AVG(sat_writing)
    FROM (
        SELECT sat_writing
        FROM students
        ORDER BY sat_writing
        LIMIT 2 - (SELECT COUNT(*) FROM students) % 2          -- 1 row if odd, 2 if even
        OFFSET (SELECT (COUNT(*) - 1) / 2 FROM students)       -- skip to middle
    ) AS middle_values
);
