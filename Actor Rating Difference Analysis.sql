-- ======================================================================
-- Actor Rating Difference Analysis
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google, Netflix
-- Access     : Premium
-- ID         : 10547
-- URL        : https://platform.stratascratch.com/coding/10547-actor-rating-difference-analysis
-- ======================================================================

/*
You are given a dataset of actors and the films they have been involved in, including each film's release date and rating. For each actor, calculate the difference between the rating of their most recent film and their average rating across all previous films (the average rating excludes the most recent one).




Return a list of actors along with their average lifetime rating, the rating of their most recent film, and the difference between the two ratings. Round the difference calculation to 2 decimal places. If an actor has only one film, return 0 for the difference and their only film’s rating for both the average and latest rating fields.
*/

-- Tables:
--   actor_rating_shift(actor_name text, film_rating double precision, film_title text, release_date date)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_films AS (
    SELECT
        actor_id,
        rating,
        release_date,
        ROW_NUMBER() OVER (PARTITION BY actor_id ORDER BY release_date DESC) AS rn,
        COUNT(*) OVER (PARTITION BY actor_id) AS total_films,
        AVG(rating) OVER (PARTITION BY actor_id) AS avg_all_ratings
    FROM actor_films
),
latest AS (
    SELECT actor_id, rating AS latest_rating
    FROM ranked_films
    WHERE rn = 1
),
prev_avg AS (
    SELECT
        actor_id,
        -- Average excluding the most recent film
        AVG(rating) AS avg_previous_rating,
        COUNT(*) AS prev_count
    FROM ranked_films
    WHERE rn > 1
    GROUP BY actor_id
)
SELECT
    a.actor_id,
    -- If only one film, use that film's rating as average; otherwise use previous avg
    COALESCE(pa.avg_previous_rating, l.latest_rating) AS avg_rating,
    l.latest_rating,
    ROUND(
        CASE
            WHEN pa.avg_previous_rating IS NULL THEN 0  -- Only one film
            ELSE l.latest_rating - pa.avg_previous_rating
        END::NUMERIC, 2
    ) AS rating_difference
FROM latest l
LEFT JOIN prev_avg pa ON l.actor_id = pa.actor_id
JOIN (SELECT DISTINCT actor_id FROM ranked_films) a ON l.actor_id = a.actor_id
ORDER BY a.actor_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    af.actor_id,
    -- Average of all films except the most recent; fallback to latest_rating if only 1 film
    COALESCE(
        (
            SELECT AVG(af2.rating)
            FROM actor_films af2
            WHERE af2.actor_id = af.actor_id
              AND af2.release_date < (
                  SELECT MAX(af3.release_date)
                  FROM actor_films af3
                  WHERE af3.actor_id = af.actor_id
              )
        ),
        (
            SELECT MAX(af4.rating)
            FROM actor_films af4
            WHERE af4.actor_id = af.actor_id
              AND af4.release_date = (
                  SELECT MAX(af5.release_date)
                  FROM actor_films af5
                  WHERE af5.actor_id = af.actor_id
              )
        )
    ) AS avg_rating,
    -- Most recent film's rating
    (
        SELECT af6.rating
        FROM actor_films af6
        WHERE af6.actor_id = af.actor_id
          AND af6.release_date = (
              SELECT MAX(af7.release_date)
              FROM actor_films af7
              WHERE af7.actor_id = af.actor_id
          )
        LIMIT 1
    ) AS latest_rating,
    ROUND(
        COALESCE(
            (
                SELECT af6b.rating
                FROM actor_films af6b
                WHERE af6b.actor_id = af.actor_id
                  AND af6b.release_date = (
                      SELECT MAX(af7b.release_date)
                      FROM actor_films af7b
                      WHERE af7b.actor_id = af.actor_id
                  )
                LIMIT 1
            ) -
            (
                SELECT AVG(af2b.rating)
                FROM actor_films af2b
                WHERE af2b.actor_id = af.actor_id
                  AND af2b.release_date < (
                      SELECT MAX(af3b.release_date)
                      FROM actor_films af3b
                      WHERE af3b.actor_id = af.actor_id
                  )
            ),
            0  -- Only one film: difference is 0
        )::NUMERIC, 2
    ) AS rating_difference
FROM actor_films af
GROUP BY af.actor_id
ORDER BY af.actor_id;
