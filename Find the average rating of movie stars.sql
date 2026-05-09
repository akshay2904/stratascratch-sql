-- ======================================================================
-- Find the average rating of movie stars
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google, Netflix
-- Access     : Premium
-- ID         : 9605
-- URL        : https://platform.stratascratch.com/coding/9605-find-the-average-rating-of-movie-stars
-- ======================================================================

/*
Find the average rating of each movie star along with their names and birthdays. Sort the result in the ascending order based on the birthday. Use the names as keys when joining the tables.
*/

-- Tables:
--   nominee_filmography(amg_movie_id character varying, id bigint, movie_title character varying, name character varying, rating bigint, role_type character varying, year bigint)
--   nominee_information(amg_person_id character varying, birthday date, id bigint, name character varying, top_genre character varying)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    p.name,
    p.birthdate,
    AVG(r.stars) AS avg_rating
FROM person p
JOIN starsIn si ON p.name = si.starName
JOIN movie m ON si.movieTitle = m.title AND si.movieYear = m.year
JOIN rating r ON m.title = r.movieTitle AND m.year = r.movieYear
GROUP BY p.name, p.birthdate
ORDER BY p.birthdate ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    p.name,
    p.birthdate,
    (
        SELECT AVG(r.stars)
        FROM starsIn si
        JOIN rating r ON si.movieTitle = r.movieTitle AND si.movieYear = r.movieYear
        WHERE si.starName = p.name
    ) AS avg_rating
FROM person p
WHERE p.name IN (
    SELECT DISTINCT starName
    FROM starsIn
)
ORDER BY p.birthdate ASC;
