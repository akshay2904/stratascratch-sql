-- ======================================================================
-- DeepMind employment competition
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 10070
-- URL        : https://platform.stratascratch.com/coding/10070-deepmind-employment-competition
-- ======================================================================

/*
Calculate average score for each team at DeepMind employment competition.

Output the team along with the average team score.

Sort records by the team score in descending order.
*/

-- Tables:
--   google_competition_participants(member_id bigint, team_id bigint)
--   google_competition_scores(member_id bigint, member_score double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    team,
    AVG(score) AS avg_score
FROM google_deepmind_employees
GROUP BY team
ORDER BY avg_score DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    team,
    (SELECT AVG(e2.score) 
     FROM google_deepmind_employees e2 
     WHERE e2.team = e1.team) AS avg_score
FROM google_deepmind_employees e1
GROUP BY team
ORDER BY avg_score DESC;
