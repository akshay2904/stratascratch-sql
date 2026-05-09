-- ======================================================================
-- MacBook Pro Events
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Apple, Google
-- Access     : Premium
-- ID         : 10140
-- URL        : https://platform.stratascratch.com/coding/10140-macbook-pro-events
-- ======================================================================

/*
Find how many events happened on MacBook-Pro per company in Argentina from users that do not speak Spanish.

Output the company id, language of users, and the number of events performed by users.
*/

-- Tables:
--   playbook_events(device text, event_name text, event_type text, location text, occurred_at timestamp without time zone, user_id bigint)
--   playbook_users(activated_at date, company_id bigint, created_at timestamp without time zone, language text, state text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH filtered_users AS (
    SELECT u.user_id, u.company_id, u.language
    FROM users u
    WHERE u.location = 'Argentina'
      AND u.language != 'Spanish'
)
SELECT 
    fu.company_id,
    fu.language,
    COUNT(e.event_id) AS event_count
FROM filtered_users fu
JOIN events e 
    ON fu.user_id = e.user_id
WHERE e.device = 'MacBook-Pro'
GROUP BY fu.company_id, fu.language
ORDER BY fu.company_id, fu.language;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    u.company_id,
    u.language,
    COUNT(e.event_id) AS event_count
FROM users u
JOIN events e 
    ON u.user_id = e.user_id
WHERE u.location = 'Argentina'
  AND u.language != 'Spanish'
  AND e.device = 'MacBook-Pro'
GROUP BY u.company_id, u.language
ORDER BY u.company_id, u.language;
