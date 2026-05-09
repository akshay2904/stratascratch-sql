-- ======================================================================
-- Customers Report Summary
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Whole Foods Market
-- Access     : Premium
-- ID         : 2040
-- URL        : https://platform.stratascratch.com/coding/2040-customers-report-summary
-- ======================================================================

/*
Summarize the number of customers and transactions for each month in 2017, keeping transactions that were greater or equal to $5.
*/

-- Tables:
--   wfm_transactions(customer_id bigint, product_id bigint, sales bigint, store_id bigint, transaction_date date, transaction_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH filtered AS (
    SELECT
        DATE_TRUNC('month', txn_date)          AS txn_month,
        customer_id,
        txn_amount
    FROM customer_transactions
    WHERE txn_date >= '2017-01-01'
      AND txn_date <  '2018-01-01'
      AND txn_amount >= 5
)
SELECT
    TO_CHAR(txn_month, 'YYYY-MM')             AS month,
    COUNT(DISTINCT customer_id)               AS num_customers,
    COUNT(*)                                  AS num_transactions
FROM filtered
GROUP BY txn_month
ORDER BY txn_month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(YEAR  FROM txn_date)              AS txn_year,
    EXTRACT(MONTH FROM txn_date)              AS txn_month,
    COUNT(DISTINCT customer_id)               AS num_customers,
    COUNT(*)                                  AS num_transactions
FROM customer_transactions
WHERE EXTRACT(YEAR FROM txn_date) = 2017
  AND txn_amount >= 5
GROUP BY
    EXTRACT(YEAR  FROM txn_date),
    EXTRACT(MONTH FROM txn_date)
ORDER BY
    txn_year,
    txn_month;
