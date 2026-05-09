-- ======================================================================
-- Titanic Survivors and Non-Survivors
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tesla, Google
-- Access     : Free
-- ID         : 9881
-- URL        : https://platform.stratascratch.com/coding/9881-make-a-report-showing-the-number-of-survivors-and-non-survivors-by-passenger-class
-- ======================================================================

/*
Make a report showing the number of survivors and non-survivors by passenger class. Classes are categorized based on the pclass value as:




•	First class: pclass = 1

•	Second class: pclass = 2

•	Third class: pclass = 3




Output the number of survivors and non-survivors by each class.
*/

-- Tables:
--   titanic(age double precision, cabin text, embarked text, fare double precision, name text, parch bigint, passengerid bigint, pclass bigint, sex text, sibsp bigint, survived bigint, ticket text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    CASE pclass
        WHEN 1 THEN 'First class'
        WHEN 2 THEN 'Second class'
        WHEN 3 THEN 'Third class'
    END AS class,
    COUNT(*) FILTER (WHERE survived = 1) AS survivors,
    COUNT(*) FILTER (WHERE survived = 0) AS non_survivors
FROM titanic
GROUP BY pclass
ORDER BY pclass;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    CASE t.pclass
        WHEN 1 THEN 'First class'
        WHEN 2 THEN 'Second class'
        WHEN 3 THEN 'Third class'
    END AS class,
    (SELECT COUNT(*) FROM titanic s WHERE s.pclass = t.pclass AND s.survived = 1) AS survivors,
    (SELECT COUNT(*) FROM titanic ns WHERE ns.pclass = t.pclass AND ns.survived = 0) AS non_survivors
FROM titanic t
GROUP BY t.pclass
ORDER BY t.pclass;
