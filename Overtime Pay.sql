-- ======================================================================
-- Overtime Pay
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9987
-- URL        : https://platform.stratascratch.com/coding/9987-overtime-pay
-- ======================================================================

/*
Find the employee who earned most from working overtime. Output the employee name.
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH overtime_earnings AS (
    SELECT 
        employee_name,
        SUM(overtime_hours * salary) AS total_overtime_pay,
        RANK() OVER (ORDER BY SUM(overtime_hours * salary) DESC) AS rnk
    FROM employee
    GROUP BY employee_name
)
SELECT employee_name
FROM overtime_earnings
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT employee_name
FROM employee
GROUP BY employee_name
HAVING SUM(overtime_hours * salary) = (
    SELECT MAX(total_ot)
    FROM (
        SELECT SUM(overtime_hours * salary) AS total_ot
        FROM employee
        GROUP BY employee_name
    ) sub
);
