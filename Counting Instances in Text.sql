-- ======================================================================
-- Counting Instances in Text
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Free
-- ID         : 9814
-- URL        : https://platform.stratascratch.com/coding/9814-counting-instances-in-text
-- ======================================================================

/*
Find the number of times the exact words bull and bear appear in the contents column.




Count all occurrences, even if they appear multiple times within the same row. Matches should be case-insensitive and only count exact words, that is, exclude substrings like bullish or bearing.




Output the word (bull or bear) and the corresponding number of occurrences.
*/

-- Tables:
--   google_file_store(contents text, filename text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH words(word) AS (
    VALUES ('bull'), ('bear')
),
counts AS (
    SELECT
        w.word,
        -- Count occurrences by comparing array length difference after splitting on the word
        -- Use regexp_count equivalent: count non-overlapping regex matches
        SUM(
            (LENGTH(LOWER(contents)) - LENGTH(REGEXP_REPLACE(LOWER(contents), '\m' || w.word || '\M', '', 'g')))
            / LENGTH(w.word)
        ) AS occurrences
    FROM reuters
    CROSS JOIN words w
    GROUP BY w.word
)
SELECT word, occurrences
FROM counts;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    'bull' AS word,
    SUM(
        (LENGTH(LOWER(contents)) - LENGTH(REGEXP_REPLACE(LOWER(contents), '\mbull\M', '', 'g')))
        / LENGTH('bull')
    ) AS occurrences
FROM reuters

UNION ALL

SELECT
    'bear' AS word,
    SUM(
        (LENGTH(LOWER(contents)) - LENGTH(REGEXP_REPLACE(LOWER(contents), '\mbear\M', '', 'g')))
        / LENGTH('bear')
    ) AS occurrences
FROM reuters;
