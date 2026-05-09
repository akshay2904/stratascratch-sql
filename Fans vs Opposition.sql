-- ======================================================================
-- Fans vs Opposition
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10062
-- URL        : https://platform.stratascratch.com/coding/10062-fans-vs-opposition
-- ======================================================================

/*
Meta/Facebook is quite keen on pushing their new programming language Hack to all their offices. They ran a survey to quantify the popularity of the language and send it to their employees. To promote Hack they have decided to pair developers which love Hack with the ones who hate it so the fans can convert the opposition. Their pair criteria is to match the biggest fan with biggest opposition, second biggest fan with second biggest opposition, and so on. Write a query which returns this pairing. Output employee ids of paired employees. Sort users with the same popularity value by id in ascending order.




Duplicates in pairings can be left in the solution. For example, (2, 3) and (3, 2) should both be in the solution.
*/

-- Tables:
--   facebook_hack_survey(age bigint, employee_id bigint, gender text, popularity bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        employee_id,
        popularity,
        -- Fans: those who love Hack (positive popularity), ranked desc by popularity, then asc by id
        -- Opposition: those who hate Hack (negative popularity), ranked asc by popularity (most negative first), then asc by id
        CASE WHEN popularity > 0 THEN
            ROW_NUMBER() OVER (
                PARTITION BY CASE WHEN popularity > 0 THEN 'fan' ELSE 'opp' END
                ORDER BY popularity DESC, employee_id ASC
            )
        ELSE
            ROW_NUMBER() OVER (
                PARTITION BY CASE WHEN popularity > 0 THEN 'fan' ELSE 'opp' END
                ORDER BY popularity ASC, employee_id ASC
            )
        END AS rn,
        CASE WHEN popularity > 0 THEN 'fan' ELSE 'opp' END AS group_type
    FROM facebook_hack_survey
),
fans AS (
    SELECT employee_id, rn
    FROM ranked
    WHERE group_type = 'fan'
),
opposition AS (
    SELECT employee_id, rn
    FROM ranked
    WHERE group_type = 'opp'
)
SELECT
    f.employee_id AS employee_id,
    o.employee_id AS pair_id
FROM fans f
JOIN opposition o ON f.rn = o.rn;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH fans AS (
    SELECT
        employee_id,
        popularity,
        -- rank biggest fan first, tie-break by id asc
        (SELECT COUNT(*) FROM facebook_hack_survey f2
         WHERE f2.popularity > 0
           AND (f2.popularity > f1.popularity
                OR (f2.popularity = f1.popularity AND f2.employee_id < f1.employee_id))
        ) + 1 AS rn
    FROM facebook_hack_survey f1
    WHERE popularity > 0
),
opposition AS (
    SELECT
        employee_id,
        popularity,
        -- rank biggest opposition first (most negative = lowest value), tie-break by id asc
        (SELECT COUNT(*) FROM facebook_hack_survey o2
         WHERE o2.popularity < 0
           AND (o2.popularity < o1.popularity
                OR (o2.popularity = o1.popularity AND o2.employee_id < o1.employee_id))
        ) + 1 AS rn
    FROM facebook_hack_survey o1
    WHERE popularity < 0
)
SELECT
    f.employee_id AS employee_id,
    o.employee_id AS pair_id
FROM fans f
JOIN opposition o ON f.rn = o.rn;
