-- ======================================================================
-- Find the nominee who has won the most Oscars
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Spotify, Netflix
-- Access     : Premium
-- ID         : 9750
-- URL        : https://platform.stratascratch.com/coding/9750-find-the-nominee-who-has-won-the-most-oscars
-- ======================================================================

/*
Find the nominee who has won the most Oscars.
Output the nominee's name alongside the result.
*/

-- Tables:
--   oscar_nominees(category text, id bigint, movie text, nominee text, winner boolean, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH win_counts AS (
    SELECT nominee,
           COUNT(*) AS oscar_wins,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM oscar_age_female
    WHERE winner = TRUE
    GROUP BY nominee
)
SELECT nominee, oscar_wins
FROM win_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT nominee, COUNT(*) AS oscar_wins
FROM oscar_age_female
WHERE winner = TRUE
GROUP BY nominee
HAVING COUNT(*) = (
    SELECT MAX(win_count)
    FROM (
        SELECT COUNT(*) AS win_count
        FROM oscar_age_female
        WHERE winner = TRUE
        GROUP BY nominee
    ) AS counts
);
