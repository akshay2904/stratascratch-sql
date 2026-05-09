-- ======================================================================
-- Find Pairs with Product Over 11
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Delta Airlines, Uber
-- Access     : Premium
-- ID         : 10011
-- URL        : https://platform.stratascratch.com/coding/10011-find-all-number-pairs-whose-first-number-is-smaller-than-the-second-one-and-the-product-of-two-numbers-is-larger-than-11
-- ======================================================================

/*
Find all number pairs whose first number is smaller than the second one and the product of two numbers is larger than 11.

Output both numbers in the combination.
*/

-- Tables:
--   transportation_numbers(index bigint, number bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assuming the table is named "numbers" with a column "number"
WITH numbered AS (
    SELECT number, ROW_NUMBER() OVER (ORDER BY number) AS rn
    FROM numbers
)
SELECT a.number AS number1, b.number AS number2
FROM numbered a
JOIN numbered b ON a.rn < b.rn
WHERE a.number < b.number
  AND a.number * b.number > 11;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT a.number AS number1, b.number AS number2
FROM numbers a, numbers b
WHERE a.number < b.number
  AND a.number * b.number > 11;
