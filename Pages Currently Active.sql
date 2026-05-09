-- ======================================================================
-- Pages Currently Active
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10556
-- URL        : https://platform.stratascratch.com/coding/10556-pages-currently-active
-- ======================================================================

/*
You are monitoring a system where pages can be turned on or off at different times. The page status log records every state change event for each page. Find the number of pages that are currently active based on their most recent status change. Return the count of currently active pages.
*/

-- Tables:
--   page_status_log(changed_at timestamp without time zone, event_id bigint, page_id bigint, status text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes table: page_status_log(page_id, status, changed_at)
-- status values: 'active' / 'inactive' (or similar on/off values)

WITH latest_status AS (
    SELECT
        page_id,
        status,
        ROW_NUMBER() OVER (PARTITION BY page_id ORDER BY changed_at DESC) AS rn
    FROM page_status_log
)
SELECT COUNT(*) AS active_page_count
FROM latest_status
WHERE rn = 1
  AND status = 'active';

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Get the most recent changed_at per page, then join back to get status
SELECT COUNT(*) AS active_page_count
FROM page_status_log psl
INNER JOIN (
    SELECT page_id, MAX(changed_at) AS latest_change
    FROM page_status_log
    GROUP BY page_id
) latest
    ON psl.page_id = latest.page_id
   AND psl.changed_at = latest.latest_change
WHERE psl.status = 'active';
