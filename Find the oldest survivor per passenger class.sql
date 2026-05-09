-- ======================================================================
-- Find the oldest survivor per passenger class
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Premium
-- ID         : 9883
-- URL        : https://platform.stratascratch.com/coding/9883-find-the-oldest-survivor-per-passenger-class
-- ======================================================================

/*
Find the oldest survivor of each passenger class.
Output the name and the age of the survivor along with the corresponding passenger class.
Order records by passenger class in ascending order.
*/

-- Tables:
--   titanic(age double precision, cabin text, embarked text, fare double precision, name text, parch bigint, passengerid bigint, pclass bigint, sex text, sibsp bigint, survived bigint, ticket text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT 
        name,
        age,
        pclass,
        ROW_NUMBER() OVER (PARTITION BY pclass ORDER BY age DESC) AS rn
    FROM titanic
    WHERE survived = 1
      AND age IS NOT NULL
)
SELECT name, age, pclass
FROM ranked
WHERE rn = 1
ORDER BY pclass ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT t.name, t.age, t.pclass
FROM titanic t
JOIN (
    SELECT pclass, MAX(age) AS max_age
    FROM titanic
    WHERE survived = 1
      AND age IS NOT NULL
    GROUP BY pclass
) AS oldest
    ON t.pclass = oldest.pclass
   AND t.age = oldest.max_age
WHERE t.survived = 1
  AND t.age IS NOT NULL
ORDER BY t.pclass ASC;
