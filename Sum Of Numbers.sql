-- ======================================================================
-- Sum Of Numbers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tesla, Uber
-- Access     : Premium
-- ID         : 10008
-- URL        : https://platform.stratascratch.com/coding/10008-sum-of-numbers
-- ======================================================================

/*
Find the sum of numbers whose index is less than 5 and the sum of numbers whose index is greater than 5. Output each result on a separate row.
*/

-- Tables:
--   transportation_numbers(index bigint, number bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH numbers(idx, num) AS (
    VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10)
),
grouped AS (
    SELECT
        CASE
            WHEN idx < 5 THEN 'index < 5'
            WHEN idx > 5 THEN 'index > 5'
        END AS label,
        num
    FROM numbers
    WHERE idx <> 5  -- exclude index = 5
)
SELECT label, SUM(num) AS sum_of_numbers
FROM grouped
GROUP BY label
ORDER BY label;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH numbers(idx, num) AS (
    VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10)
)
SELECT 'index < 5' AS label, SUM(num) AS sum_of_numbers
FROM numbers
WHERE idx < 5

UNION ALL

SELECT 'index > 5' AS label, SUM(num) AS sum_of_numbers
FROM numbers
WHERE idx > 5

ORDER BY label;
