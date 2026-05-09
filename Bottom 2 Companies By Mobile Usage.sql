-- ======================================================================
-- Bottom 2 Companies By Mobile Usage
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Apple, Microsoft
-- Access     : Premium
-- ID         : 2026
-- URL        : https://platform.stratascratch.com/coding/2026-bottom-2-companies-by-mobile-usage
-- ======================================================================

/*
Write a query to identify all companies (customer_id) whose mobile usage ranks in the bottom two positions. Mobile usage is the count of events where client_id = 'mobile'. Companies with the same usage count should share the same rank, and all companies in the bottom two ranks should be included. Return the customer_id and event count, sorted in ascending order by the number of events.
*/

-- Tables:
--   fact_events(client_id text, customer_id text, event_id bigint, event_type text, id bigint, time_id date, user_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH mobile_counts AS (
    SELECT
        customer_id,
        COUNT(*) AS event_count
    FROM fact_events
    WHERE client_id = 'mobile'
    GROUP BY customer_id
),
ranked AS (
    SELECT
        customer_id,
        event_count,
        DENSE_RANK() OVER (ORDER BY event_count ASC) AS rnk
    FROM mobile_counts
)
SELECT
    customer_id,
    event_count
FROM ranked
WHERE rnk <= 2
ORDER BY event_count ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer_id,
    event_count
FROM (
    SELECT
        customer_id,
        COUNT(*) AS event_count
    FROM fact_events
    WHERE client_id = 'mobile'
    GROUP BY customer_id
) AS mobile_counts
WHERE event_count IN (
    -- Find the two smallest distinct event counts
    SELECT DISTINCT event_count
    FROM (
        SELECT
            customer_id,
            COUNT(*) AS event_count
        FROM fact_events
        WHERE client_id = 'mobile'
        GROUP BY customer_id
    ) AS all_counts
    ORDER BY event_count ASC
    LIMIT 2
)
ORDER BY event_count ASC;
