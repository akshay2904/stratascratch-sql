-- ======================================================================
-- Find the total number of available beds per hosts' nationality
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 10187
-- URL        : https://platform.stratascratch.com/coding/10187-find-the-total-number-of-available-beds-per-hosts-nationality
-- ======================================================================

/*
Find the total number of available beds per hosts' nationality.

Output the nationality along with the corresponding total number of available beds.

Sort records by the total available beds in descending order.
*/

-- Tables:
--   airbnb_apartments(apartment_id text, apartment_type text, city text, country text, host_id bigint, n_bedrooms bigint, n_beds bigint)
--   airbnb_hosts(age bigint, gender text, host_id bigint, nationality text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    u.nationality,
    SUM(a.beds) AS total_available_beds
FROM airbnb_apartments a
JOIN airbnb_hosts h ON a.host_id = h.host_id
JOIN users u ON h.host_id = u.id  -- assuming hosts link to users via id
GROUP BY u.nationality
ORDER BY total_available_beds DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.nationality,
    SUM(a.beds) AS total_available_beds
FROM (
    SELECT host_id, beds
    FROM airbnb_apartments
) a,
(
    SELECT host_id
    FROM airbnb_hosts
) h,
(
    SELECT id, nationality
    FROM users
) u
WHERE a.host_id = h.host_id
  AND h.host_id = u.id
GROUP BY u.nationality
ORDER BY total_available_beds DESC;
