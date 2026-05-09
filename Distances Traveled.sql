-- ======================================================================
-- Distances Traveled
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Lyft
-- Access     : Premium
-- ID         : 10324
-- URL        : https://platform.stratascratch.com/coding/10324-distances-traveled
-- ======================================================================

/*
Find the top 10 users that have traveled the greatest distance. Output their id, name and a total distance traveled.
*/

-- Tables:
--   lyft_rides_log(distance bigint, id bigint, user_id bigint)
--   lyft_users(id bigint, name text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH user_distances AS (
    SELECT
        u.id,
        u.name,
        SUM(r.distance) AS total_distance,
        RANK() OVER (ORDER BY SUM(r.distance) DESC) AS rnk
    FROM users u
    JOIN rides r ON u.id = r.user_id
    GROUP BY u.id, u.name
)
SELECT
    id,
    name,
    total_distance
FROM user_distances
WHERE rnk <= 10
ORDER BY total_distance DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.id,
    u.name,
    SUM(r.distance) AS total_distance
FROM users u
JOIN rides r ON u.id = r.user_id
GROUP BY u.id, u.name
ORDER BY total_distance DESC
LIMIT 10;
