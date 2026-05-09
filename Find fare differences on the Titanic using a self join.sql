-- ======================================================================
-- Find fare differences on the Titanic using a self join
-- ======================================================================
-- Difficulty : Hard
-- Companies  : LinkedIn, Google
-- Access     : Premium
-- ID         : 9603
-- URL        : https://platform.stratascratch.com/coding/9603-find-fare-differences-on-the-titanic-using-a-self-join
-- ======================================================================

/*
Find the average absolute fare difference between a specific passenger and all passengers that belong to the same pclass,  both are non-survivors and age difference between two of them is 5 or less years. Do that for each passenger (that satisfy above mentioned coniditions). Output the result along with the passenger name.
*/

-- Tables:
--   titanic(age double precision, cabin text, embarked text, fare double precision, name text, parch bigint, passengerid bigint, pclass bigint, sex text, sibsp bigint, survived bigint, ticket text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH non_survivors AS (
    -- Pre-filter non-survivors with valid age and fare
    SELECT 
        passengerid,
        name,
        pclass,
        age,
        fare
    FROM titanic
    WHERE survived = 0
      AND age IS NOT NULL
      AND fare IS NOT NULL
)
SELECT 
    p.passengerid,
    p.name,
    AVG(ABS(p.fare - o.fare)) AS avg_abs_fare_difference
FROM non_survivors p
JOIN non_survivors o
    ON p.pclass = o.pclass                    -- same pclass
    AND p.passengerid <> o.passengerid        -- not the same passenger
    AND ABS(p.age - o.age) <= 5               -- age difference <= 5 years
GROUP BY p.passengerid, p.name
ORDER BY p.passengerid;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    p.passengerid,
    p.name,
    (
        SELECT AVG(ABS(p.fare - o.fare))
        FROM titanic o
        WHERE o.survived = 0
          AND o.age IS NOT NULL
          AND o.fare IS NOT NULL
          AND o.pclass = p.pclass
          AND o.passengerid <> p.passengerid
          AND ABS(o.age - p.age) <= 5
    ) AS avg_abs_fare_difference
FROM titanic p
WHERE p.survived = 0
  AND p.age IS NOT NULL
  AND p.fare IS NOT NULL
  -- Only include passengers that have at least one matching companion
  AND EXISTS (
        SELECT 1
        FROM titanic o
        WHERE o.survived = 0
          AND o.age IS NOT NULL
          AND o.fare IS NOT NULL
          AND o.pclass = p.pclass
          AND o.passengerid <> p.passengerid
          AND ABS(o.age - p.age) <= 5
  )
ORDER BY p.passengerid;
