-- ======================================================================
-- First 50% of Records From Dataset
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Bosch, Amazon
-- Access     : Premium
-- ID         : 9859
-- URL        : https://platform.stratascratch.com/coding/9859-find-the-first-50-records-of-the-dataset
-- ======================================================================

/*
Find the first 50% records of the dataset.
*/

-- Tables:
--   worker(department text, first_name text, joining_date date, last_name text, salary bigint, worker_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER () AS rn,
        COUNT(*) OVER ()     AS total
    FROM dataset
)
SELECT *
FROM ranked
WHERE rn <= total / 2.0
ORDER BY rn;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT *
FROM dataset
LIMIT (
    SELECT CEIL(COUNT(*) / 2.0)
    FROM dataset
);
