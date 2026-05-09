-- ======================================================================
-- Average Weight of Medal-Winning Judo
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 10144
-- URL        : https://platform.stratascratch.com/coding/10144-average-weight-of-medal-winning-judo
-- ======================================================================

/*
Find the average weight of medal-winning Judo players of each team with a minimum age of 20 and a maximum age of 30. Consider players at the age of 20 and 30 too. Output the team along with the average player weight.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

SELECT 
    team,
    AVG(weight) AS avg_weight
FROM athletes
WHERE sport = 'Judo'
  AND medal IS NOT NULL
  AND medal <> 'NA'  -- exclude non-medal entries often stored as 'NA'
  AND age BETWEEN 20 AND 30
GROUP BY team;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    team,
    AVG(weight) AS avg_weight
FROM (
    SELECT team, weight
    FROM athletes
    WHERE sport = 'Judo'
      AND medal IS NOT NULL
      AND medal <> 'NA'
      AND age >= 20
      AND age <= 30
) AS judo_medal_winners
GROUP BY team;
