-- ======================================================================
-- Find how the survivors are distributed by the gender and passenger classes
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 9882
-- URL        : https://platform.stratascratch.com/coding/9882-find-how-the-survivors-are-distributed-by-the-gender-and-passenger-classes
-- ======================================================================

/*
Find how the survivors are distributed by the gender and passenger classes.

Classes are categorized based on the pclass value as:

pclass = 1: first_class

pclass = 2: second_classs

pclass = 3: third_class

Output the sex along with the corresponding number of survivors for each class.

HINT: each sex should be in the separate line with one column having the value of that sex and other 3 columns having number of survivors for each 3 classes.
*/

-- Tables:
--   titanic(age double precision, cabin text, embarked text, fare double precision, name text, parch bigint, passengerid bigint, pclass bigint, sex text, sibsp bigint, survived bigint, ticket text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    sex,
    COUNT(*) FILTER (WHERE pclass = 1) AS first_class,
    COUNT(*) FILTER (WHERE pclass = 2) AS second_class,
    COUNT(*) FILTER (WHERE pclass = 3) AS third_class
FROM titanic
WHERE survived = 1
GROUP BY sex;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    sex,
    SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
WHERE survived = 1
GROUP BY sex;
