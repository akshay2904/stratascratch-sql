-- ======================================================================
-- Maximum of Two Numbers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Deloitte
-- Access     : Free
-- ID         : 2101
-- URL        : https://platform.stratascratch.com/coding/2101-maximum-of-two-numbers
-- ======================================================================

/*
Given a single column of numbers, consider all possible permutations of two numbers with replacement, assuming that pairs of numbers (x,y) and (y,x) are two different permutations. Then, for each permutation, find the maximum of the two numbers.

Output three columns: the first number, the second number and the maximum of the two.
*/

-- Tables:
--   deloitte_numbers(number bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH nums AS (
    SELECT val FROM numbers
)
SELECT
    a.val AS first_number,
    b.val AS second_number,
    GREATEST(a.val, b.val) AS maximum
FROM nums a
CROSS JOIN nums b
ORDER BY first_number, second_number;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    a.val AS first_number,
    b.val AS second_number,
    CASE
        WHEN a.val >= b.val THEN a.val
        ELSE b.val
    END AS maximum
FROM numbers a
CROSS JOIN numbers b
ORDER BY first_number, second_number;
