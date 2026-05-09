-- ======================================================================
-- Common Letters
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Premium
-- ID         : 9823
-- URL        : https://platform.stratascratch.com/coding/9823-common-letters
-- ======================================================================

/*
Find the top 3 most common letters across all the words from both the tables (ignore filename column). Output the letter along with the number of occurrences and order records in descending order based on the number of occurrences.
*/

-- Tables:
--   google_file_store(contents text, filename text)
--   google_word_lists(words1 text, words2 text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH all_words AS (
    -- Combine words from both tables (excluding filename column)
    SELECT word FROM table1
    UNION ALL
    SELECT word FROM table2
),
letters AS (
    -- Unnest each word into individual characters
    SELECT lower(unnest(string_to_array(regexp_replace(word, '[^a-zA-Z]', '', 'g'), NULL))) AS letter
    FROM all_words
),
letter_counts AS (
    SELECT 
        letter,
        COUNT(*) AS occurrences,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM letters
    WHERE letter ~ '[a-z]'  -- keep only alphabetic characters
    GROUP BY letter
)
SELECT letter, occurrences
FROM letter_counts
WHERE rnk <= 3
ORDER BY occurrences DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT letter, occurrences
FROM (
    SELECT 
        lower(unnest(string_to_array(regexp_replace(word, '[^a-zA-Z]', '', 'g'), NULL))) AS letter,
        COUNT(*) AS occurrences
    FROM (
        SELECT word FROM table1
        UNION ALL
        SELECT word FROM table2
    ) all_words
    GROUP BY letter
    HAVING lower(unnest(string_to_array(regexp_replace(word, '[^a-zA-Z]', '', 'g'), NULL))) ~ '[a-z]'
) counted
WHERE letter ~ '[a-z]'
ORDER BY occurrences DESC
LIMIT 3;
