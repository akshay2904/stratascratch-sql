-- ======================================================================
-- Best Actors/Actresses Of All Time
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Netflix
-- Access     : Premium
-- ID         : 9754
-- URL        : https://platform.stratascratch.com/coding/9754-best-actorsactresses-of-all-time
-- ======================================================================

/*
Find the actors and actresses with the most Oscar wins of all time, based on the number of awards they've won. Output each nominee and their total number of Oscar wins, ordered from most to least.
*/

-- Tables:
--   oscar_nominees(category text, id bigint, movie text, nominee text, winner boolean, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_winners AS (
    SELECT
        nominee,
        COUNT(*) AS total_wins,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM oscar_nominees
    WHERE winner = TRUE
      AND category ILIKE '%act%'  -- filters actor/actress categories
    GROUP BY nominee
)
SELECT
    nominee,
    total_wins
FROM ranked_winners
ORDER BY total_wins DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    nominee,
    COUNT(*) AS total_wins
FROM oscar_nominees
WHERE winner = TRUE
  AND category ILIKE '%act%'
GROUP BY nominee
ORDER BY total_wins DESC;
