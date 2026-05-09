-- ======================================================================
-- Ranking Hosts By Beds
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 10161
-- URL        : https://platform.stratascratch.com/coding/10161-ranking-hosts-by-beds
-- ======================================================================

/*
Rank each host based on the number of beds they have listed. The host with the most beds should be ranked 1 and the host with the least number of beds should be ranked last. Hosts that have the same number of beds should have the same rank but there should be no gaps between ranking values. A host can also own multiple properties.
Output the host ID, number of beds, and rank from highest rank to lowest.
*/

-- Tables:
--   airbnb_apartments(apartment_id text, apartment_type text, city text, country text, host_id bigint, n_bedrooms bigint, n_beds bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    host_id,
    SUM(beds) AS total_beds,
    DENSE_RANK() OVER (ORDER BY SUM(beds) DESC) AS rank
FROM airbnb_apartments
GROUP BY host_id
ORDER BY rank, host_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    h.host_id,
    h.total_beds,
    -- Count how many distinct bed totals are greater than this host's total, then add 1
    (
        SELECT COUNT(DISTINCT h2.total_beds)
        FROM (
            SELECT host_id, SUM(beds) AS total_beds
            FROM airbnb_apartments
            GROUP BY host_id
        ) h2
        WHERE h2.total_beds > h.total_beds
    ) + 1 AS rank
FROM (
    SELECT host_id, SUM(beds) AS total_beds
    FROM airbnb_apartments
    GROUP BY host_id
) h
ORDER BY rank, host_id;
