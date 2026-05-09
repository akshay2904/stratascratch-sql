-- ======================================================================
-- Monthly Churn Rate
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Natera
-- Access     : Premium
-- ID         : 2074
-- URL        : https://platform.stratascratch.com/coding/2074-monthly-churn-rate
-- ======================================================================

/*
Calculate the churn rate of September 2021 in percentages. The churn rate is the difference between the number of customers on the first day of the month and on the last day of the month, divided by the number of customers on the first day of a month.
Assume that if customer's contract_end is NULL, their contract is still active. Additionally, if a customer started or finished their contract on a certain day, they should still be counted as a customer on that day.
*/

-- Tables:
--   natera_subscriptions(contract_end date, contract_start date, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

WITH first_day AS (
    SELECT COUNT(*) AS customers_first
    FROM customers
    WHERE contract_start <= '2021-09-01'
      AND (contract_end IS NULL OR contract_end >= '2021-09-01')
),
last_day AS (
    SELECT COUNT(*) AS customers_last
    FROM customers
    WHERE contract_start <= '2021-09-30'
      AND (contract_end IS NULL OR contract_end >= '2021-09-30')
)
SELECT
    ROUND(
        (customers_first - customers_last) * 100.0 / NULLIF(customers_first, 0),
        2
    ) AS churn_rate_pct
FROM first_day, last_day;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- ============================================================

SELECT
    ROUND(
        (
            (
                SELECT COUNT(*)
                FROM customers
                WHERE contract_start <= '2021-09-01'
                  AND (contract_end IS NULL OR contract_end >= '2021-09-01')
            )
            -
            (
                SELECT COUNT(*)
                FROM customers
                WHERE contract_start <= '2021-09-30'
                  AND (contract_end IS NULL OR contract_end >= '2021-09-30')
            )
        ) * 100.0
        /
        NULLIF(
            (
                SELECT COUNT(*)
                FROM customers
                WHERE contract_start <= '2021-09-01'
                  AND (contract_end IS NULL OR contract_end >= '2021-09-01')
            ),
            0
        ),
        2
    ) AS churn_rate_pct;
