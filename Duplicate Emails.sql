-- ======================================================================
-- Duplicate Emails
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Dropbox, Coca-Cola, Dell, Salesforce
-- Access     : Premium
-- ID         : 9895
-- URL        : https://platform.stratascratch.com/coding/9895-duplicate-emails
-- ======================================================================

/*
Find all emails with duplicates.
*/

-- Tables:
--   employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH email_counts AS (
    SELECT
        email,
        COUNT(*) OVER (PARTITION BY email) AS cnt
    FROM users
)
SELECT DISTINCT email
FROM email_counts
WHERE cnt > 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT email
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
