-- ======================================================================
-- Process a Refund
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Noom
-- Access     : Premium
-- ID         : 2125
-- URL        : https://platform.stratascratch.com/coding/2125-process-a-refund
-- ======================================================================

/*
Calculate and display the minimum, average and the maximum number of days it takes to process a refund for accounts opened from January 1, 2019. Group by billing cycle in months.




Note: The time frame for a refund to be fully processed is from settled_at until refunded_at.
*/

-- Tables:
--   noom_signups(plan_id bigint, signup_id text, started_at date)
--   noom_transactions(refunded_at date, settled_at date, signup_id text, transaction_id bigint, usd_gross bigint)
--   noom_plans(billing_cycle_in_months bigint, plan_id bigint, plan_rate bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH refund_days AS (
    SELECT
        a.billing_cycle_months,
        EXTRACT(DAY FROM (t.refunded_at - t.settled_at)) AS days_to_refund
    FROM accounts a
    JOIN transactions t ON t.account_id = a.id
    WHERE a.opened_at >= '2019-01-01'
      AND t.refunded_at IS NOT NULL
      AND t.settled_at  IS NOT NULL
)
SELECT
    billing_cycle_months,
    MIN(days_to_refund)                    AS min_days_to_refund,
    ROUND(AVG(days_to_refund), 2)          AS avg_days_to_refund,
    MAX(days_to_refund)                    AS max_days_to_refund
FROM refund_days
GROUP BY billing_cycle_months
ORDER BY billing_cycle_months;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    a.billing_cycle_months,
    MIN(EXTRACT(DAY FROM (t.refunded_at - t.settled_at)))          AS min_days_to_refund,
    ROUND(AVG(EXTRACT(DAY FROM (t.refunded_at - t.settled_at))), 2) AS avg_days_to_refund,
    MAX(EXTRACT(DAY FROM (t.refunded_at - t.settled_at)))          AS max_days_to_refund
FROM accounts a
JOIN transactions t ON t.account_id = a.id
WHERE a.opened_at >= '2019-01-01'
  AND t.refunded_at IS NOT NULL
  AND t.settled_at  IS NOT NULL
GROUP BY a.billing_cycle_months
ORDER BY a.billing_cycle_months;
