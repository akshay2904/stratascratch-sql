-- ======================================================================
-- Rows With Missing Values
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 2106
-- URL        : https://platform.stratascratch.com/coding/2106-rows-with-missing-values
-- ======================================================================

/*
The data engineering team at YouTube want to clean the dataset user_flags. In particular, they want to examine rows that have missing values in more than one column. List these rows.
*/

-- Tables:
--   user_flags(flag_id text, user_firstname text, user_lastname text, video_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Use a single pass with inline CASE expressions to count NULLs per row
SELECT *
FROM user_flags
WHERE (
    CASE WHEN user_firstname IS NULL THEN 1 ELSE 0 END +
    CASE WHEN user_lastname  IS NULL THEN 1 ELSE 0 END +
    CASE WHEN video_id       IS NULL THEN 1 ELSE 0 END +
    CASE WHEN flag_id        IS NULL THEN 1 ELSE 0 END
) > 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Explicitly enumerate every combination of two-or-more NULL columns
SELECT *
FROM user_flags
WHERE (user_firstname IS NULL AND user_lastname IS NULL)
   OR (user_firstname IS NULL AND video_id       IS NULL)
   OR (user_firstname IS NULL AND flag_id        IS NULL)
   OR (user_lastname  IS NULL AND video_id       IS NULL)
   OR (user_lastname  IS NULL AND flag_id        IS NULL)
   OR (video_id       IS NULL AND flag_id        IS NULL);
