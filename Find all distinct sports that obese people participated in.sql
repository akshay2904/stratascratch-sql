-- ======================================================================
-- Find all distinct sports that obese people participated in
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9945
-- URL        : https://platform.stratascratch.com/coding/9945-find-all-distinct-sports-that-obese-people-participated-in
-- ======================================================================

/*
Find all distinct sports that obese people participated in.
A person is considered as obese if his or her body mass index exceeds 30.
The body mass index is calculated as weight / (height * height). Use meters for height and kilograms for weight.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH obese_athletes AS (
    SELECT DISTINCT p.id
    FROM Person p
    WHERE (p.weight / (p.height * p.height / 10000.0)) > 30
    -- height typically in cm, so divide by 10000 to convert cm² to m²
)
SELECT DISTINCT s.sport_name
FROM obese_athletes oa
JOIN Participates pa ON oa.id = pa.person_id
JOIN Sports s ON pa.sport_id = s.id
ORDER BY s.sport_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT s.sport_name
FROM Sports s
WHERE s.id IN (
    SELECT pa.sport_id
    FROM Participates pa
    WHERE pa.person_id IN (
        SELECT p.id
        FROM Person p
        WHERE (p.weight / (p.height * p.height / 10000.0)) > 30
    )
)
ORDER BY s.sport_name;
