-- ======================================================================
-- Time from 10th Runner
-- ======================================================================
-- Difficulty : Medium
-- Companies  : EY, Deloitte
-- Access     : Premium
-- ID         : 2065
-- URL        : https://platform.stratascratch.com/coding/2065-time-from-10th-runner
-- ======================================================================

/*
In a marathon, gun time is counted from the moment of the formal start of the race while net time is counted from the moment a runner crosses a starting line. Both variables are in seconds.




How much net time separates Chris Doe from the 10th best net time (in ascending order)? Avoid gaps in the ranking calculation. Output absolute net time difference.
*/

-- Tables:
--   marathon_male(age bigint, div_tot text, gun_time bigint, hometown text, net_time bigint, num bigint, pace bigint, person_name text, place bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        name,
        net_time,
        DENSE_RANK() OVER (ORDER BY net_time ASC) AS rnk
    FROM marathon
),
chris AS (
    SELECT net_time FROM ranked WHERE name = 'Chris Doe'
),
tenth AS (
    SELECT net_time FROM ranked WHERE rnk = 10
)
SELECT ABS(c.net_time - t.net_time) AS net_time_difference
FROM chris c, tenth t;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT ABS(
    (SELECT net_time FROM marathon WHERE name = 'Chris Doe') -
    (
        SELECT MIN(net_time)
        FROM marathon
        WHERE net_time IN (
            -- get the 10th distinct net_time value
            SELECT net_time
            FROM (
                SELECT DISTINCT net_time
                FROM marathon
                ORDER BY net_time ASC
                LIMIT 10
            ) top10
            ORDER BY net_time DESC
            LIMIT 1
        )
    )
) AS net_time_difference;
