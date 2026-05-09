-- ======================================================================
-- Income By Title and Gender
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Free
-- ID         : 10077
-- URL        : https://platform.stratascratch.com/coding/10077-income-by-title-and-gender
-- ======================================================================

/*
Find the average total compensation based on employee titles and gender. Total compensation is calculated by adding both the salary and bonus of each employee. However, not every employee receives a bonus so disregard employees without bonuses in your calculation. Employee can receive more than one bonus.

Output the employee title, gender (i.e., sex), along with the average total compensation.
*/

-- Tables:
--   sf_employee(address text, age bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)
--   sf_bonus(bonus bigint, worker_ref_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH employee_bonuses AS (
    -- Sum all bonuses per employee
    SELECT worker_ref_id, SUM(bonus) AS total_bonus
    FROM bonus
    GROUP BY worker_ref_id
),
total_comp AS (
    SELECT 
        e.worker_title,
        e.sex,
        e.salary + eb.total_bonus AS total_compensation
    FROM employee e
    INNER JOIN employee_bonuses eb ON e.worker_id = eb.worker_ref_id
)
SELECT 
    worker_title,
    sex,
    AVG(total_compensation) AS avg_total_compensation
FROM total_comp
GROUP BY worker_title, sex;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    e.worker_title,
    e.sex,
    AVG(e.salary + b.total_bonus) AS avg_total_compensation
FROM employee e
INNER JOIN (
    SELECT worker_ref_id, SUM(bonus) AS total_bonus
    FROM bonus
    GROUP BY worker_ref_id
) b ON e.worker_id = b.worker_ref_id
GROUP BY e.worker_title, e.sex;
