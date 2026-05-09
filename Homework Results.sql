-- ======================================================================
-- Homework Results
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Allstate
-- Access     : Premium
-- ID         : 2075
-- URL        : https://platform.stratascratch.com/coding/2075-homework-results
-- ======================================================================

/*
Given the homework results of a group of students, calculate the average grade and the completion rate of each student. A homework is considered not completed if no grade has been assigned.
Output first name of a student, their average grade, and completion rate in percentages. Note that it's possible for several students to have the same first name but their results should still be shown separately.
*/

-- Tables:
--   allstate_homework(grade double precision, homework_id bigint, student_id bigint)
--   allstate_students(student_firstname text, student_id bigint, student_lastname text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes tables: students(id, first_name, ...), homeworks(id, student_id, grade, ...)
-- grade IS NULL means homework not completed

WITH student_stats AS (
    SELECT
        s.id AS student_id,
        s.first_name,
        AVG(h.grade)                                                         AS average_grade,
        COUNT(h.grade) * 100.0 / NULLIF(COUNT(*), 0)                        AS completion_rate
    FROM students s
    LEFT JOIN homeworks h ON s.id = h.student_id
    GROUP BY s.id, s.first_name
)
SELECT
    first_name,
    ROUND(average_grade, 2)    AS average_grade,
    ROUND(completion_rate, 2)  AS completion_rate
FROM student_stats
ORDER BY student_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- COUNT(grade) ignores NULLs, so it counts only completed homeworks
-- COUNT(*) counts all homework entries for the student

SELECT
    s.first_name,
    ROUND(
        (SELECT AVG(h2.grade)
         FROM homeworks h2
         WHERE h2.student_id = s.id),
        2
    )                                                                        AS average_grade,
    ROUND(
        (SELECT COUNT(h3.grade) * 100.0 / NULLIF(COUNT(*), 0)
         FROM homeworks h3
         WHERE h3.student_id = s.id),
        2
    )                                                                        AS completion_rate
FROM students s
ORDER BY s.id;
