-- ======================================================================
-- Find The Combinations
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Lyft, Uber
-- Access     : Premium
-- ID         : 10010
-- URL        : https://platform.stratascratch.com/coding/10010-find-the-combinations
-- ======================================================================

/*
Find all combinations of 3 numbers that sum up to 8. Output 3 numbers in the combination but each combination must use three different rows (do not reuse the same record).
*/

-- Tables:
--   transportation_numbers(index bigint, number bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (self-join with row ordering to avoid duplicates and reuse)
-- ============================================================

-- Assumes a table called "numbers" with a column "number" and a unique row identifier "id"
SELECT 
    a.number AS num1,
    b.number AS num2,
    c.number AS num3
FROM numbers a
JOIN numbers b ON b.id > a.id          -- ensure b comes after a to avoid duplicates
JOIN numbers c ON c.id > b.id          -- ensure c comes after b to avoid duplicates
WHERE a.number + b.number + c.number = 8;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Uses row_number to assign unique IDs if no natural key exists
SELECT 
    sub.num1,
    sub.num2,
    sub.num3
FROM (
    SELECT 
        a.number AS num1,
        b.number AS num2,
        c.number AS num3,
        a.id AS id1,
        b.id AS id2,
        c.id AS id3
    FROM numbers a, numbers b, numbers c
    WHERE a.id <> b.id              -- different rows
      AND a.id <> c.id              -- different rows
      AND b.id <> c.id              -- different rows
      AND a.id < b.id               -- avoid permutation duplicates
      AND b.id < c.id               -- avoid permutation duplicates
      AND a.number + b.number + c.number = 8
) sub;
