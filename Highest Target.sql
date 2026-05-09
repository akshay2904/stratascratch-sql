-- ======================================================================
-- Highest Target
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Sears, Salesforce
-- Access     : Premium
-- ID         : 9904
-- URL        : https://platform.stratascratch.com/coding/9904-highest-target
-- ======================================================================

/*
Find the employee who has achieved the highest target.
Output the employee's first name along with the achieved target and the bonus.
*/

-- Tables:
--   employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT 
        e.first_name,
        s.target_achieved,
        s.bonus,
        RANK() OVER (ORDER BY s.target_achieved DESC) AS rnk
    FROM employee e
    JOIN sales s ON e.id = s.employee_id
)
SELECT first_name, target_achieved, bonus
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    e.first_name,
    s.target_achieved,
    s.bonus
FROM employee e
JOIN sales s ON e.id = s.employee_id
WHERE s.target_achieved = (
    SELECT MAX(target_achieved)
    FROM sales
);
