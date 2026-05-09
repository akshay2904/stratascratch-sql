-- ======================================================================
-- Fastest Hometowns
-- ======================================================================
-- Difficulty : Medium
-- Companies  : EY, Deloitte
-- Access     : Premium
-- ID         : 2066
-- URL        : https://platform.stratascratch.com/coding/2066-fastest-hometowns
-- ======================================================================

/*
Find the hometowns with the top 3 average net times. Output the hometowns and their average net time. Keep in mind that a lower net_time is better. In case there are ties in net time, return all unique hometowns.
*/

-- Tables:
--   marathon_male(age bigint, div_tot text, gun_time bigint, hometown text, net_time bigint, num bigint, pace bigint, person_name text, place bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH avg_times AS (
    SELECT 
        hometown,
        AVG(net_time) AS avg_net_time
    FROM marathon_td
    GROUP BY hometown
),
ranked AS (
    SELECT 
        hometown,
        avg_net_time,
        DENSE_RANK() OVER (ORDER BY avg_net_time ASC) AS rnk
    FROM avg_times
)
SELECT hometown, avg_net_time
FROM ranked
WHERE rnk <= 3;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT hometown, AVG(net_time) AS avg_net_time
FROM marathon_td
GROUP BY hometown
HAVING AVG(net_time) <= (
    -- Find the 3rd smallest distinct average net time
    SELECT MIN(avg_net_time)
    FROM (
        SELECT AVG(net_time) AS avg_net_time
        FROM marathon_td
        GROUP BY hometown
        ORDER BY avg_net_time ASC
        LIMIT 3
    ) top3
);
