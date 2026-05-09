-- ======================================================================
-- Find the duplicate records in the dataset
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google, Amazon
-- Access     : Premium
-- ID         : 9849
-- URL        : https://platform.stratascratch.com/coding/9849-find-the-duplicate-records-in-the-dataset
-- ======================================================================

/*
Find the duplicate records in the dataset.
Output the worker title, affected_from date, and the number of times the records appear in the dataset.
*/

-- Tables:
--   title(affected_from date, worker_ref_id bigint, worker_title text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH counted AS (
    SELECT 
        worker_title,
        affected_from,
        COUNT(*) OVER (PARTITION BY worker_title, affected_from) AS record_count
    FROM title
)
SELECT DISTINCT
    worker_title,
    affected_from,
    record_count
FROM counted
WHERE record_count > 1
ORDER BY record_count DESC, worker_title;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    worker_title,
    affected_from,
    COUNT(*) AS record_count
FROM title
GROUP BY worker_title, affected_from
HAVING COUNT(*) > 1
ORDER BY record_count DESC, worker_title;
