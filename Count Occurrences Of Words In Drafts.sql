-- ======================================================================
-- Count Occurrences Of Words In Drafts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Free
-- ID         : 9817
-- URL        : https://platform.stratascratch.com/coding/9817-find-the-number-of-times-each-word-appears-in-drafts
-- ======================================================================

/*
Find the number of times each word appears in the contents column across all rows in the google_file_store dataset. Output two columns: word and occurrences.
*/

-- Tables:
--   google_file_store(contents text, filename text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (use regexp_split_to_table for efficient word splitting)
-- ============================================================

SELECT
    word,
    COUNT(*) AS occurrences
FROM (
    SELECT regexp_split_to_table(lower(contents), '\s+') AS word
    FROM google_file_store
    WHERE contents IS NOT NULL
) w
WHERE word <> ''
GROUP BY word
ORDER BY occurrences DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (unnest with string_to_array for basic splitting)
-- ============================================================

SELECT
    word,
    COUNT(*) AS occurrences
FROM (
    SELECT unnest(string_to_array(lower(contents), ' ')) AS word
    FROM google_file_store
    WHERE contents IS NOT NULL
) w
WHERE word <> ''
  AND word IS NOT NULL
GROUP BY word
ORDER BY occurrences DESC;
