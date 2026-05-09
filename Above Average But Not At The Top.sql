-- ======================================================================
-- Above Average But Not At The Top
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9985
-- URL        : https://platform.stratascratch.com/coding/9985-above-average-but-not-at-the-top
-- ======================================================================

/*
Find all employees who earned more than the average salary for their job title in 2013 but were not among the top 5 highest earners for their job title. Use the totalpay column to calculate total earnings. Output the employee name(s) as the result.
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH salary_stats AS (
    SELECT
        employeename,
        jobtitle,
        totalpay,
        AVG(totalpay) OVER (PARTITION BY jobtitle) AS avg_pay_for_title,
        DENSE_RANK() OVER (PARTITION BY jobtitle ORDER BY totalpay DESC) AS pay_rank
    FROM salaries
    WHERE year = 2013
)
SELECT employeename
FROM salary_stats
WHERE totalpay > avg_pay_for_title
  AND pay_rank > 5;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT s.employeename
FROM salaries s
WHERE s.year = 2013
  -- Earned more than the average for their job title
  AND s.totalpay > (
      SELECT AVG(s2.totalpay)
      FROM salaries s2
      WHERE s2.year = 2013
        AND s2.jobtitle = s.jobtitle
  )
  -- Not among the top 5 highest earners for their job title
  AND s.employeename NOT IN (
      SELECT s3.employeename
      FROM salaries s3
      WHERE s3.year = 2013
        AND s3.jobtitle = s.jobtitle
      ORDER BY s3.totalpay DESC
      LIMIT 5
  );
