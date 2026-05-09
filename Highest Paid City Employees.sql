-- ======================================================================
-- Highest Paid City Employees
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9989
-- URL        : https://platform.stratascratch.com/coding/9989-highest-paid-city-employees
-- ======================================================================

/*
Find the top 2 highest paid City employees for each job title. Use totalpaybenefits column for their ranking. Output the job title along with the corresponding highest and second-highest paid employees.
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_employees AS (
    SELECT
        jobtitle,
        employeename,
        totalpaybenefits,
        ROW_NUMBER() OVER (PARTITION BY jobtitle ORDER BY totalpaybenefits DESC) AS rn
    FROM salaries
)
SELECT
    jobtitle,
    MAX(CASE WHEN rn = 1 THEN employeename END) AS highest_paid_employee,
    MAX(CASE WHEN rn = 2 THEN employeename END) AS second_highest_paid_employee
FROM ranked_employees
WHERE rn <= 2
GROUP BY jobtitle
ORDER BY jobtitle;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    s1.jobtitle,
    s1.employeename AS highest_paid_employee,
    s2.employeename AS second_highest_paid_employee
FROM salaries s1
-- Join to find the highest paid per job title
JOIN (
    SELECT jobtitle, MAX(totalpaybenefits) AS max_pay
    FROM salaries
    GROUP BY jobtitle
) top1 ON s1.jobtitle = top1.jobtitle AND s1.totalpaybenefits = top1.max_pay
-- Join to find the second highest paid per job title
LEFT JOIN salaries s2 ON s2.jobtitle = s1.jobtitle
    AND s2.totalpaybenefits = (
        SELECT MAX(totalpaybenefits)
        FROM salaries s3
        WHERE s3.jobtitle = s1.jobtitle
          AND s3.totalpaybenefits < top1.max_pay
    )
ORDER BY s1.jobtitle;
