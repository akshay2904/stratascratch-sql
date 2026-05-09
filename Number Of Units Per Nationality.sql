-- ======================================================================
-- Number Of Units Per Nationality
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Free
-- ID         : 10156
-- URL        : https://platform.stratascratch.com/coding/10156-number-of-units-per-nationality
-- ======================================================================

/*
Write a query that returns how many different apartment-type units (counted by distinct unit_id) are owned by people under 30, grouped by their nationality. Sort the results by the number of apartments in descending order.
*/

-- Tables:
--   airbnb_hosts(age bigint, gender text, host_id bigint, nationality text)
--   airbnb_units(city text, country text, host_id bigint, n_bedrooms bigint, n_beds bigint, unit_id text, unit_type text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH young_owners AS (
    SELECT owner_id, nationality
    FROM owners
    WHERE age < 30
),
apt_counts AS (
    SELECT
        yo.nationality,
        COUNT(DISTINCT u.unit_id) AS apartment_count
    FROM young_owners yo
    JOIN units u
        ON yo.owner_id = u.owner_id
    WHERE LOWER(u.unit_type) = 'apartment'
    GROUP BY yo.nationality
)
SELECT
    nationality,
    apartment_count
FROM apt_counts
ORDER BY apartment_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    o.nationality,
    COUNT(DISTINCT u.unit_id) AS apartment_count
FROM owners o
JOIN units u
    ON o.owner_id = u.owner_id
WHERE o.age < 30
  AND LOWER(u.unit_type) = 'apartment'
GROUP BY o.nationality
ORDER BY apartment_count DESC;
