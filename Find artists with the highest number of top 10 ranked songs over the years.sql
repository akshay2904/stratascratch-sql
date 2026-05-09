-- ======================================================================
-- Find artists with the highest number of top 10 ranked songs over the years
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Spotify
-- Access     : Premium
-- ID         : 9993
-- URL        : https://platform.stratascratch.com/coding/9993-find-artists-with-the-highest-number-of-top-10-ranked-songs-over-the-years
-- ======================================================================

/*
Find artists with the highest number of top 10 ranked songs for 2017.

Output the artist along with the corresponding number of top 10 rankings.
*/

-- Tables:
--   spotify_worldwide_daily_song_ranking(artist text, id bigint, position bigint, region text, stream_date date, streams bigint, trackname text, url text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH top10_counts AS (
    SELECT 
        artist,
        COUNT(*) AS top10_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM billboard_top_100_year_end
    WHERE year = 2017
      AND year_rank <= 10
    GROUP BY artist
)
SELECT artist, top10_count
FROM top10_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT artist, COUNT(*) AS top10_count
FROM billboard_top_100_year_end
WHERE year = 2017
  AND year_rank <= 10
GROUP BY artist
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM billboard_top_100_year_end
        WHERE year = 2017
          AND year_rank <= 10
        GROUP BY artist
    ) sub
);
