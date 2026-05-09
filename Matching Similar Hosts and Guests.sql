-- ======================================================================
-- Matching Similar Hosts and Guests
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Free
-- ID         : 10078
-- URL        : https://platform.stratascratch.com/coding/10078-find-matching-hosts-and-guests-in-a-way-that-they-are-both-of-the-same-gender-and-nationality
-- ======================================================================

/*
Find matching hosts and guests pairs in a way that they are both of the same gender and nationality.

Output the host id and the guest id of matched pair.
*/

-- Tables:
--   airbnb_hosts(age bigint, gender text, host_id bigint, nationality text)
--   airbnb_guests(age bigint, gender text, guest_id bigint, nationality text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Join hosts and guests on matching gender and nationality,
-- excluding self-matches if host and guest share the same id space
SELECT
    h.host_id,
    g.guest_id
FROM airbnb_hosts h
JOIN airbnb_guests g
    ON h.gender = g.gender
    AND h.nationality = g.nationality;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Use a subquery to get all host/guest combinations with matching attributes
SELECT
    host_id,
    guest_id
FROM (
    SELECT
        h.host_id,
        g.guest_id,
        h.gender   AS host_gender,
        g.gender   AS guest_gender,
        h.nationality AS host_nationality,
        g.nationality AS guest_nationality
    FROM airbnb_hosts h,
         airbnb_guests g
) pairs
WHERE host_gender = guest_gender
  AND host_nationality = guest_nationality;
