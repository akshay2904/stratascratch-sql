-- ======================================================================
-- Find the top 5 least paid employees for each job title
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9986
-- URL        : https://platform.stratascratch.com/coding/9986-find-the-top-5-least-paid-employees-for-each-job-title
-- ======================================================================

/*
Find the top 5 least paid employees for each job title.
Output the employee name, job title and total pay with benefits for the first 5 least paid employees. Avoid gaps in ranking.
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
        employeename,
        jobtitle,
        totalpaybenefits,
        DENSE_RANK() OVER (
            PARTITION BY jobtitle 
            ORDER BY totalpaybenefits ASC
        ) AS pay_rank
    FROM salaries
)
SELECT 
    employeename,
    jobtitle,
    totalpaybenefits
FROM ranked_employees
WHERE pay_rank <= 5
ORDER BY jobtitle, totalpaybenefits ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    s1.employeename,
    s1.jobtitle,
    s1.totalpaybenefits
FROM salaries s1
WHERE (
    -- Count how many distinct pay values are lower than this employee's pay
    -- within the same job title; if fewer than 5, this employee is in top 5 least paid
    SELECT COUNT(DISTINCT s2.totalpaybenefits)
    FROM salaries s2
    WHERE s2.jobtitle = s1.jobtitle
      AND s2.totalpaybenefits < s1.totalpaybenefits
) < 5
ORDER BY jobtitle, totalpaybenefits ASC;
