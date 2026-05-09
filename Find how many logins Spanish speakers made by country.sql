-- ======================================================================
-- Find how many logins Spanish speakers made by country
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 9889
-- URL        : https://platform.stratascratch.com/coding/9889-find-how-many-logins-spanish-speakers-made-by-country
-- ======================================================================

/*
Find how many logins Spanish speakers made by country.

Output the country along with the corresponding number of logins. Filter out countries without logins.

Order records by the number of logins in descending order.
*/

-- Tables:
--   playbook_events(device text, event_name text, event_type text, location text, occurred_at timestamp without time zone, user_id bigint)
--   playbook_users(activated_at date, company_id bigint, created_at timestamp without time zone, language text, state text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    u.country,
    COUNT(l.login_id) AS login_count
FROM users u
JOIN logins l ON u.id = l.user_id
WHERE u.language = 'Spanish'
GROUP BY u.country
HAVING COUNT(l.login_id) > 0
ORDER BY login_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    country,
    login_count
FROM (
    SELECT 
        u.country,
        COUNT(l.login_id) AS login_count
    FROM users u,
         logins l
    WHERE u.id = l.user_id
      AND u.language = 'Spanish'
    GROUP BY u.country
) country_logins
WHERE login_count > 0
ORDER BY login_count DESC;
