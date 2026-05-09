-- ======================================================================
-- Find the student with the highest efficiency for mathematics
-- ======================================================================
-- Difficulty : Medium
-- Companies  : General Assembly, Kaplan, Google
-- Access     : Premium
-- ID         : 9661
-- URL        : https://platform.stratascratch.com/coding/9661-find-the-student-with-the-highest-efficiency-for-mathematics
-- ======================================================================

/*
Find the student with the highest efficiency for mathematics?  Consider only students with at least 1 hour of studying.

The efficiency is defined as the score divided by hours studied.

Output the highest efficiency along with the other data of that student: student id, hours studies and the obtained score for mathematics.
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
        hours_studied,
        score,
        score::NUMERIC / hours_studied AS efficiency,
        RANK() OVER (ORDER BY score::NUMERIC / hours_studied DESC) AS rnk
    FROM student_performance
    WHERE subject = 'Mathematics'
      AND hours_studied >= 1
)
SELECT
    student_id,
    hours_studied,
    score,
    efficiency
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    student_id,
    hours_studied,
    score,
    score::NUMERIC / hours_studied AS efficiency
FROM student_performance
WHERE subject = 'Mathematics'
  AND hours_studied >= 1
  AND score::NUMERIC / hours_studied = (
      SELECT MAX(score::NUMERIC / hours_studied)
      FROM student_performance
      WHERE subject = 'Mathematics'
        AND hours_studied >= 1
  );
