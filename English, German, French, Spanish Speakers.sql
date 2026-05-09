-- ======================================================================
-- English, German, French, Spanish Speakers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 9668
-- URL        : https://platform.stratascratch.com/coding/9668-english-german-french-spanish-speakers
-- ======================================================================

/*
Find company IDs with more than 2 unique users who speak any of the following languages: English, German, French, or Spanish.
*/

-- Tables:
--   playbook_users(activated_at date, company_id bigint, created_at timestamp without time zone, language text, state text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH filtered_users AS (
    SELECT DISTINCT
        u.company_id,
        u.id AS user_id
    FROM users u
    JOIN user_languages ul ON u.id = ul.user_id
    WHERE ul.language IN ('English', 'German', 'French', 'Spanish')
)
SELECT
    company_id,
    COUNT(user_id) AS unique_user_count
FROM filtered_users
GROUP BY company_id
HAVING COUNT(user_id) > 2;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.company_id,
    COUNT(DISTINCT u.id) AS unique_user_count
FROM users u
WHERE u.id IN (
    SELECT ul.user_id
    FROM user_languages ul
    WHERE ul.language IN ('English', 'German', 'French', 'Spanish')
)
GROUP BY u.company_id
HAVING COUNT(DISTINCT u.id) > 2;
