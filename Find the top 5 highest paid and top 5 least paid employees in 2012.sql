-- ======================================================================
-- Find the top 5 highest paid and top 5 least paid employees in 2012
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9979
-- URL        : https://platform.stratascratch.com/coding/9979-find-the-top-5-highest-paid-and-top-5-least-paid-employees-in-2012
-- ======================================================================

/*
Find the top 5 highest paid and top 5 least paid employees in 2012.
Output the employee name along with the corresponding total pay with benefits.
Sort records based on the total payment with benefits in ascending order.
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        employeename,
        totalpaybenefits,
        RANK() OVER (ORDER BY totalpaybenefits DESC) AS rank_high,
        RANK() OVER (ORDER BY totalpaybenefits ASC)  AS rank_low
    FROM salaries
    WHERE year = 2012
)
SELECT
    employeename,
    totalpaybenefits
FROM ranked
WHERE rank_high <= 5
   OR rank_low  <= 5
ORDER BY totalpaybenefits ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT employeename, totalpaybenefits
FROM salaries
WHERE year = 2012
  AND totalpaybenefits IN (
      -- Top 5 highest paid
      SELECT totalpaybenefits
      FROM salaries
      WHERE year = 2012
      ORDER BY totalpaybenefits DESC
      LIMIT 5
  )
UNION
SELECT employeename, totalpaybenefits
FROM salaries
WHERE year = 2012
  AND totalpaybenefits IN (
      -- Top 5 least paid
      SELECT totalpaybenefits
      FROM salaries
      WHERE year = 2012
      ORDER BY totalpaybenefits ASC
      LIMIT 5
  )
ORDER BY totalpaybenefits ASC;
