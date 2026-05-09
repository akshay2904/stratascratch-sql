-- ======================================================================
-- Count the number of words per row in both words lists
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 9812
-- URL        : https://platform.stratascratch.com/coding/9812-count-the-number-of-words-per-row-in-both-words-lists
-- ======================================================================

/*
Count the number of words per row in both words lists.
*/

-- Tables:
--   google_word_lists(words1 text, words2 text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- NOTE: Without knowing the exact table/column names, I'll use a common
-- example schema: a table `sentences` with columns `id`, `words_list1`, `words_list2`
-- where each column contains space-separated words.

WITH word_counts AS (
    SELECT
        id,
        -- Count words by counting spaces + 1 (handling nulls and empty strings)
        CASE
            WHEN words_list1 IS NULL OR TRIM(words_list1) = '' THEN 0
            ELSE array_length(string_to_array(TRIM(words_list1), ' '), 1)
        END AS word_count_list1,
        CASE
            WHEN words_list2 IS NULL OR TRIM(words_list2) = '' THEN 0
            ELSE array_length(string_to_array(TRIM(words_list2), ' '), 1)
        END AS word_count_list2
    FROM sentences
)
SELECT
    id,
    word_count_list1,
    word_count_list2,
    word_count_list1 + word_count_list2 AS total_word_count
FROM word_counts
ORDER BY id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    id,
    -- Count words in list1 by splitting on spaces
    (
        SELECT COUNT(*)
        FROM unnest(string_to_array(TRIM(s.words_list1), ' ')) AS word
        WHERE word <> ''
    ) AS word_count_list1,
    -- Count words in list2 by splitting on spaces
    (
        SELECT COUNT(*)
        FROM unnest(string_to_array(TRIM(s.words_list2), ' ')) AS word
        WHERE word <> ''
    ) AS word_count_list2,
    -- Total words per row
    (
        SELECT COUNT(*)
        FROM unnest(string_to_array(TRIM(s.words_list1), ' ')) AS word
        WHERE word <> ''
    ) +
    (
        SELECT COUNT(*)
        FROM unnest(string_to_array(TRIM(s.words_list2), ' ')) AS word
        WHERE word <> ''
    ) AS total_word_count
FROM sentences s
ORDER BY id;
