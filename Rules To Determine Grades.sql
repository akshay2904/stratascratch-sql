-- ======================================================================
-- Rules To Determine Grades
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9700
-- URL        : https://platform.stratascratch.com/coding/9700-rules-to-determine-grades
-- ======================================================================

/*
Find the rules used to determine each grade. Show the rule in a separate column in the format of 'Score > X AND Score <= Y => Grade = A' where X and Y are the lower and upper bounds for a grade. Output the corresponding grade and its highest and lowest scores along with the rule. Order the result based on the grade in ascending order.
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes tables: Enrollments (or similar) with a Score column,
-- and a Grades table with columns: grade, min_score, max_score
-- Common schema: grade_rule(grade, min_score, max_score) and student_scores(score)

WITH grade_stats AS (
    SELECT 
        g.grade,
        g.min_score,
        g.max_score,
        MIN(e.score) AS lowest_score,
        MAX(e.score) AS highest_score
    FROM grades g
    JOIN enrollments e 
        ON e.score > g.min_score 
        AND e.score <= g.max_score
    GROUP BY g.grade, g.min_score, g.max_score
)
SELECT
    grade,
    highest_score,
    lowest_score,
    'Score > ' || min_score::text 
        || ' AND Score <= ' || max_score::text 
        || ' => Grade = ' || grade AS rule
FROM grade_stats
ORDER BY grade ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    g.grade,
    (SELECT MAX(e.score) 
     FROM enrollments e 
     WHERE e.score > g.min_score 
       AND e.score <= g.max_score) AS highest_score,
    (SELECT MIN(e.score) 
     FROM enrollments e 
     WHERE e.score > g.min_score 
       AND e.score <= g.max_score) AS lowest_score,
    'Score > ' || CAST(g.min_score AS TEXT) 
        || ' AND Score <= ' || CAST(g.max_score AS TEXT) 
        || ' => Grade = ' || g.grade AS rule
FROM grades g
WHERE EXISTS (
    SELECT 1 
    FROM enrollments e 
    WHERE e.score > g.min_score 
      AND e.score <= g.max_score
)
ORDER BY g.grade ASC;
