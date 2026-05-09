-- ======================================================================
-- Find the number of police officers, firefighters, and medical staff employees
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9977
-- URL        : https://platform.stratascratch.com/coding/9977-find-the-number-of-police-officers-firefighters-and-medical-staff-employees
-- ======================================================================

/*
Find the number of police officers (job title contains substring police), firefighters (job title contains substring fire), and medical staff employees (job title contains substring medical) based on the employee name.

Output each job title along with the corresponding number of employees.
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH categorized AS (
    SELECT
        CASE
            WHEN LOWER(job_title) LIKE '%police%' THEN 'police'
            WHEN LOWER(job_title) LIKE '%fire%'   THEN 'firefighter'
            WHEN LOWER(job_title) LIKE '%medical%' THEN 'medical'
        END AS category
    FROM employee
    WHERE LOWER(job_title) LIKE '%police%'
       OR LOWER(job_title) LIKE '%fire%'
       OR LOWER(job_title) LIKE '%medical%'
)
SELECT
    category AS job_title,
    COUNT(*) AS num_employees
FROM categorized
GROUP BY category
ORDER BY category;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 'police' AS job_title,
       COUNT(*) AS num_employees
FROM employee
WHERE LOWER(job_title) LIKE '%police%'

UNION ALL

SELECT 'firefighter' AS job_title,
       COUNT(*) AS num_employees
FROM employee
WHERE LOWER(job_title) LIKE '%fire%'

UNION ALL

SELECT 'medical' AS job_title,
       COUNT(*) AS num_employees
FROM employee
WHERE LOWER(job_title) LIKE '%medical%'

ORDER BY job_title;
