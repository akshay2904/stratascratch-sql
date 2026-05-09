-- ======================================================================
-- Meta/Facebook Accounts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10296
-- URL        : https://platform.stratascratch.com/coding/10296-facebook-accounts
-- ======================================================================

/*
Of all accounts with status records on January 10th, 2020, calculate the ratio of those with 'closed' status.
*/

-- Tables:
--   fb_account_status(acc_id bigint, status character varying, status_date date)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH jan10_accounts AS (
    SELECT
        account_id,
        status,
        COUNT(*) OVER () AS total_accounts,
        SUM(CASE WHEN status = 'closed' THEN 1 ELSE 0 END) OVER () AS closed_accounts
    FROM account_status_records
    WHERE record_date = '2020-01-10'
)
SELECT
    ROUND(
        closed_accounts::NUMERIC / NULLIF(total_accounts, 0),
        2
    ) AS closed_ratio
FROM jan10_accounts
LIMIT 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        SUM(CASE WHEN status = 'closed' THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(*), 0),
        2
    ) AS closed_ratio
FROM account_status_records
WHERE record_date = '2020-01-10';
