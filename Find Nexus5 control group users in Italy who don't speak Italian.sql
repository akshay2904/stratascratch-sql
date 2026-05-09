-- ======================================================================
-- Find Nexus5 control group users in Italy who don't speak Italian
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 9609
-- URL        : https://platform.stratascratch.com/coding/9609-find-nexus5-control-group-users-in-italy-who-dont-speak-italian
-- ======================================================================

/*
Find user id, language, and location of all Nexus 5 control group users in Italy who do not speak Italian. Sort the results in ascending order based on the occurred_at value of the playbook_experiments dataset.
*/

-- Tables:
--   playbook_experiments(device text, experiment text, experiment_group text, location text, occurred_at timestamp without time zone, user_id bigint)
--   playbook_users(activated_at date, company_id bigint, created_at timestamp without time zone, language text, state text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH nexus5_italy_control AS (
    SELECT pe.user_id, pe.occurred_at
    FROM playbook_experiments pe
    WHERE pe.device = 'nexus 5'
      AND pe.location = 'Italy'
      AND pe.experiment_group = 'control_group'
),
filtered_users AS (
    SELECT u.user_id, u.language, u.location
    FROM users u
    WHERE u.language <> 'Italian'
)
SELECT fu.user_id, fu.language, fu.location
FROM nexus5_italy_control nic
JOIN filtered_users fu ON nic.user_id = fu.user_id
ORDER BY nic.occurred_at ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT u.user_id, u.language, u.location
FROM users u
WHERE u.language <> 'Italian'
  AND u.user_id IN (
      SELECT pe.user_id
      FROM playbook_experiments pe
      WHERE pe.device = 'nexus 5'
        AND pe.location = 'Italy'
        AND pe.experiment_group = 'control_group'
  )
ORDER BY (
    SELECT MIN(pe2.occurred_at)
    FROM playbook_experiments pe2
    WHERE pe2.user_id = u.user_id
      AND pe2.device = 'nexus 5'
      AND pe2.location = 'Italy'
      AND pe2.experiment_group = 'control_group'
) ASC;
