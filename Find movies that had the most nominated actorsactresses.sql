-- ======================================================================
-- Find movies that had the most nominated actors/actresses
-- ======================================================================
-- Difficulty : Medium
-- Companies  : BuzzFeed, Netflix
-- Access     : Premium
-- ID         : 9753
-- URL        : https://platform.stratascratch.com/coding/9753-find-movies-that-had-the-most-nominated-actorsactresses
-- ======================================================================

/*
Find movies that had the most nominated actors/actresses. Be aware of the fact that some movies have the same name. Use the year column to separate count for such movies.
Output the movie name alongside the number of nominees.
Order the result in descending order.
*/

-- Tables:
--   oscar_nominees(category text, id bigint, movie text, nominee text, winner boolean, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH movie_nominee_counts AS (
    SELECT 
        movie,
        year,
        COUNT(*) AS nominee_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM oscar_nominees
    GROUP BY movie, year
)
SELECT 
    movie,
    nominee_count
FROM movie_nominee_counts
WHERE rnk = 1
ORDER BY nominee_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    movie,
    COUNT(*) AS nominee_count
FROM oscar_nominees
GROUP BY movie, year
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM oscar_nominees
        GROUP BY movie, year
    ) sub
)
ORDER BY nominee_count DESC;
