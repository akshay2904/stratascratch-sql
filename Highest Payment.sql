-- ======================================================================
-- Highest Payment
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 10145
-- URL        : https://platform.stratascratch.com/coding/10145-make-a-pivot-table-to-find-the-highest-payment-in-each-year-for-each-employee
-- ======================================================================

/*
Make a pivot table to find the highest payment in each year for each employee.

Find payment details for 2011, 2012, 2013, and 2014.

Output payment details along with the corresponding employee name.

Order records by the employee name in ascending order
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH yearly_max AS (
    SELECT
        e.name,
        MAX(CASE WHEN EXTRACT(YEAR FROM p.date) = 2011 THEN p.amount END) AS "2011",
        MAX(CASE WHEN EXTRACT(YEAR FROM p.date) = 2012 THEN p.amount END) AS "2012",
        MAX(CASE WHEN EXTRACT(YEAR FROM p.date) = 2013 THEN p.amount END) AS "2013",
        MAX(CASE WHEN EXTRACT(YEAR FROM p.date) = 2014 THEN p.amount END) AS "2014"
    FROM ms_employee_salary e
    JOIN ms_payments p ON e.id = p.worker_id
    WHERE EXTRACT(YEAR FROM p.date) BETWEEN 2011 AND 2014
    GROUP BY e.name
)
SELECT *
FROM yearly_max
ORDER BY name ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e.name,
    MAX(CASE WHEN EXTRACT(YEAR FROM p.date) = 2011 THEN p.amount ELSE NULL END) AS "2011",
    MAX(CASE WHEN EXTRACT(YEAR FROM p.date) = 2012 THEN p.amount ELSE NULL END) AS "2012",
    MAX(CASE WHEN EXTRACT(YEAR FROM p.date) = 2013 THEN p.amount ELSE NULL END) AS "2013",
    MAX(CASE WHEN EXTRACT(YEAR FROM p.date) = 2014 THEN p.amount ELSE NULL END) AS "2014"
FROM ms_employee_salary e
JOIN ms_payments p
    ON e.id = p.worker_id
GROUP BY e.name
ORDER BY e.name ASC;
