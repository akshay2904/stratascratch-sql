-- ======================================================================
-- Processed Ticket Rate By Type
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Free
-- ID         : 9781
-- URL        : https://platform.stratascratch.com/coding/9781-find-the-rate-of-processed-tickets-for-each-type
-- ======================================================================

/*
Find the processed rate of tickets for each type. The processed rate is defined as the number of processed tickets divided by the total number of tickets for that type. Round this result to two decimal places.
*/

-- Tables:
--   facebook_complaints(complaint_id bigint, processed boolean, type bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    type,
    ROUND(
        COUNT(*) FILTER (WHERE status = 'processed')::NUMERIC / COUNT(*),
        2
    ) AS processed_rate
FROM tickets
GROUP BY type
ORDER BY type;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    t.type,
    ROUND(
        COALESCE(p.processed_count, 0)::NUMERIC / t.total_count,
        2
    ) AS processed_rate
FROM (
    SELECT type, COUNT(*) AS total_count
    FROM tickets
    GROUP BY type
) t
LEFT JOIN (
    SELECT type, COUNT(*) AS processed_count
    FROM tickets
    WHERE status = 'processed'
    GROUP BY type
) p ON t.type = p.type
ORDER BY t.type;
