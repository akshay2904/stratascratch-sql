-- ======================================================================
-- Sum Of Transportation Numbers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Uber, Tesla, Google
-- Access     : Premium
-- ID         : 9819
-- URL        : https://platform.stratascratch.com/coding/9819-sum-of-transportation-numbers
-- ======================================================================

/*
Find the sum of all values between the lowest and highest transportation numbers (i.e., exclude the lowest and highest numbers in your sum).
Your output should have 3 columns: the minimum number, maximum number, and summation.
*/

-- Tables:
--   transportation_numbers(index bigint, number bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH stats AS (
    SELECT
        MIN(transportation_number) AS min_num,
        MAX(transportation_number) AS max_num
    FROM transportation
),
filtered_sum AS (
    SELECT SUM(transportation_number) AS total_sum
    FROM transportation t, stats s
    WHERE t.transportation_number > s.min_num
      AND t.transportation_number < s.max_num
)
SELECT
    s.min_num,
    s.max_num,
    f.total_sum
FROM stats s, filtered_sum f;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    (SELECT MIN(transportation_number) FROM transportation) AS min_num,
    (SELECT MAX(transportation_number) FROM transportation) AS max_num,
    (
        SELECT SUM(transportation_number)
        FROM transportation
        WHERE transportation_number > (SELECT MIN(transportation_number) FROM transportation)
          AND transportation_number < (SELECT MAX(transportation_number) FROM transportation)
    ) AS total_sum;
