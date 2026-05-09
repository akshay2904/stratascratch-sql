-- ======================================================================
-- File Contents Shuffle
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Premium
-- ID         : 9818
-- URL        : https://platform.stratascratch.com/coding/9818-file-contents-shuffle
-- ======================================================================

/*
Sort the words alphabetically in 'final.txt' and make a new file named 'wacky.txt'. Output the file contents in one column and the filename 'wacky.txt' in another column. Lowercase all the words. To simplify the question, there is no need to remove the punctuation marks.





If coding in python, the file contents should be contained in a list.
*/

-- Tables:
--   google_file_store(contents text, filename text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assume table: files(filename TEXT, word TEXT)
-- We read words from 'final.txt', lowercase + sort, output as 'wacky.txt'

WITH words_from_final AS (
    SELECT LOWER(word) AS word
    FROM files
    WHERE filename = 'final.txt'
),
sorted_words AS (
    SELECT
        word,
        ROW_NUMBER() OVER (ORDER BY word) AS rn
    FROM words_from_final
)
SELECT
    word          AS file_contents,
    'wacky.txt'   AS filename
FROM sorted_words
ORDER BY rn;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Assume table: files(filename TEXT, word TEXT)
-- We read words from 'final.txt', lowercase + sort, output as 'wacky.txt'

SELECT
    LOWER(word)   AS file_contents,
    'wacky.txt'   AS filename
FROM files
WHERE filename = 'final.txt'
ORDER BY LOWER(word);
