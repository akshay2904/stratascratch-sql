-- ======================================================================
-- Nominees Without An Oscar
-- ======================================================================
-- Difficulty : Medium
-- Companies  : BuzzFeed, Netflix
-- Access     : Premium
-- ID         : 9751
-- URL        : https://platform.stratascratch.com/coding/9751-nominees-without-an-oscar
-- ======================================================================

/*
Find the nominees who have been nominated the most but have never won an Oscar. Output the number of unsuccessful nominations alongside the nominee's name. Order records based on the number of nominations in descending order.
*/

-- Tables:
--   oscar_nominees(category text, id bigint, movie text, nominee text, winner boolean, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH nominee_stats AS (
    SELECT
        nominee,
        COUNT(*) AS total_nominations,
        MAX(CASE WHEN winner = TRUE THEN 1 ELSE 0 END) AS ever_won
    FROM oscar_nominees
    GROUP BY nominee
)
SELECT
    nominee,
    total_nominations AS nominations
FROM nominee_stats
WHERE ever_won = 0
ORDER BY total_nominations DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    nominee,
    COUNT(*) AS nominations
FROM oscar_nominees
WHERE nominee NOT IN (
    SELECT DISTINCT nominee
    FROM oscar_nominees
    WHERE winner = TRUE
)
GROUP BY nominee
ORDER BY nominations DESC;
