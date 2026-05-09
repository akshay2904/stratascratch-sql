-- ======================================================================
-- Class Performance
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Box
-- Access     : Premium
-- ID         : 10310
-- URL        : https://platform.stratascratch.com/coding/10310-class-performance
-- ======================================================================

/*
You are given a table containing assignment scores of students in a class. Write a query that identifies the largest difference in total score  of all assignments.
Output just the difference in total score (sum of all 3 assignments) between a student with the highest score and a student with the lowest score.
*/

-- Tables:
--   box_scores(assignment1 bigint, assignment2 bigint, assignment3 bigint, id bigint, student text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH total_scores AS (
    SELECT
        student_name,
        assignment1 + assignment2 + assignment3 AS total_score
    FROM scores
),
min_max AS (
    SELECT
        MAX(total_score) OVER () AS max_total,
        MIN(total_score) OVER () AS min_total
    FROM total_scores
    LIMIT 1
)
SELECT max_total - min_total AS score_difference
FROM min_max;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    (SELECT MAX(assignment1 + assignment2 + assignment3) FROM scores)
    -
    (SELECT MIN(assignment1 + assignment2 + assignment3) FROM scores)
    AS score_difference;
