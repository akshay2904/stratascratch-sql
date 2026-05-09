-- ======================================================================
-- Share of Loan Balance
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Credit Acceptance, Credit Karma
-- Access     : Premium
-- ID         : 2001
-- URL        : https://platform.stratascratch.com/coding/2001-share-of-loan-balance
-- ======================================================================

/*
Write a query that returns the rate_type, loan_id, loan balance , and a column that shows with what percentage the loan's balance contributes to the total balance among the loans of the same rate type. Sort the final output by rate_type and loan_id.
*/

-- Tables:
--   submissions(balance double precision, id bigint, interest_rate double precision, loan_id bigint, rate_type text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    rate_type,
    loan_id,
    balance,
    ROUND(
        balance * 100.0 / SUM(balance) OVER (PARTITION BY rate_type),
        2
    ) AS pct_of_rate_type_total
FROM loans
ORDER BY rate_type, loan_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    l.rate_type,
    l.loan_id,
    l.balance,
    ROUND(
        l.balance * 100.0 / rt.total_balance,
        2
    ) AS pct_of_rate_type_total
FROM loans l
JOIN (
    SELECT
        rate_type,
        SUM(balance) AS total_balance
    FROM loans
    GROUP BY rate_type
) rt
    ON l.rate_type = rt.rate_type
ORDER BY l.rate_type, l.loan_id;
