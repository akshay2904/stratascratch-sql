-- ======================================================================
-- Hosts' Abroad Apartments
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 10071
-- URL        : https://platform.stratascratch.com/coding/10071-hosts-abroad-apartments
-- ======================================================================

/*
Find the number of hosts that have accommodations in countries of which they are not citizens.
*/

-- Tables:
--   airbnb_hosts(age bigint, gender text, host_id bigint, nationality text)
--   airbnb_apartments(apartment_id text, apartment_type text, city text, country text, host_id bigint, n_bedrooms bigint, n_beds bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT COUNT(DISTINCT h.host_id) AS num_hosts
FROM hosts h
JOIN accommodations a ON h.host_id = a.host_id
WHERE h.nationality <> a.country;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT COUNT(*) AS num_hosts
FROM (
    SELECT h.host_id
    FROM hosts h
    WHERE h.host_id IN (
        SELECT a.host_id
        FROM accommodations a
        JOIN hosts h2 ON a.host_id = h2.host_id
        WHERE a.country <> h2.nationality
    )
    GROUP BY h.host_id
) AS foreign_hosts;
