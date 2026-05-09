-- ======================================================================
-- Employee With Lowest Pay
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9980
-- URL        : https://platform.stratascratch.com/coding/9980-employee-with-lowest-pay
-- ======================================================================

/*
Find the employee who earned the lowest total payment with benefits from a list of employees who earned more from other payments compared to their base pay. Output the first name of the employee along with the corresponding total payment with benefits.
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH filtered AS (
    SELECT
        employeename,
        totalpaybenefits,
        -- Rank employees where other_pay > base_pay by total pay with benefits
        RANK() OVER (ORDER BY totalpaybenefits ASC) AS rnk
    FROM sf_public_salaries
    WHERE otherpay > basepay
),
split_name AS (
    SELECT
        SPLIT_PART(employeename, ' ', 1) AS first_name,
        totalpaybenefits
    FROM filtered
    WHERE rnk = 1
)
SELECT first_name, totalpaybenefits
FROM split_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    SPLIT_PART(employeename, ' ', 1) AS first_name,
    totalpaybenefits
FROM sf_public_salaries
WHERE otherpay > basepay
  AND totalpaybenefits = (
      SELECT MIN(totalpaybenefits)
      FROM sf_public_salaries
      WHERE otherpay > basepay
  );
