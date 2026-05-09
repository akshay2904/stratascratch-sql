-- ======================================================================
-- Highest Total Miles
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Uber
-- Access     : Premium
-- ID         : 10169
-- URL        : https://platform.stratascratch.com/coding/10169-highest-total-miles
-- ======================================================================

/*
You’re given a table of Uber rides that contains the mileage and the purpose for the business expense.  You’re asked to find business purposes that generate the most miles driven for passengers that use Uber for their business transportation. Find the top 3 business purpose categories by total mileage.
*/

-- Tables:
--   my_uber_drives(category text, end_date timestamp without time zone, miles double precision, purpose text, start text, start_date timestamp without time zone, stop text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH purpose_mileage AS (
    SELECT
        purpose,
        SUM(miles) AS total_miles,
        RANK() OVER (ORDER BY SUM(miles) DESC) AS rnk
    FROM uber_rides
    WHERE purpose IS NOT NULL
    GROUP BY purpose
)
SELECT
    purpose,
    total_miles,
    rnk
FROM purpose_mileage
WHERE rnk <= 3
ORDER BY total_miles DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    purpose,
    SUM(miles) AS total_miles
FROM uber_rides
WHERE purpose IS NOT NULL
GROUP BY purpose
ORDER BY total_miles DESC
LIMIT 3;
