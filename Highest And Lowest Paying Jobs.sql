-- ======================================================================
-- Highest And Lowest Paying Jobs
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9984
-- URL        : https://platform.stratascratch.com/coding/9984-highest-and-lowest-paying-jobs
-- ======================================================================

/*
Find the ratio and the difference between the highest and lowest total pay for each job title.  Another condition is to remove rows total pay equal to zero from the calculation. Output the job title along with the corresponding difference, ratio, highest total pay, and the lowest total pay. Sort records based on the ratio in descending order.
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH pay_stats AS (
    SELECT 
        job_title,
        MAX(total_pay) OVER (PARTITION BY job_title) AS highest_pay,
        MIN(total_pay) OVER (PARTITION BY job_title) AS lowest_pay
    FROM sf_salaries
    WHERE total_pay <> 0
),
distinct_stats AS (
    SELECT DISTINCT
        job_title,
        highest_pay,
        lowest_pay,
        highest_pay - lowest_pay AS difference,
        ROUND((highest_pay / NULLIF(lowest_pay, 0))::NUMERIC, 2) AS ratio
    FROM pay_stats
)
SELECT 
    job_title,
    difference,
    ratio,
    highest_pay,
    lowest_pay
FROM distinct_stats
ORDER BY ratio DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    job_title,
    MAX(total_pay) - MIN(total_pay) AS difference,
    ROUND((MAX(total_pay) / NULLIF(MIN(total_pay), 0))::NUMERIC, 2) AS ratio,
    MAX(total_pay) AS highest_pay,
    MIN(total_pay) AS lowest_pay
FROM sf_salaries
WHERE total_pay <> 0
GROUP BY job_title
ORDER BY ratio DESC;
