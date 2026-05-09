-- ======================================================================
-- Find the genre of the person with the most number of oscar winnings
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Netflix
-- Access     : Premium
-- ID         : 10171
-- URL        : https://platform.stratascratch.com/coding/10171-find-the-genre-of-the-person-with-the-most-number-of-oscar-winnings
-- ======================================================================

/*
Find the genre of the person with the most number of oscar winnings.

If there are more than one person with the same number of oscar wins, return the first one in alphabetic order based on their name. Use the names as keys when joining the tables.
*/

-- Tables:
--   oscar_nominees(category text, id bigint, movie text, nominee text, winner boolean, year bigint)
--   nominee_information(amg_person_id character varying, birthday date, id bigint, name character varying, top_genre character varying)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH oscar_counts AS (
    SELECT
        name,
        COUNT(*) AS win_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC, name ASC) AS rn
    FROM oscars
    GROUP BY name
),
top_winner AS (
    SELECT name
    FROM oscar_counts
    WHERE rn = 1
)
SELECT m.genre
FROM top_winner tw
JOIN movies m ON m.name = tw.name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT m.genre
FROM movies m
WHERE m.name = (
    SELECT name
    FROM oscars
    GROUP BY name
    ORDER BY COUNT(*) DESC, name ASC
    LIMIT 1
);
