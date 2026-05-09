-- ======================================================================
-- The Best Artist
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Spotify
-- Access     : Premium
-- ID         : 9744
-- URL        : https://platform.stratascratch.com/coding/9744-artist-of-the-decade
-- ======================================================================

/*
Find the number of times an artist has been on the Billboard Top 100 in the past 20 years, based on the most recent year available in the dataset. Use the latest year in the dataset as the reference point and count entries from the last 20 years relative to that year. Output the result alongside the artist's name and order records based on the count in descending order.
*/

-- Tables:
--   billboard_top_100_year_end(artist text, group_name text, id bigint, song_name text, year bigint, year_rank bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH max_year AS (
    SELECT MAX(year) AS latest_year
    FROM billboard_top_100_year_end
),
filtered AS (
    SELECT artist
    FROM billboard_top_100_year_end, max_year
    WHERE year > latest_year - 20
)
SELECT
    artist,
    COUNT(*) AS appearances
FROM filtered
GROUP BY artist
ORDER BY appearances DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    artist,
    COUNT(*) AS appearances
FROM billboard_top_100_year_end
WHERE year > (
    SELECT MAX(year) - 20
    FROM billboard_top_100_year_end
)
GROUP BY artist
ORDER BY appearances DESC;
