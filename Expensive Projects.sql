-- ======================================================================
-- Expensive Projects
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Microsoft
-- Access     : Premium
-- ID         : 10301
-- URL        : https://platform.stratascratch.com/coding/10301-expensive-projects
-- ======================================================================

/*
Given a list of projects and employees mapped to each project, calculate by the amount of project budget allocated to each employee . The output should include the project title and the project budget rounded to the closest integer. Order your list by projects with the highest budget per employee first.
*/

-- Tables:
--   ms_projects(budget bigint, id bigint, title text)
--   ms_emp_projects(emp_id bigint, project_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH employee_counts AS (
    SELECT 
        project_id,
        COUNT(employee_id) AS emp_count
    FROM ms_emp_projects
    GROUP BY project_id
)
SELECT 
    p.title,
    ROUND(p.budget::NUMERIC / ec.emp_count) AS budget_per_employee
FROM ms_projects p
JOIN employee_counts ec ON p.id = ec.project_id
ORDER BY budget_per_employee DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    p.title,
    ROUND(p.budget::NUMERIC / COUNT(ep.employee_id)) AS budget_per_employee
FROM ms_projects p
JOIN ms_emp_projects ep ON p.id = ep.project_id
GROUP BY p.id, p.title, p.budget
ORDER BY budget_per_employee DESC;
