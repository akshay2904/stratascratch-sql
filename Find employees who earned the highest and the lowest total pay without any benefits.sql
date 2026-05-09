-- ======================================================================
-- Find employees who earned the highest and the lowest total pay without any benefits
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9978
-- URL        : https://platform.stratascratch.com/coding/9978-find-employees-who-earned-the-highest-and-the-lowest-total-pay-without-any-benefits
-- ======================================================================

/*
Find employees who earned the highest and the lowest total pay without any benefits.
Output the employee name along with the total pay.
Order records based on the total pay in descending order.
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
        employeename,
        totalpaybenefits,
        MIN(totalpaybenefits) OVER () AS min_pay,
        MAX(totalpaybenefits) OVER () AS max_pay
    FROM sf_salary
    WHERE benefits = 0 OR benefits IS NULL
)
SELECT 
    employeename,
    totalpaybenefits
FROM pay_stats
WHERE totalpaybenefits = max_pay 
   OR totalpaybenefits = min_pay
ORDER BY totalpaybenefits DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    employeename,
    totalpaybenefits
FROM sf_salary
WHERE (benefits = 0 OR benefits IS NULL)
  AND (
      totalpaybenefits = (
          SELECT MAX(totalpaybenefits) 
          FROM sf_salary 
          WHERE benefits = 0 OR benefits IS NULL
      )
      OR 
      totalpaybenefits = (
          SELECT MIN(totalpaybenefits) 
          FROM sf_salary 
          WHERE benefits = 0 OR benefits IS NULL
      )
  )
ORDER BY totalpaybenefits DESC;
