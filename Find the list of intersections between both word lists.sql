-- ======================================================================
-- Find the list of intersections between both word lists
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Premium
-- ID         : 9816
-- URL        : https://platform.stratascratch.com/coding/9816-find-the-list-of-intersections-between-both-word-lists
-- ======================================================================

/*
Find the list of intersections between both word lists.
*/

-- Tables:
--   google_word_lists(words1 text, words2 text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assuming two tables: word_list1(word) and word_list2(word)
SELECT DISTINCT w1.word
FROM word_list1 w1
INNER JOIN word_list2 w2
    ON w1.word = w2.word
ORDER BY w1.word;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT word
FROM word_list1
WHERE word IN (
    SELECT word
    FROM word_list2
)
GROUP BY word
ORDER BY word;
