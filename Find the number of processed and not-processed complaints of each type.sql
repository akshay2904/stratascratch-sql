-- ======================================================================
-- Find the number of processed and not-processed complaints of each type
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 9790
-- URL        : https://platform.stratascratch.com/coding/9790-find-the-number-of-processed-and-not-processed-complaints-of-each-type
-- ======================================================================

/*
Find the number of processed and non-processed complaints of each type.
Replace NULL values with 0s.
Output the complaint type along with the number of processed and not-processed complaints.
*/

-- Tables:
--   facebook_complaints(complaint_id bigint, processed boolean, type bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    complaint_type,
    COUNT(*) FILTER (WHERE processed = TRUE)  AS processed,
    COUNT(*) FILTER (WHERE processed = FALSE OR processed IS NULL) AS not_processed
FROM complaints
GROUP BY complaint_type
ORDER BY complaint_type;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    complaint_type,
    COALESCE(SUM(CASE WHEN processed = TRUE  THEN 1 ELSE 0 END), 0) AS processed,
    COALESCE(SUM(CASE WHEN processed = FALSE OR processed IS NULL THEN 1 ELSE 0 END), 0) AS not_processed
FROM complaints
GROUP BY complaint_type
ORDER BY complaint_type;
