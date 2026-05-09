-- ======================================================================
-- Find the best artists in the last 20 years
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Spotify
-- Access     : Premium
-- ID         : 9745
-- URL        : https://platform.stratascratch.com/coding/9745-find-the-best-artists-in-the-last-50-years
-- ======================================================================

/*
Find the best artists in the last 20 years.

Use the metric (100 - avg_yearly_rank) * number_of_years_present to score each artist.

Output the artist's name and the average yearly rank alongside the score. Round the score and average rank to 2 decimals.

Order records based on the score in descending order.
*/

-- Tables:
--   billboard_top_100_year_end(artist text, group_name text, id bigint, song_name text, year bigint, year_rank bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH artist_stats AS (
    SELECT
        artist,
        AVG(year_rank)        AS avg_yearly_rank,
        COUNT(DISTINCT year)  AS number_of_years_present
    FROM billboard_top_100_year_end
    WHERE year > EXTRACT(YEAR FROM CURRENT_DATE) - 20
    GROUP BY artist
)
SELECT
    artist,
    ROUND(avg_yearly_rank::NUMERIC, 2)                                        AS avg_yearly_rank,
    ROUND(((100 - avg_yearly_rank) * number_of_years_present)::NUMERIC, 2)    AS score
FROM artist_stats
ORDER BY score DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    artist,
    ROUND(AVG(year_rank)::NUMERIC, 2) AS avg_yearly_rank,
    ROUND(
        ((100 - AVG(year_rank)) * COUNT(DISTINCT year))::NUMERIC, 2
    ) AS score
FROM billboard_top_100_year_end
WHERE year > EXTRACT(YEAR FROM CURRENT_DATE) - 20
GROUP BY artist
ORDER BY score DESC;
