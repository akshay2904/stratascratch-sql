-- ======================================================================
-- Employees Without Benefits
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9981
-- URL        : https://platform.stratascratch.com/coding/9981-employees-without-benefits
-- ======================================================================

/*
Find the ratio between the number of employees without benefits to total employees. Output the job title, number of employees without benefits, total employees relevant to that job title, and the corresponding ratio. Order records based on the ratio in ascending order.
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH job_stats AS (
    SELECT
        job_title,
        COUNT(*) FILTER (WHERE benefits IS NULL OR benefits = '') AS no_benefits_count,
        COUNT(*) AS total_count
    FROM linkedin_jobs
    GROUP BY job_title
)
SELECT
    job_title,
    no_benefits_count,
    total_count,
    ROUND(no_benefits_count::NUMERIC / total_count, 2) AS ratio
FROM job_stats
ORDER BY ratio ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    job_title,
    SUM(CASE WHEN benefits IS NULL OR benefits = '' THEN 1 ELSE 0 END) AS no_benefits_count,
    COUNT(*) AS total_count,
    ROUND(
        SUM(CASE WHEN benefits IS NULL OR benefits = '' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*),
        2
    ) AS ratio
FROM linkedin_jobs
GROUP BY job_title
ORDER BY ratio ASC;
