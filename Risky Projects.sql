-- ======================================================================
-- Risky Projects
-- ======================================================================
-- Difficulty : Medium
-- Companies  : LinkedIn
-- Access     : Free
-- ID         : 10304
-- URL        : https://platform.stratascratch.com/coding/10304-risky-projects
-- ======================================================================

/*
You are given a set of projects and employee data. Each project has a name, a budget, and a specific duration, while each employee has an annual salary and may be assigned to one or more projects for particular periods. The task is to identify which projects are overbudget. A project is considered overbudget if the prorated cost of all employees assigned to it exceeds the project’s budget.




To solve this, you must prorate each employee's annual salary based on the exact period they work on a given project, relative to a full year. For example, if an employee works on a six-month project, only half of their annual salary should be attributed to that project. Sum these prorated salary amounts for all employees assigned to a project and compare the total with the project’s budget.




Your output should be a list of overbudget projects, where each entry includes the project’s name, its budget, and the total prorated employee expenses for that project. The total expenses should be rounded up to the nearest dollar. Assume all years have 365 days and disregard leap years.
*/

-- Tables:
--   linkedin_projects(budget bigint, end_date date, id bigint, start_date date, title text)
--   linkedin_emp_projects(emp_id bigint, project_id bigint)
--   linkedin_employees(first_name text, id bigint, last_name text, salary bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH project_costs AS (
    SELECT
        p.project_id,
        p.name                                          AS project_name,
        p.budget,
        -- Sum prorated salaries: (days worked / 365) * annual_salary
        CEIL(
            SUM(
                e.salary
                * (p.end_date - p.start_date)::numeric  -- project duration in days
                / 365.0
            )
        )                                               AS total_expenses
    FROM projects   p
    JOIN assignments a ON a.project_id = p.project_id
    JOIN employees   e ON e.employee_id = a.employee_id
    GROUP BY p.project_id, p.name, p.budget
)
SELECT
    project_name,
    budget,
    total_expenses
FROM project_costs
WHERE total_expenses > budget
ORDER BY project_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    p.name                                              AS project_name,
    p.budget,
    CEIL(
        SUM(
            e.salary
            * (p.end_date - p.start_date)::numeric
            / 365.0
        )
    )                                                   AS total_expenses
FROM projects   p
JOIN assignments a ON a.project_id = p.project_id
JOIN employees   e ON e.employee_id = a.employee_id
GROUP BY p.project_id, p.name, p.budget
HAVING
    CEIL(
        SUM(
            e.salary
            * (p.end_date - p.start_date)::numeric
            / 365.0
        )
    ) > p.budget
ORDER BY p.name;
