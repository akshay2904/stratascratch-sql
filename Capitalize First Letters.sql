-- ======================================================================
-- Capitalize First Letters
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Cisco Systems
-- Access     : Premium
-- ID         : 10546
-- URL        : https://platform.stratascratch.com/coding/10546-capitalize-first-letters
-- ======================================================================

/*
Convert the first letter of each word found in content_text to uppercase, while keeping the rest of the letters lowercase.




Your output should include the original text in one column and the modified text in another column.
*/

-- Tables:
--   user_content(content_id bigint, content_text text, content_type text, customer_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Using initcap() which converts first letter of each word to uppercase
-- and remaining letters to lowercase
SELECT
    content_text AS original_text,
    INITCAP(content_text) AS modified_text
FROM
    content;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Manually splitting words, applying UPPER to first char and LOWER to rest,
-- then reassembling using string_agg
SELECT
    content_text AS original_text,
    (
        SELECT STRING_AGG(
            UPPER(LEFT(word, 1)) || LOWER(SUBSTRING(word FROM 2)),
            ' '
            ORDER BY word_position
        )
        FROM (
            SELECT
                UNNEST(STRING_TO_ARRAY(c2.content_text, ' ')) AS word,
                GENERATE_SUBSCRIPTS(STRING_TO_ARRAY(c2.content_text, ' '), 1) AS word_position
        ) AS words
    ) AS modified_text
FROM
    content c2;
