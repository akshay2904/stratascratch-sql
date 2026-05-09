-- ======================================================================
-- Top 10 Songs 2010
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Spotify
-- Access     : Free
-- ID         : 9650
-- URL        : https://platform.stratascratch.com/coding/9650-find-the-top-10-ranked-songs-in-2010
-- ======================================================================

/*
Find the top 10 ranked songs in 2010. Output the rank, group name, and song name, but do not show the same song twice. Sort the result based on the rank in ascending order.
*/

-- Tables:
--   billboard_top_100_year_end(artist text, group_name text, id bigint, song_name text, year bigint, year_rank bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

SELECT DISTINCT rank, group_name, song_name
FROM billboard_top_100_year_end
WHERE year = 2010
  AND rank <= 10
ORDER BY rank ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT rank, group_name, song_name
FROM (
    SELECT rank, group_name, song_name
    FROM billboard_top_100_year_end
    WHERE year = 2010
      AND rank <= 10
    GROUP BY rank, group_name, song_name
) deduped
ORDER BY rank ASC;
