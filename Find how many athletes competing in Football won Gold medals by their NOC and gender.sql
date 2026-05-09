-- ======================================================================
-- Find how many athletes competing in Football won Gold medals by their NOC and gender
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9947
-- URL        : https://platform.stratascratch.com/coding/9947-find-how-many-athletes-competing-in-football-won-gold-medals-by-their-noc-and-gender
-- ======================================================================

/*
Find how many athletes competing in Football won Gold medals by their NOC and gender.
Output the NOC, sex, and the corresponding number of athletes.
Sort records by the NOC, sex, and the number of athletes in ascending order.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

SELECT 
    noc,
    sex,
    COUNT(DISTINCT id) AS num_athletes
FROM athlete_events
WHERE sport = 'Football'
  AND medal = 'Gold'
GROUP BY noc, sex
ORDER BY noc, sex, num_athletes ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    noc,
    sex,
    COUNT(DISTINCT id) AS num_athletes
FROM (
    SELECT id, noc, sex
    FROM athlete_events
    WHERE sport = 'Football'
      AND medal = 'Gold'
) AS football_gold_winners
GROUP BY noc, sex
ORDER BY noc, sex, num_athletes ASC;
