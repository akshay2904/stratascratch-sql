-- ======================================================================
-- Duplicate Training Lessons
-- ======================================================================
-- Difficulty : Medium
-- Companies  : General Assembly, Amazon
-- Access     : Premium
-- ID         : 2130
-- URL        : https://platform.stratascratch.com/coding/2130-duplicate-training-lessons
-- ======================================================================

/*
Display a list of users who took the same training lessons more than once on the same day. Assume that each u_name is unique. Output their usernames, training IDs, dates and the number of times they took the same lesson.
*/

-- Tables:
--   users_training(u_id bigint, u_name text)
--   training_details(training_date date, training_id bigint, u_id bigint, u_t_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH lesson_counts AS (
    SELECT
        u_name,
        training_id,
        DATE(training_date) AS training_day,
        COUNT(*) AS times_taken,
        COUNT(*) OVER (PARTITION BY u_name, training_id, DATE(training_date)) AS cnt
    FROM training_details
    GROUP BY u_name, training_id, DATE(training_date)
)
SELECT
    u_name,
    training_id,
    training_day,
    times_taken
FROM lesson_counts
WHERE times_taken > 1
ORDER BY u_name, training_id, training_day;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u_name,
    training_id,
    DATE(training_date) AS training_day,
    COUNT(*) AS times_taken
FROM training_details
GROUP BY u_name, training_id, DATE(training_date)
HAVING COUNT(*) > 1
ORDER BY u_name, training_id, training_day;
